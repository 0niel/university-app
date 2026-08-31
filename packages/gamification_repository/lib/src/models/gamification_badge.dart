import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'gamification_badge.freezed.dart';
part 'gamification_badge.g.dart';

@freezed
abstract class GamificationBadge with _$GamificationBadge {
  const factory GamificationBadge({
    required String id,
    required String category,
    required String name,
    required String description,
    required String emoji,
    @Default('common') String rarity,
    @Default(0) int xpReward,
    @Default(0) int shurikenReward,
    @Default(false) bool isEarned,
    @Default(0) double progress,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? earnedAt,
  }) = _GamificationBadge;

  factory GamificationBadge.fromJson(Map<String, Object?> json) =>
      _$GamificationBadgeFromJson(json);
}
