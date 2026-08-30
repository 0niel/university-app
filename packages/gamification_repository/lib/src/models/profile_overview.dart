import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/src/models/academic_profile.dart';

part 'profile_overview.freezed.dart';
part 'profile_overview.g.dart';

@freezed
abstract class ProfileOverview with _$ProfileOverview {
  @JsonSerializable(explicitToJson: true)
  const factory ProfileOverview({
    @Default(AcademicProfile.empty) AcademicProfile academic,
    @Default(SemesterStats.empty) SemesterStats semester,
    int? groupRank,
    int? groupSize,
    @JsonKey(fromJson: _streakHistoryFromJson)
    @Default(<bool>[])
    List<bool> streakHistory,
    @Default(0) int earnedBadges,
    @Default(0) int totalBadges,
  }) = _ProfileOverview;

  factory ProfileOverview.fromJson(Map<String, Object?> json) =>
      _$ProfileOverviewFromJson(_normalizeJson(json));

  static const empty = ProfileOverview();
}

@freezed
abstract class SemesterStats with _$SemesterStats {
  const factory SemesterStats({
    String? label,
    String? moduleLabel,
    double? gpa,
  }) = _SemesterStats;

  factory SemesterStats.fromJson(Map<String, Object?> json) =>
      _$SemesterStatsFromJson(json);

  static const empty = SemesterStats();
}

Map<String, Object?> _normalizeJson(Map<String, Object?> json) {
  final counts = json['badgeCounts'];
  if (counts is! Map<String, Object?>) return json;
  return {
    ...json,
    'earnedBadges': counts['earned'],
    'totalBadges': counts['total'],
  };
}

List<bool> _streakHistoryFromJson(Object? value) => switch (value) {
  final List<Object?> entries => [for (final entry in entries) entry == true],
  _ => const [],
};
