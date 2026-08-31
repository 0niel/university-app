import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_lesson_editor/lesson_editor_section_label.dart';

class LessonEditorSubjectCard extends StatelessWidget {
  const LessonEditorSubjectCard({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      spacing: 10,
      crossAxisAlignment: .start,
      children: [
        LessonEditorSectionLabel(label),
        NinjaInput(
          controller: controller,
          placeholder: hint,
          autofocus: true,
          textInputAction: .done,
          onChanged: onChanged,
          textStyle: NinjaText.dialogTitle.copyWith(color: colors.ink),
        ),
      ],
    );
  }
}
