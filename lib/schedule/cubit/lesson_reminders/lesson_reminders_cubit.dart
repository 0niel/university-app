import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

class LessonRemindersCubit extends HydratedCubit<Map<String, int>> {
  LessonRemindersCubit() : super(const {});

  static const options = [5, 15, 30, 60];

  int? minutesFor(LessonSchedulePart lesson, DateTime day) =>
      state[lessonKey(lesson, day)];

  void set(LessonSchedulePart lesson, DateTime day, int minutes) {
    emit({...state, lessonKey(lesson, day): minutes});
  }

  void remove(LessonSchedulePart lesson, DateTime day) {
    final next = {...state}..remove(lessonKey(lesson, day));
    emit(next);
  }

  @override
  Map<String, int>? fromJson(Map<String, dynamic> json) {
    return {
      for (final entry in json.entries)
        if (entry.value is num) entry.key: (entry.value as num).toInt(),
    };
  }

  @override
  Map<String, dynamic>? toJson(Map<String, int> state) => state;
}
