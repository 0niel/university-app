import 'package:freezed_annotation/freezed_annotation.dart';

part 'squad_challenge.freezed.dart';
part 'squad_challenge.g.dart';

@freezed
abstract class SquadChallenge with _$SquadChallenge {
  const factory SquadChallenge({
    required String id,
    required String title,
    required String description,
    required int rewardShurikens,
    required int target,
    required int progress,
    required DateTime endsAt,
  }) = _SquadChallenge;

  const SquadChallenge._();

  factory SquadChallenge.fromJson(Map<String, Object?> json) =>
      _$SquadChallengeFromJson(json);

  int get daysLeft => endsAt.difference(DateTime.now()).inDays.clamp(0, 999);
}
