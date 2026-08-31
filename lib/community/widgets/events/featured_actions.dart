part of '../featured_event_card.dart';

class _FeaturedActions extends StatelessWidget {
  const _FeaturedActions({
    required this.event,
    required this.onRsvp,
    required this.isPending,
  });

  final CampusEvent event;
  final VoidCallback onRsvp;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final names = event.goingNames.take(3).toList();
    final action = event.isGoing
        ? NinjaButton.secondary(
            label: l10n.eventsGoingYes,
            size: NinjaButtonSize.medium,
            loading: isPending,
            onPressed: isPending ? null : onRsvp,
          )
        : NinjaButton.primary(
            label: l10n.eventsRsvp,
            size: NinjaButtonSize.medium,
            loading: isPending,
            onPressed: isPending ? null : onRsvp,
          );
    final people = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (names.isNotEmpty) ...[
          NinjaAvatarGroup(
            size: 32,
            items: [
              for (final name in names)
                NinjaAvatarGroupItem(ninjaInitials(name)),
            ],
          ),
          const SizedBox(width: 8),
        ],
        Text(
          _attendeeCount,
          style: NinjaText.tabular(
            NinjaText.helper.copyWith(color: colors.onAccentSoftMuted),
          ),
        ),
      ],
    );
    if (MediaQuery.textScalerOf(context).scale(14) > 19) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [action, const SizedBox(height: 12), people],
      );
    }
    return Row(children: [action, const SizedBox(width: 12), people]);
  }

  String get _attendeeCount {
    final hiddenCount = event.goingCount - event.goingNames.take(3).length;
    return hiddenCount > 0 ? '+$hiddenCount' : '${event.goingCount}';
  }
}
