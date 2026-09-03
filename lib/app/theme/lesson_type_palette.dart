import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const Map<String, int> kDefaultLessonTypeColors = {
  'lecture': 0xFF0E8A63,
  'practice': 0xFF2F7AFF,
  'laboratoryWork': 0xFF8B5CF6,
  'individualWork': 0xFF8B5CF6,
  'physicalEducation': 0xFF0E8A63,
  'consultation': 0xFF2F7AFF,
  'exam': 0xFFE5484D,
  'credit': 0xFFC77700,
  'courseWork': 0xFF8B5CF6,
  'courseProject': 0xFF8B5CF6,
  'unknown': 0xFF6B7280,
};

const Map<String, int> _legacyDefaultLessonTypeColors = {
  'lecture': 0xFF087F5B,
  'physicalEducation': 0xFF087F5B,
  'credit': 0xFFDB8B00,
  'unknown': 0xFF74747D,
};

class LessonTypePalette extends InheritedWidget {
  const LessonTypePalette({
    required this.colors,
    required super.child,
    super.key,
  });

  final Map<String, int> colors;

  static Map<String, int> of(BuildContext context) => resolve(
    context.colors,
    context.dependOnInheritedWidgetOfExactType<LessonTypePalette>()?.colors ??
        const {},
  );

  static Map<String, int> resolve(
    AppColors palette,
    Map<String, int> overrides,
  ) => {
    'lecture': palette.lecture.toARGB32(),
    'practice': palette.practice.toARGB32(),
    'laboratoryWork': palette.lab.toARGB32(),
    'individualWork': palette.lab.toARGB32(),
    'physicalEducation': palette.lecture.toARGB32(),
    'consultation': palette.practice.toARGB32(),
    'exam': palette.exam.toARGB32(),
    'credit': palette.warn.toARGB32(),
    'courseWork': palette.lab.toARGB32(),
    'courseProject': palette.lab.toARGB32(),
    'unknown': palette.muted.toARGB32(),
    for (final entry in overrides.entries)
      if (entry.value != kDefaultLessonTypeColors[entry.key] &&
          entry.value != _legacyDefaultLessonTypeColors[entry.key])
        entry.key: entry.value,
  };

  @override
  bool updateShouldNotify(LessonTypePalette oldWidget) =>
      !mapEquals(colors, oldWidget.colors);
}
