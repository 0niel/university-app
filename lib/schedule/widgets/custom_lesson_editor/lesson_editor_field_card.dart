import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LessonEditorFieldCard extends StatelessWidget {
  const LessonEditorFieldCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    spacing: AppSpacing.gap,
    children: children,
  );
}
