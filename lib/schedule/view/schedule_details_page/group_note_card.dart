part of '../schedule_details_page.dart';

class _GroupNoteCard extends StatelessWidget {
  const _GroupNoteCard({
    required this.lesson,
    required this.day,
    required this.onTap,
  });
  final LessonSchedulePart lesson;
  final DateTime day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final comments =
        context.watch<LessonCommentsCubit?>()?.state.comments ??
        const <LessonComment>[];
    final note = comments
        .where(
          (comment) =>
              comment.isSharedWithGroup &&
              comment.subjectName == lesson.subject &&
              _sameDate(comment.lessonDate, day) &&
              comment.lessonBells == lesson.lessonBells,
        )
        .firstOrNull;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sheetBottom,
        AppSpacing.screen,
        AppSpacing.zero,
      ),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.fieldGap,
          vertical: AppSpacing.lg,
        ),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.lessonGroupNote,
              style: AppText.captionSmall.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              note?.text ?? context.l10n.lessonGroupNoteEmpty,
              style: AppText.cell.copyWith(
                color: note == null ? context.colors.muted : context.colors.ink,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
