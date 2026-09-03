import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll.freezed.dart';
part 'poll.g.dart';

@Freezed(toJson: true)
abstract class Poll with _$Poll {
  const factory Poll({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @Default('') String description,
    String? category,
    String? authorId,
    String? authorName,
    @Default(false) bool isAnonymous,
    @JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson)
    @Default(PollResultsVisibility.always)
    PollResultsVisibility resultsVisibility,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? expiresAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isClosed,
    @Default(false) bool allowChange,
    @Default(false) bool isMine,
    @Default(0) int participantsCount,
    @Default(false) bool iParticipated,
    @Default(false) bool canSeeResults,
    @JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson)
    @Default(<PollQuestion>[])
    List<PollQuestion> questions,
  }) = _Poll;

  const Poll._();

  factory Poll.fromJson(Map<String, Object?> json) => _$PollFromJson(json);

  bool get isExpired {
    final deadline = expiresAt;
    return deadline != null && deadline.isBefore(DateTime.now());
  }

  bool get isEnded => isClosed || isExpired;

  int get requiredQuestionCount =>
      questions.where((question) => question.isRequired).length;

  bool get isFullyAnswered => questions.every(
    (question) => !question.isRequired || question.hasMyAnswer,
  );
}

enum PollResultsVisibility {
  always('always'),
  afterVote('after_vote'),
  afterClose('after_close');

  const PollResultsVisibility(this.wire);

  final String wire;

  static PollResultsVisibility fromWire(String? wire) => values.firstWhere(
    (value) => value.wire == wire,
    orElse: () => PollResultsVisibility.always,
  );
}

enum PollCategory {
  general('general'),
  academic('academic'),
  events('events'),
  feedback('feedback'),
  other('other');

  const PollCategory(this.wire);

  final String wire;

  static PollCategory? fromWire(String? wire) =>
      values.cast<PollCategory?>().firstWhere(
        (value) => value?.wire == wire,
        orElse: () => null,
      );
}

enum PollFilter {
  all('all'),
  active('active'),
  closed('closed'),
  mine('mine'),
  participated('participated');

  const PollFilter(this.wire);

  final String wire;
}

enum PollQuestionKind {
  single('single'),
  multiple('multiple'),
  text('text'),
  rating('rating'),
  quiz('quiz');

  const PollQuestionKind(this.wire);

  final String wire;

  static PollQuestionKind fromWire(String? wire) => values.firstWhere(
    (value) => value.wire == wire,
    orElse: () => PollQuestionKind.single,
  );
}

@Freezed(toJson: true)
abstract class PollQuestion with _$PollQuestion {
  const factory PollQuestion({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String text,
    @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)
    required PollQuestionKind kind,
    @Default(0) int position,
    @Default(true) bool isRequired,
    @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)
    @Default(<PollOption>[])
    List<PollOption> options,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> myOptionIds,
    String? myTextAnswer,
    int? myRating,
    double? ratingAverage,
    @Default(0) int ratingCount,
    @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)
    @Default(<String>[])
    List<String> textAnswers,
  }) = _PollQuestion;

  const PollQuestion._();

  factory PollQuestion.fromJson(Map<String, Object?> json) =>
      _$PollQuestionFromJson(json);

  int get totalVotes => options.fold(0, (sum, option) => sum + option.votes);

  bool get hasMyAnswer =>
      myOptionIds.isNotEmpty ||
      (myTextAnswer?.trim().isNotEmpty ?? false) ||
      myRating != null;
}

@freezed
abstract class PollOption with _$PollOption {
  const factory PollOption({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String text,
    @Default(0) int position,
    @Default(false) bool isCorrect,
    @Default(0) int votes,
    @Default(false) bool votedByMe,
  }) = _PollOption;

  const PollOption._();

  factory PollOption.fromJson(Map<String, Object?> json) =>
      _$PollOptionFromJson(json);

  double share(int total) => total <= 0 ? 0 : votes / total;
}

@freezed
abstract class PollAnswer with _$PollAnswer {
  const factory PollAnswer({
    required String questionId,
    @Default(<String>[]) List<String> optionIds,
    String? text,
    int? rating,
  }) = _PollAnswer;

  const PollAnswer._();

  Map<String, Object?> toJson() => {
    'questionId': questionId,
    'optionIds': optionIds,
    if (text != null) 'text': text,
    if (rating != null) 'rating': rating,
  };
}

@freezed
abstract class PollQuestionDraft with _$PollQuestionDraft {
  const factory PollQuestionDraft({
    required String text,
    required PollQuestionKind kind,
    @Default(true) bool isRequired,
    @Default(<String>[]) List<String> options,
    int? correctIndex,
  }) = _PollQuestionDraft;

  const PollQuestionDraft._();

  Map<String, Object?> toJson() => {
    'text': text,
    'kind': kind.wire,
    'isRequired': isRequired,
    'options': options,
    if (correctIndex != null) 'correctIndex': correctIndex,
  };
}

PollResultsVisibility _visibilityFromJson(Object? value) =>
    PollResultsVisibility.fromWire(value is String ? value : null);

String _visibilityToJson(PollResultsVisibility value) => value.wire;

PollQuestionKind _kindFromJson(Object? value) =>
    PollQuestionKind.fromWire(value is String ? value : null);

String _kindToJson(PollQuestionKind value) => value.wire;

List<PollQuestion> _questionsFromJson(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((question) => PollQuestion.fromJson(question.cast()))
          .toList()
    : const [];

List<Map<String, Object?>> _questionsToJson(List<PollQuestion> value) =>
    value.map((question) => question.toJson()).toList();

List<PollOption> _optionsFromJson(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((option) => PollOption.fromJson(option.cast()))
          .toList()
    : const [];

List<Map<String, Object?>> _optionsToJson(List<PollOption> value) =>
    value.map((option) => option.toJson()).toList();
