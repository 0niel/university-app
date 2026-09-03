part of 'ninja_friend_requests_sheet.dart';

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.fullName,
    required this.group,
    required this.busy,
    required this.onRespond,
  });

  final String fullName;
  final String? group;
  final bool busy;
  final ValueChanged<bool> onRespond;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final groupName = group;
    return Padding(
      padding: const .only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(AppSpacing.lg),
          child: Row(
            children: [
              AppAvatar(name: fullName, size: FriendsLayout.avatar),
              const SizedBox(width: AppSpacing.sectionGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 3,
                  children: [
                    Text(
                      fullName,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: AppText.headline.copyWith(color: colors.ink),
                    ),
                    if (groupName != null)
                      Text(
                        groupName,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.gap),
              Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [
                  FriendsCircleButton(
                    icon: .check,
                    tone: .accent,
                    label: '${l10n.friendsAccept}: $fullName',
                    onTap: busy ? null : () => onRespond(true),
                  ),
                  FriendsCircleButton(
                    icon: .close,
                    tone: .danger,
                    label: '${l10n.friendsDecline}: $fullName',
                    onTap: busy ? null : () => onRespond(false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
