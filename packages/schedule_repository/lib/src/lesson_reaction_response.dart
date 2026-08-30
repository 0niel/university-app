import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/src/util/json_parser.dart';

part 'lesson_reaction_response.freezed.dart';
part 'lesson_reaction_response.g.dart';

@freezed
abstract class LessonReactionResponse with _$LessonReactionResponse {
  const factory LessonReactionResponse({
    required Map<String, int> counts,
    String? userReaction,
  }) = _LessonReactionResponse;

  factory LessonReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonReactionResponseFromJson({
        'counts': JsonParser.reactionCounts(json['counts']),
        'userReaction': json['userReaction'] as String?,
      });
}
