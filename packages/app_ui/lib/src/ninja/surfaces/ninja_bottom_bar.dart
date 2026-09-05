import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
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
    final colors = context.colors;
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [colors.canvas, colors.canvas.withValues(alpha: 0)],
              stops: const [0.6, 1],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              topPadding,
              AppSpacing.md,
              bottomPadding + bottomInset,
            ),
            child: Container(
              height: pillHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.full),
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
      context.dependOnInheritedWidgetOfExactType<_NinjaBottomBarViewportData>();

  @override
  bool updateShouldNotify(_NinjaBottomBarViewportData oldWidget) =>
      oldWidget.bottomInset != bottomInset;
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
    final colors = context.colors;
    final expanded = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    final width = expanded ? 176.0 : 116.0;

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
                return Center(
                  child: SizedBox(
                    height: itemHeight * items.length,
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
              decoration: BoxDecoration(
                color: selected ? colors.accent : const Color(0x00000000),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: selected ? colors.onAccent : colors.muted,
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
                          color: selected
                              ? colors.onAccent
                              : (item.badgeColor ?? colors.accent),
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
    final colors = context.colors;
    final icon = selected ? (item.activeIcon ?? item.icon) : item.icon;
    final tint = selected ? colors.accent : colors.muted;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: AppPressable(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.fieldGap),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 24,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: tint,
                          size: AppIconSize.navigation,
                        ),
                        child: icon,
                      ),
                      if (item.hasBadge)
                        PositionedDirectional(
                          end: -2,
                          top: -2,
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
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: (selected ? AppText.captionBold : AppText.caption)
                        .copyWith(color: tint, height: 1.08),
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

typedef AppBottomBar = NinjaBottomBar;

typedef AppBottomBarItem = NinjaBottomBarItem;

typedef AppBottomBarViewport = NinjaBottomBarViewport;
