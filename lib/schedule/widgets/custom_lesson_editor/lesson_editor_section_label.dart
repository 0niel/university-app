import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LessonEditorSectionLabel extends StatelessWidget {
  const LessonEditorSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppText.headline.copyWith(color: context.colors.ink),
  );
}
