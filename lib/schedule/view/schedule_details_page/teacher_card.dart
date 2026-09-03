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
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: Column(
            spacing: AppSpacing.gap,
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
