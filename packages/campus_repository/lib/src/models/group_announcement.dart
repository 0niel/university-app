import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_announcement.freezed.dart';
part 'group_announcement.g.dart';

@freezed
abstract class GroupAnnouncement with _$GroupAnnouncement {
  const factory GroupAnnouncement({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @JsonKey(defaultValue: '') required String body,
    @JsonKey(defaultValue: '') required String authorName,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isMine,
    @Default(0) int commentsCount,
  }) = _GroupAnnouncement;

  factory GroupAnnouncement.fromJson(Map<String, Object?> json) =>
      _$GroupAnnouncementFromJson(json);
}
