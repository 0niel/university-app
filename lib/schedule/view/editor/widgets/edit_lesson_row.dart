part of '../edit_schedule_page.dart';

class _EditLessonRow extends StatelessWidget {
  const _EditLessonRow({
    required this.lesson,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  final LessonSchedulePart lesson;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final color = LessonCard.colorOf(lesson);
    final classroomName = lesson.classrooms.firstOrNull?.name;
    final classroomSuffix = classroomName == null || classroomName.isEmpty
        ? ''
        : ' · $classroomName';

    return Dismissible(
      key: ValueKey(
        (
          lesson.subject,
          lesson.lessonBells.number,
          lesson.lessonBells.startTime,
        ),
      ),
      direction: .endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const .only(right: 20),
        decoration: BoxDecoration(
          color: colors.dangerTint,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: AppLineIconWidget(
          .trash,
          size: 20,
          color: colors.scarlet,
        ),
      ),
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Row(
          spacing: 12,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: RotatedBox(
                quarterTurns: 1,
                child: AppLineIconWidget(
                  .swipe,
                  size: 18,
                  color: colors.muted,
                ),
              ),
            ),
            Container(
              width: NinjaMetrics.subjectBarWidthCompact,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: .circular(NinjaRadius.pill),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 2,
                children: [
                  Text(
                    lesson.subject,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.body.copyWith(
                      color: colors.ink,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    '${lesson.lessonBells.startTime}–'
                    '${lesson.lessonBells.endTime}$classroomSuffix',
                    style: NinjaText.tabular(
                      NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
            ),
            AppPressable(
              onTap: onEdit,
              semanticsLabel: context.l10n.edit,
              child: Container(
                width: NinjaMetrics.minTouchTarget,
                height: NinjaMetrics.minTouchTarget,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  shape: .circle,
                ),
                child: Center(
                  child: AppLineIconWidget(
                    .pencil,
                    size: 17,
                    color: colors.mutedDark,
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
