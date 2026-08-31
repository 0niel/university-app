import 'package:schedule_repository/src/data/lesson_reaction_key.dart';
import 'package:schedule_repository/src/lesson_details.dart';
import 'package:schedule_repository/src/util/supabase_json.dart';
import 'package:supabase/supabase.dart';

export 'lesson_reaction_key.dart';

class LessonReactionsDataSource {
  const LessonReactionsDataSource({required SupabaseClient supabaseClient})
    : _supabase = supabaseClient;

  final SupabaseClient _supabase;

  Future<void> postReaction({
    required LessonReactionKey key,
    required String reactionType,
  }) async {
    await _supabase.rpc<Object?>(
      'upsert_lesson_reaction',
      params: {...key.toParams(), 'p_reaction_type': reactionType},
    );
  }

  Future<void> deleteReaction(LessonReactionKey key) async {
    await _supabase.rpc<Object?>(
      'delete_lesson_reaction',
      params: key.toParams(),
    );
  }

  Future<LessonReactionResponse> getReactionSummary(
    LessonReactionKey key,
  ) async {
    final response = await _supabase.rpc<Object?>(
      'get_lesson_reactions',
      params: key.toParams(),
    );
    return reactionResponseFromJson(response);
  }
}

LessonReactionResponse reactionResponseFromJson(Object? response) {
  final data = SupabaseJson.asMap(response);
  final rawCounts = data['counts'];
  final counts = rawCounts is Map
      ? rawCounts.map(
          (key, value) => MapEntry(
            key.toString(),
            value is num ? value.toInt() : (int.tryParse('$value') ?? 0),
          ),
        )
      : <String, int>{};

  return LessonReactionResponse(
    counts: counts,
    userReaction: data['userReaction'] as String?,
  );
}
