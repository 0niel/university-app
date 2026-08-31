part of 'map_floor_switcher.dart';

class _FloorChoice extends StatelessWidget {
  const _FloorChoice({
    required this.floor,
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
  });

  final FloorModel floor;
  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticLabel,
      semanticsButton: true,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration:
            MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(
          minWidth: 52,
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.brand : Colors.transparent,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        alignment: .center,
        child: Text(
          '${floor.number}',
          style: NinjaText.tabular(
            NinjaText.headline.copyWith(
              color: selected ? colors.onBrand : colors.mutedDark,
            ),
          ),
        ),
      ),
    );
  }
}
