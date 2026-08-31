part of 'campus_selector.dart';

class _CampusChoice extends StatelessWidget {
  const _CampusChoice({
    required this.campus,
    required this.selected,
    required this.onTap,
  });

  final CampusModel campus;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final floorLabel = context.l10n.mapFloorsCount(campus.floors.length);
    return AppPressable(
      onTap: onTap,
      semanticsLabel: campus.displayName,
      semanticsButton: true,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration:
            MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              alignment: .center,
              decoration: BoxDecoration(
                color: selected ? colors.brand : colors.surface,
                shape: .circle,
              ),
              child: AppLineIconWidget(
                .school,
                size: 20,
                color: selected ? colors.onBrand : colors.mutedDark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    campus.displayName,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    floorLabel,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AppLineIconWidget(
              selected ? .check : .chevronR,
              size: 18,
              color: selected ? colors.brand : colors.chevron,
            ),
          ],
        ),
      ),
    );
  }
}
