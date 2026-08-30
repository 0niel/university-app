part of '../event_row.dart';

class _RsvpPill extends StatelessWidget {
  const _RsvpPill({
    required this.isGoing,
    required this.isPending,
    required this.onPressed,
  });

  final bool isGoing;
  final bool isPending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isGoing
        ? context.l10n.eventsGoingShort
        : context.l10n.eventsRsvp;
    void handlePress() {
      unawaited(HapticFeedback.lightImpact());
      onPressed();
    }

    return Semantics(
      button: true,
      enabled: !isPending,
      label: label,
      child: isGoing
          ? NinjaButton.secondary(
              label: label,
              size: NinjaButtonSize.small,
              loading: isPending,
              onPressed: isPending ? null : handlePress,
            )
          : NinjaButton.primary(
              label: label,
              size: NinjaButtonSize.small,
              loading: isPending,
              onPressed: isPending ? null : handlePress,
            ),
    );
  }
}
