import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/src/models/json_converters.dart';

part 'friend.freezed.dart';
part 'friend.g.dart';

@freezed
abstract class Friend with _$Friend {
  const factory Friend({
    required String friendshipId,
    required String userId,
    @JsonKey(defaultValue: 'Студент') required String fullName,
    String? handle,
    String? group,
    double? latitude,
    double? longitude,
    int? battery,
    @Default('') String mood,
    @Default(false) bool isGhost,
    @JsonKey(
      fromJson: optionalDateTimeFromJson,
      toJson: optionalDateTimeToJson,
    )
    DateTime? locationUpdatedAt,
  }) = _Friend;

  const Friend._();

  factory Friend.fromJson(Map<String, Object?> json) => _$FriendFromJson(json);

  bool get hasLocation =>
      latitude?.isFinite == true && longitude?.isFinite == true && !isGhost;

  Friend withoutLocation({bool ghost = true}) => copyWith(
    latitude: null,
    longitude: null,
    battery: null,
    mood: '',
    isGhost: ghost,
    locationUpdatedAt: null,
  );
}
