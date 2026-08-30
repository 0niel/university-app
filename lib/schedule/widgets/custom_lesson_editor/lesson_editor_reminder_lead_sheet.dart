import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LessonEditorReminderLeadSheet extends StatelessWidget {
  const LessonEditorReminderLeadSheet({
    required this.current,
    required this.options,
    super.key,
  });

  final int current;
  final List<int> options;

  @override
  Widget build(BuildContext context) => NinjaSegmented<int>(
    value: options.contains(current)
        ? current
        : (options.firstOrNull ?? current),
    expanded: true,
    segments: [
      for (final minutes in options)
        NinjaSegment(value: minutes, label: '$minutes'),
    ],
    onChanged: (value) => Navigator.of(context, rootNavigator: true).pop(value),
  );
}
