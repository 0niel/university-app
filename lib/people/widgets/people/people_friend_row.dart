part of '../people_widgets.dart';

class PeopleFriendRow extends StatelessWidget {
  const PeopleFriendRow({required this.friend, required this.now, super.key});

  final Friend friend;
  final DateTime now;

  (bool, String)? _lastSeen(AppLocalizations l10n) {
    final updated = friend.locationUpdatedAt;
    if (updated == null || friend.isGhost) return null;
    final difference = now.difference(updated.toLocal());
    if (difference.inMinutes < 5) return (true, l10n.peopleOnline);
    if (difference.inMinutes < 60) {
      return (false, l10n.lostFoundMinutesAgo(difference.inMinutes));
    }
    if (difference.inHours < 24) {
      return (false, l10n.lostFoundHoursAgo(difference.inHours));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final lastSeen = _lastSeen(context.l10n);
    final group = friend.group;
    return Row(
      children: [
        NinjaAvatar(initials: ninjaInitials(friend.fullName)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      friend.fullName,
                      overflow: .ellipsis,
                      style: NinjaText.body.copyWith(color: colors.ink),
                    ),
                  ),
                  if (friend.mood.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(friend.mood, style: const TextStyle(fontSize: 14)),
                  ],
                ],
              ),
              Text(
                [
                  if (friend.handle case final handle? when handle.isNotEmpty)
                    '@$handle',
                  ?group,
                ].join(' · '),
                overflow: .ellipsis,
                style: NinjaText.helper.copyWith(
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
        if (lastSeen != null)
          Text(
            lastSeen.$2,
            style: NinjaText.helper.copyWith(
              fontWeight: .w600,
              color: lastSeen.$1 ? colors.brandInk : colors.muted,
            ),
          )
        else if (friend.isGhost)
          AppLineIconWidget(.hide, size: 16, color: colors.muted),
      ],
    );
  }
}
