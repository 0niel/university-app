import 'package:schedule_repository/src/util/supabase_json.dart';

class LessonReactionKey {
  const LessonReactionKey({
    required this.subjectName,
    required this.lessonDate,
    required this.lessonBellsNumber,
  });

  final String subjectName;
  final DateTime lessonDate;
  final int lessonBellsNumber;

  Map<String, dynamic> toParams() => {
    'p_subject_name': subjectName,
    'p_lesson_date': SupabaseJson.dateParam(lessonDate),
    'p_lesson_bells_number': lessonBellsNumber,
  };
}
