import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/json_converters.dart';

part 'gamification_quest.freezed.dart';
part 'gamification_quest.g.dart';

@freezed
abstract class GamificationQuest with _$GamificationQuest {
  const factory GamificationQuest({
    required String id,
    required String period,
    required String emoji,
    required String title,
    required int target,
    required int xpReward,
    @Default(0) int progress,
    @Default(false) bool isCompleted,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? completedAt,
  }) = _GamificationQuest;

  const GamificationQuest._();

  factory GamificationQuest.fromJson(Map<String, Object?> json) =>
      _$GamificationQuestFromJson(json);

  bool get isDaily => period == 'daily';

  bool get isWeekly => period == 'weekly';
}
