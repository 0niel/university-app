part of '../schedule_page.dart';

double _viewSelectorItemHeight(BuildContext context) {
  final scale = math
      .max(1, MediaQuery.textScalerOf(context).scale(1))
      .toDouble();
  return NinjaMetrics.minTouchTarget + (scale - 1) * 12;
}

class _CollapsingViewSelector extends StatelessWidget {
  const _CollapsingViewSelector({
    required this.progress,
    required this.child,
  });

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);
    return IgnorePointer(
      ignoring: value > .95,
      child: ExcludeSemantics(
        excluding: value > .95,
        child: ClipRect(
          key: const ValueKey('schedule-collapsing-view-selector'),
          child: Align(
            heightFactor: 1 - value,
            alignment: .topCenter,
            child: Opacity(
              opacity: 1 - value,
              child: FractionalTranslation(
                translation: Offset(0, -.3 * value),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewSelector extends StatelessWidget {
  const _ViewSelector({required this.value, required this.onChanged});

  final _ScheduleView value;
  final ValueChanged<_ScheduleView> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final items = [
      (_ScheduleView.agenda, l10n.viewDay),
      (_ScheduleView.week, l10n.viewWeek),
      (_ScheduleView.month, l10n.viewMonth),
    ];
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final height = _viewSelectorItemHeight(context);
    final selectedIndex = items.indexWhere((item) => item.$1 == value);
    final indicatorAlignment = switch (selectedIndex) {
      0 => AlignmentDirectional.centerStart,
      1 => AlignmentDirectional.center,
      _ => AlignmentDirectional.centerEnd,
    };
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 360);

    return Padding(
      key: const ValueKey('schedule-view-selector'),
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        2,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Container(
        padding: const .all(4),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                duration: duration,
                curve: const Cubic(0.2, 0.82, 0.2, 1),
                alignment: indicatorAlignment,
                child: FractionallySizedBox(
                  widthFactor: 1 / 3,
                  heightFactor: 1,
                  child: DecoratedBox(
                    key: const ValueKey('schedule-view-indicator'),
                    decoration: BoxDecoration(
                      color: colors.brand,
                      borderRadius: .circular(NinjaRadius.pill),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: AppPressable(
                      onTap: () => onChanged(item.$1),
                      semanticsButton: true,
                      semanticsSelected: item.$1 == value,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: height),
                        child: AnimatedDefaultTextStyle(
                          duration: reduceMotion
                              ? Duration.zero
                              : NinjaMotion.fast,
                          curve: NinjaMotion.enter,
                          style: NinjaText.buttonSmall.copyWith(
                            color: item.$1 == value
                                ? colors.onBrand
                                : colors.mutedDark,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const .symmetric(horizontal: 8),
                              child: Text(
                                item.$2,
                                maxLines: 1,
                                overflow: .ellipsis,
                                textAlign: .center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
