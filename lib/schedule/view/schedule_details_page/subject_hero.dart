part of '../schedule_details_page.dart';

class _SubjectHero extends StatelessWidget {
  const _SubjectHero({required this.lesson, required this.selectedDate});

  final LessonSchedulePart lesson;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final runtime = _lessonRuntime(lesson, selectedDate);
    final teacher = _teacherLine(lesson);
    final live = runtime.live;
    final foreground = live ? colors.onAccentSoft : colors.ink;
    final muted = live ? colors.onAccentSoftMuted : colors.muted;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: NinjaScheduleSurface(
        color: live ? colors.accentSoft : colors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (live) ...[
                  ExcludeSemantics(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: foreground,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
                Flexible(
                  child: Text(
                    live
                        ? l10n.lessonDetailsLiveNow
                        : _lessonTypeName(l10n, lesson),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.microLabel.copyWith(
                      color: live
                          ? foreground
                          : colors.subjectColor(
                              lesson.subject,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              lesson.subject,
              style: NinjaText.title.copyWith(color: foreground),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _timeRange(lesson),
                  style: NinjaText.tabular(
                    NinjaText.body.copyWith(color: foreground),
                  ),
                ),
                if (runtime.past)
                  Text(
                    l10n.lessonDetailsEnded,
                    style: NinjaText.subtext.copyWith(color: muted),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth >= 540
                    ? (constraints.maxWidth - 24) / 3
                    : constraints.maxWidth;
                return Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: NinjaScheduleFact(
                        label: l10n.classroom,
                        value: _classroomLine(l10n, lesson),
                        icon: AppLineIcon.pin,
                        foreground: foreground,
                        muted: muted,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: NinjaScheduleFact(
                        label: l10n.lessonDetailsTeacherFallback,
                        value: teacher.isEmpty ? '—' : teacher,
                        icon: AppLineIcon.user,
                        foreground: foreground,
                        muted: muted,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: NinjaScheduleFact(
                        label: l10n.classLabel,
                        value: '${lesson.lessonBells.number ?? '—'}',
                        icon: AppLineIcon.clock,
                        foreground: foreground,
                        muted: muted,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
