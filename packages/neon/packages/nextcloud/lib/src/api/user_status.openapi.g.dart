// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClearAt_Type _$clearAtTypePeriod = ClearAt_Type._('period');
const ClearAt_Type _$clearAtTypeEndOf = ClearAt_Type._('endOf');

ClearAt_Type _$valueOfClearAt_Type(String name) {
  switch (name) {
    case 'period':
      return _$clearAtTypePeriod;
    case 'endOf':
      return _$clearAtTypeEndOf;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClearAt_Type> _$clearAtTypeValues = BuiltSet<ClearAt_Type>(const <ClearAt_Type>[
  _$clearAtTypePeriod,
  _$clearAtTypeEndOf,
]);

const ClearAtTimeType _$clearAtTimeTypeDay = ClearAtTimeType._('day');
const ClearAtTimeType _$clearAtTimeTypeWeek = ClearAtTimeType._('week');

ClearAtTimeType _$valueOfClearAtTimeType(String name) {
  switch (name) {
    case 'day':
      return _$clearAtTimeTypeDay;
    case 'week':
      return _$clearAtTimeTypeWeek;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClearAtTimeType> _$clearAtTimeTypeValues = BuiltSet<ClearAtTimeType>(const <ClearAtTimeType>[
  _$clearAtTimeTypeDay,
  _$clearAtTimeTypeWeek,
]);

Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<Public> _$publicSerializer = _$PublicSerializer();
Serializer<Private> _$privateSerializer = _$PrivateSerializer();
Serializer<HeartbeatHeartbeatResponseApplicationJson_Ocs> _$heartbeatHeartbeatResponseApplicationJsonOcsSerializer =
    _$HeartbeatHeartbeatResponseApplicationJson_OcsSerializer();
Serializer<HeartbeatHeartbeatResponseApplicationJson> _$heartbeatHeartbeatResponseApplicationJsonSerializer =
    _$HeartbeatHeartbeatResponseApplicationJsonSerializer();
Serializer<ClearAt> _$clearAtSerializer = _$ClearAtSerializer();
Serializer<Predefined> _$predefinedSerializer = _$PredefinedSerializer();
Serializer<PredefinedStatusFindAllResponseApplicationJson_Ocs>
    _$predefinedStatusFindAllResponseApplicationJsonOcsSerializer =
    _$PredefinedStatusFindAllResponseApplicationJson_OcsSerializer();
Serializer<PredefinedStatusFindAllResponseApplicationJson> _$predefinedStatusFindAllResponseApplicationJsonSerializer =
    _$PredefinedStatusFindAllResponseApplicationJsonSerializer();
Serializer<StatusesFindAllResponseApplicationJson_Ocs> _$statusesFindAllResponseApplicationJsonOcsSerializer =
    _$StatusesFindAllResponseApplicationJson_OcsSerializer();
Serializer<StatusesFindAllResponseApplicationJson> _$statusesFindAllResponseApplicationJsonSerializer =
    _$StatusesFindAllResponseApplicationJsonSerializer();
Serializer<StatusesFindResponseApplicationJson_Ocs> _$statusesFindResponseApplicationJsonOcsSerializer =
    _$StatusesFindResponseApplicationJson_OcsSerializer();
Serializer<StatusesFindResponseApplicationJson> _$statusesFindResponseApplicationJsonSerializer =
    _$StatusesFindResponseApplicationJsonSerializer();
Serializer<UserStatusGetStatusResponseApplicationJson_Ocs> _$userStatusGetStatusResponseApplicationJsonOcsSerializer =
    _$UserStatusGetStatusResponseApplicationJson_OcsSerializer();
Serializer<UserStatusGetStatusResponseApplicationJson> _$userStatusGetStatusResponseApplicationJsonSerializer =
    _$UserStatusGetStatusResponseApplicationJsonSerializer();
Serializer<UserStatusSetStatusResponseApplicationJson_Ocs> _$userStatusSetStatusResponseApplicationJsonOcsSerializer =
    _$UserStatusSetStatusResponseApplicationJson_OcsSerializer();
Serializer<UserStatusSetStatusResponseApplicationJson> _$userStatusSetStatusResponseApplicationJsonSerializer =
    _$UserStatusSetStatusResponseApplicationJsonSerializer();
Serializer<UserStatusSetPredefinedMessageResponseApplicationJson_Ocs>
    _$userStatusSetPredefinedMessageResponseApplicationJsonOcsSerializer =
    _$UserStatusSetPredefinedMessageResponseApplicationJson_OcsSerializer();
Serializer<UserStatusSetPredefinedMessageResponseApplicationJson>
    _$userStatusSetPredefinedMessageResponseApplicationJsonSerializer =
    _$UserStatusSetPredefinedMessageResponseApplicationJsonSerializer();
Serializer<UserStatusSetCustomMessageResponseApplicationJson_Ocs>
    _$userStatusSetCustomMessageResponseApplicationJsonOcsSerializer =
    _$UserStatusSetCustomMessageResponseApplicationJson_OcsSerializer();
Serializer<UserStatusSetCustomMessageResponseApplicationJson>
    _$userStatusSetCustomMessageResponseApplicationJsonSerializer =
    _$UserStatusSetCustomMessageResponseApplicationJsonSerializer();
Serializer<UserStatusClearMessageResponseApplicationJson_Ocs>
    _$userStatusClearMessageResponseApplicationJsonOcsSerializer =
    _$UserStatusClearMessageResponseApplicationJson_OcsSerializer();
Serializer<UserStatusClearMessageResponseApplicationJson> _$userStatusClearMessageResponseApplicationJsonSerializer =
    _$UserStatusClearMessageResponseApplicationJsonSerializer();
Serializer<UserStatusRevertStatusResponseApplicationJson_Ocs>
    _$userStatusRevertStatusResponseApplicationJsonOcsSerializer =
    _$UserStatusRevertStatusResponseApplicationJson_OcsSerializer();
Serializer<UserStatusRevertStatusResponseApplicationJson> _$userStatusRevertStatusResponseApplicationJsonSerializer =
    _$UserStatusRevertStatusResponseApplicationJsonSerializer();
Serializer<Capabilities_UserStatus> _$capabilitiesUserStatusSerializer = _$Capabilities_UserStatusSerializer();
Serializer<Capabilities> _$capabilitiesSerializer = _$CapabilitiesSerializer();

class _$OCSMetaSerializer implements StructuredSerializer<OCSMeta> {
  @override
  final Iterable<Type> types = const [OCSMeta, _$OCSMeta];
  @override
  final String wireName = 'OCSMeta';

  @override
  Iterable<Object?> serialize(Serializers serializers, OCSMeta object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
      'statuscode',
      serializers.serialize(object.statuscode, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.totalitems;
    if (value != null) {
      result
        ..add('totalitems')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.itemsperpage;
    if (value != null) {
      result
        ..add('itemsperpage')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  OCSMeta deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OCSMetaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'statuscode':
          result.statuscode = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'totalitems':
          result.totalitems = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'itemsperpage':
          result.itemsperpage = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PublicSerializer implements StructuredSerializer<Public> {
  @override
  final Iterable<Type> types = const [Public, _$Public];
  @override
  final String wireName = 'Public';

  @override
  Iterable<Object?> serialize(Serializers serializers, Public object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.icon;
    if (value != null) {
      result
        ..add('icon')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.clearAt;
    if (value != null) {
      result
        ..add('clearAt')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Public deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PublicBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'icon':
          result.icon = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'clearAt':
          result.clearAt = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$PrivateSerializer implements StructuredSerializer<Private> {
  @override
  final Iterable<Type> types = const [Private, _$Private];
  @override
  final String wireName = 'Private';

  @override
  Iterable<Object?> serialize(Serializers serializers, Private object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'messageIsPredefined',
      serializers.serialize(object.messageIsPredefined, specifiedType: const FullType(bool)),
      'statusIsUserDefined',
      serializers.serialize(object.statusIsUserDefined, specifiedType: const FullType(bool)),
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.messageId;
    if (value != null) {
      result
        ..add('messageId')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.message;
    if (value != null) {
      result
        ..add('message')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.icon;
    if (value != null) {
      result
        ..add('icon')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.clearAt;
    if (value != null) {
      result
        ..add('clearAt')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Private deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PrivateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'messageId':
          result.messageId = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'messageIsPredefined':
          result.messageIsPredefined = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'statusIsUserDefined':
          result.statusIsUserDefined = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'icon':
          result.icon = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'clearAt':
          result.clearAt = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$HeartbeatHeartbeatResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<HeartbeatHeartbeatResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    HeartbeatHeartbeatResponseApplicationJson_Ocs,
    _$HeartbeatHeartbeatResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'HeartbeatHeartbeatResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, HeartbeatHeartbeatResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Private)),
    ];

    return result;
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = HeartbeatHeartbeatResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Private))! as Private);
          break;
      }
    }

    return result.build();
  }
}

class _$HeartbeatHeartbeatResponseApplicationJsonSerializer
    implements StructuredSerializer<HeartbeatHeartbeatResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    HeartbeatHeartbeatResponseApplicationJson,
    _$HeartbeatHeartbeatResponseApplicationJson
  ];
  @override
  final String wireName = 'HeartbeatHeartbeatResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, HeartbeatHeartbeatResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(HeartbeatHeartbeatResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = HeartbeatHeartbeatResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(HeartbeatHeartbeatResponseApplicationJson_Ocs))!
              as HeartbeatHeartbeatResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$ClearAtSerializer implements StructuredSerializer<ClearAt> {
  @override
  final Iterable<Type> types = const [ClearAt, _$ClearAt];
  @override
  final String wireName = 'ClearAt';

  @override
  Iterable<Object?> serialize(Serializers serializers, ClearAt object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(ClearAt_Type)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(ClearAt_Time)),
    ];

    return result;
  }

  @override
  ClearAt deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ClearAtBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(ClearAt_Type))! as ClearAt_Type;
          break;
        case 'time':
          result.time = serializers.deserialize(value, specifiedType: const FullType(ClearAt_Time))! as ClearAt_Time;
          break;
      }
    }

    return result.build();
  }
}

class _$PredefinedSerializer implements StructuredSerializer<Predefined> {
  @override
  final Iterable<Type> types = const [Predefined, _$Predefined];
  @override
  final String wireName = 'Predefined';

  @override
  Iterable<Object?> serialize(Serializers serializers, Predefined object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'icon',
      serializers.serialize(object.icon, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.clearAt;
    if (value != null) {
      result
        ..add('clearAt')
        ..add(serializers.serialize(value, specifiedType: const FullType(ClearAt)));
    }
    value = object.visible;
    if (value != null) {
      result
        ..add('visible')
        ..add(serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Predefined deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PredefinedBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'icon':
          result.icon = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'clearAt':
          result.clearAt.replace(serializers.deserialize(value, specifiedType: const FullType(ClearAt))! as ClearAt);
          break;
        case 'visible':
          result.visible = serializers.deserialize(value, specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }

    return result.build();
  }
}

class _$PredefinedStatusFindAllResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<PredefinedStatusFindAllResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    PredefinedStatusFindAllResponseApplicationJson_Ocs,
    _$PredefinedStatusFindAllResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'PredefinedStatusFindAllResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, PredefinedStatusFindAllResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(BuiltList, [FullType(Predefined)])),
    ];

    return result;
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PredefinedStatusFindAllResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Predefined)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$PredefinedStatusFindAllResponseApplicationJsonSerializer
    implements StructuredSerializer<PredefinedStatusFindAllResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    PredefinedStatusFindAllResponseApplicationJson,
    _$PredefinedStatusFindAllResponseApplicationJson
  ];
  @override
  final String wireName = 'PredefinedStatusFindAllResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, PredefinedStatusFindAllResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(PredefinedStatusFindAllResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PredefinedStatusFindAllResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(PredefinedStatusFindAllResponseApplicationJson_Ocs))!
              as PredefinedStatusFindAllResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$StatusesFindAllResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<StatusesFindAllResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    StatusesFindAllResponseApplicationJson_Ocs,
    _$StatusesFindAllResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'StatusesFindAllResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, StatusesFindAllResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(BuiltList, [FullType(Public)])),
    ];

    return result;
  }

  @override
  StatusesFindAllResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StatusesFindAllResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Public)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$StatusesFindAllResponseApplicationJsonSerializer
    implements StructuredSerializer<StatusesFindAllResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [StatusesFindAllResponseApplicationJson, _$StatusesFindAllResponseApplicationJson];
  @override
  final String wireName = 'StatusesFindAllResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, StatusesFindAllResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(StatusesFindAllResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  StatusesFindAllResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StatusesFindAllResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(
              serializers.deserialize(value, specifiedType: const FullType(StatusesFindAllResponseApplicationJson_Ocs))!
                  as StatusesFindAllResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$StatusesFindResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<StatusesFindResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    StatusesFindResponseApplicationJson_Ocs,
    _$StatusesFindResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'StatusesFindResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, StatusesFindResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Public)),
    ];

    return result;
  }

  @override
  StatusesFindResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StatusesFindResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Public))! as Public);
          break;
      }
    }

    return result.build();
  }
}

class _$StatusesFindResponseApplicationJsonSerializer
    implements StructuredSerializer<StatusesFindResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [StatusesFindResponseApplicationJson, _$StatusesFindResponseApplicationJson];
  @override
  final String wireName = 'StatusesFindResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, StatusesFindResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(StatusesFindResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  StatusesFindResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StatusesFindResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(
              serializers.deserialize(value, specifiedType: const FullType(StatusesFindResponseApplicationJson_Ocs))!
                  as StatusesFindResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusGetStatusResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusGetStatusResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusGetStatusResponseApplicationJson_Ocs,
    _$UserStatusGetStatusResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusGetStatusResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusGetStatusResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Private)),
    ];

    return result;
  }

  @override
  UserStatusGetStatusResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusGetStatusResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Private))! as Private);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusGetStatusResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusGetStatusResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusGetStatusResponseApplicationJson,
    _$UserStatusGetStatusResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusGetStatusResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusGetStatusResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(UserStatusGetStatusResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusGetStatusResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusGetStatusResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusGetStatusResponseApplicationJson_Ocs))!
              as UserStatusGetStatusResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetStatusResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusSetStatusResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetStatusResponseApplicationJson_Ocs,
    _$UserStatusSetStatusResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusSetStatusResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetStatusResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Private)),
    ];

    return result;
  }

  @override
  UserStatusSetStatusResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetStatusResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Private))! as Private);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetStatusResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusSetStatusResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetStatusResponseApplicationJson,
    _$UserStatusSetStatusResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusSetStatusResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetStatusResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(UserStatusSetStatusResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusSetStatusResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetStatusResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusSetStatusResponseApplicationJson_Ocs))!
              as UserStatusSetStatusResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetPredefinedMessageResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusSetPredefinedMessageResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetPredefinedMessageResponseApplicationJson_Ocs,
    _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusSetPredefinedMessageResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetPredefinedMessageResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Private)),
    ];

    return result;
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Private))! as Private);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetPredefinedMessageResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusSetPredefinedMessageResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetPredefinedMessageResponseApplicationJson,
    _$UserStatusSetPredefinedMessageResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusSetPredefinedMessageResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetPredefinedMessageResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(UserStatusSetPredefinedMessageResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetPredefinedMessageResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusSetPredefinedMessageResponseApplicationJson_Ocs))!
              as UserStatusSetPredefinedMessageResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetCustomMessageResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusSetCustomMessageResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetCustomMessageResponseApplicationJson_Ocs,
    _$UserStatusSetCustomMessageResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusSetCustomMessageResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetCustomMessageResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(Private)),
    ];

    return result;
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(Private))! as Private);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusSetCustomMessageResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusSetCustomMessageResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusSetCustomMessageResponseApplicationJson,
    _$UserStatusSetCustomMessageResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusSetCustomMessageResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusSetCustomMessageResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(UserStatusSetCustomMessageResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusSetCustomMessageResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusSetCustomMessageResponseApplicationJson_Ocs))!
              as UserStatusSetCustomMessageResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusClearMessageResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusClearMessageResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusClearMessageResponseApplicationJson_Ocs,
    _$UserStatusClearMessageResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusClearMessageResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusClearMessageResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(JsonObject)),
    ];

    return result;
  }

  @override
  UserStatusClearMessageResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusClearMessageResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data = serializers.deserialize(value, specifiedType: const FullType(JsonObject))! as JsonObject;
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusClearMessageResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusClearMessageResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusClearMessageResponseApplicationJson,
    _$UserStatusClearMessageResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusClearMessageResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusClearMessageResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(UserStatusClearMessageResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusClearMessageResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusClearMessageResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusClearMessageResponseApplicationJson_Ocs))!
              as UserStatusClearMessageResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusRevertStatusResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<UserStatusRevertStatusResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    UserStatusRevertStatusResponseApplicationJson_Ocs,
    _$UserStatusRevertStatusResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'UserStatusRevertStatusResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusRevertStatusResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(UserStatusRevertStatusResponseApplicationJson_Ocs_Data)),
    ];

    return result;
  }

  @override
  UserStatusRevertStatusResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusRevertStatusResponseApplicationJson_OcsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'meta':
          result.meta.replace(serializers.deserialize(value, specifiedType: const FullType(OCSMeta))! as OCSMeta);
          break;
        case 'data':
          result.data = serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusRevertStatusResponseApplicationJson_Ocs_Data))!
              as UserStatusRevertStatusResponseApplicationJson_Ocs_Data;
          break;
      }
    }

    return result.build();
  }
}

class _$UserStatusRevertStatusResponseApplicationJsonSerializer
    implements StructuredSerializer<UserStatusRevertStatusResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UserStatusRevertStatusResponseApplicationJson,
    _$UserStatusRevertStatusResponseApplicationJson
  ];
  @override
  final String wireName = 'UserStatusRevertStatusResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserStatusRevertStatusResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(UserStatusRevertStatusResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  UserStatusRevertStatusResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserStatusRevertStatusResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UserStatusRevertStatusResponseApplicationJson_Ocs))!
              as UserStatusRevertStatusResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_UserStatusSerializer implements StructuredSerializer<Capabilities_UserStatus> {
  @override
  final Iterable<Type> types = const [Capabilities_UserStatus, _$Capabilities_UserStatus];
  @override
  final String wireName = 'Capabilities_UserStatus';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_UserStatus object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'supports_emoji',
      serializers.serialize(object.supportsEmoji, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.restore;
    if (value != null) {
      result
        ..add('restore')
        ..add(serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Capabilities_UserStatus deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_UserStatusBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'restore':
          result.restore = serializers.deserialize(value, specifiedType: const FullType(bool)) as bool?;
          break;
        case 'supports_emoji':
          result.supportsEmoji = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$CapabilitiesSerializer implements StructuredSerializer<Capabilities> {
  @override
  final Iterable<Type> types = const [Capabilities, _$Capabilities];
  @override
  final String wireName = 'Capabilities';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'user_status',
      serializers.serialize(object.userStatus, specifiedType: const FullType(Capabilities_UserStatus)),
    ];

    return result;
  }

  @override
  Capabilities deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CapabilitiesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_status':
          result.userStatus.replace(serializers.deserialize(value,
              specifiedType: const FullType(Capabilities_UserStatus))! as Capabilities_UserStatus);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $OCSMetaInterfaceBuilder {
  void replace($OCSMetaInterface other);
  void update(void Function($OCSMetaInterfaceBuilder) updates);
  String? get status;
  set status(String? status);

  int? get statuscode;
  set statuscode(int? statuscode);

  String? get message;
  set message(String? message);

  String? get totalitems;
  set totalitems(String? totalitems);

  String? get itemsperpage;
  set itemsperpage(String? itemsperpage);
}

class _$OCSMeta extends OCSMeta {
  @override
  final String status;
  @override
  final int statuscode;
  @override
  final String? message;
  @override
  final String? totalitems;
  @override
  final String? itemsperpage;

  factory _$OCSMeta([void Function(OCSMetaBuilder)? updates]) => (OCSMetaBuilder()..update(updates))._build();

  _$OCSMeta._({required this.status, required this.statuscode, this.message, this.totalitems, this.itemsperpage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status');
    BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode');
  }

  @override
  OCSMeta rebuild(void Function(OCSMetaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OCSMetaBuilder toBuilder() => OCSMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OCSMeta &&
        status == other.status &&
        statuscode == other.statuscode &&
        message == other.message &&
        totalitems == other.totalitems &&
        itemsperpage == other.itemsperpage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statuscode.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, totalitems.hashCode);
    _$hash = $jc(_$hash, itemsperpage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OCSMeta')
          ..add('status', status)
          ..add('statuscode', statuscode)
          ..add('message', message)
          ..add('totalitems', totalitems)
          ..add('itemsperpage', itemsperpage))
        .toString();
  }
}

class OCSMetaBuilder implements Builder<OCSMeta, OCSMetaBuilder>, $OCSMetaInterfaceBuilder {
  _$OCSMeta? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  int? _statuscode;
  int? get statuscode => _$this._statuscode;
  set statuscode(covariant int? statuscode) => _$this._statuscode = statuscode;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  String? _totalitems;
  String? get totalitems => _$this._totalitems;
  set totalitems(covariant String? totalitems) => _$this._totalitems = totalitems;

  String? _itemsperpage;
  String? get itemsperpage => _$this._itemsperpage;
  set itemsperpage(covariant String? itemsperpage) => _$this._itemsperpage = itemsperpage;

  OCSMetaBuilder();

  OCSMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _statuscode = $v.statuscode;
      _message = $v.message;
      _totalitems = $v.totalitems;
      _itemsperpage = $v.itemsperpage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OCSMeta other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OCSMeta;
  }

  @override
  void update(void Function(OCSMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OCSMeta build() => _build();

  _$OCSMeta _build() {
    final _$result = _$v ??
        _$OCSMeta._(
            status: BuiltValueNullFieldError.checkNotNull(status, r'OCSMeta', 'status'),
            statuscode: BuiltValueNullFieldError.checkNotNull(statuscode, r'OCSMeta', 'statuscode'),
            message: message,
            totalitems: totalitems,
            itemsperpage: itemsperpage);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PublicInterfaceBuilder {
  void replace($PublicInterface other);
  void update(void Function($PublicInterfaceBuilder) updates);
  String? get userId;
  set userId(String? userId);

  String? get message;
  set message(String? message);

  String? get icon;
  set icon(String? icon);

  int? get clearAt;
  set clearAt(int? clearAt);

  String? get status;
  set status(String? status);
}

class _$Public extends Public {
  @override
  final String userId;
  @override
  final String? message;
  @override
  final String? icon;
  @override
  final int? clearAt;
  @override
  final String status;

  factory _$Public([void Function(PublicBuilder)? updates]) => (PublicBuilder()..update(updates))._build();

  _$Public._({required this.userId, this.message, this.icon, this.clearAt, required this.status}) : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, r'Public', 'userId');
    BuiltValueNullFieldError.checkNotNull(status, r'Public', 'status');
  }

  @override
  Public rebuild(void Function(PublicBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PublicBuilder toBuilder() => PublicBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Public &&
        userId == other.userId &&
        message == other.message &&
        icon == other.icon &&
        clearAt == other.clearAt &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, clearAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Public')
          ..add('userId', userId)
          ..add('message', message)
          ..add('icon', icon)
          ..add('clearAt', clearAt)
          ..add('status', status))
        .toString();
  }
}

class PublicBuilder implements Builder<Public, PublicBuilder>, $PublicInterfaceBuilder {
  _$Public? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(covariant String? icon) => _$this._icon = icon;

  int? _clearAt;
  int? get clearAt => _$this._clearAt;
  set clearAt(covariant int? clearAt) => _$this._clearAt = clearAt;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  PublicBuilder();

  PublicBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _message = $v.message;
      _icon = $v.icon;
      _clearAt = $v.clearAt;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Public other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Public;
  }

  @override
  void update(void Function(PublicBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Public build() => _build();

  _$Public _build() {
    final _$result = _$v ??
        _$Public._(
            userId: BuiltValueNullFieldError.checkNotNull(userId, r'Public', 'userId'),
            message: message,
            icon: icon,
            clearAt: clearAt,
            status: BuiltValueNullFieldError.checkNotNull(status, r'Public', 'status'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PrivateInterfaceBuilder implements $PublicInterfaceBuilder {
  void replace(covariant $PrivateInterface other);
  void update(void Function($PrivateInterfaceBuilder) updates);
  String? get messageId;
  set messageId(covariant String? messageId);

  bool? get messageIsPredefined;
  set messageIsPredefined(covariant bool? messageIsPredefined);

  bool? get statusIsUserDefined;
  set statusIsUserDefined(covariant bool? statusIsUserDefined);

  String? get userId;
  set userId(covariant String? userId);

  String? get message;
  set message(covariant String? message);

  String? get icon;
  set icon(covariant String? icon);

  int? get clearAt;
  set clearAt(covariant int? clearAt);

  String? get status;
  set status(covariant String? status);
}

class _$Private extends Private {
  @override
  final String? messageId;
  @override
  final bool messageIsPredefined;
  @override
  final bool statusIsUserDefined;
  @override
  final String userId;
  @override
  final String? message;
  @override
  final String? icon;
  @override
  final int? clearAt;
  @override
  final String status;

  factory _$Private([void Function(PrivateBuilder)? updates]) => (PrivateBuilder()..update(updates))._build();

  _$Private._(
      {this.messageId,
      required this.messageIsPredefined,
      required this.statusIsUserDefined,
      required this.userId,
      this.message,
      this.icon,
      this.clearAt,
      required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(messageIsPredefined, r'Private', 'messageIsPredefined');
    BuiltValueNullFieldError.checkNotNull(statusIsUserDefined, r'Private', 'statusIsUserDefined');
    BuiltValueNullFieldError.checkNotNull(userId, r'Private', 'userId');
    BuiltValueNullFieldError.checkNotNull(status, r'Private', 'status');
  }

  @override
  Private rebuild(void Function(PrivateBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PrivateBuilder toBuilder() => PrivateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Private &&
        messageId == other.messageId &&
        messageIsPredefined == other.messageIsPredefined &&
        statusIsUserDefined == other.statusIsUserDefined &&
        userId == other.userId &&
        message == other.message &&
        icon == other.icon &&
        clearAt == other.clearAt &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, messageIsPredefined.hashCode);
    _$hash = $jc(_$hash, statusIsUserDefined.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, clearAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Private')
          ..add('messageId', messageId)
          ..add('messageIsPredefined', messageIsPredefined)
          ..add('statusIsUserDefined', statusIsUserDefined)
          ..add('userId', userId)
          ..add('message', message)
          ..add('icon', icon)
          ..add('clearAt', clearAt)
          ..add('status', status))
        .toString();
  }
}

class PrivateBuilder implements Builder<Private, PrivateBuilder>, $PrivateInterfaceBuilder {
  _$Private? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(covariant String? messageId) => _$this._messageId = messageId;

  bool? _messageIsPredefined;
  bool? get messageIsPredefined => _$this._messageIsPredefined;
  set messageIsPredefined(covariant bool? messageIsPredefined) => _$this._messageIsPredefined = messageIsPredefined;

  bool? _statusIsUserDefined;
  bool? get statusIsUserDefined => _$this._statusIsUserDefined;
  set statusIsUserDefined(covariant bool? statusIsUserDefined) => _$this._statusIsUserDefined = statusIsUserDefined;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(covariant String? icon) => _$this._icon = icon;

  int? _clearAt;
  int? get clearAt => _$this._clearAt;
  set clearAt(covariant int? clearAt) => _$this._clearAt = clearAt;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  PrivateBuilder();

  PrivateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _messageIsPredefined = $v.messageIsPredefined;
      _statusIsUserDefined = $v.statusIsUserDefined;
      _userId = $v.userId;
      _message = $v.message;
      _icon = $v.icon;
      _clearAt = $v.clearAt;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Private other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Private;
  }

  @override
  void update(void Function(PrivateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Private build() => _build();

  _$Private _build() {
    final _$result = _$v ??
        _$Private._(
            messageId: messageId,
            messageIsPredefined:
                BuiltValueNullFieldError.checkNotNull(messageIsPredefined, r'Private', 'messageIsPredefined'),
            statusIsUserDefined:
                BuiltValueNullFieldError.checkNotNull(statusIsUserDefined, r'Private', 'statusIsUserDefined'),
            userId: BuiltValueNullFieldError.checkNotNull(userId, r'Private', 'userId'),
            message: message,
            icon: icon,
            clearAt: clearAt,
            status: BuiltValueNullFieldError.checkNotNull(status, r'Private', 'status'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $HeartbeatHeartbeatResponseApplicationJson_OcsInterfaceBuilder {
  void replace($HeartbeatHeartbeatResponseApplicationJson_OcsInterface other);
  void update(void Function($HeartbeatHeartbeatResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PrivateBuilder get data;
  set data(PrivateBuilder? data);
}

class _$HeartbeatHeartbeatResponseApplicationJson_Ocs extends HeartbeatHeartbeatResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Private data;

  factory _$HeartbeatHeartbeatResponseApplicationJson_Ocs(
          [void Function(HeartbeatHeartbeatResponseApplicationJson_OcsBuilder)? updates]) =>
      (HeartbeatHeartbeatResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$HeartbeatHeartbeatResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'HeartbeatHeartbeatResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'HeartbeatHeartbeatResponseApplicationJson_Ocs', 'data');
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson_Ocs rebuild(
          void Function(HeartbeatHeartbeatResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder toBuilder() =>
      HeartbeatHeartbeatResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HeartbeatHeartbeatResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HeartbeatHeartbeatResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class HeartbeatHeartbeatResponseApplicationJson_OcsBuilder
    implements
        Builder<HeartbeatHeartbeatResponseApplicationJson_Ocs, HeartbeatHeartbeatResponseApplicationJson_OcsBuilder>,
        $HeartbeatHeartbeatResponseApplicationJson_OcsInterfaceBuilder {
  _$HeartbeatHeartbeatResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PrivateBuilder? _data;
  PrivateBuilder get data => _$this._data ??= PrivateBuilder();
  set data(covariant PrivateBuilder? data) => _$this._data = data;

  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder();

  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant HeartbeatHeartbeatResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HeartbeatHeartbeatResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(HeartbeatHeartbeatResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson_Ocs build() => _build();

  _$HeartbeatHeartbeatResponseApplicationJson_Ocs _build() {
    _$HeartbeatHeartbeatResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$HeartbeatHeartbeatResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'HeartbeatHeartbeatResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $HeartbeatHeartbeatResponseApplicationJsonInterfaceBuilder {
  void replace($HeartbeatHeartbeatResponseApplicationJsonInterface other);
  void update(void Function($HeartbeatHeartbeatResponseApplicationJsonInterfaceBuilder) updates);
  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder get ocs;
  set ocs(HeartbeatHeartbeatResponseApplicationJson_OcsBuilder? ocs);
}

class _$HeartbeatHeartbeatResponseApplicationJson extends HeartbeatHeartbeatResponseApplicationJson {
  @override
  final HeartbeatHeartbeatResponseApplicationJson_Ocs ocs;

  factory _$HeartbeatHeartbeatResponseApplicationJson(
          [void Function(HeartbeatHeartbeatResponseApplicationJsonBuilder)? updates]) =>
      (HeartbeatHeartbeatResponseApplicationJsonBuilder()..update(updates))._build();

  _$HeartbeatHeartbeatResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'HeartbeatHeartbeatResponseApplicationJson', 'ocs');
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson rebuild(
          void Function(HeartbeatHeartbeatResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HeartbeatHeartbeatResponseApplicationJsonBuilder toBuilder() =>
      HeartbeatHeartbeatResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HeartbeatHeartbeatResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HeartbeatHeartbeatResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class HeartbeatHeartbeatResponseApplicationJsonBuilder
    implements
        Builder<HeartbeatHeartbeatResponseApplicationJson, HeartbeatHeartbeatResponseApplicationJsonBuilder>,
        $HeartbeatHeartbeatResponseApplicationJsonInterfaceBuilder {
  _$HeartbeatHeartbeatResponseApplicationJson? _$v;

  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder? _ocs;
  HeartbeatHeartbeatResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= HeartbeatHeartbeatResponseApplicationJson_OcsBuilder();
  set ocs(covariant HeartbeatHeartbeatResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  HeartbeatHeartbeatResponseApplicationJsonBuilder();

  HeartbeatHeartbeatResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant HeartbeatHeartbeatResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HeartbeatHeartbeatResponseApplicationJson;
  }

  @override
  void update(void Function(HeartbeatHeartbeatResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HeartbeatHeartbeatResponseApplicationJson build() => _build();

  _$HeartbeatHeartbeatResponseApplicationJson _build() {
    _$HeartbeatHeartbeatResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$HeartbeatHeartbeatResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'HeartbeatHeartbeatResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ClearAtInterfaceBuilder {
  void replace($ClearAtInterface other);
  void update(void Function($ClearAtInterfaceBuilder) updates);
  ClearAt_Type? get type;
  set type(ClearAt_Type? type);

  ClearAt_Time? get time;
  set time(ClearAt_Time? time);
}

class _$ClearAt extends ClearAt {
  @override
  final ClearAt_Type type;
  @override
  final ClearAt_Time time;

  factory _$ClearAt([void Function(ClearAtBuilder)? updates]) => (ClearAtBuilder()..update(updates))._build();

  _$ClearAt._({required this.type, required this.time}) : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'ClearAt', 'type');
    BuiltValueNullFieldError.checkNotNull(time, r'ClearAt', 'time');
  }

  @override
  ClearAt rebuild(void Function(ClearAtBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ClearAtBuilder toBuilder() => ClearAtBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is ClearAt && type == other.type && time == _$dynamicOther.time;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClearAt')
          ..add('type', type)
          ..add('time', time))
        .toString();
  }
}

class ClearAtBuilder implements Builder<ClearAt, ClearAtBuilder>, $ClearAtInterfaceBuilder {
  _$ClearAt? _$v;

  ClearAt_Type? _type;
  ClearAt_Type? get type => _$this._type;
  set type(covariant ClearAt_Type? type) => _$this._type = type;

  ClearAt_Time? _time;
  ClearAt_Time? get time => _$this._time;
  set time(covariant ClearAt_Time? time) => _$this._time = time;

  ClearAtBuilder();

  ClearAtBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _time = $v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ClearAt other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ClearAt;
  }

  @override
  void update(void Function(ClearAtBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClearAt build() => _build();

  _$ClearAt _build() {
    ClearAt._validate(this);
    final _$result = _$v ??
        _$ClearAt._(
            type: BuiltValueNullFieldError.checkNotNull(type, r'ClearAt', 'type'),
            time: BuiltValueNullFieldError.checkNotNull(time, r'ClearAt', 'time'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PredefinedInterfaceBuilder {
  void replace($PredefinedInterface other);
  void update(void Function($PredefinedInterfaceBuilder) updates);
  String? get id;
  set id(String? id);

  String? get icon;
  set icon(String? icon);

  String? get message;
  set message(String? message);

  ClearAtBuilder get clearAt;
  set clearAt(ClearAtBuilder? clearAt);

  bool? get visible;
  set visible(bool? visible);
}

class _$Predefined extends Predefined {
  @override
  final String id;
  @override
  final String icon;
  @override
  final String message;
  @override
  final ClearAt? clearAt;
  @override
  final bool? visible;

  factory _$Predefined([void Function(PredefinedBuilder)? updates]) => (PredefinedBuilder()..update(updates))._build();

  _$Predefined._({required this.id, required this.icon, required this.message, this.clearAt, this.visible})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Predefined', 'id');
    BuiltValueNullFieldError.checkNotNull(icon, r'Predefined', 'icon');
    BuiltValueNullFieldError.checkNotNull(message, r'Predefined', 'message');
  }

  @override
  Predefined rebuild(void Function(PredefinedBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PredefinedBuilder toBuilder() => PredefinedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Predefined &&
        id == other.id &&
        icon == other.icon &&
        message == other.message &&
        clearAt == other.clearAt &&
        visible == other.visible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, clearAt.hashCode);
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Predefined')
          ..add('id', id)
          ..add('icon', icon)
          ..add('message', message)
          ..add('clearAt', clearAt)
          ..add('visible', visible))
        .toString();
  }
}

class PredefinedBuilder implements Builder<Predefined, PredefinedBuilder>, $PredefinedInterfaceBuilder {
  _$Predefined? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(covariant String? icon) => _$this._icon = icon;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  ClearAtBuilder? _clearAt;
  ClearAtBuilder get clearAt => _$this._clearAt ??= ClearAtBuilder();
  set clearAt(covariant ClearAtBuilder? clearAt) => _$this._clearAt = clearAt;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(covariant bool? visible) => _$this._visible = visible;

  PredefinedBuilder();

  PredefinedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _icon = $v.icon;
      _message = $v.message;
      _clearAt = $v.clearAt?.toBuilder();
      _visible = $v.visible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Predefined other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Predefined;
  }

  @override
  void update(void Function(PredefinedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Predefined build() => _build();

  _$Predefined _build() {
    _$Predefined _$result;
    try {
      _$result = _$v ??
          _$Predefined._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Predefined', 'id'),
              icon: BuiltValueNullFieldError.checkNotNull(icon, r'Predefined', 'icon'),
              message: BuiltValueNullFieldError.checkNotNull(message, r'Predefined', 'message'),
              clearAt: _clearAt?.build(),
              visible: visible);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'clearAt';
        _clearAt?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Predefined', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PredefinedStatusFindAllResponseApplicationJson_OcsInterfaceBuilder {
  void replace($PredefinedStatusFindAllResponseApplicationJson_OcsInterface other);
  void update(void Function($PredefinedStatusFindAllResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ListBuilder<Predefined> get data;
  set data(ListBuilder<Predefined>? data);
}

class _$PredefinedStatusFindAllResponseApplicationJson_Ocs extends PredefinedStatusFindAllResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltList<Predefined> data;

  factory _$PredefinedStatusFindAllResponseApplicationJson_Ocs(
          [void Function(PredefinedStatusFindAllResponseApplicationJson_OcsBuilder)? updates]) =>
      (PredefinedStatusFindAllResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$PredefinedStatusFindAllResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'PredefinedStatusFindAllResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'PredefinedStatusFindAllResponseApplicationJson_Ocs', 'data');
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson_Ocs rebuild(
          void Function(PredefinedStatusFindAllResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder toBuilder() =>
      PredefinedStatusFindAllResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PredefinedStatusFindAllResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PredefinedStatusFindAllResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class PredefinedStatusFindAllResponseApplicationJson_OcsBuilder
    implements
        Builder<PredefinedStatusFindAllResponseApplicationJson_Ocs,
            PredefinedStatusFindAllResponseApplicationJson_OcsBuilder>,
        $PredefinedStatusFindAllResponseApplicationJson_OcsInterfaceBuilder {
  _$PredefinedStatusFindAllResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<Predefined>? _data;
  ListBuilder<Predefined> get data => _$this._data ??= ListBuilder<Predefined>();
  set data(covariant ListBuilder<Predefined>? data) => _$this._data = data;

  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder();

  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PredefinedStatusFindAllResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PredefinedStatusFindAllResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(PredefinedStatusFindAllResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson_Ocs build() => _build();

  _$PredefinedStatusFindAllResponseApplicationJson_Ocs _build() {
    _$PredefinedStatusFindAllResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$PredefinedStatusFindAllResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PredefinedStatusFindAllResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PredefinedStatusFindAllResponseApplicationJsonInterfaceBuilder {
  void replace($PredefinedStatusFindAllResponseApplicationJsonInterface other);
  void update(void Function($PredefinedStatusFindAllResponseApplicationJsonInterfaceBuilder) updates);
  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder get ocs;
  set ocs(PredefinedStatusFindAllResponseApplicationJson_OcsBuilder? ocs);
}

class _$PredefinedStatusFindAllResponseApplicationJson extends PredefinedStatusFindAllResponseApplicationJson {
  @override
  final PredefinedStatusFindAllResponseApplicationJson_Ocs ocs;

  factory _$PredefinedStatusFindAllResponseApplicationJson(
          [void Function(PredefinedStatusFindAllResponseApplicationJsonBuilder)? updates]) =>
      (PredefinedStatusFindAllResponseApplicationJsonBuilder()..update(updates))._build();

  _$PredefinedStatusFindAllResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'PredefinedStatusFindAllResponseApplicationJson', 'ocs');
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson rebuild(
          void Function(PredefinedStatusFindAllResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PredefinedStatusFindAllResponseApplicationJsonBuilder toBuilder() =>
      PredefinedStatusFindAllResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PredefinedStatusFindAllResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PredefinedStatusFindAllResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class PredefinedStatusFindAllResponseApplicationJsonBuilder
    implements
        Builder<PredefinedStatusFindAllResponseApplicationJson, PredefinedStatusFindAllResponseApplicationJsonBuilder>,
        $PredefinedStatusFindAllResponseApplicationJsonInterfaceBuilder {
  _$PredefinedStatusFindAllResponseApplicationJson? _$v;

  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder? _ocs;
  PredefinedStatusFindAllResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= PredefinedStatusFindAllResponseApplicationJson_OcsBuilder();
  set ocs(covariant PredefinedStatusFindAllResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  PredefinedStatusFindAllResponseApplicationJsonBuilder();

  PredefinedStatusFindAllResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PredefinedStatusFindAllResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PredefinedStatusFindAllResponseApplicationJson;
  }

  @override
  void update(void Function(PredefinedStatusFindAllResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PredefinedStatusFindAllResponseApplicationJson build() => _build();

  _$PredefinedStatusFindAllResponseApplicationJson _build() {
    _$PredefinedStatusFindAllResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$PredefinedStatusFindAllResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PredefinedStatusFindAllResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $StatusesFindAllResponseApplicationJson_OcsInterfaceBuilder {
  void replace($StatusesFindAllResponseApplicationJson_OcsInterface other);
  void update(void Function($StatusesFindAllResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ListBuilder<Public> get data;
  set data(ListBuilder<Public>? data);
}

class _$StatusesFindAllResponseApplicationJson_Ocs extends StatusesFindAllResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltList<Public> data;

  factory _$StatusesFindAllResponseApplicationJson_Ocs(
          [void Function(StatusesFindAllResponseApplicationJson_OcsBuilder)? updates]) =>
      (StatusesFindAllResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$StatusesFindAllResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'StatusesFindAllResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'StatusesFindAllResponseApplicationJson_Ocs', 'data');
  }

  @override
  StatusesFindAllResponseApplicationJson_Ocs rebuild(
          void Function(StatusesFindAllResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusesFindAllResponseApplicationJson_OcsBuilder toBuilder() =>
      StatusesFindAllResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusesFindAllResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatusesFindAllResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class StatusesFindAllResponseApplicationJson_OcsBuilder
    implements
        Builder<StatusesFindAllResponseApplicationJson_Ocs, StatusesFindAllResponseApplicationJson_OcsBuilder>,
        $StatusesFindAllResponseApplicationJson_OcsInterfaceBuilder {
  _$StatusesFindAllResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<Public>? _data;
  ListBuilder<Public> get data => _$this._data ??= ListBuilder<Public>();
  set data(covariant ListBuilder<Public>? data) => _$this._data = data;

  StatusesFindAllResponseApplicationJson_OcsBuilder();

  StatusesFindAllResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StatusesFindAllResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StatusesFindAllResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(StatusesFindAllResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatusesFindAllResponseApplicationJson_Ocs build() => _build();

  _$StatusesFindAllResponseApplicationJson_Ocs _build() {
    _$StatusesFindAllResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$StatusesFindAllResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'StatusesFindAllResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $StatusesFindAllResponseApplicationJsonInterfaceBuilder {
  void replace($StatusesFindAllResponseApplicationJsonInterface other);
  void update(void Function($StatusesFindAllResponseApplicationJsonInterfaceBuilder) updates);
  StatusesFindAllResponseApplicationJson_OcsBuilder get ocs;
  set ocs(StatusesFindAllResponseApplicationJson_OcsBuilder? ocs);
}

class _$StatusesFindAllResponseApplicationJson extends StatusesFindAllResponseApplicationJson {
  @override
  final StatusesFindAllResponseApplicationJson_Ocs ocs;

  factory _$StatusesFindAllResponseApplicationJson(
          [void Function(StatusesFindAllResponseApplicationJsonBuilder)? updates]) =>
      (StatusesFindAllResponseApplicationJsonBuilder()..update(updates))._build();

  _$StatusesFindAllResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'StatusesFindAllResponseApplicationJson', 'ocs');
  }

  @override
  StatusesFindAllResponseApplicationJson rebuild(
          void Function(StatusesFindAllResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusesFindAllResponseApplicationJsonBuilder toBuilder() =>
      StatusesFindAllResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusesFindAllResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatusesFindAllResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class StatusesFindAllResponseApplicationJsonBuilder
    implements
        Builder<StatusesFindAllResponseApplicationJson, StatusesFindAllResponseApplicationJsonBuilder>,
        $StatusesFindAllResponseApplicationJsonInterfaceBuilder {
  _$StatusesFindAllResponseApplicationJson? _$v;

  StatusesFindAllResponseApplicationJson_OcsBuilder? _ocs;
  StatusesFindAllResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= StatusesFindAllResponseApplicationJson_OcsBuilder();
  set ocs(covariant StatusesFindAllResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  StatusesFindAllResponseApplicationJsonBuilder();

  StatusesFindAllResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StatusesFindAllResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StatusesFindAllResponseApplicationJson;
  }

  @override
  void update(void Function(StatusesFindAllResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatusesFindAllResponseApplicationJson build() => _build();

  _$StatusesFindAllResponseApplicationJson _build() {
    _$StatusesFindAllResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$StatusesFindAllResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'StatusesFindAllResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $StatusesFindResponseApplicationJson_OcsInterfaceBuilder {
  void replace($StatusesFindResponseApplicationJson_OcsInterface other);
  void update(void Function($StatusesFindResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PublicBuilder get data;
  set data(PublicBuilder? data);
}

class _$StatusesFindResponseApplicationJson_Ocs extends StatusesFindResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Public data;

  factory _$StatusesFindResponseApplicationJson_Ocs(
          [void Function(StatusesFindResponseApplicationJson_OcsBuilder)? updates]) =>
      (StatusesFindResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$StatusesFindResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'StatusesFindResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'StatusesFindResponseApplicationJson_Ocs', 'data');
  }

  @override
  StatusesFindResponseApplicationJson_Ocs rebuild(
          void Function(StatusesFindResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusesFindResponseApplicationJson_OcsBuilder toBuilder() =>
      StatusesFindResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusesFindResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatusesFindResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class StatusesFindResponseApplicationJson_OcsBuilder
    implements
        Builder<StatusesFindResponseApplicationJson_Ocs, StatusesFindResponseApplicationJson_OcsBuilder>,
        $StatusesFindResponseApplicationJson_OcsInterfaceBuilder {
  _$StatusesFindResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PublicBuilder? _data;
  PublicBuilder get data => _$this._data ??= PublicBuilder();
  set data(covariant PublicBuilder? data) => _$this._data = data;

  StatusesFindResponseApplicationJson_OcsBuilder();

  StatusesFindResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StatusesFindResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StatusesFindResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(StatusesFindResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatusesFindResponseApplicationJson_Ocs build() => _build();

  _$StatusesFindResponseApplicationJson_Ocs _build() {
    _$StatusesFindResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$StatusesFindResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'StatusesFindResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $StatusesFindResponseApplicationJsonInterfaceBuilder {
  void replace($StatusesFindResponseApplicationJsonInterface other);
  void update(void Function($StatusesFindResponseApplicationJsonInterfaceBuilder) updates);
  StatusesFindResponseApplicationJson_OcsBuilder get ocs;
  set ocs(StatusesFindResponseApplicationJson_OcsBuilder? ocs);
}

class _$StatusesFindResponseApplicationJson extends StatusesFindResponseApplicationJson {
  @override
  final StatusesFindResponseApplicationJson_Ocs ocs;

  factory _$StatusesFindResponseApplicationJson([void Function(StatusesFindResponseApplicationJsonBuilder)? updates]) =>
      (StatusesFindResponseApplicationJsonBuilder()..update(updates))._build();

  _$StatusesFindResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'StatusesFindResponseApplicationJson', 'ocs');
  }

  @override
  StatusesFindResponseApplicationJson rebuild(void Function(StatusesFindResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatusesFindResponseApplicationJsonBuilder toBuilder() => StatusesFindResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatusesFindResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatusesFindResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class StatusesFindResponseApplicationJsonBuilder
    implements
        Builder<StatusesFindResponseApplicationJson, StatusesFindResponseApplicationJsonBuilder>,
        $StatusesFindResponseApplicationJsonInterfaceBuilder {
  _$StatusesFindResponseApplicationJson? _$v;

  StatusesFindResponseApplicationJson_OcsBuilder? _ocs;
  StatusesFindResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= StatusesFindResponseApplicationJson_OcsBuilder();
  set ocs(covariant StatusesFindResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  StatusesFindResponseApplicationJsonBuilder();

  StatusesFindResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StatusesFindResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StatusesFindResponseApplicationJson;
  }

  @override
  void update(void Function(StatusesFindResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatusesFindResponseApplicationJson build() => _build();

  _$StatusesFindResponseApplicationJson _build() {
    _$StatusesFindResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$StatusesFindResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'StatusesFindResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusGetStatusResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusGetStatusResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusGetStatusResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PrivateBuilder get data;
  set data(PrivateBuilder? data);
}

class _$UserStatusGetStatusResponseApplicationJson_Ocs extends UserStatusGetStatusResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Private data;

  factory _$UserStatusGetStatusResponseApplicationJson_Ocs(
          [void Function(UserStatusGetStatusResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusGetStatusResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusGetStatusResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusGetStatusResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusGetStatusResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusGetStatusResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusGetStatusResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusGetStatusResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusGetStatusResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusGetStatusResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusGetStatusResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusGetStatusResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusGetStatusResponseApplicationJson_Ocs, UserStatusGetStatusResponseApplicationJson_OcsBuilder>,
        $UserStatusGetStatusResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusGetStatusResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PrivateBuilder? _data;
  PrivateBuilder get data => _$this._data ??= PrivateBuilder();
  set data(covariant PrivateBuilder? data) => _$this._data = data;

  UserStatusGetStatusResponseApplicationJson_OcsBuilder();

  UserStatusGetStatusResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusGetStatusResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusGetStatusResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusGetStatusResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusGetStatusResponseApplicationJson_Ocs build() => _build();

  _$UserStatusGetStatusResponseApplicationJson_Ocs _build() {
    _$UserStatusGetStatusResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$UserStatusGetStatusResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusGetStatusResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusGetStatusResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusGetStatusResponseApplicationJsonInterface other);
  void update(void Function($UserStatusGetStatusResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusGetStatusResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusGetStatusResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusGetStatusResponseApplicationJson extends UserStatusGetStatusResponseApplicationJson {
  @override
  final UserStatusGetStatusResponseApplicationJson_Ocs ocs;

  factory _$UserStatusGetStatusResponseApplicationJson(
          [void Function(UserStatusGetStatusResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusGetStatusResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusGetStatusResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusGetStatusResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusGetStatusResponseApplicationJson rebuild(
          void Function(UserStatusGetStatusResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusGetStatusResponseApplicationJsonBuilder toBuilder() =>
      UserStatusGetStatusResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusGetStatusResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusGetStatusResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class UserStatusGetStatusResponseApplicationJsonBuilder
    implements
        Builder<UserStatusGetStatusResponseApplicationJson, UserStatusGetStatusResponseApplicationJsonBuilder>,
        $UserStatusGetStatusResponseApplicationJsonInterfaceBuilder {
  _$UserStatusGetStatusResponseApplicationJson? _$v;

  UserStatusGetStatusResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusGetStatusResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusGetStatusResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusGetStatusResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusGetStatusResponseApplicationJsonBuilder();

  UserStatusGetStatusResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusGetStatusResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusGetStatusResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusGetStatusResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusGetStatusResponseApplicationJson build() => _build();

  _$UserStatusGetStatusResponseApplicationJson _build() {
    _$UserStatusGetStatusResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusGetStatusResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UserStatusGetStatusResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetStatusResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusSetStatusResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusSetStatusResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PrivateBuilder get data;
  set data(PrivateBuilder? data);
}

class _$UserStatusSetStatusResponseApplicationJson_Ocs extends UserStatusSetStatusResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Private data;

  factory _$UserStatusSetStatusResponseApplicationJson_Ocs(
          [void Function(UserStatusSetStatusResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusSetStatusResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusSetStatusResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusSetStatusResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusSetStatusResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusSetStatusResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusSetStatusResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetStatusResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusSetStatusResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetStatusResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetStatusResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusSetStatusResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusSetStatusResponseApplicationJson_Ocs, UserStatusSetStatusResponseApplicationJson_OcsBuilder>,
        $UserStatusSetStatusResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusSetStatusResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PrivateBuilder? _data;
  PrivateBuilder get data => _$this._data ??= PrivateBuilder();
  set data(covariant PrivateBuilder? data) => _$this._data = data;

  UserStatusSetStatusResponseApplicationJson_OcsBuilder();

  UserStatusSetStatusResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetStatusResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetStatusResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusSetStatusResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetStatusResponseApplicationJson_Ocs build() => _build();

  _$UserStatusSetStatusResponseApplicationJson_Ocs _build() {
    _$UserStatusSetStatusResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$UserStatusSetStatusResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusSetStatusResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetStatusResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusSetStatusResponseApplicationJsonInterface other);
  void update(void Function($UserStatusSetStatusResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusSetStatusResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusSetStatusResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusSetStatusResponseApplicationJson extends UserStatusSetStatusResponseApplicationJson {
  @override
  final UserStatusSetStatusResponseApplicationJson_Ocs ocs;

  factory _$UserStatusSetStatusResponseApplicationJson(
          [void Function(UserStatusSetStatusResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusSetStatusResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusSetStatusResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusSetStatusResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusSetStatusResponseApplicationJson rebuild(
          void Function(UserStatusSetStatusResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetStatusResponseApplicationJsonBuilder toBuilder() =>
      UserStatusSetStatusResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetStatusResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetStatusResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class UserStatusSetStatusResponseApplicationJsonBuilder
    implements
        Builder<UserStatusSetStatusResponseApplicationJson, UserStatusSetStatusResponseApplicationJsonBuilder>,
        $UserStatusSetStatusResponseApplicationJsonInterfaceBuilder {
  _$UserStatusSetStatusResponseApplicationJson? _$v;

  UserStatusSetStatusResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusSetStatusResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusSetStatusResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusSetStatusResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusSetStatusResponseApplicationJsonBuilder();

  UserStatusSetStatusResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetStatusResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetStatusResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusSetStatusResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetStatusResponseApplicationJson build() => _build();

  _$UserStatusSetStatusResponseApplicationJson _build() {
    _$UserStatusSetStatusResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusSetStatusResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UserStatusSetStatusResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetPredefinedMessageResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusSetPredefinedMessageResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusSetPredefinedMessageResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PrivateBuilder get data;
  set data(PrivateBuilder? data);
}

class _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs
    extends UserStatusSetPredefinedMessageResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Private data;

  factory _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs(
          [void Function(UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusSetPredefinedMessageResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusSetPredefinedMessageResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetPredefinedMessageResponseApplicationJson_Ocs &&
        meta == other.meta &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetPredefinedMessageResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusSetPredefinedMessageResponseApplicationJson_Ocs,
            UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder>,
        $UserStatusSetPredefinedMessageResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PrivateBuilder? _data;
  PrivateBuilder get data => _$this._data ??= PrivateBuilder();
  set data(covariant PrivateBuilder? data) => _$this._data = data;

  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder();

  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetPredefinedMessageResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson_Ocs build() => _build();

  _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs _build() {
    _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$UserStatusSetPredefinedMessageResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusSetPredefinedMessageResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetPredefinedMessageResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusSetPredefinedMessageResponseApplicationJsonInterface other);
  void update(void Function($UserStatusSetPredefinedMessageResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusSetPredefinedMessageResponseApplicationJson
    extends UserStatusSetPredefinedMessageResponseApplicationJson {
  @override
  final UserStatusSetPredefinedMessageResponseApplicationJson_Ocs ocs;

  factory _$UserStatusSetPredefinedMessageResponseApplicationJson(
          [void Function(UserStatusSetPredefinedMessageResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusSetPredefinedMessageResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusSetPredefinedMessageResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusSetPredefinedMessageResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson rebuild(
          void Function(UserStatusSetPredefinedMessageResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetPredefinedMessageResponseApplicationJsonBuilder toBuilder() =>
      UserStatusSetPredefinedMessageResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetPredefinedMessageResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetPredefinedMessageResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class UserStatusSetPredefinedMessageResponseApplicationJsonBuilder
    implements
        Builder<UserStatusSetPredefinedMessageResponseApplicationJson,
            UserStatusSetPredefinedMessageResponseApplicationJsonBuilder>,
        $UserStatusSetPredefinedMessageResponseApplicationJsonInterfaceBuilder {
  _$UserStatusSetPredefinedMessageResponseApplicationJson? _$v;

  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusSetPredefinedMessageResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusSetPredefinedMessageResponseApplicationJsonBuilder();

  UserStatusSetPredefinedMessageResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetPredefinedMessageResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetPredefinedMessageResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusSetPredefinedMessageResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetPredefinedMessageResponseApplicationJson build() => _build();

  _$UserStatusSetPredefinedMessageResponseApplicationJson _build() {
    _$UserStatusSetPredefinedMessageResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusSetPredefinedMessageResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusSetPredefinedMessageResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetCustomMessageResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusSetCustomMessageResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusSetCustomMessageResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  PrivateBuilder get data;
  set data(PrivateBuilder? data);
}

class _$UserStatusSetCustomMessageResponseApplicationJson_Ocs
    extends UserStatusSetCustomMessageResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final Private data;

  factory _$UserStatusSetCustomMessageResponseApplicationJson_Ocs(
          [void Function(UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusSetCustomMessageResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusSetCustomMessageResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusSetCustomMessageResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetCustomMessageResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetCustomMessageResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusSetCustomMessageResponseApplicationJson_Ocs,
            UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder>,
        $UserStatusSetCustomMessageResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusSetCustomMessageResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  PrivateBuilder? _data;
  PrivateBuilder get data => _$this._data ??= PrivateBuilder();
  set data(covariant PrivateBuilder? data) => _$this._data = data;

  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder();

  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetCustomMessageResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetCustomMessageResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson_Ocs build() => _build();

  _$UserStatusSetCustomMessageResponseApplicationJson_Ocs _build() {
    _$UserStatusSetCustomMessageResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$UserStatusSetCustomMessageResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusSetCustomMessageResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusSetCustomMessageResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusSetCustomMessageResponseApplicationJsonInterface other);
  void update(void Function($UserStatusSetCustomMessageResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusSetCustomMessageResponseApplicationJson extends UserStatusSetCustomMessageResponseApplicationJson {
  @override
  final UserStatusSetCustomMessageResponseApplicationJson_Ocs ocs;

  factory _$UserStatusSetCustomMessageResponseApplicationJson(
          [void Function(UserStatusSetCustomMessageResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusSetCustomMessageResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusSetCustomMessageResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusSetCustomMessageResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson rebuild(
          void Function(UserStatusSetCustomMessageResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusSetCustomMessageResponseApplicationJsonBuilder toBuilder() =>
      UserStatusSetCustomMessageResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusSetCustomMessageResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusSetCustomMessageResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class UserStatusSetCustomMessageResponseApplicationJsonBuilder
    implements
        Builder<UserStatusSetCustomMessageResponseApplicationJson,
            UserStatusSetCustomMessageResponseApplicationJsonBuilder>,
        $UserStatusSetCustomMessageResponseApplicationJsonInterfaceBuilder {
  _$UserStatusSetCustomMessageResponseApplicationJson? _$v;

  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusSetCustomMessageResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusSetCustomMessageResponseApplicationJsonBuilder();

  UserStatusSetCustomMessageResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusSetCustomMessageResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusSetCustomMessageResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusSetCustomMessageResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusSetCustomMessageResponseApplicationJson build() => _build();

  _$UserStatusSetCustomMessageResponseApplicationJson _build() {
    _$UserStatusSetCustomMessageResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusSetCustomMessageResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusSetCustomMessageResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusClearMessageResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusClearMessageResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusClearMessageResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  JsonObject? get data;
  set data(JsonObject? data);
}

class _$UserStatusClearMessageResponseApplicationJson_Ocs extends UserStatusClearMessageResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final JsonObject data;

  factory _$UserStatusClearMessageResponseApplicationJson_Ocs(
          [void Function(UserStatusClearMessageResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusClearMessageResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusClearMessageResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusClearMessageResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusClearMessageResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusClearMessageResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusClearMessageResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusClearMessageResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusClearMessageResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusClearMessageResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusClearMessageResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusClearMessageResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusClearMessageResponseApplicationJson_Ocs,
            UserStatusClearMessageResponseApplicationJson_OcsBuilder>,
        $UserStatusClearMessageResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusClearMessageResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(covariant JsonObject? data) => _$this._data = data;

  UserStatusClearMessageResponseApplicationJson_OcsBuilder();

  UserStatusClearMessageResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusClearMessageResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusClearMessageResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusClearMessageResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusClearMessageResponseApplicationJson_Ocs build() => _build();

  _$UserStatusClearMessageResponseApplicationJson_Ocs _build() {
    _$UserStatusClearMessageResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ??
          _$UserStatusClearMessageResponseApplicationJson_Ocs._(
              meta: meta.build(),
              data: BuiltValueNullFieldError.checkNotNull(
                  data, r'UserStatusClearMessageResponseApplicationJson_Ocs', 'data'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusClearMessageResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusClearMessageResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusClearMessageResponseApplicationJsonInterface other);
  void update(void Function($UserStatusClearMessageResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusClearMessageResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusClearMessageResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusClearMessageResponseApplicationJson extends UserStatusClearMessageResponseApplicationJson {
  @override
  final UserStatusClearMessageResponseApplicationJson_Ocs ocs;

  factory _$UserStatusClearMessageResponseApplicationJson(
          [void Function(UserStatusClearMessageResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusClearMessageResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusClearMessageResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusClearMessageResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusClearMessageResponseApplicationJson rebuild(
          void Function(UserStatusClearMessageResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusClearMessageResponseApplicationJsonBuilder toBuilder() =>
      UserStatusClearMessageResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusClearMessageResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusClearMessageResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class UserStatusClearMessageResponseApplicationJsonBuilder
    implements
        Builder<UserStatusClearMessageResponseApplicationJson, UserStatusClearMessageResponseApplicationJsonBuilder>,
        $UserStatusClearMessageResponseApplicationJsonInterfaceBuilder {
  _$UserStatusClearMessageResponseApplicationJson? _$v;

  UserStatusClearMessageResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusClearMessageResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusClearMessageResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusClearMessageResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusClearMessageResponseApplicationJsonBuilder();

  UserStatusClearMessageResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusClearMessageResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusClearMessageResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusClearMessageResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusClearMessageResponseApplicationJson build() => _build();

  _$UserStatusClearMessageResponseApplicationJson _build() {
    _$UserStatusClearMessageResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusClearMessageResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UserStatusClearMessageResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusRevertStatusResponseApplicationJson_OcsInterfaceBuilder {
  void replace($UserStatusRevertStatusResponseApplicationJson_OcsInterface other);
  void update(void Function($UserStatusRevertStatusResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  UserStatusRevertStatusResponseApplicationJson_Ocs_Data? get data;
  set data(UserStatusRevertStatusResponseApplicationJson_Ocs_Data? data);
}

class _$UserStatusRevertStatusResponseApplicationJson_Ocs extends UserStatusRevertStatusResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final UserStatusRevertStatusResponseApplicationJson_Ocs_Data data;

  factory _$UserStatusRevertStatusResponseApplicationJson_Ocs(
          [void Function(UserStatusRevertStatusResponseApplicationJson_OcsBuilder)? updates]) =>
      (UserStatusRevertStatusResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$UserStatusRevertStatusResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'UserStatusRevertStatusResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'UserStatusRevertStatusResponseApplicationJson_Ocs', 'data');
  }

  @override
  UserStatusRevertStatusResponseApplicationJson_Ocs rebuild(
          void Function(UserStatusRevertStatusResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusRevertStatusResponseApplicationJson_OcsBuilder toBuilder() =>
      UserStatusRevertStatusResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is UserStatusRevertStatusResponseApplicationJson_Ocs &&
        meta == other.meta &&
        data == _$dynamicOther.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusRevertStatusResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class UserStatusRevertStatusResponseApplicationJson_OcsBuilder
    implements
        Builder<UserStatusRevertStatusResponseApplicationJson_Ocs,
            UserStatusRevertStatusResponseApplicationJson_OcsBuilder>,
        $UserStatusRevertStatusResponseApplicationJson_OcsInterfaceBuilder {
  _$UserStatusRevertStatusResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  UserStatusRevertStatusResponseApplicationJson_Ocs_Data? _data;
  UserStatusRevertStatusResponseApplicationJson_Ocs_Data? get data => _$this._data;
  set data(covariant UserStatusRevertStatusResponseApplicationJson_Ocs_Data? data) => _$this._data = data;

  UserStatusRevertStatusResponseApplicationJson_OcsBuilder();

  UserStatusRevertStatusResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusRevertStatusResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusRevertStatusResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(UserStatusRevertStatusResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusRevertStatusResponseApplicationJson_Ocs build() => _build();

  _$UserStatusRevertStatusResponseApplicationJson_Ocs _build() {
    UserStatusRevertStatusResponseApplicationJson_Ocs._validate(this);
    _$UserStatusRevertStatusResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ??
          _$UserStatusRevertStatusResponseApplicationJson_Ocs._(
              meta: meta.build(),
              data: BuiltValueNullFieldError.checkNotNull(
                  data, r'UserStatusRevertStatusResponseApplicationJson_Ocs', 'data'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserStatusRevertStatusResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UserStatusRevertStatusResponseApplicationJsonInterfaceBuilder {
  void replace($UserStatusRevertStatusResponseApplicationJsonInterface other);
  void update(void Function($UserStatusRevertStatusResponseApplicationJsonInterfaceBuilder) updates);
  UserStatusRevertStatusResponseApplicationJson_OcsBuilder get ocs;
  set ocs(UserStatusRevertStatusResponseApplicationJson_OcsBuilder? ocs);
}

class _$UserStatusRevertStatusResponseApplicationJson extends UserStatusRevertStatusResponseApplicationJson {
  @override
  final UserStatusRevertStatusResponseApplicationJson_Ocs ocs;

  factory _$UserStatusRevertStatusResponseApplicationJson(
          [void Function(UserStatusRevertStatusResponseApplicationJsonBuilder)? updates]) =>
      (UserStatusRevertStatusResponseApplicationJsonBuilder()..update(updates))._build();

  _$UserStatusRevertStatusResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'UserStatusRevertStatusResponseApplicationJson', 'ocs');
  }

  @override
  UserStatusRevertStatusResponseApplicationJson rebuild(
          void Function(UserStatusRevertStatusResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStatusRevertStatusResponseApplicationJsonBuilder toBuilder() =>
      UserStatusRevertStatusResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserStatusRevertStatusResponseApplicationJson && ocs == other.ocs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ocs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserStatusRevertStatusResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class UserStatusRevertStatusResponseApplicationJsonBuilder
    implements
        Builder<UserStatusRevertStatusResponseApplicationJson, UserStatusRevertStatusResponseApplicationJsonBuilder>,
        $UserStatusRevertStatusResponseApplicationJsonInterfaceBuilder {
  _$UserStatusRevertStatusResponseApplicationJson? _$v;

  UserStatusRevertStatusResponseApplicationJson_OcsBuilder? _ocs;
  UserStatusRevertStatusResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= UserStatusRevertStatusResponseApplicationJson_OcsBuilder();
  set ocs(covariant UserStatusRevertStatusResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  UserStatusRevertStatusResponseApplicationJsonBuilder();

  UserStatusRevertStatusResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UserStatusRevertStatusResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserStatusRevertStatusResponseApplicationJson;
  }

  @override
  void update(void Function(UserStatusRevertStatusResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserStatusRevertStatusResponseApplicationJson build() => _build();

  _$UserStatusRevertStatusResponseApplicationJson _build() {
    _$UserStatusRevertStatusResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UserStatusRevertStatusResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UserStatusRevertStatusResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_UserStatusInterfaceBuilder {
  void replace($Capabilities_UserStatusInterface other);
  void update(void Function($Capabilities_UserStatusInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get restore;
  set restore(bool? restore);

  bool? get supportsEmoji;
  set supportsEmoji(bool? supportsEmoji);
}

class _$Capabilities_UserStatus extends Capabilities_UserStatus {
  @override
  final bool enabled;
  @override
  final bool? restore;
  @override
  final bool supportsEmoji;

  factory _$Capabilities_UserStatus([void Function(Capabilities_UserStatusBuilder)? updates]) =>
      (Capabilities_UserStatusBuilder()..update(updates))._build();

  _$Capabilities_UserStatus._({required this.enabled, this.restore, required this.supportsEmoji}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_UserStatus', 'enabled');
    BuiltValueNullFieldError.checkNotNull(supportsEmoji, r'Capabilities_UserStatus', 'supportsEmoji');
  }

  @override
  Capabilities_UserStatus rebuild(void Function(Capabilities_UserStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities_UserStatusBuilder toBuilder() => Capabilities_UserStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_UserStatus &&
        enabled == other.enabled &&
        restore == other.restore &&
        supportsEmoji == other.supportsEmoji;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, restore.hashCode);
    _$hash = $jc(_$hash, supportsEmoji.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_UserStatus')
          ..add('enabled', enabled)
          ..add('restore', restore)
          ..add('supportsEmoji', supportsEmoji))
        .toString();
  }
}

class Capabilities_UserStatusBuilder
    implements
        Builder<Capabilities_UserStatus, Capabilities_UserStatusBuilder>,
        $Capabilities_UserStatusInterfaceBuilder {
  _$Capabilities_UserStatus? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _restore;
  bool? get restore => _$this._restore;
  set restore(covariant bool? restore) => _$this._restore = restore;

  bool? _supportsEmoji;
  bool? get supportsEmoji => _$this._supportsEmoji;
  set supportsEmoji(covariant bool? supportsEmoji) => _$this._supportsEmoji = supportsEmoji;

  Capabilities_UserStatusBuilder();

  Capabilities_UserStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _restore = $v.restore;
      _supportsEmoji = $v.supportsEmoji;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_UserStatus other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_UserStatus;
  }

  @override
  void update(void Function(Capabilities_UserStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_UserStatus build() => _build();

  _$Capabilities_UserStatus _build() {
    final _$result = _$v ??
        _$Capabilities_UserStatus._(
            enabled: BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities_UserStatus', 'enabled'),
            restore: restore,
            supportsEmoji:
                BuiltValueNullFieldError.checkNotNull(supportsEmoji, r'Capabilities_UserStatus', 'supportsEmoji'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CapabilitiesInterfaceBuilder {
  void replace($CapabilitiesInterface other);
  void update(void Function($CapabilitiesInterfaceBuilder) updates);
  Capabilities_UserStatusBuilder get userStatus;
  set userStatus(Capabilities_UserStatusBuilder? userStatus);
}

class _$Capabilities extends Capabilities {
  @override
  final Capabilities_UserStatus userStatus;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._({required this.userStatus}) : super._() {
    BuiltValueNullFieldError.checkNotNull(userStatus, r'Capabilities', 'userStatus');
  }

  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities && userStatus == other.userStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')..add('userStatus', userStatus)).toString();
  }
}

class CapabilitiesBuilder implements Builder<Capabilities, CapabilitiesBuilder>, $CapabilitiesInterfaceBuilder {
  _$Capabilities? _$v;

  Capabilities_UserStatusBuilder? _userStatus;
  Capabilities_UserStatusBuilder get userStatus => _$this._userStatus ??= Capabilities_UserStatusBuilder();
  set userStatus(covariant Capabilities_UserStatusBuilder? userStatus) => _$this._userStatus = userStatus;

  CapabilitiesBuilder();

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userStatus = $v.userStatus.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities;
  }

  @override
  void update(void Function(CapabilitiesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities build() => _build();

  _$Capabilities _build() {
    _$Capabilities _$result;
    try {
      _$result = _$v ?? _$Capabilities._(userStatus: userStatus.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'userStatus';
        userStatus.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
