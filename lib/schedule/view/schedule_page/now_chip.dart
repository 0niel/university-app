part of '../schedule_page.dart';

class _NowChip extends StatelessWidget {
  const _NowChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final chip = AppPressable(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: colors.brand,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colors.onBrand,
                shape: .circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.liveNow,
              style: NinjaText.buttonSmall.copyWith(
                color: colors.onBrand,
              ),
            ),
          ],
        ),
      ),
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 18,
      child: Center(
        child: reduceMotion
            ? chip
            : TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: chip,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: FractionalTranslation(
                    translation: Offset(0, .4 * (1 - value)),
                    child: child,
                  ),
                ),
              ),
      ),
    );
  }
}
