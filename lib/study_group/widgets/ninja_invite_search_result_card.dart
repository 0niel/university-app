part of 'ninja_invite_sheet.dart';

class NinjaInviteSearchResultCard extends StatelessWidget {
  const NinjaInviteSearchResultCard({
    required this.name,
    required this.subtitle,
    required this.invited,
    required this.onInvite,
    super.key,
  });

  final String name;
  final String subtitle;
  final bool invited;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final Widget trailing = invited
        ? NinjaBadge(l10n.studyGroupInviteSent, tone: .ink)
        : NinjaButton.primary(
            label: l10n.studyGroupInviteSend,
            size: .small,
            onPressed: onInvite,
          );
    return Padding(
      padding: const .only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            spacing: 14,
            children: [
              NinjaAvatar(initials: ninjaInitials(name)),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.headline.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
