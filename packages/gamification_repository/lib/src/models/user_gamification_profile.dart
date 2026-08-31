import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/gamification_badge_summary.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'user_gamification_profile.freezed.dart';
part 'user_gamification_profile.g.dart';

@freezed
abstract class UserGamificationProfile with _$UserGamificationProfile {
  @JsonSerializable(explicitToJson: true)
  const factory UserGamificationProfile({
    @Default('') String userId,
    @Default(0) int xp,
    @Default(1) int level,
    @Default(0) int shurikens,
    @Default(0) int streakDays,
    @Default(0) int longestStreak,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? lastActiveDate,
    GamificationBadgeSummary? recentBadge,
  }) = _UserGamificationProfile;

  const UserGamificationProfile._();

  factory UserGamificationProfile.fromJson(Map<String, Object?> json) =>
      _$UserGamificationProfileFromJson(json);

  static const empty = UserGamificationProfile();

  bool get isEmpty => userId.isEmpty;
}
