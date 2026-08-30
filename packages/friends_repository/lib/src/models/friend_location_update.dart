import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/src/models/json_converters.dart';

part 'friend_location_update.freezed.dart';
part 'friend_location_update.g.dart';

/// A visible realtime row from `public.friend_locations`.
@freezed
abstract class FriendLocationUpdate with _$FriendLocationUpdate {
  const factory FriendLocationUpdate({
    @JsonKey(name: 'user_id') required String userId,
    required double latitude,
    required double longitude,
    int? battery,
    @Default('') String mood,
    @JsonKey(name: 'is_ghost') @Default(false) bool isGhost,
    @JsonKey(
      name: 'updated_at',
      fromJson: optionalDateTimeFromJson,
      toJson: optionalDateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _FriendLocationUpdate;

  const FriendLocationUpdate._();

  factory FriendLocationUpdate.fromJson(Map<String, Object?> json) =>
      _$FriendLocationUpdateFromJson(json);

  factory FriendLocationUpdate.fromRow(Map<String, Object?> row) =>
      FriendLocationUpdate.fromJson(row);

  bool get hasValidCoordinates =>
      latitude.isFinite &&
      longitude.isFinite &&
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}
