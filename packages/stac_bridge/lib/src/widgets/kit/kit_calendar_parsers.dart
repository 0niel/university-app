import 'package:app_ui/app_ui.dart';

export 'stac_app_deadline_row_parser.dart';
export 'stac_app_lesson_row_parser.dart';
export 'stac_app_week_strip_parser.dart';

LessonRowState? lessonRowStateOf(String? name) => switch (name) {
  'plain' => .plain,
  'past' => .past,
  'current' || 'now' => .current,
  'next' => .next,
  'moved' => .moved,
  'cancelled' => .cancelled,
  'exam' => .exam,
  'own' || 'custom' => .own,
  _ => null,
};
