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
    final colors = context.colors;
    final color = LessonCard.colorOfFor(context, lesson);
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
          borderRadius: .circular(AppRadius.card),
        ),
        child: AppLineIconWidget(
          .trash,
          size: 20,
          color: colors.exam,
        ),
      ),
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Row(
          spacing: AppSpacing.md,
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
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: .circular(AppRadius.full),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(
                    lesson.subject,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: AppText.body.copyWith(
                      color: colors.ink,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    '${lesson.lessonBells.startTime}–'
                    '${lesson.lessonBells.endTime}$classroomSuffix',
                    style: AppText.tabular(
                      AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
            ),
            AppPressable(
              onTap: onEdit,
              semanticsLabel: context.l10n.edit,
              child: Container(
                width: AppControlSize.touchTarget,
                height: AppControlSize.touchTarget,
                decoration: BoxDecoration(
                  color: colors.surface2,
                  shape: .circle,
                ),
                child: Center(
                  child: AppLineIconWidget(
                    .pencil,
                    size: 17,
                    color: colors.muted,
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
