import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_draft.freezed.dart';

@freezed
abstract class TeamDraft with _$TeamDraft {
  const factory TeamDraft({
    @Default('') String title,
    @Default('') String description,
    @Default(<String>[]) List<String> neededRoles,
    @Default(5) int capacity,
    @Default('hackathon') String kind,
    DateTime? deadlineAt,
    @Default(false) bool boost,
  }) = _TeamDraft;
}
