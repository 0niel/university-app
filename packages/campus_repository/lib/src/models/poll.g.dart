// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll _$PollFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Poll', json, ($checkedConvert) {
      final val = _Poll(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        question: $checkedConvert('question', (v) => v as String? ?? ''),
        pollType: $checkedConvert('pollType', (v) => _pollTypeFromJson(v)),
        options: $checkedConvert('options', (v) => _optionsFromJson(v)),
        authorId: $checkedConvert('authorId', (v) => v as String?),
        isAnonymous: $checkedConvert('isAnonymous', (v) => v as bool? ?? false),
        showResults: $checkedConvert('showResults', (v) => v as bool? ?? true),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        totalVotes: $checkedConvert(
          'totalVotes',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        expiresAt: $checkedConvert('expiresAt', (v) => dateTimeFromJson(v)),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$PollToJson(_Poll instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'pollType': _pollTypeToJson(instance.pollType),
  'options': _optionsToJson(instance.options),
  'authorId': instance.authorId,
  'isAnonymous': instance.isAnonymous,
  'showResults': instance.showResults,
  'isMine': instance.isMine,
  'totalVotes': instance.totalVotes,
  'expiresAt': dateTimeToJson(instance.expiresAt),
  'createdAt': dateTimeToJson(instance.createdAt),
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
