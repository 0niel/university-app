import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.g.dart';

@immutable
@JsonSerializable()
class Subject extends Equatable {
  const Subject({
    required this.name,
    required this.dates,
    this.mainScore,
    this.additionalScore,
    this.classScore,
    this.visitedDays,
  });

  /// {@macro from_json}
  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);

  /// {@macro to_json}
  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  /// Название предмета.
  final String name;

  /// Даты занятия.
  final List<DateTime> dates;

  /// Основные баллы.
  final double? mainScore;

  /// Дополнительные баллы.
  final double? additionalScore;

  /// Баллы за работу на занятиях.
  final double? classScore;

  /// Посещенные дни.
  final List<DateTime>? visitedDays;

  Subject copyWith({
    String? name,
    List<DateTime>? dates,
    double? mainScore,
    double? additionalScore,
    double? classScore,
    List<DateTime>? visitedDays,
  }) {
    return Subject(
      name: name ?? this.name,
      dates: dates ?? this.dates,
      mainScore: mainScore ?? this.mainScore,
      additionalScore: additionalScore ?? this.additionalScore,
      classScore: classScore ?? this.classScore,
      visitedDays: visitedDays ?? this.visitedDays,
    );
  }

  @override
  List<Object?> get props => [
        name,
        dates,
        mainScore,
        additionalScore,
        classScore,
        visitedDays,
      ];
}
