import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

/// {@template lesson}
/// Занятие в расписании
/// {@endtemplate}
@JsonSerializable()
class LessonResponse extends Equatable {
  /// {@macro lesson}
  const LessonResponse({
    required this.name,
    required this.weeks,
    required this.timeStart,
    required this.timeEnd,
    required this.types,
    required this.teachers,
    required this.rooms,
  });

  /// Конвертирует `Map<String, dynamic>` в [LessonResponse]
  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);

  /// Название предмета
  final String name;

  /// Номера недель, в которые проходит занятие
  final List<int> weeks;

  /// Время начала занятия в формате `HH:mm`, если занятие начинается в 9 или
  /// раньше, то вместо `HH` используется `H`. Например, 9:00.
  final String timeStart;

  /// Время окончания занятия в формате `HH:mm`, если занятие начинается в 9
  /// или раньше, то вместо `HH` используется `H`. Например, 9:00.
  final String timeEnd;

  /// Типы занятия. Обычно используется: "пр", "лаб", "лек", "с/р".
  final String types;

  /// Преподаватели занятия (ФИО). Обычно в формате "Иванов И. И.".
  final List<String> teachers;

  /// Аудитории, в которых проходит занятие. Обычно в формате "А-123 (В-78)".
  final List<String> rooms;

  /// Конвертирует [LessonResponse] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$LessonToJson(this);

  @override
  List<Object?> get props =>
      [name, weeks, timeStart, timeEnd, types, teachers, rooms];
}
