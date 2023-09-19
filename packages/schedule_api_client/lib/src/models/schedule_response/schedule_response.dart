import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule_api_client/src/models/schedule_response/lesson.dart';

part 'schedule_response.g.dart';

/// {@template groups_response}
/// Ответ на запрос расписания занятий группы
/// {@endtemplate}
@JsonSerializable()
class ScheduleResponse extends Equatable {
  /// {@macro groups_response}
  const ScheduleResponse({
    required this.group,
    required this.schedule,
  });

  /// Конвертирует `Map<String, dynamic>` в [ScheduleResponse]
  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  /// Название группы
  final String group;

  /// Расписание занятий. Ключ - день недели, где 1 - понедельник,
  /// 2 - вторник и т.д.
  ///
  /// Значение - список списков занятий. Внешний список обычно означает
  /// номер пары, то есть всего 7 списков занятий, а внутренний список -
  /// список занятий. Если, например, в одно время проходят занятия по четным и
  /// нечетным неделям, то этот внутренний список будет содержать 2 элемента.
  final Map<String, List<List<LessonResponse>>> schedule;

  /// Конвертирует [ScheduleResponse] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);

  @override
  List<Object> get props => [group, schedule];
}
