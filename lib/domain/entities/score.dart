import 'package:equatable/equatable.dart';

class Score extends Equatable {
  final String subjectName;
  final String result;
  final String type;
  final String? comission;
  final String? courseWork;
  final String? exam;
  final String? credit;
  final String date;
  final String year;

  const Score({
    required this.subjectName,
    required this.result,
    required this.type,
    required this.comission,
    required this.courseWork,
    required this.exam,
    required this.credit,
    required this.date,
    required this.year,
  });

  @override
  List<Object> get props => [
        subjectName,
        result,
        type,
        date,
        year,
      ];
}
