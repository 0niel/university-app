part of '../schedule_page.dart';

class _ScheduleFloatingActions extends StatelessWidget {
  const _ScheduleFloatingActions({
    required this.showToday,
    required this.showAdd,
    required this.onToday,
    required this.onAdd,
  });

  static const double _fullyVisibleScale = 1;

  final bool showToday;
  final bool showAdd;
  final VoidCallback onToday;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration = reduceMotion ? Duration.zero : NinjaMotion.base;

    return Padding(
      padding: .only(bottom: context.ui.space(16)),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        children: [
          AnimatedSwitcher(
            duration: duration,
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(.22, .45),
                  end: Offset.zero,
                ).animate(animation),
                child: ScaleTransition(
                  scale: Tween(
                    begin: .86,
                    end: _fullyVisibleScale,
                  ).animate(animation),
                  child: child,
                ),
              ),
            ),
            child: showToday
                ? _TodayFloatingButton(
                    key: const ValueKey('schedule-today-button'),
                    onTap: onToday,
                  )
                : const SizedBox.shrink(
                    key: ValueKey('schedule-today-button-hidden'),
                  ),
          ),
          if (showToday && showAdd) const SizedBox(height: 10),
          if (showAdd) _ScheduleFab(onPressed: onAdd),
        ],
      ),
    );
  }
}

class _TodayFloatingButton extends StatelessWidget {
  const _TodayFloatingButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: true,
      label: context.l10n.today,
      child: AppPressable(
        pressedScale: .96,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          padding: const .symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: .circular(NinjaRadius.pill),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              AppLineIconWidget(.calendar, size: 17, color: colors.onInk),
              const SizedBox(width: 8),
              Text(
                context.l10n.today,
                style: NinjaText.buttonSmall.copyWith(color: colors.onInk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
