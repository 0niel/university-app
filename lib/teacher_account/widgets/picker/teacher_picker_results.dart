import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_picker_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/picker/teacher_picker_row.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherPickerResults extends StatelessWidget {
  const TeacherPickerResults({
    required this.state,
    required this.enabled,
    required this.maxHeight,
    required this.onSelected,
    super.key,
  });

  final TeacherPickerState state;
  final bool enabled;
  final double maxHeight;
  final ValueChanged<Teacher> onSelected;

  @override
  Widget build(BuildContext context) {
    final teachers = state.visibleTeachers;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.row),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.separated(
          key: const ValueKey('teacher-picker-results'),
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          separatorBuilder: (_, _) => const AppDivider(),
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return TeacherPickerRow(
              teacher: teacher,
              enabled: enabled,
              ambiguous: state.isAmbiguous(teacher),
              onSelected: onSelected,
            );
          },
        ),
      ),
    );
  }
}
