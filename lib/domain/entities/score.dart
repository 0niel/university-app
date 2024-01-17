import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'score.g.dart';

@JsonSerializable()
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

  Score copyWith({
    String? subjectName,
    String? result,
    String? type,
    String? comission,
    String? courseWork,
    String? exam,
    String? credit,
    String? date,
    String? year,
  }) {
    return Score(
      subjectName: subjectName ?? this.subjectName,
      result: result ?? this.result,
      type: type ?? this.type,
      comission: comission ?? this.comission,
      courseWork: courseWork ?? this.courseWork,
      exam: exam ?? this.exam,
      credit: credit ?? this.credit,
      date: date ?? this.date,
      year: year ?? this.year,
    );
  }

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}
