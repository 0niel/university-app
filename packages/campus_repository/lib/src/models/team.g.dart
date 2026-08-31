// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Team',
  json,
  ($checkedConvert) {
    final val = _Team(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      eventName: $checkedConvert('eventName', (v) => v as String? ?? ''),
      description: $checkedConvert('description', (v) => v as String? ?? ''),
      neededRoles: $checkedConvert(
        'neededRoles',
        (v) => v == null ? const <String>[] : stringListFromJson(v),
      ),
      capacity: $checkedConvert('capacity', (v) => (v as num?)?.toInt() ?? 5),
      kind: $checkedConvert('kind', (v) => v as String? ?? 'hackathon'),
      deadlineAt: $checkedConvert('deadlineAt', (v) => dateTimeFromJson(v)),
      isBoosted: $checkedConvert('isBoosted', (v) => v as bool? ?? false),
      createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
      isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
      isMember: $checkedConvert('isMember', (v) => v as bool? ?? false),
      hasApplied: $checkedConvert('hasApplied', (v) => v as bool? ?? false),
      myApplicationId: $checkedConvert('myApplicationId', (v) => v as String?),
      status: $checkedConvert(
        'status',
        (v) => $enumDecodeNullable(_$TeamStatusEnumMap, v) ?? TeamStatus.open,
      ),
      applicationsCount: $checkedConvert(
        'applicationsCount',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      memberCount: $checkedConvert(
        'memberCount',
        (v) => (v as num?)?.toInt() ?? 1,
      ),
      memberNames: $checkedConvert(
        'memberNames',
        (v) => v == null ? const <String>[] : stringListFromJson(v),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'eventName': instance.eventName,
  'description': instance.description,
  'neededRoles': stringListToJson(instance.neededRoles),
  'capacity': instance.capacity,
  'kind': instance.kind,
  'deadlineAt': dateTimeToJson(instance.deadlineAt),
  'isBoosted': instance.isBoosted,
  'createdAt': dateTimeToJson(instance.createdAt),
  'isMine': instance.isMine,
  'isMember': instance.isMember,
  'hasApplied': instance.hasApplied,
  'myApplicationId': instance.myApplicationId,
  'status': _$TeamStatusEnumMap[instance.status]!,
  'applicationsCount': instance.applicationsCount,
  'memberCount': instance.memberCount,
  'memberNames': stringListToJson(instance.memberNames),
};

const _$TeamStatusEnumMap = {
  TeamStatus.open: 'open',
  TeamStatus.closed: 'closed',
  TeamStatus.completed: 'completed',
  TeamStatus.archived: 'archived',
};

_TeamApplication _$TeamApplicationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TeamApplication', json, ($checkedConvert) {
  final val = _TeamApplication(
    id: $checkedConvert('id', (v) => v as String),
    teamId: $checkedConvert('teamId', (v) => v as String),
    applicantId: $checkedConvert('applicantId', (v) => v as String),
    role: $checkedConvert('role', (v) => v as String? ?? ''),
    message: $checkedConvert('message', (v) => v as String? ?? ''),
    applicantName: $checkedConvert('applicantName', (v) => v as String? ?? ''),
    applicantHandle: $checkedConvert('applicantHandle', (v) => v as String?),
    applicantGroup: $checkedConvert('applicantGroup', (v) => v as String?),
    attachProfile: $checkedConvert('attachProfile', (v) => v as bool? ?? false),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$TeamApplicationStatusEnumMap, v) ??
          TeamApplicationStatus.pending,
    ),
    createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$TeamApplicationToJson(_TeamApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'applicantId': instance.applicantId,
      'role': instance.role,
      'message': instance.message,
      'applicantName': instance.applicantName,
      'applicantHandle': instance.applicantHandle,
      'applicantGroup': instance.applicantGroup,
      'attachProfile': instance.attachProfile,
      'status': _$TeamApplicationStatusEnumMap[instance.status]!,
      'createdAt': dateTimeToJson(instance.createdAt),
    };

const _$TeamApplicationStatusEnumMap = {
  TeamApplicationStatus.pending: 'pending',
  TeamApplicationStatus.accepted: 'accepted',
  TeamApplicationStatus.rejected: 'rejected',
  TeamApplicationStatus.withdrawn: 'withdrawn',
};
