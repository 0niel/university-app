part of '../schedule_details_page.dart';

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.lesson, this.profile});

  final LessonSchedulePart lesson;
  final TeacherProfile? profile;

  @override
  Widget build(BuildContext context) {
    final teachers = lesson.teachers;
    if (teachers.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(title: context.l10n.lessonDetailsTeacherFallback),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NinjaMetrics.screenPadding,
          ),
          child: Column(
            spacing: 10,
            children: [
              for (var i = 0; i < teachers.length; i++)
                _TeacherRow(
                  teacher: teachers[i],
                  profile: i == 0 ? profile : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
