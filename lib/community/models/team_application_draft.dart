import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_application_draft.freezed.dart';

@freezed
abstract class TeamApplicationDraft with _$TeamApplicationDraft {
  const factory TeamApplicationDraft({
    required String teamId,
    @Default('') String role,
    @Default('') String message,
    @Default(true) bool attachProfile,
  }) = _TeamApplicationDraft;
}
