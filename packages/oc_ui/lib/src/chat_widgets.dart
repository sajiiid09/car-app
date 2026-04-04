import 'package:flutter/material.dart';

import 'tokens.dart';

enum OcChatListFilter { all, unread }

Duration _chatMotionDuration(BuildContext context) {
  final reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return reducedMotion ? Duration.zero : const Duration(milliseconds: 220);
}

class OcChatAvatar extends StatelessWidget {
  const OcChatAvatar({
    super.key,
    required this.label,
    this.imageUrl,
    this.radius = 22,
    this.fallbackIcon = Icons.person_outline_rounded,
    this.backgroundColor = const Color(0xFFFFE9D6),
    this.foregroundColor = OcColors.textPrimary,
  });

  final String label;
  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl?.trim();
    final avatarImage = normalizedUrl != null && normalizedUrl.isNotEmpty
        ? NetworkImage(normalizedUrl)
        : null;

    if (avatarImage != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: avatarImage,
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: _AvatarFallback(
        initials: _initials(label),
        icon: fallbackIcon,
        foregroundColor: foregroundColor,
      ),
    );
  }

  String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) {
      return '';
    }
    return parts
        .map((part) => part.isEmpty ? '' : part.substring(0, 1).toUpperCase())
        .join();
  }
}

class OcChatInboxHeader extends StatelessWidget {
  const OcChatInboxHeader({
    super.key,
    required this.title,
    required this.sectionLabel,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.avatarLabel = '',
    this.avatarImageUrl,
    this.avatarFallbackIcon = Icons.person_outline_rounded,
    this.onAvatarTap,
    this.onNotificationTap,
    this.showNotificationAction = true,
    this.allFilterLabel = 'All',
    this.unreadFilterLabel = 'Unread',
  });

  final String title;
  final String sectionLabel;
  final OcChatListFilter selectedFilter;
  final ValueChanged<OcChatListFilter> onFilterSelected;
  final String avatarLabel;
  final String? avatarImageUrl;
  final IconData avatarFallbackIcon;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationAction;
  final String allFilterLabel;
  final String unreadFilterLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: OcColors.textPrimary,
                  ),
                ),
              ),
              if (showNotificationAction) ...[
                _OcChatIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: onNotificationTap,
                ),
                const SizedBox(width: 10),
              ],
              GestureDetector(
                onTap: onAvatarTap,
                child: OcChatAvatar(
                  label: avatarLabel,
                  imageUrl: avatarImageUrl,
                  radius: 20,
                  fallbackIcon: avatarFallbackIcon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                sectionLabel,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: OcColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              PopupMenuButton<OcChatListFilter>(
                initialValue: selectedFilter,
                onSelected: onFilterSelected,
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: OcColors.borderLight),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: OcChatListFilter.all,
                    child: Text(allFilterLabel),
                  ),
                  PopupMenuItem(
                    value: OcChatListFilter.unread,
                    child: Text(unreadFilterLabel),
                  ),
                ],
                child: AnimatedContainer(
                  duration: _chatMotionDuration(context),
                  curve: Curves.easeOutCubic,
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selectedFilter == OcChatListFilter.unread
                        ? OcColors.accentSoft
                        : OcColors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: selectedFilter == OcChatListFilter.unread
                        ? OcColors.accent
                        : OcColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OcChatThreadHeader extends StatelessWidget {
  const OcChatThreadHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.avatarLabel = '',
    this.avatarImageUrl,
    this.avatarFallbackIcon = Icons.person_outline_rounded,
  });

  final String title;
  final VoidCallback onBack;
  final String avatarLabel;
  final String? avatarImageUrl;
  final IconData avatarFallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          _OcChatIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: OcColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          OcChatAvatar(
            label: avatarLabel,
            imageUrl: avatarImageUrl,
            radius: 20,
            fallbackIcon: avatarFallbackIcon,
          ),
        ],
      ),
    );
  }
}

class OcChatThreadTile extends StatelessWidget {
  const OcChatThreadTile({
    super.key,
    required this.title,
    required this.preview,
    required this.timestamp,
    this.imageUrl,
    this.unreadCount = 0,
    this.highlightPreview = false,
    this.avatarFallbackIcon = Icons.person_outline_rounded,
    this.onTap,
  });

  final String title;
  final String preview;
  final String timestamp;
  final String? imageUrl;
  final int unreadCount;
  final bool highlightPreview;
  final IconData avatarFallbackIcon;
  final VoidCallback? onTap;

  bool get _isUnread => unreadCount > 0 || highlightPreview;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OcChatAvatar(
                label: title,
                imageUrl: imageUrl,
                radius: 18,
                fallbackIcon: avatarFallbackIcon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _isUnread
                            ? OcColors.accent
                            : OcColors.textPrimary,
                        fontWeight: _isUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: highlightPreview
                            ? OcColors.accent
                            : OcColors.textSecondary,
                        fontWeight: highlightPreview
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  timestamp,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: OcColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OcChatStateSection extends StatelessWidget {
  const OcChatStateSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.chat_bubble_outline_rounded,
    this.action,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: OcColors.accentSoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: OcColors.accent, size: 32),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: OcColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

class OcChatBubble extends StatelessWidget {
  const OcChatBubble({
    super.key,
    required this.message,
    required this.timeLabel,
    required this.isCurrentUser,
  });

  final String message;
  final String timeLabel;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isCurrentUser ? OcColors.accent : OcColors.surfaceLight;
    final textColor = isCurrentUser ? OcColors.onAccent : OcColors.textPrimary;
    final timeColor = isCurrentUser
        ? OcColors.onAccent.withValues(alpha: 0.78)
        : OcColors.textMuted;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.74,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isCurrentUser ? 18 : 6),
              bottomRight: Radius.circular(isCurrentUser ? 6 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: textColor, height: 1.35),
              ),
              const SizedBox(height: 6),
              Text(
                timeLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: timeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OcChatComposer extends StatelessWidget {
  const OcChatComposer({
    super.key,
    required this.controller,
    required this.hintText,
    required this.sendLabel,
    required this.onSend,
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final String sendLabel;
  final VoidCallback onSend;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: OcColors.borderLight)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmitted,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: OcColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: OcColors.accent),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedScale(
              duration: _chatMotionDuration(context),
              curve: Curves.easeOutCubic,
              scale: enabled ? 1 : 0.96,
              child: Semantics(
                button: true,
                label: sendLabel,
                child: Material(
                  color: enabled ? OcColors.accent : OcColors.textMuted,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: enabled ? onSend : null,
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OcChatIconButton extends StatelessWidget {
  const _OcChatIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OcColors.surfaceLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: OcColors.accent, size: 20),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({
    required this.initials,
    required this.icon,
    required this.foregroundColor,
  });

  final String initials;
  final IconData icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    if (initials.isEmpty) {
      return Icon(icon, color: foregroundColor, size: 18);
    }

    return Text(
      initials,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
