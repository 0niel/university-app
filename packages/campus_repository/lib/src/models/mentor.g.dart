// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mentor _$MentorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Mentor', json, ($checkedConvert) {
      final val = _Mentor(
        userId: $checkedConvert('userId', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        topics: $checkedConvert(
          'topics',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
        bio: $checkedConvert('bio', (v) => v as String? ?? ''),
        sessions: $checkedConvert('sessions', (v) => (v as num?)?.toInt() ?? 0),
        level: $checkedConvert('level', (v) => v as String? ?? ''),
        formats: $checkedConvert(
          'formats',
          (v) => v == null ? const <String>[] : stringListFromJson(v),
        ),
        price: $checkedConvert('price', (v) => (v as num?)?.toInt() ?? 0),
        isMe: $checkedConvert('isMe', (v) => v as bool? ?? false),
        course: $checkedConvert('course', (v) => (v as num?)?.toInt()),
        group: $checkedConvert('group', (v) => v as String?),
        handle: $checkedConvert('handle', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MentorToJson(_Mentor instance) => <String, dynamic>{
  'userId': instance.userId,
  'fullName': instance.fullName,
  'topics': stringListToJson(instance.topics),
  'bio': instance.bio,
  'sessions': instance.sessions,
  'level': instance.level,
  'formats': stringListToJson(instance.formats),
  'price': instance.price,
  'isMe': instance.isMe,
  'course': instance.course,
  'group': instance.group,
  'handle': instance.handle,
};

_MentorRequest _$MentorRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MentorRequest', json, ($checkedConvert) {
  final val = _MentorRequest(
    id: $checkedConvert('id', (v) => v as String),
    mentorUserId: $checkedConvert('mentorUserId', (v) => v as String),
    requesterId: $checkedConvert('requesterId', (v) => v as String),
    topic: $checkedConvert('topic', (v) => v as String? ?? ''),
    whenSlot: $checkedConvert(
      'whenSlot',
      (v) =>
          $enumDecodeNullable(_$MentorWhenSlotEnumMap, v) ??
          MentorWhenSlot.week,
    ),
    message: $checkedConvert('message', (v) => v as String? ?? ''),
    price: $checkedConvert('price', (v) => (v as num?)?.toInt() ?? 0),
    requesterName: $checkedConvert('requesterName', (v) => v as String? ?? ''),
    mentorName: $checkedConvert('mentorName', (v) => v as String? ?? ''),
    requesterHandle: $checkedConvert('requesterHandle', (v) => v as String?),
    mentorHandle: $checkedConvert('mentorHandle', (v) => v as String?),
    isIncoming: $checkedConvert('isIncoming', (v) => v as bool? ?? true),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$MentorRequestStatusEnumMap, v) ??
          MentorRequestStatus.pending,
    ),
    mentorConfirmed: $checkedConvert(
      'mentorConfirmed',
      (v) => v as bool? ?? false,
    ),
    requesterConfirmed: $checkedConvert(
      'requesterConfirmed',
      (v) => v as bool? ?? false,
    ),
    createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$MentorRequestToJson(_MentorRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mentorUserId': instance.mentorUserId,
      'requesterId': instance.requesterId,
      'topic': instance.topic,
      'whenSlot': _$MentorWhenSlotEnumMap[instance.whenSlot]!,
      'message': instance.message,
      'price': instance.price,
      'requesterName': instance.requesterName,
      'mentorName': instance.mentorName,
      'requesterHandle': instance.requesterHandle,
      'mentorHandle': instance.mentorHandle,
      'isIncoming': instance.isIncoming,
      'status': _$MentorRequestStatusEnumMap[instance.status]!,
      'mentorConfirmed': instance.mentorConfirmed,
      'requesterConfirmed': instance.requesterConfirmed,
      'createdAt': dateTimeToJson(instance.createdAt),
    };

const _$MentorWhenSlotEnumMap = {
  MentorWhenSlot.tonight: 'tonight',
  MentorWhenSlot.tomorrow: 'tomorrow',
  MentorWhenSlot.week: 'week',
};

const _$MentorRequestStatusEnumMap = {
  MentorRequestStatus.pending: 'pending',
  MentorRequestStatus.accepted: 'accepted',
  MentorRequestStatus.declined: 'declined',
  MentorRequestStatus.cancelled: 'cancelled',
  MentorRequestStatus.completionPending: 'completion_pending',
  MentorRequestStatus.completed: 'completed',
};
