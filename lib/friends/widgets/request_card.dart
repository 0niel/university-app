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
    final colors = context.ninja;
    final l10n = context.l10n;
    final groupName = group;
    return Padding(
      padding: const .only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            children: [
              NinjaAvatar(initials: ninjaInitials(fullName)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 3,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    if (groupName != null)
                      Text(
                        groupName,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.helper.copyWith(color: colors.muted),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
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
