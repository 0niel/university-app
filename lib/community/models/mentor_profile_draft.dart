import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentor_profile_draft.freezed.dart';

@freezed
abstract class MentorProfileDraft with _$MentorProfileDraft {
  const factory MentorProfileDraft({
    @Default(<String>[]) List<String> topics,
    @Default('') String bio,
    @Default('') String level,
    @Default(<String>[]) List<String> formats,
    @Default(0) int price,
  }) = _MentorProfileDraft;

  factory MentorProfileDraft.fromMentor(Mentor? mentor) => MentorProfileDraft(
    topics: mentor?.topics ?? const [],
    bio: mentor?.bio ?? '',
    level: mentor?.level ?? '',
    formats: mentor?.formats ?? const [],
    price: mentor?.price ?? 0,
  );
}
