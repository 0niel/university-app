part of '../compare_page.dart';

class _SlotCell extends StatelessWidget {
  const _SlotCell({required this.lesson, required this.same});

  final LessonSchedulePart? lesson;
  final bool same;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final lesson = this.lesson;
    if (lesson == null) {
      return Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Center(
          child: Text(
            context.l10n.compareFreeCell,
            style: NinjaText.subtext.copyWith(color: colors.muted),
          ),
        ),
      );
    }

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: NinjaMetrics.subjectBarWidthCompact,
                height: 18,
                decoration: BoxDecoration(
                  color: LessonCard.colorOf(lesson),
                  borderRadius: .circular(NinjaRadius.pill),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  lesson.subject,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.subtext.copyWith(color: colors.ink),
                ),
              ),
            ],
          ),
          if (same) ...[
            const SizedBox(height: 5),
            Text(
              context.l10n.compareTogether,
              style: NinjaText.helper.copyWith(color: colors.brandInk),
            ),
          ],
        ],
      ),
    );
  }
}
