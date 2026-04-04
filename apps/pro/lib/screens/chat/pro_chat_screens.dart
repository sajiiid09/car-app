import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';

import 'pro_chat_state.dart';

class ProChatInboxScreen extends ConsumerStatefulWidget {
  const ProChatInboxScreen({
    super.key,
    required this.role,
    required this.screenKey,
  });

  final ProChatRole role;
  final Key screenKey;

  @override
  ConsumerState<ProChatInboxScreen> createState() => _ProChatInboxScreenState();
}

class _ProChatInboxScreenState extends ConsumerState<ProChatInboxScreen> {
  OcChatListFilter _selectedFilter = OcChatListFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roleState = ref.watch(
      proChatProvider.select((state) => state.roleState(widget.role)),
    );
    final visibleThreads = _selectedFilter == OcChatListFilter.unread
        ? roleState.threads
              .where((thread) => thread.unreadCount > 0)
              .toList(growable: false)
        : roleState.threads;

    return ColoredBox(
      color: OcColors.background,
      child: SafeArea(
        child: Column(
          children: [
            KeyedSubtree(key: widget.screenKey, child: const SizedBox.shrink()),
            OcChatInboxHeader(
              title: l10n.chatInboxTitle,
              sectionLabel: l10n.chatMessagesSectionLabel,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() => _selectedFilter = filter);
              },
              avatarLabel: roleState.currentUser.name,
              avatarImageUrl: roleState.currentUser.avatarUrl,
              allFilterLabel: l10n.chatFilterAll,
              unreadFilterLabel: l10n.chatFilterUnread,
            ),
            Expanded(
              child: visibleThreads.isEmpty
                  ? OcChatStateSection(
                      title: l10n.chatEmptyTitle,
                      subtitle: l10n.chatEmptySubtitle,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: visibleThreads.length,
                      itemBuilder: (context, index) {
                        final thread = visibleThreads[index];
                        return OcChatThreadTile(
                          key: ValueKey(
                            '${widget.role.name}Thread-${thread.id}',
                          ),
                          title: thread.participant.name,
                          preview: _previewText(
                            l10n: l10n,
                            currentUserId: roleState.currentUser.id,
                            thread: thread,
                          ),
                          timestamp: _formatTime(thread.lastMessage?.sentAt),
                          imageUrl: thread.participant.avatarUrl,
                          unreadCount: thread.unreadCount,
                          highlightPreview: thread.unreadCount > 0,
                          onTap: () {
                            ref
                                .read(proChatProvider.notifier)
                                .markThreadRead(widget.role, thread.id);
                            context.push(_threadPath(widget.role, thread.id));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _previewText({
    required AppLocalizations l10n,
    required String currentUserId,
    required ProChatThread thread,
  }) {
    if (thread.unreadCount > 0) {
      return l10n.chatUnreadCount(thread.unreadCount);
    }
    final lastMessage = thread.lastMessage;
    if (lastMessage == null) {
      return l10n.chatNoMessagesYet;
    }
    if (lastMessage.senderId == currentUserId) {
      return '${l10n.chatYouPrefix}: ${lastMessage.text}';
    }
    return lastMessage.text;
  }
}

class ProChatThreadScreen extends ConsumerStatefulWidget {
  const ProChatThreadScreen({
    super.key,
    required this.role,
    required this.threadId,
    required this.screenKey,
  });

  final ProChatRole role;
  final String threadId;
  final Key screenKey;

  @override
  ConsumerState<ProChatThreadScreen> createState() =>
      _ProChatThreadScreenState();
}

class _ProChatThreadScreenState extends ConsumerState<ProChatThreadScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _canSend = false;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleComposerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(proChatProvider.notifier)
          .markThreadRead(widget.role, widget.threadId);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController
      ..removeListener(_handleComposerChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleComposerChanged() {
    final nextCanSend = _messageController.text.trim().isNotEmpty;
    if (_canSend != nextCanSend && mounted) {
      setState(() => _canSend = nextCanSend);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roleState = ref.watch(
      proChatProvider.select((state) => state.roleState(widget.role)),
    );
    final thread = roleState.threadById(widget.threadId);

    if (thread == null) {
      return Scaffold(
        backgroundColor: OcColors.background,
        body: SafeArea(
          child: Column(
            children: [
              KeyedSubtree(
                key: widget.screenKey,
                child: const SizedBox.shrink(),
              ),
              OcChatThreadHeader(
                title: l10n.chatThreadFallbackTitle,
                avatarLabel: l10n.chatThreadFallbackTitle,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: OcChatStateSection(
                  title: l10n.chatLoadError,
                  subtitle: l10n.errorGeneric,
                  icon: Icons.error_outline_rounded,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (thread.messages.length != _lastMessageCount) {
      _lastMessageCount = thread.messages.length;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
      backgroundColor: OcColors.background,
      body: SafeArea(
        child: Column(
          children: [
            KeyedSubtree(key: widget.screenKey, child: const SizedBox.shrink()),
            OcChatThreadHeader(
              title: thread.participant.name,
              avatarLabel: thread.participant.name,
              avatarImageUrl: thread.participant.avatarUrl,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: thread.messages.isEmpty
                  ? OcChatStateSection(
                      title: l10n.chatMessagesSectionLabel,
                      subtitle: l10n.chatNoMessagesYet,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      itemCount: thread.messages.length,
                      itemBuilder: (context, index) {
                        final message = thread.messages[index];
                        return OcChatBubble(
                          message: message.text,
                          timeLabel: _formatTime(message.sentAt),
                          isCurrentUser:
                              message.senderId == roleState.currentUser.id,
                        );
                      },
                    ),
            ),
            OcChatComposer(
              controller: _messageController,
              hintText: l10n.chatComposerHint,
              sendLabel: l10n.chatSend,
              enabled: _canSend,
              onSubmitted: (_) => _sendMessage(),
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    ref
        .read(proChatProvider.notifier)
        .sendMessage(role: widget.role, threadId: widget.threadId, text: text);
    _messageController.clear();
  }

  void _scrollToBottom() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }
}

String _threadPath(ProChatRole role, String threadId) {
  return switch (role) {
    ProChatRole.workshop => '/workshop/messages/$threadId',
    ProChatRole.shop => '/shop/messages/$threadId',
    ProChatRole.driver => '/driver/messages/$threadId',
  };
}

String _formatTime(DateTime? value) {
  if (value == null) {
    return '';
  }
  final local = value.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final meridiem = local.hour >= 12 ? 'pm' : 'am';
  return '$hour:$minute$meridiem';
}
