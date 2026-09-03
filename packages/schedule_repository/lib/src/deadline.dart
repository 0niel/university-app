import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/deadline_priority.dart';
import 'package:schedule_repository/src/deadline_source.dart';

part 'deadline.freezed.dart';
part 'deadline.g.dart';

@freezed
abstract class Deadline with _$Deadline {
  const factory Deadline({
    @_NonEmptyStringConverter() required String id,
    @_NonEmptyStringConverter() required String title,
    @_LocalDateTimeConverter() required DateTime dueAt,
    @JsonKey(unknownEnumValue: DeadlineSource.me)
    required DeadlineSource source,
    @Default('') String subjectName,
    @_DeadlineProgressConverter() @Default(0) int progress,
    @Default(false) bool isDone,
    @Default(false) bool isMine,
    @JsonKey(unknownEnumValue: DeadlinePriority.medium)
    @Default(DeadlinePriority.medium)
    DeadlinePriority priority,
    @Default(true) bool remind,
    @Default(60) int remindMinutes,
  }) = _Deadline;

  const Deadline._();

  factory Deadline.fromJson(Map<String, Object?> json) =>
      _$DeadlineFromJson(json);

  Duration timeLeftAt(DateTime now) => dueAt.difference(now);

  Duration get timeLeft => timeLeftAt(DateTime.now());

  bool isUrgentAt(DateTime now) =>
      !isDone &&
      (priority == DeadlinePriority.urgent ||
          timeLeftAt(now) < const Duration(hours: 48));

  bool get isUrgent => isUrgentAt(DateTime.now());

  bool isWarnAt(DateTime now) =>
      !isDone && !isUrgentAt(now) && timeLeftAt(now) < const Duration(days: 3);

  bool get isWarn => isWarnAt(DateTime.now());
}

class _NonEmptyStringConverter implements JsonConverter<String, Object?> {
  const _NonEmptyStringConverter();

  @override
  String fromJson(Object? json) {
    if (json case final String value when value.trim().isNotEmpty) return value;
    throw const FormatException('Expected a non-empty string');
  }

  @override
  String toJson(String object) => object;
}

class _DeadlineProgressConverter implements JsonConverter<int, Object?> {
  const _DeadlineProgressConverter();

  @override
  int fromJson(Object? json) {
    if (json is! num || json != json.roundToDouble()) {
      throw const FormatException('Expected an integer progress value');
    }
    final progress = json.toInt();
    if (progress < 0 || progress > 100) {
      throw const FormatException('Progress must be between 0 and 100');
    }
    return progress;
  }

  @override
  int toJson(int object) => object;
}

class _LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const _LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}
