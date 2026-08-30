import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/src/models/json_converters.dart';

part 'friend_request.freezed.dart';
part 'friend_request.g.dart';

/// An incoming friend request.
@freezed
abstract class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required String friendshipId,
    required String userId,
    @JsonKey(defaultValue: 'Студент') required String fullName,
    String? handle,
    String? group,
    @JsonKey(
      fromJson: optionalDateTimeFromJson,
      toJson: optionalDateTimeToJson,
    )
    DateTime? createdAt,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, Object?> json) =>
      _$FriendRequestFromJson(json);
}
