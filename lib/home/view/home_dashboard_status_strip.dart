import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/home/cubit/home_gamification_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_status_strip.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDashboardStatusStrip extends StatelessWidget {
  const HomeDashboardStatusStrip({
    required this.deadlines,
    required this.now,
    required this.onProfile,
    required this.onDeadlines,
    required this.onExam,
    this.exam,
    super.key,
  });

  final List<Deadline> deadlines;
  final DateTime now;
  final HomeLessonEntry? exam;
  final VoidCallback onProfile;
  final VoidCallback onDeadlines;
  final VoidCallback onExam;

  @override
  Widget build(BuildContext context) {
    final nextExam = exam;
    final readiness = context.select<ExamReadinessCubit, double?>((cubit) {
      final state = cubit.state;
      return nextExam != null &&
              state.entries.any(
                (entry) => entry.subjectName == nextExam.lesson.subject,
              )
          ? state.readinessFor(nextExam.lesson.subject)
          : null;
    });
    return HomeStatusStrip(
      deadlines: deadlines,
      profile: context.watch<HomeGamificationCubit>().state,
      now: now,
      exam: nextExam,
      readiness: readiness,
      onProfile: onProfile,
      onDeadlines: onDeadlines,
      onExam: onExam,
    );
  }
}
