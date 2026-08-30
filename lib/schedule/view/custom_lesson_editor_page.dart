import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/custom_lesson_editor_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

class CustomLessonEditorPage extends StatelessWidget {
  const CustomLessonEditorPage({
    required this.scheduleId,
    this.lesson,
    this.weekday,
    super.key,
  });

  final String scheduleId;
  final LessonSchedulePart? lesson;
  final int? weekday;

  @override
  Widget build(BuildContext context) {
    final config = context.read<UniversityConfig>();
    return BlocProvider(
      create: (providerContext) => CustomLessonEditorCubit(
        customScheduleCubit: providerContext.read(),
        scheduleId: scheduleId,
        bellSlots: config.lessonBellSlots,
        colors: config.lessonColorValues,
        reminderLeadMinutes: config.lessonReminderLeadMinutes,
        lesson: lesson,
        weekday: weekday,
      ),
      child: CustomLessonEditorView(
        isEditing: lesson != null,
        bellSlots: config.lessonBellSlots,
        colors: config.lessonColorValues,
        reminderLeadMinutes: config.lessonReminderLeadMinutes,
      ),
    );
  }
}
