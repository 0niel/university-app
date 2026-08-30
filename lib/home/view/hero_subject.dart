part of 'home_lesson_hero.dart';

class _HeroSubject extends StatelessWidget {
  const _HeroSubject({
    required this.lesson,
    required this.room,
    required this.teacher,
    required this.accessible,
  });

  final LessonSchedulePart lesson;
  final String room;
  final String teacher;
  final bool accessible;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          lesson.subject,
          maxLines: accessible ? 4 : 3,
          overflow: .ellipsis,
          style: NinjaText.title.copyWith(color: colors.onAccentSoft),
        ),
        const SizedBox(height: 6),
        Text(
          [
            if (lesson.lessonBells.number case final number?)
              context.l10n.lessonDetailsPairNumber('$number'),
            LessonCard.getLessonTypeName(
              context.l10n,
              lesson.lessonType,
            ).toLowerCase(),
            room,
            if (teacher.isNotEmpty) teacher,
          ].join(' · '),
          maxLines: accessible ? 3 : 2,
          overflow: .ellipsis,
          style: NinjaText.subtext.copyWith(color: colors.onAccentSoftMuted),
        ),
      ],
    );
  }
}
