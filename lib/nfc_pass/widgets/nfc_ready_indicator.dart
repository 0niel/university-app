part of 'nfc_pass_card.dart';

class _NfcReadyIndicator extends StatelessWidget {
  const _NfcReadyIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final dot = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onAccentSoft,
        shape: BoxShape.circle,
      ),
      child: const SizedBox.square(dimension: 13),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onAccentSoft.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: 34,
        child: Center(
          child: reduceMotion
              ? dot
              : dot
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(begin: 0.35, end: 1, duration: 900.ms),
        ),
      ),
    );
  }
}
