import 'dart:async';

import 'package:consumer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../providers.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = const [];
  StreamSubscription<ChatMessage>? _subscription;
  bool _isLoading = true;
  bool _canSend = false;
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    _currentUid = ref.read(currentChatUserIdProvider);
    _messageController.addListener(_handleComposerChanged);
    _loadMessages();
    _markAsRead();
  }

  @override
  void dispose() {
    _subscription?.cancel();
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

  Future<void> _loadMessages() async {
    try {
      final chatService = ref.read(chatServiceProvider);
      final messages = await chatService.getMessages(widget.roomId, limit: 100);
      if (!mounted) {
        return;
      }
      setState(() {
        _messages = messages.reversed.toList(growable: false);
        _isLoading = false;
      });
      _scrollToBottom();
      _subscribeToNewMessages();
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _subscribeToNewMessages() {
    final chatService = ref.read(chatServiceProvider);
    _subscription = chatService.subscribeToMessages(widget.roomId).listen((
      msg,
    ) {
      if (!mounted) {
        return;
      }
      if (_messages.any((message) => message.id == msg.id)) {
        return;
      }
      setState(() {
        _messages = [..._messages, msg];
      });
      _scrollToBottom();
      if (msg.senderId != _currentUid) {
        chatService.markAsRead(widget.roomId);
      }
    });
  }

  Future<void> _markAsRead() async {
    try {
      await ref.read(chatServiceProvider).markAsRead(widget.roomId);
    } catch (_) {}
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _sendMessage() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    _messageController.clear();

    try {
      await ref
          .read(chatServiceProvider)
          .sendMessage(roomId: widget.roomId, content: text);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.chatSendFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(chatRoomSummaryProvider(widget.roomId));
    final title =
        summaryAsync.valueOrNull?.room.otherUser?['name'] as String? ??
        l10n.chatThreadFallbackTitle;
    final avatarUrl =
        summaryAsync.valueOrNull?.room.otherUser?['avatar_url'] as String?;

    return Scaffold(
      backgroundColor: OcColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const KeyedSubtree(
              key: ValueKey('consumerChatDetailScreen'),
              child: SizedBox.shrink(),
            ),
            OcChatThreadHeader(
              title: title,
              avatarLabel: title,
              avatarImageUrl: avatarUrl,
              onBack: () {
                ref.invalidate(chatRoomsProvider);
                ref.invalidate(chatInboxProvider);
                ref.invalidate(chatRoomSummaryProvider(widget.roomId));
                context.pop();
              },
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                  ? OcChatStateSection(
                      title: l10n.chatMessagesSectionLabel,
                      subtitle: l10n.chatNoMessagesYet,
                    )
                  : ListView.builder(
                      key: const ValueKey('consumerChatMessageList'),
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return OcChatBubble(
                          message: message.content?.trim().isNotEmpty == true
                              ? message.content!.trim()
                              : '...',
                          timeLabel: _formatTime(message.createdAt),
                          isCurrentUser: message.senderId == _currentUid,
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
}
