part of '../schedule_details_page.dart';

class _LessonProgressCard extends StatelessWidget {
  const _LessonProgressCard({required this.lesson, required this.selectedDate});

  final LessonSchedulePart lesson;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final runtime = _lessonRuntime(lesson, selectedDate);
    if (!runtime.live && !runtime.past) return const SizedBox.shrink();
    final label = runtime.live
        ? context.l10n.lessonDetailsStatusLive
        : context.l10n.lessonDetailsStatusPast;
    final progress = runtime.progress;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.zero,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: ColoredBox(
          color: context.colors.tint,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xxs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: AppText.sans(
                          12,
                          FontWeight.w700,
                        ).copyWith(color: context.colors.accent),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppText.sans(
                        11,
                        FontWeight.w600,
                        tabular: true,
                      ).copyWith(color: context.colors.accent),
                    ),
                  ],
                ),
              ),
              if (runtime.live)
                TweenAnimationBuilder<double>(
                  tween: Tween(end: progress.clamp(0.0, 1.0)),
                  duration: NinjaMotion.of(context, NinjaMotion.slow),
                  curve: NinjaMotion.enter,
                  builder: (context, value, _) => FractionallySizedBox(
                    widthFactor: value,
                    alignment: Alignment.centerLeft,
                    child: ColoredBox(
                      color: context.colors.accent,
                      child: const SizedBox(height: AppSpacing.xxs),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
