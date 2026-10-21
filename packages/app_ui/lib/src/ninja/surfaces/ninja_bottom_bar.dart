import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_batch.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter/widgets.dart';

part 'ninja_navigation_rail.dart';

class NinjaBottomBar extends StatelessWidget {
  const NinjaBottomBar({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  }) : assert(items.length > 1, 'At least two navigation items are required.'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'The selected navigation index must reference an item.',
       );

  final List<NinjaBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const double topPadding = 14;
  static const double bottomPadding = 6;

  static double extentOf(BuildContext context) {
    final viewport = _NinjaBottomBarViewportData.maybeOf(context);
    if (viewport != null) return viewport.bottomInset;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final pillHeight = textScale >= 1.6 ? 76.0 : AppControlSize.bottomBar;
    return pillHeight +
        topPadding +
        bottomPadding +
        MediaQuery.paddingOf(context).bottom;
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final expanded = textScale >= 1.6;
    final pillHeight = expanded ? 76.0 : AppControlSize.bottomBar;
    final circleSize = expanded ? 52.0 : AppControlSize.navCircle;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: SizedBox(
        height: pillHeight + topPadding + bottomPadding + bottomInset,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            topPadding,
            AppSpacing.md,
            bottomPadding + bottomInset,
          ),
          child: AppGlassBatch(
            child: AppGlassSurface(
              role: AppGlassRole.navigation,
              borderRadius: AppRadius.full,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: RepaintBoundary(
                child: SizedBox(
                  height: pillHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cellWidth = constraints.maxWidth / items.length;
                      return Stack(
                        children: [
                          PositionedDirectional(
                            start: 2,
                            top: 6,
                            bottom: 6,
                            width: cellWidth - 4,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: currentIndex * cellWidth,
                                end: currentIndex * cellWidth,
                              ),
                              duration: _reduceMotion(context)
                                  ? Duration.zero
                                  : const Duration(milliseconds: 360),
                              curve: Curves.easeOutCubic,
                              builder: (context, offset, child) =>
                                  Transform.translate(
                                    offset: Offset(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? -offset
                                          : offset,
                                      0,
                                    ),
                                    child: child,
                                  ),
                              child: DecoratedBox(
                                key: const ValueKey('navigation-selection'),
                                decoration: BoxDecoration(
                                  color: context.colors.tint,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.full,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
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
                        ],
                      );
                    },
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
    return _NinjaBottomBarViewportData(
      bottomInset: bottomInset,
      child: MediaQuery(
        data: mediaQuery.copyWith(
          padding: mediaQuery.padding.copyWith(
            bottom: math.max(mediaQuery.padding.bottom, bottomInset),
          ),
          viewPadding: mediaQuery.viewPadding.copyWith(
            bottom: math.max(mediaQuery.viewPadding.bottom, bottomInset),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _NinjaBottomBarViewportData extends InheritedWidget {
  const _NinjaBottomBarViewportData({
    required this.bottomInset,
    required super.child,
  });

  final double bottomInset;

  static _NinjaBottomBarViewportData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(_NinjaBottomBarViewportData oldWidget) =>
      oldWidget.bottomInset != bottomInset;
}

class NinjaBottomBarItem {
  const NinjaBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.hasBadge = false,
    this.badgeColor,
  });

  final Widget icon;
  final Widget? activeIcon;
  final String label;
  final bool hasBadge;
  final Color? badgeColor;
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
    final colors = context.colors;
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
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              decoration: const BoxDecoration(
                color: Color(0x00000000),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: selected ? colors.ink : colors.muted,
                      size: AppIconSize.navigation,
                    ),
                    child: icon,
                  ),
                  if (item.hasBadge)
                    PositionedDirectional(
                      end: 9,
                      top: 9,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: item.badgeColor ?? colors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 7),
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

bool _reduceMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);

typedef AppBottomBar = NinjaBottomBar;

typedef AppBottomBarItem = NinjaBottomBarItem;

typedef AppBottomBarViewport = NinjaBottomBarViewport;
