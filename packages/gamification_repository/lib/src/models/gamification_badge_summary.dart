import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_badge_summary.freezed.dart';
part 'gamification_badge_summary.g.dart';

@freezed
abstract class GamificationBadgeSummary with _$GamificationBadgeSummary {
  const factory GamificationBadgeSummary({
    required String id,
    required String name,
    required String emoji,
    @Default('common') String rarity,
  }) = _GamificationBadgeSummary;

  factory GamificationBadgeSummary.fromJson(Map<String, Object?> json) =>
      _$GamificationBadgeSummaryFromJson(json);
}
