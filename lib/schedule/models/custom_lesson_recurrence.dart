import 'package:academic_calendar/academic_calendar.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/custom_lesson_week_pattern.dart';

part 'custom_lesson_recurrence.freezed.dart';
part 'custom_lesson_recurrence.g.dart';

@Freezed(unionKey: 'type', unionValueCase: .none)
sealed class CustomLessonRecurrence with _$CustomLessonRecurrence {
  @FreezedUnionValue('weekly')
  const factory CustomLessonRecurrence.weekly({
    required int weekday,
    @Default(CustomLessonWeekPattern.every) CustomLessonWeekPattern pattern,
  }) = CustomLessonWeeklyRecurrence;

  @FreezedUnionValue('dates')
  const factory CustomLessonRecurrence.dates({
    required List<DateTime> dates,
  }) = CustomLessonDatesRecurrence;

  const CustomLessonRecurrence._();

  factory CustomLessonRecurrence.fromJson(Map<String, dynamic> json) =>
      _$CustomLessonRecurrenceFromJson(json);

  factory CustomLessonRecurrence.fromDates(List<DateTime> dates) {
    if (dates.isEmpty) return const .dates(dates: []);
    final firstDate = dates.firstOrNull;
    if (firstDate == null) return const .dates(dates: []);
    final weekday = firstDate.weekday;
    for (final candidatePattern in CustomLessonWeekPattern.values) {
      final recurrence = CustomLessonRecurrence.weekly(
        weekday: weekday,
        pattern: candidatePattern,
      );
      if (_sameDates(recurrence.expand(firstDate), dates)) return recurrence;
    }
    return CustomLessonRecurrence.dates(dates: _dateOnly(dates));
  }

  int? get weekday => switch (this) {
    CustomLessonWeeklyRecurrence(weekday: final weeklyWeekday) => weeklyWeekday,
    CustomLessonDatesRecurrence(:final dates) => dates.firstOrNull?.weekday,
  };

  List<DateTime> expand(DateTime reference) => switch (this) {
    CustomLessonDatesRecurrence(:final dates) => _dateOnly(dates),
    CustomLessonWeeklyRecurrence(
      weekday: final weeklyWeekday,
      :final pattern,
    ) =>
      [
        for (var week = 1; week <= kMaxWeeksInSemester; week++)
          if (_matchesWeek(pattern, week))
            _dayOnly(getDayByWeek(getPeriod(reference), weeklyWeekday, week)),
      ],
  };
}

bool _matchesWeek(CustomLessonWeekPattern pattern, int week) =>
    switch (pattern) {
      .every => true,
      .even => week.isEven,
      .odd => week.isOdd,
    };

List<DateTime> _dateOnly(Iterable<DateTime> dates) =>
    dates.map(_dayOnly).toSet().toList()..sort();

DateTime _dayOnly(DateTime date) => .new(date.year, date.month, date.day);

bool _sameDates(List<DateTime> left, List<DateTime> right) {
  final normalizedLeft = _dateOnly(left);
  final normalizedRight = _dateOnly(right);
  if (normalizedLeft.length != normalizedRight.length) return false;
  return Iterable<int>.generate(normalizedLeft.length).every(
    (index) =>
        normalizedLeft.elementAtOrNull(index) ==
        normalizedRight.elementAtOrNull(index),
  );
}
