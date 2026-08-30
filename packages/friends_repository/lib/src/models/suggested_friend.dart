import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggested_friend.freezed.dart';
part 'suggested_friend.g.dart';

/// A non-friend ranked by shared-friend count.
@freezed
abstract class SuggestedFriend with _$SuggestedFriend {
  const factory SuggestedFriend({
    required String userId,
    @JsonKey(defaultValue: 'Студент') required String fullName,
    String? handle,
    String? group,
    @Default(0) int mutualCount,
  }) = _SuggestedFriend;

  factory SuggestedFriend.fromJson(Map<String, Object?> json) =>
      _$SuggestedFriendFromJson(json);
}
