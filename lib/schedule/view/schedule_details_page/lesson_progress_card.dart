part of '../schedule_details_page.dart';

class _LessonProgressCard extends StatelessWidget {
  const _LessonProgressCard({required this.lesson, required this.selectedDate});

  final LessonSchedulePart lesson;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final runtime = _lessonRuntime(lesson, selectedDate);
    final label = runtime.live
        ? l10n.lessonDetailsStatusLive
        : (runtime.past
              ? l10n.lessonDetailsStatusPast
              : l10n.lessonDetailsStatusSoon);
    final progress = runtime.progress;

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaScheduleSurface(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: NinjaText.body.copyWith(
                      color: runtime.live ? colors.brandInk : colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: NinjaText.tabular(
                    NinjaText.body.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(NinjaRadius.pill),
              child: SizedBox(
                height: 8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: progress.clamp(0.0, 1.0)),
                  duration: NinjaMotion.of(context, NinjaMotion.slow),
                  curve: NinjaMotion.enter,
                  builder: (context, value, _) => Stack(
                    fit: .expand,
                    children: [
                      ColoredBox(color: colors.surfaceAlt),
                      FractionallySizedBox(
                        alignment: .centerLeft,
                        widthFactor: value,
                        child: ColoredBox(color: colors.brand),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
