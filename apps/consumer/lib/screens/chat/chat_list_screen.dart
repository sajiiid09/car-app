import 'package:consumer/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../providers.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  OcChatListFilter _selectedFilter = OcChatListFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inboxAsync = ref.watch(chatInboxProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      backgroundColor: OcColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const KeyedSubtree(
              key: ValueKey('consumerChatListScreen'),
              child: SizedBox.shrink(),
            ),
            OcChatInboxHeader(
              title: l10n.chatInboxTitle,
              sectionLabel: l10n.chatMessagesSectionLabel,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() => _selectedFilter = filter);
              },
              avatarLabel: profile?.name ?? l10n.profile,
              avatarImageUrl: profile?.avatarUrl,
              allFilterLabel: l10n.chatFilterAll,
              unreadFilterLabel: l10n.chatFilterUnread,
            ),
            Expanded(
              child: inboxAsync.when(
                data: (summaries) {
                  final visibleSummaries =
                      _selectedFilter == OcChatListFilter.unread
                      ? summaries
                            .where((summary) => summary.unreadCount > 0)
                            .toList(growable: false)
                      : summaries;

                  if (visibleSummaries.isEmpty) {
                    return OcChatStateSection(
                      title: l10n.chatEmptyTitle,
                      subtitle: l10n.chatEmptySubtitle,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(chatRoomsProvider);
                      ref.invalidate(chatInboxProvider);
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: visibleSummaries.length,
                      itemBuilder: (context, index) {
                        final summary = visibleSummaries[index];
                        final room = summary.room;
                        return OcChatThreadTile(
                          key: ValueKey('consumerChatThread-${room.id}'),
                          title: _participantName(room),
                          preview: _previewText(l10n: l10n, summary: summary),
                          timestamp: _formatInboxTime(room.lastMessageAt),
                          imageUrl: room.otherUser?['avatar_url'] as String?,
                          unreadCount: summary.unreadCount,
                          highlightPreview: summary.unreadCount > 0,
                          onTap: () => context.push('/chat/${room.id}'),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => OcChatStateSection(
                  title: l10n.chatLoadError,
                  subtitle: l10n.errorGeneric,
                  icon: Icons.error_outline_rounded,
                  action: TextButton(
                    onPressed: () {
                      ref.invalidate(chatRoomsProvider);
                      ref.invalidate(chatInboxProvider);
                    },
                    child: Text(l10n.retry),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _participantName(ChatRoom room) {
    final otherUser = room.otherUser;
    final value = otherUser?['name'] as String?;
    if (value == null || value.trim().isEmpty) {
      return 'User';
    }
    return value.trim();
  }

  String _previewText({
    required AppLocalizations l10n,
    required ChatInboxSummary summary,
  }) {
    if (summary.unreadCount > 0) {
      return l10n.chatUnreadCount(summary.unreadCount);
    }
    final text = summary.room.lastMessage?.trim();
    if (text == null || text.isEmpty) {
      return l10n.chatNoMessagesYet;
    }
    return text;
  }

  String _formatInboxTime(DateTime? value) {
    if (value == null) {
      return '';
    }

    final now = DateTime.now();
    final local = value.toLocal();
    final difference = now.difference(local);
    if (difference.inHours < 24) {
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final minute = local.minute.toString().padLeft(2, '0');
      final meridiem = local.hour >= 12 ? 'pm' : 'am';
      return '$hour:$minute$meridiem';
    }
    return '${local.day}/${local.month}';
  }
}
