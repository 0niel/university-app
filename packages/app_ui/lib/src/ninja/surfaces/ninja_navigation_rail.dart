part of 'ninja_bottom_bar.dart';

class NinjaNavigationRail extends StatelessWidget {
  const NinjaNavigationRail({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    this.extended = false,
    super.key,
  }) : assert(items.length > 1, 'At least two navigation items are required.'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'The selected navigation index must reference an item.',
       );

  final List<NinjaBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showLabels =
        extended && MediaQuery.textScalerOf(context).scale(1) < 1.6;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: ColoredBox(
        color: colors.canvas,
        child: SafeArea(
          right: false,
          child: SizedBox(
            width: showLabels ? 220 : 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Center(
                child: AppGlassBatch(
                  child: AppGlassSurface(
                    role: AppGlassRole.navigation,
                    borderRadius: AppRadius.sheet,
                    child: RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sheet),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (
                                  var index = 0;
                                  index < items.length;
                                  index++
                                )
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: index == items.length - 1
                                          ? 0
                                          : AppSpacing.sm,
                                    ),
                                    child: _RailItem(
                                      key: ValueKey(index),
                                      item: items[index],
                                      selected: index == currentIndex,
                                      showLabel: showLabels,
                                      onTap: () => onSelected(index),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.item,
    required this.selected,
    required this.showLabel,
    required this.onTap,
    super.key,
  });

  final NinjaBottomBarItem item;
  final bool selected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = selected ? colors.ink : colors.muted;
    final icon = SizedBox.square(
      dimension: AppIconSize.lg,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          IconTheme(
            data: IconThemeData(color: tint, size: AppIconSize.navigation),
            child: selected ? (item.activeIcon ?? item.icon) : item.icon,
          ),
          if (item.hasBadge)
            PositionedDirectional(
              end: -AppSpacing.xxs,
              top: -AppSpacing.xxs,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: item.badgeColor ?? colors.accent,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: AppSpacing.compactGap),
              ),
            ),
        ],
      ),
    );

    return Tooltip(
      message: item.label,
      excludeFromSemantics: true,
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: item.label,
        semanticsButton: true,
        semanticsSelected: selected,
        child: AnimatedContainer(
          duration: _reduceMotion(context)
              ? Duration.zero
              : const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(
            minHeight: AppControlSize.buttonMedium,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? AppSpacing.md : 0,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colors.accent.withValues(alpha: .17)
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: showLabel
              ? Row(
                  children: [
                    icon,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            (selected ? AppText.captionBold : AppText.caption)
                                .copyWith(color: tint),
                      ),
                    ),
                  ],
                )
              : Center(child: icon),
        ),
      ),
    );
  }
}
