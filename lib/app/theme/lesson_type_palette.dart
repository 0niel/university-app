import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const Map<String, int> kDefaultLessonTypeColors = {
  'lecture': 0xFF087F5B,
  'practice': 0xFF2F7AFF,
  'laboratoryWork': 0xFF8B5CF6,
  'individualWork': 0xFF8B5CF6,
  'physicalEducation': 0xFF087F5B,
  'consultation': 0xFF2F7AFF,
  'exam': 0xFFE5484D,
  'credit': 0xFFDB8B00,
  'courseWork': 0xFF8B5CF6,
  'courseProject': 0xFF8B5CF6,
  'unknown': 0xFF74747D,
};

class LessonTypePalette extends InheritedWidget {
  const LessonTypePalette({
    required this.colors,
    required super.child,
    super.key,
  });

  final Map<String, int> colors;

  static Map<String, int> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LessonTypePalette>()?.colors ??
      kDefaultLessonTypeColors;

  @override
  bool updateShouldNotify(LessonTypePalette oldWidget) =>
      !mapEquals(colors, oldWidget.colors);
}
