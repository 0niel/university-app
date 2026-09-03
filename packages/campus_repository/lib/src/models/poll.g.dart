// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll _$PollFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_Poll', json, ($checkedConvert) {
  final val = _Poll(
    id: $checkedConvert('id', (v) => v as String? ?? ''),
    title: $checkedConvert('title', (v) => v as String? ?? ''),
    description: $checkedConvert('description', (v) => v as String? ?? ''),
    category: $checkedConvert('category', (v) => v as String?),
    authorId: $checkedConvert('authorId', (v) => v as String?),
    authorName: $checkedConvert('authorName', (v) => v as String?),
    isAnonymous: $checkedConvert('isAnonymous', (v) => v as bool? ?? false),
    resultsVisibility: $checkedConvert(
      'resultsVisibility',
      (v) => v == null ? PollResultsVisibility.always : _visibilityFromJson(v),
    ),
    expiresAt: $checkedConvert('expiresAt', (v) => dateTimeFromJson(v)),
    createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
    isClosed: $checkedConvert('isClosed', (v) => v as bool? ?? false),
    allowChange: $checkedConvert('allowChange', (v) => v as bool? ?? false),
    isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
    participantsCount: $checkedConvert(
      'participantsCount',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    iParticipated: $checkedConvert('iParticipated', (v) => v as bool? ?? false),
    canSeeResults: $checkedConvert('canSeeResults', (v) => v as bool? ?? false),
    questions: $checkedConvert(
      'questions',
      (v) => v == null ? const <PollQuestion>[] : _questionsFromJson(v),
    ),
  );
  return val;
});

Map<String, dynamic> _$PollToJson(_Poll instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'isAnonymous': instance.isAnonymous,
  'resultsVisibility': _visibilityToJson(instance.resultsVisibility),
  'expiresAt': dateTimeToJson(instance.expiresAt),
  'createdAt': dateTimeToJson(instance.createdAt),
  'isClosed': instance.isClosed,
  'allowChange': instance.allowChange,
  'isMine': instance.isMine,
  'participantsCount': instance.participantsCount,
  'iParticipated': instance.iParticipated,
  'canSeeResults': instance.canSeeResults,
  'questions': _questionsToJson(instance.questions),
};

_PollQuestion _$PollQuestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PollQuestion', json, ($checkedConvert) {
      final val = _PollQuestion(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        position: $checkedConvert('position', (v) => (v as num?)?.toInt() ?? 0),
        text: $checkedConvert('text', (v) => v as String? ?? ''),
        kind: $checkedConvert('kind', (v) => _kindFromJson(v)),
        isRequired: $checkedConvert('isRequired', (v) => v as bool? ?? true),
        options: $checkedConvert(
          'options',
          (v) => v == null ? const <PollOption>[] : _optionsFromJson(v),
        ),
        myOptionIds: $checkedConvert(
          'myOptionIds',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
        myTextAnswer: $checkedConvert('myTextAnswer', (v) => v as String?),
        myRating: $checkedConvert('myRating', (v) => (v as num?)?.toInt()),
        ratingAverage: $checkedConvert(
          'ratingAverage',
          (v) => (v as num?)?.toDouble(),
        ),
        ratingCount: $checkedConvert(
          'ratingCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        textAnswers: $checkedConvert(
          'textAnswers',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PollQuestionToJson(_PollQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'text': instance.text,
      'kind': _kindToJson(instance.kind),
      'isRequired': instance.isRequired,
      'options': _optionsToJson(instance.options),
      'myOptionIds': stringListToJson(instance.myOptionIds),
      'myTextAnswer': instance.myTextAnswer,
      'myRating': instance.myRating,
      'ratingAverage': instance.ratingAverage,
      'ratingCount': instance.ratingCount,
      'textAnswers': stringListToJson(instance.textAnswers),
    };

_PollOption _$PollOptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PollOption', json, ($checkedConvert) {
      final val = _PollOption(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        text: $checkedConvert('text', (v) => v as String? ?? ''),
        position: $checkedConvert('position', (v) => (v as num?)?.toInt() ?? 0),
        isCorrect: $checkedConvert('isCorrect', (v) => v as bool? ?? false),
        votes: $checkedConvert('votes', (v) => (v as num?)?.toInt() ?? 0),
        votedByMe: $checkedConvert('votedByMe', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$PollOptionToJson(_PollOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'position': instance.position,
      'isCorrect': instance.isCorrect,
      'votes': instance.votes,
      'votedByMe': instance.votedByMe,
    };
