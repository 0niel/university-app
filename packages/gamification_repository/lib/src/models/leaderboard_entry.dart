import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required int xp,
    @Default('Студент') String displayName,
    @Default(1) int level,
    @Default(0) int streakDays,
    @Default(false) bool isCurrentUser,
  }) = _LeaderboardEntry;

  const LeaderboardEntry._();

  factory LeaderboardEntry.fromJson(Map<String, Object?> json) =>
      _$LeaderboardEntryFromJson(json);

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts case [final first, final second, ...]) {
      return '${first[0]}${second[0]}'.toUpperCase();
    }
    return displayName.isEmpty ? '?' : displayName[0].toUpperCase();
  }
}
