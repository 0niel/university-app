import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/user_activity_type.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

@freezed
abstract class UserActivity with _$UserActivity {
  const factory UserActivity({
    required String id,
    required UserActivityType type,
    required String title,
    required DateTime startsAt,
    String? place,
    String? subtitle,
    String? lessonUid,
    DateTime? endsAt,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson({
        'id': json['id'].toString(),
        'type': UserActivityType.fromWireValue(
          (json['activityType'] ?? json['activity_type'] ?? 'event').toString(),
        ).wireValue,
        'title': json['title'].toString(),
        'place': (json['place'] as Object?)?.toString(),
        'subtitle': (json['subtitle'] as Object?)?.toString(),
        'lessonUid': (json['lessonUid'] ?? json['lesson_uid'])?.toString(),
        'startsAt': _localDateTime(json['startsAt'] ?? json['starts_at']),
        'endsAt': _nullableLocalDateTime(json['endsAt'] ?? json['ends_at']),
      });
}

@freezed
abstract class UpsertUserActivityRequest with _$UpsertUserActivityRequest {
  const factory UpsertUserActivityRequest({
    required UserActivityType type,
    required String title,
    required DateTime startsAt,
    String? id,
    String? place,
    String? subtitle,
    String? lessonUid,
    DateTime? endsAt,
  }) = _UpsertUserActivityRequest;
}

String _localDateTime(Object? value) {
  return (DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
          DateTime.now())
      .toIso8601String();
}

String? _nullableLocalDateTime(Object? value) => DateTime.tryParse(
  value?.toString() ?? '',
)?.toLocal().toIso8601String();
