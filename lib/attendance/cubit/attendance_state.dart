import 'package:academic_calendar/academic_calendar.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/attendance/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

enum AttendanceStatus { initial, loading, ready, failure }

class AttendanceState extends Equatable {
  const AttendanceState({
    this.status = AttendanceStatus.initial,
    this.absences = const [],
    this.lessons = const [],
    this.expandedSubject,
    this.now,
  });

  static const weekCount = 14;

  final AttendanceStatus status;
  final List<Absence> absences;
  final List<LessonSchedulePart> lessons;
  final String? expandedSubject;
  final DateTime? now;

  DateTime get today => _dayOnly(now ?? DateTime.now());

  DateTime get semesterStart =>
      _dayOnly(getSemesterStartWithPeriod(getPeriod(today)));

  bool get isEmpty => lessons.isEmpty && absences.isEmpty;

  List<Absence> get semesterAbsences => [
    for (final absence in absences)
      if (_inSemester(absence.day)) absence,
  ];

  List<AttendanceSubject> get subjects {
    final order = <String>[];
    final held = <String, int>{};
    for (final lesson in lessons) {
      final name = lesson.subject.trim();
      if (name.isEmpty) continue;
      if (!held.containsKey(name)) order.add(name);
      held[name] =
          (held[name] ?? 0) +
          lesson.dates.toSet().where((date) => _isHeld(lesson, date)).length;
    }
    final absences = semesterAbsences;
    for (final absence in absences) {
      if (held.containsKey(absence.subject)) continue;
      order.add(absence.subject);
      held[absence.subject] = 0;
    }
    return [
      for (final name in order)
        AttendanceSubject(
          subject: name,
          total: held[name] ?? 0,
          misses: absences
              .where((absence) => absence.subject == name)
              .sorted(
                (a, b) => b.date.compareTo(a.date),
              ),
        ),
    ];
  }

  int? get totalPercent {
    var total = 0;
    var attended = 0;
    for (final subject in subjects) {
      total += subject.total;
      attended += subject.attended;
    }
    return total == 0 ? null : (attended / total * 100).round();
  }

  int get missedCount => semesterAbsences.length;

  int get riskCount => subjects.where((subject) => subject.isRisk).length;

  AttendanceSubject? get riskSubject =>
      subjects.firstWhereOrNull((subject) => subject.isRisk);

  int get currentWeekIndex =>
      (today.difference(semesterStart).inDays ~/ 7).clamp(0, weekCount - 1);

  List<AttendanceWeek> get weeks {
    final start = semesterStart;
    final absences = semesterAbsences;
    return [
      for (var index = 0; index < weekCount; index++)
        _week(index, start.add(Duration(days: 7 * index)), absences),
    ];
  }

  AttendanceWeek _week(int index, DateTime start, List<Absence> absences) {
    final end = start.add(const Duration(days: 7));
    bool inWeek(DateTime day) => !day.isBefore(start) && day.isBefore(end);
    var total = 0;
    for (final lesson in lessons) {
      total += lesson.dates.toSet().where((date) {
        final day = _dayOnly(date);
        return inWeek(day) && _isHeld(lesson, date);
      }).length;
    }
    return AttendanceWeek(
      index: index,
      total: total,
      misses: absences.where((absence) => inWeek(absence.day)).length,
      isCurrent: index == currentWeekIndex,
    );
  }

  bool _inSemester(DateTime day) =>
      !day.isBefore(semesterStart) && !day.isAfter(today);

  bool _isHeld(LessonSchedulePart lesson, DateTime date) {
    if (!_inSemester(_dayOnly(date))) return false;
    final end = lesson.lessonBells.endTime;
    final finished = DateTime(
      date.year,
      date.month,
      date.day,
      end.hour,
      end.minute,
    );
    return !finished.isAfter(now ?? DateTime.now());
  }

  static DateTime _dayOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  AttendanceState copyWith({
    AttendanceStatus? status,
    List<Absence>? absences,
    List<LessonSchedulePart>? lessons,
    String? Function()? expandedSubject,
    DateTime? now,
  }) => AttendanceState(
    status: status ?? this.status,
    absences: absences ?? this.absences,
    lessons: lessons ?? this.lessons,
    expandedSubject: expandedSubject == null
        ? this.expandedSubject
        : expandedSubject(),
    now: now ?? this.now,
  );

  @override
  List<Object?> get props => [status, absences, lessons, expandedSubject, now];
}
