import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

part 'lesson_reaction.g.dart';

/// Available reaction types for lessons
enum ReactionType {
  love('❤️'),
  sad('😢'),
  flushed('😳'),
  sick('🤮'),
  poo('💩'),
  sleepy('🥱');

  const ReactionType(this.emoji);
  final String emoji;
}

/// {@template lesson_reaction}
/// Reaction for a specific lesson.
/// {@endtemplate}
@immutable
@JsonSerializable()
class LessonReaction extends Equatable {
  /// {@macro lesson_reaction}
  const LessonReaction({
    required this.subjectName,
    required this.lessonDate,
    required this.lessonBells,
    required this.reactionType,
    required this.createdAt,
  });

  /// {@macro from_json}
  factory LessonReaction.fromJson(Map<String, dynamic> json) => _$LessonReactionFromJson(json);

  /// {@macro to_json}
  Map<String, dynamic> toJson() => _$LessonReactionToJson(this);

  /// Subject name for the lesson
  final String subjectName;

  /// Date when lesson is scheduled
  final DateTime lessonDate;

  /// Lesson bells timing
  final LessonBells lessonBells;

  /// Type of reaction
  final ReactionType reactionType;

  /// When the reaction was created
  final DateTime createdAt;

  /// Create a copy with updated fields
  LessonReaction copyWith({
    String? subjectName,
    DateTime? lessonDate,
    LessonBells? lessonBells,
    ReactionType? reactionType,
    DateTime? createdAt,
  }) {
    return LessonReaction(
      subjectName: subjectName ?? this.subjectName,
      lessonDate: lessonDate ?? this.lessonDate,
      lessonBells: lessonBells ?? this.lessonBells,
      reactionType: reactionType ?? this.reactionType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [subjectName, lessonDate, lessonBells, reactionType, createdAt];
}

/// {@template lesson_reaction_summary}
/// Summary of reactions for a lesson showing counts per reaction type
/// {@endtemplate}
@immutable
@JsonSerializable()
class LessonReactionSummary extends Equatable {
  /// {@macro lesson_reaction_summary}
  const LessonReactionSummary({
    required this.subjectName,
    required this.lessonDate,
    required this.lessonBells,
    required this.reactionCounts,
    this.userReaction,
  });

  /// {@macro from_json}
  factory LessonReactionSummary.fromJson(Map<String, dynamic> json) => _$LessonReactionSummaryFromJson(json);

  /// {@macro to_json}
  Map<String, dynamic> toJson() => _$LessonReactionSummaryToJson(this);

  /// Subject name for the lesson
  final String subjectName;

  /// Date when lesson is scheduled
  final DateTime lessonDate;

  /// Lesson bells timing
  final LessonBells lessonBells;

  /// Map of reaction type to count
  final Map<ReactionType, int> reactionCounts;

  /// Current user's reaction (if any)
  final ReactionType? userReaction;

  /// Total number of reactions
  int get totalReactions => reactionCounts.values.fold(0, (sum, count) => sum + count);

  /// Get the most popular reaction
  ReactionType? get topReaction {
    if (reactionCounts.isEmpty) return null;
    final sorted = reactionCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// Create a copy with updated fields
  LessonReactionSummary copyWith({
    String? subjectName,
    DateTime? lessonDate,
    LessonBells? lessonBells,
    Map<ReactionType, int>? reactionCounts,
    ReactionType? userReaction,
  }) {
    return LessonReactionSummary(
      subjectName: subjectName ?? this.subjectName,
      lessonDate: lessonDate ?? this.lessonDate,
      lessonBells: lessonBells ?? this.lessonBells,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      userReaction: userReaction ?? this.userReaction,
    );
  }

  @override
  List<Object?> get props => [subjectName, lessonDate, lessonBells, reactionCounts, userReaction];
}
