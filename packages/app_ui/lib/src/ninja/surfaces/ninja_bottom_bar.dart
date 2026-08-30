import 'dart:math' as math;

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaBottomBar extends StatelessWidget {
  const NinjaBottomBar({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  })  : assert(items.length > 1, 'At least two navigation items are required.'),
        assert(
          currentIndex >= 0 && currentIndex < items.length,
          'The selected navigation index must reference an item.',
        );

  final List<NinjaBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  static double extentOf(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final pillHeight = textScale >= 1.6 ? 76.0 : 64.0;
    return pillHeight + 24 + MediaQuery.paddingOf(context).bottom;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final expanded = textScale >= 1.6;
    final pillHeight = expanded ? 76.0 : 64.0;
    final circleSize = expanded ? 52.0 : 46.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: SizedBox(
        height: pillHeight + 24 + bottomInset,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
          child: Container(
            height: pillHeight,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(NinjaRadius.pill),
            ),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: _BottomBarItem(
                      item: items[index],
                      selected: index == currentIndex,
                      circleSize: circleSize,
                      onTap: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NinjaBottomBarViewport extends StatelessWidget {
  const NinjaBottomBarViewport({
    required this.bottomInset,
    required this.child,
    super.key,
  });

  final double bottomInset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: mediaQuery.padding.copyWith(
          bottom: math.max(mediaQuery.padding.bottom, bottomInset),
        ),
        viewPadding: mediaQuery.viewPadding.copyWith(
          bottom: math.max(mediaQuery.viewPadding.bottom, bottomInset),
        ),
      ),
      child: child,
    );
  }
}

class NinjaNavigationRail extends StatelessWidget {
  const NinjaNavigationRail({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  })  : assert(items.length > 1, 'At least two navigation items are required.'),
        assert(
          currentIndex >= 0 && currentIndex < items.length,
          'The selected navigation index must reference an item.',
        );

  final List<NinjaBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final expanded = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    final width = expanded ? 176.0 : 116.0;
    final reduceMotion = _reduceMotion(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: ColoredBox(
        color: colors.surface,
        child: SizedBox(
          width: width,
          child: SafeArea(
            right: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemHeight = (constraints.maxHeight / items.length)
                    .clamp(48, 64)
                    .toDouble();
                final groupHeight = itemHeight * items.length;
                return Center(
                  child: SizedBox(
                    height: groupHeight,
                    child: Stack(
                      children: [
                        AnimatedPositionedDirectional(
                          duration: reduceMotion
                              ? Duration.zero
                              : const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          start: 0,
                          top:
                              currentIndex * itemHeight + (itemHeight - 30) / 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.brand,
                              borderRadius:
                                  const BorderRadiusDirectional.horizontal(
                                end: Radius.circular(3),
                              ),
                            ),
                            child: const SizedBox(width: 3, height: 30),
                          ),
                        ),
                        Positioned.fill(
                          child: Column(
                            children: [
                              for (var index = 0; index < items.length; index++)
                                SizedBox(
                                  height: itemHeight,
                                  child: _RailItem(
                                    item: items[index],
                                    selected: index == currentIndex,
                                    onTap: () => onSelected(index),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NinjaBottomBarItem {
  const NinjaBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.hasBadge = false,
  });

  final Widget icon;
  final Widget? activeIcon;
  final String label;
  final bool hasBadge;
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.item,
    required this.selected,
    required this.circleSize,
    required this.onTap,
  });

  final NinjaBottomBarItem item;
  final bool selected;
  final double circleSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion = _reduceMotion(context);
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: AppPressable(
          onTap: onTap,
          child: Center(
            child: AnimatedContainer(
              width: circleSize,
              height: circleSize,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: selected ? colors.brand : const Color(0x00000000),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: selected ? colors.onBrand : colors.mutedDark,
                      size: 23,
                    ),
                    child: icon,
                  ),
                  if (item.hasBadge)
                    PositionedDirectional(
                      end: 8,
                      top: 8,
                      child: Container(
                        constraints: const BoxConstraints.tightFor(
                          width: 7,
                          height: 7,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? colors.onBrand : colors.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
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
    required this.onTap,
  });

  final NinjaBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;
    final tint = selected ? colors.brandInk : colors.mutedDark;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: AppPressable(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 24,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(color: tint, size: 23),
                        child: icon,
                      ),
                      if (item.hasBadge)
                        PositionedDirectional(
                          end: -2,
                          top: -2,
                          child: Container(
                            constraints: const BoxConstraints.tightFor(
                              width: 7,
                              height: 7,
                            ),
                            decoration: BoxDecoration(
                              color: colors.brand,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tint,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      height: 1.08,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _reduceMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);
