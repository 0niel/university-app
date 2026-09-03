import 'package:academic_calendar/academic_calendar.dart';
import 'package:equatable/equatable.dart';

class GradesTerm extends Equatable {
  const GradesTerm({required this.yearStart, required this.semester});

  factory GradesTerm.of(DateTime date) {
    final period = getPeriod(date);
    return GradesTerm(yearStart: period.yearStart, semester: period.semester);
  }

  final int yearStart;
  final int semester;

  String get id => '$yearStart-$semester';

  Period get period =>
      Period(yearStart: yearStart, yearEnd: yearStart + 1, semester: semester);

  DateTime get start => getSemesterStartWithPeriod(period);

  DateTime get end => semester == 1
      ? DateTime(yearStart + 1, 2, 9)
      : DateTime(yearStart + 1, 7);

  GradesTerm get previous => semester == 2
      ? GradesTerm(yearStart: yearStart, semester: 1)
      : GradesTerm(yearStart: yearStart - 1, semester: 2);

  bool contains(DateTime date) => !date.isBefore(start) && date.isBefore(end);

  static List<GradesTerm> recent(DateTime now, {int count = 3}) {
    var term = GradesTerm.of(now);
    return [
      for (var i = 0; i < count; i++) i == 0 ? term : term = term.previous,
    ];
  }

  @override
  List<Object?> get props => [yearStart, semester];
}
