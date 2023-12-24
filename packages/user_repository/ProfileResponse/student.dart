import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule_api_client/src/models/ProfileResponse/edu_program.dart';

part 'student.g.dart';

/// {@template groups_response}
/// Студент, полученный в ответе на запрос профиля студента.
/// {@endtemplate}
@JsonSerializable()
class Student extends Equatable {
  /// {@macro groups_response}
  const Student({
    required this.id,
    required this.isActive,
    required this.course,
    required this.personalNumber,
    required this.educationStartDate,
    required this.educationEndDate,
    required this.academicGroup,
    required this.code,
    required this.status,
    required this.eduProgram,
  });

  /// Конвертирует `Map<String, dynamic>` в [Student]
  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  static DateTime _dateFromJson(String date) =>
      DateFormat('dd.MM.yyyy').parse(date);

  static String _dateToJson(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date);

  /// UUID.
  @JsonKey(name: 'ID')
  final String id;

  static bool _isActiveFromJson(String value) => value == 'Y';

  /// Cтатус студента.
  @JsonKey(name: 'ACTIVE', fromJson: _isActiveFromJson)
  final bool isActive;

  static Object _readPrepertiesValue(Map<dynamic, dynamic> json, String key) {
    return ((json['PROPERTIES'] as Map<String, dynamic>)[key]
            as Map<String, dynamic>)['VALUE']
        .toString();
  }

  /// Курс студента.
  @JsonKey(name: 'COURSE', readValue: _readPrepertiesValue)
  final int course;

  /// Уникальный идентификатор, используемый в студенческом билете.
  @JsonKey(name: 'PERSONAL_NUMBER', readValue: _readPrepertiesValue)
  final String personalNumber;

  /// Дата начала обучения.
  @JsonKey(
    name: 'START_DATE',
    fromJson: _dateFromJson,
    toJson: _dateToJson,
    readValue: _readPrepertiesValue,
  )
  final DateTime educationStartDate;

  /// Дата окончания обучения.
  @JsonKey(
    name: 'END_DATE',
    fromJson: _dateFromJson,
    toJson: _dateToJson,
    readValue: _readPrepertiesValue,
  )
  final DateTime educationEndDate;

  /// Академическая группа.
  @JsonKey(name: 'ACADEMIC_GROUP', readValue: _readPrepertiesValue)
  final String academicGroup;

  /// Уникальный ID студента в системе.
  @JsonKey(name: 'CODE')
  final String code;

  /// Статус студента. Например, "активный" или "академический отпуск".
  @JsonKey(name: 'STATUS', readValue: _readPrepertiesValue)
  final String status;

  static _readEduProgram(Map<dynamic, dynamic> json, String key) {}

  /// Информация об образовательной программе студента.
  @JsonKey(name: 'EDU_PROGRAM', readValue: _readPrepertiesValue)
  final EduProgram eduProgram;

  /// Конвертирует [Student] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  @override
  List<Object> get props => [
        id,
        isActive,
        course,
        personalNumber,
        educationStartDate,
        educationEndDate,
        academicGroup,
        code,
        status,
        eduProgram,
      ];
}
