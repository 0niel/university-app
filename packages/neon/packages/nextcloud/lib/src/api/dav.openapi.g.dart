// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dav.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<DirectGetUrlResponseApplicationJson_Ocs_Data> _$directGetUrlResponseApplicationJsonOcsDataSerializer =
    _$DirectGetUrlResponseApplicationJson_Ocs_DataSerializer();
Serializer<DirectGetUrlResponseApplicationJson_Ocs> _$directGetUrlResponseApplicationJsonOcsSerializer =
    _$DirectGetUrlResponseApplicationJson_OcsSerializer();
Serializer<DirectGetUrlResponseApplicationJson> _$directGetUrlResponseApplicationJsonSerializer =
    _$DirectGetUrlResponseApplicationJsonSerializer();
Serializer<OutOfOfficeDataCommon> _$outOfOfficeDataCommonSerializer = _$OutOfOfficeDataCommonSerializer();
Serializer<CurrentOutOfOfficeData> _$currentOutOfOfficeDataSerializer = _$CurrentOutOfOfficeDataSerializer();
Serializer<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs>
    _$outOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonOcsSerializer =
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsSerializer();
Serializer<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson>
    _$outOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonSerializer =
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonSerializer();
Serializer<OutOfOfficeData> _$outOfOfficeDataSerializer = _$OutOfOfficeDataSerializer();
Serializer<OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs>
    _$outOfOfficeGetOutOfOfficeResponseApplicationJsonOcsSerializer =
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsSerializer();
Serializer<OutOfOfficeGetOutOfOfficeResponseApplicationJson>
    _$outOfOfficeGetOutOfOfficeResponseApplicationJsonSerializer =
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJsonSerializer();
Serializer<OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs>
    _$outOfOfficeSetOutOfOfficeResponseApplicationJsonOcsSerializer =
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsSerializer();
Serializer<OutOfOfficeSetOutOfOfficeResponseApplicationJson>
    _$outOfOfficeSetOutOfOfficeResponseApplicationJsonSerializer =
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJsonSerializer();
Serializer<OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs>
    _$outOfOfficeClearOutOfOfficeResponseApplicationJsonOcsSerializer =
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsSerializer();
Serializer<OutOfOfficeClearOutOfOfficeResponseApplicationJson>
    _$outOfOfficeClearOutOfOfficeResponseApplicationJsonSerializer =
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJsonSerializer();
Serializer<Capabilities_Dav> _$capabilitiesDavSerializer = _$Capabilities_DavSerializer();
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

class _$DirectGetUrlResponseApplicationJson_Ocs_DataSerializer
    implements StructuredSerializer<DirectGetUrlResponseApplicationJson_Ocs_Data> {
  @override
  final Iterable<Type> types = const [
    DirectGetUrlResponseApplicationJson_Ocs_Data,
    _$DirectGetUrlResponseApplicationJson_Ocs_Data
  ];
  @override
  final String wireName = 'DirectGetUrlResponseApplicationJson_Ocs_Data';

  @override
  Iterable<Object?> serialize(Serializers serializers, DirectGetUrlResponseApplicationJson_Ocs_Data object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs_Data deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DirectGetUrlResponseApplicationJson_Ocs_DataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DirectGetUrlResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<DirectGetUrlResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    DirectGetUrlResponseApplicationJson_Ocs,
    _$DirectGetUrlResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'DirectGetUrlResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, DirectGetUrlResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(DirectGetUrlResponseApplicationJson_Ocs_Data)),
    ];

    return result;
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DirectGetUrlResponseApplicationJson_OcsBuilder();

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
                  specifiedType: const FullType(DirectGetUrlResponseApplicationJson_Ocs_Data))!
              as DirectGetUrlResponseApplicationJson_Ocs_Data);
          break;
      }
    }

    return result.build();
  }
}

class _$DirectGetUrlResponseApplicationJsonSerializer
    implements StructuredSerializer<DirectGetUrlResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [DirectGetUrlResponseApplicationJson, _$DirectGetUrlResponseApplicationJson];
  @override
  final String wireName = 'DirectGetUrlResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DirectGetUrlResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(DirectGetUrlResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  DirectGetUrlResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DirectGetUrlResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(
              serializers.deserialize(value, specifiedType: const FullType(DirectGetUrlResponseApplicationJson_Ocs))!
                  as DirectGetUrlResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeDataCommonSerializer implements StructuredSerializer<OutOfOfficeDataCommon> {
  @override
  final Iterable<Type> types = const [OutOfOfficeDataCommon, _$OutOfOfficeDataCommon];
  @override
  final String wireName = 'OutOfOfficeDataCommon';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeDataCommon object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OutOfOfficeDataCommon deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeDataCommonBuilder();

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
          result.message = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CurrentOutOfOfficeDataSerializer implements StructuredSerializer<CurrentOutOfOfficeData> {
  @override
  final Iterable<Type> types = const [CurrentOutOfOfficeData, _$CurrentOutOfOfficeData];
  @override
  final String wireName = 'CurrentOutOfOfficeData';

  @override
  Iterable<Object?> serialize(Serializers serializers, CurrentOutOfOfficeData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'startDate',
      serializers.serialize(object.startDate, specifiedType: const FullType(int)),
      'endDate',
      serializers.serialize(object.endDate, specifiedType: const FullType(int)),
      'shortMessage',
      serializers.serialize(object.shortMessage, specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  CurrentOutOfOfficeData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CurrentOutOfOfficeDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'startDate':
          result.startDate = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'endDate':
          result.endDate = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'shortMessage':
          result.shortMessage = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs,
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(CurrentOutOfOfficeData)),
    ];

    return result;
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder();

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
          result.data.replace(serializers.deserialize(value, specifiedType: const FullType(CurrentOutOfOfficeData))!
              as CurrentOutOfOfficeData);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonSerializer
    implements StructuredSerializer<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson,
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson
  ];
  @override
  final String wireName = 'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs))!
              as OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeDataSerializer implements StructuredSerializer<OutOfOfficeData> {
  @override
  final Iterable<Type> types = const [OutOfOfficeData, _$OutOfOfficeData];
  @override
  final String wireName = 'OutOfOfficeData';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'firstDay',
      serializers.serialize(object.firstDay, specifiedType: const FullType(String)),
      'lastDay',
      serializers.serialize(object.lastDay, specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(String)),
      'userId',
      serializers.serialize(object.userId, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.message, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OutOfOfficeData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'firstDay':
          result.firstDay = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'lastDay':
          result.lastDay = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs,
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(OutOfOfficeData)),
    ];

    return result;
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder();

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
          result.data.replace(
              serializers.deserialize(value, specifiedType: const FullType(OutOfOfficeData))! as OutOfOfficeData);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeGetOutOfOfficeResponseApplicationJsonSerializer
    implements StructuredSerializer<OutOfOfficeGetOutOfOfficeResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeGetOutOfOfficeResponseApplicationJson,
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJson
  ];
  @override
  final String wireName = 'OutOfOfficeGetOutOfOfficeResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeGetOutOfOfficeResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs))!
              as OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs,
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(OutOfOfficeData)),
    ];

    return result;
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder();

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
          result.data.replace(
              serializers.deserialize(value, specifiedType: const FullType(OutOfOfficeData))! as OutOfOfficeData);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeSetOutOfOfficeResponseApplicationJsonSerializer
    implements StructuredSerializer<OutOfOfficeSetOutOfOfficeResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeSetOutOfOfficeResponseApplicationJson,
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJson
  ];
  @override
  final String wireName = 'OutOfOfficeSetOutOfOfficeResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeSetOutOfOfficeResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs))!
              as OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs,
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
    ];
    Object? value;
    value = object.data;
    if (value != null) {
      result
        ..add('data')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonObject)));
    }
    return result;
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder();

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
          result.data = serializers.deserialize(value, specifiedType: const FullType(JsonObject)) as JsonObject?;
          break;
      }
    }

    return result.build();
  }
}

class _$OutOfOfficeClearOutOfOfficeResponseApplicationJsonSerializer
    implements StructuredSerializer<OutOfOfficeClearOutOfOfficeResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    OutOfOfficeClearOutOfOfficeResponseApplicationJson,
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJson
  ];
  @override
  final String wireName = 'OutOfOfficeClearOutOfOfficeResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, OutOfOfficeClearOutOfOfficeResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs,
          specifiedType: const FullType(OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs))!
              as OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities_DavSerializer implements StructuredSerializer<Capabilities_Dav> {
  @override
  final Iterable<Type> types = const [Capabilities_Dav, _$Capabilities_Dav];
  @override
  final String wireName = 'Capabilities_Dav';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities_Dav object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'chunking',
      serializers.serialize(object.chunking, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.bulkupload;
    if (value != null) {
      result
        ..add('bulkupload')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Capabilities_Dav deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities_DavBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'chunking':
          result.chunking = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'bulkupload':
          result.bulkupload = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
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
      'dav',
      serializers.serialize(object.dav, specifiedType: const FullType(Capabilities_Dav)),
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
        case 'dav':
          result.dav.replace(
              serializers.deserialize(value, specifiedType: const FullType(Capabilities_Dav))! as Capabilities_Dav);
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

abstract mixin class $DirectGetUrlResponseApplicationJson_Ocs_DataInterfaceBuilder {
  void replace($DirectGetUrlResponseApplicationJson_Ocs_DataInterface other);
  void update(void Function($DirectGetUrlResponseApplicationJson_Ocs_DataInterfaceBuilder) updates);
  String? get url;
  set url(String? url);
}

class _$DirectGetUrlResponseApplicationJson_Ocs_Data extends DirectGetUrlResponseApplicationJson_Ocs_Data {
  @override
  final String url;

  factory _$DirectGetUrlResponseApplicationJson_Ocs_Data(
          [void Function(DirectGetUrlResponseApplicationJson_Ocs_DataBuilder)? updates]) =>
      (DirectGetUrlResponseApplicationJson_Ocs_DataBuilder()..update(updates))._build();

  _$DirectGetUrlResponseApplicationJson_Ocs_Data._({required this.url}) : super._() {
    BuiltValueNullFieldError.checkNotNull(url, r'DirectGetUrlResponseApplicationJson_Ocs_Data', 'url');
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs_Data rebuild(
          void Function(DirectGetUrlResponseApplicationJson_Ocs_DataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder toBuilder() =>
      DirectGetUrlResponseApplicationJson_Ocs_DataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectGetUrlResponseApplicationJson_Ocs_Data && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectGetUrlResponseApplicationJson_Ocs_Data')..add('url', url)).toString();
  }
}

class DirectGetUrlResponseApplicationJson_Ocs_DataBuilder
    implements
        Builder<DirectGetUrlResponseApplicationJson_Ocs_Data, DirectGetUrlResponseApplicationJson_Ocs_DataBuilder>,
        $DirectGetUrlResponseApplicationJson_Ocs_DataInterfaceBuilder {
  _$DirectGetUrlResponseApplicationJson_Ocs_Data? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(covariant String? url) => _$this._url = url;

  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder();

  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DirectGetUrlResponseApplicationJson_Ocs_Data other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DirectGetUrlResponseApplicationJson_Ocs_Data;
  }

  @override
  void update(void Function(DirectGetUrlResponseApplicationJson_Ocs_DataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs_Data build() => _build();

  _$DirectGetUrlResponseApplicationJson_Ocs_Data _build() {
    final _$result = _$v ??
        _$DirectGetUrlResponseApplicationJson_Ocs_Data._(
            url: BuiltValueNullFieldError.checkNotNull(url, r'DirectGetUrlResponseApplicationJson_Ocs_Data', 'url'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DirectGetUrlResponseApplicationJson_OcsInterfaceBuilder {
  void replace($DirectGetUrlResponseApplicationJson_OcsInterface other);
  void update(void Function($DirectGetUrlResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder get data;
  set data(DirectGetUrlResponseApplicationJson_Ocs_DataBuilder? data);
}

class _$DirectGetUrlResponseApplicationJson_Ocs extends DirectGetUrlResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final DirectGetUrlResponseApplicationJson_Ocs_Data data;

  factory _$DirectGetUrlResponseApplicationJson_Ocs(
          [void Function(DirectGetUrlResponseApplicationJson_OcsBuilder)? updates]) =>
      (DirectGetUrlResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$DirectGetUrlResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'DirectGetUrlResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'DirectGetUrlResponseApplicationJson_Ocs', 'data');
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs rebuild(
          void Function(DirectGetUrlResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectGetUrlResponseApplicationJson_OcsBuilder toBuilder() =>
      DirectGetUrlResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectGetUrlResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'DirectGetUrlResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class DirectGetUrlResponseApplicationJson_OcsBuilder
    implements
        Builder<DirectGetUrlResponseApplicationJson_Ocs, DirectGetUrlResponseApplicationJson_OcsBuilder>,
        $DirectGetUrlResponseApplicationJson_OcsInterfaceBuilder {
  _$DirectGetUrlResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder? _data;
  DirectGetUrlResponseApplicationJson_Ocs_DataBuilder get data =>
      _$this._data ??= DirectGetUrlResponseApplicationJson_Ocs_DataBuilder();
  set data(covariant DirectGetUrlResponseApplicationJson_Ocs_DataBuilder? data) => _$this._data = data;

  DirectGetUrlResponseApplicationJson_OcsBuilder();

  DirectGetUrlResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DirectGetUrlResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DirectGetUrlResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(DirectGetUrlResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectGetUrlResponseApplicationJson_Ocs build() => _build();

  _$DirectGetUrlResponseApplicationJson_Ocs _build() {
    _$DirectGetUrlResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$DirectGetUrlResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'DirectGetUrlResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DirectGetUrlResponseApplicationJsonInterfaceBuilder {
  void replace($DirectGetUrlResponseApplicationJsonInterface other);
  void update(void Function($DirectGetUrlResponseApplicationJsonInterfaceBuilder) updates);
  DirectGetUrlResponseApplicationJson_OcsBuilder get ocs;
  set ocs(DirectGetUrlResponseApplicationJson_OcsBuilder? ocs);
}

class _$DirectGetUrlResponseApplicationJson extends DirectGetUrlResponseApplicationJson {
  @override
  final DirectGetUrlResponseApplicationJson_Ocs ocs;

  factory _$DirectGetUrlResponseApplicationJson([void Function(DirectGetUrlResponseApplicationJsonBuilder)? updates]) =>
      (DirectGetUrlResponseApplicationJsonBuilder()..update(updates))._build();

  _$DirectGetUrlResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'DirectGetUrlResponseApplicationJson', 'ocs');
  }

  @override
  DirectGetUrlResponseApplicationJson rebuild(void Function(DirectGetUrlResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectGetUrlResponseApplicationJsonBuilder toBuilder() => DirectGetUrlResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectGetUrlResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'DirectGetUrlResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class DirectGetUrlResponseApplicationJsonBuilder
    implements
        Builder<DirectGetUrlResponseApplicationJson, DirectGetUrlResponseApplicationJsonBuilder>,
        $DirectGetUrlResponseApplicationJsonInterfaceBuilder {
  _$DirectGetUrlResponseApplicationJson? _$v;

  DirectGetUrlResponseApplicationJson_OcsBuilder? _ocs;
  DirectGetUrlResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= DirectGetUrlResponseApplicationJson_OcsBuilder();
  set ocs(covariant DirectGetUrlResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  DirectGetUrlResponseApplicationJsonBuilder();

  DirectGetUrlResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DirectGetUrlResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DirectGetUrlResponseApplicationJson;
  }

  @override
  void update(void Function(DirectGetUrlResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectGetUrlResponseApplicationJson build() => _build();

  _$DirectGetUrlResponseApplicationJson _build() {
    _$DirectGetUrlResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$DirectGetUrlResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'DirectGetUrlResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeDataCommonInterfaceBuilder {
  void replace($OutOfOfficeDataCommonInterface other);
  void update(void Function($OutOfOfficeDataCommonInterfaceBuilder) updates);
  String? get userId;
  set userId(String? userId);

  String? get message;
  set message(String? message);
}

class _$OutOfOfficeDataCommon extends OutOfOfficeDataCommon {
  @override
  final String userId;
  @override
  final String message;

  factory _$OutOfOfficeDataCommon([void Function(OutOfOfficeDataCommonBuilder)? updates]) =>
      (OutOfOfficeDataCommonBuilder()..update(updates))._build();

  _$OutOfOfficeDataCommon._({required this.userId, required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, r'OutOfOfficeDataCommon', 'userId');
    BuiltValueNullFieldError.checkNotNull(message, r'OutOfOfficeDataCommon', 'message');
  }

  @override
  OutOfOfficeDataCommon rebuild(void Function(OutOfOfficeDataCommonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeDataCommonBuilder toBuilder() => OutOfOfficeDataCommonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeDataCommon && userId == other.userId && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OutOfOfficeDataCommon')
          ..add('userId', userId)
          ..add('message', message))
        .toString();
  }
}

class OutOfOfficeDataCommonBuilder
    implements Builder<OutOfOfficeDataCommon, OutOfOfficeDataCommonBuilder>, $OutOfOfficeDataCommonInterfaceBuilder {
  _$OutOfOfficeDataCommon? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  OutOfOfficeDataCommonBuilder();

  OutOfOfficeDataCommonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeDataCommon other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeDataCommon;
  }

  @override
  void update(void Function(OutOfOfficeDataCommonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeDataCommon build() => _build();

  _$OutOfOfficeDataCommon _build() {
    final _$result = _$v ??
        _$OutOfOfficeDataCommon._(
            userId: BuiltValueNullFieldError.checkNotNull(userId, r'OutOfOfficeDataCommon', 'userId'),
            message: BuiltValueNullFieldError.checkNotNull(message, r'OutOfOfficeDataCommon', 'message'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CurrentOutOfOfficeDataInterfaceBuilder implements $OutOfOfficeDataCommonInterfaceBuilder {
  void replace(covariant $CurrentOutOfOfficeDataInterface other);
  void update(void Function($CurrentOutOfOfficeDataInterfaceBuilder) updates);
  String? get id;
  set id(covariant String? id);

  int? get startDate;
  set startDate(covariant int? startDate);

  int? get endDate;
  set endDate(covariant int? endDate);

  String? get shortMessage;
  set shortMessage(covariant String? shortMessage);

  String? get userId;
  set userId(covariant String? userId);

  String? get message;
  set message(covariant String? message);
}

class _$CurrentOutOfOfficeData extends CurrentOutOfOfficeData {
  @override
  final String id;
  @override
  final int startDate;
  @override
  final int endDate;
  @override
  final String shortMessage;
  @override
  final String userId;
  @override
  final String message;

  factory _$CurrentOutOfOfficeData([void Function(CurrentOutOfOfficeDataBuilder)? updates]) =>
      (CurrentOutOfOfficeDataBuilder()..update(updates))._build();

  _$CurrentOutOfOfficeData._(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.shortMessage,
      required this.userId,
      required this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'CurrentOutOfOfficeData', 'id');
    BuiltValueNullFieldError.checkNotNull(startDate, r'CurrentOutOfOfficeData', 'startDate');
    BuiltValueNullFieldError.checkNotNull(endDate, r'CurrentOutOfOfficeData', 'endDate');
    BuiltValueNullFieldError.checkNotNull(shortMessage, r'CurrentOutOfOfficeData', 'shortMessage');
    BuiltValueNullFieldError.checkNotNull(userId, r'CurrentOutOfOfficeData', 'userId');
    BuiltValueNullFieldError.checkNotNull(message, r'CurrentOutOfOfficeData', 'message');
  }

  @override
  CurrentOutOfOfficeData rebuild(void Function(CurrentOutOfOfficeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurrentOutOfOfficeDataBuilder toBuilder() => CurrentOutOfOfficeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurrentOutOfOfficeData &&
        id == other.id &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        shortMessage == other.shortMessage &&
        userId == other.userId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, shortMessage.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CurrentOutOfOfficeData')
          ..add('id', id)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('shortMessage', shortMessage)
          ..add('userId', userId)
          ..add('message', message))
        .toString();
  }
}

class CurrentOutOfOfficeDataBuilder
    implements Builder<CurrentOutOfOfficeData, CurrentOutOfOfficeDataBuilder>, $CurrentOutOfOfficeDataInterfaceBuilder {
  _$CurrentOutOfOfficeData? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  int? _startDate;
  int? get startDate => _$this._startDate;
  set startDate(covariant int? startDate) => _$this._startDate = startDate;

  int? _endDate;
  int? get endDate => _$this._endDate;
  set endDate(covariant int? endDate) => _$this._endDate = endDate;

  String? _shortMessage;
  String? get shortMessage => _$this._shortMessage;
  set shortMessage(covariant String? shortMessage) => _$this._shortMessage = shortMessage;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  CurrentOutOfOfficeDataBuilder();

  CurrentOutOfOfficeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _shortMessage = $v.shortMessage;
      _userId = $v.userId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CurrentOutOfOfficeData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CurrentOutOfOfficeData;
  }

  @override
  void update(void Function(CurrentOutOfOfficeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CurrentOutOfOfficeData build() => _build();

  _$CurrentOutOfOfficeData _build() {
    final _$result = _$v ??
        _$CurrentOutOfOfficeData._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'CurrentOutOfOfficeData', 'id'),
            startDate: BuiltValueNullFieldError.checkNotNull(startDate, r'CurrentOutOfOfficeData', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(endDate, r'CurrentOutOfOfficeData', 'endDate'),
            shortMessage:
                BuiltValueNullFieldError.checkNotNull(shortMessage, r'CurrentOutOfOfficeData', 'shortMessage'),
            userId: BuiltValueNullFieldError.checkNotNull(userId, r'CurrentOutOfOfficeData', 'userId'),
            message: BuiltValueNullFieldError.checkNotNull(message, r'CurrentOutOfOfficeData', 'message'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsInterfaceBuilder {
  void replace($OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsInterface other);
  void update(void Function($OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  CurrentOutOfOfficeDataBuilder get data;
  set data(CurrentOutOfOfficeDataBuilder? data);
}

class _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs
    extends OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final CurrentOutOfOfficeData data;

  factory _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs(
          [void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder)? updates]) =>
      (OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs._({required this.meta, required this.data})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        meta, r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(
        data, r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs', 'data');
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs rebuild(
          void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder toBuilder() =>
      OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs &&
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder
    implements
        Builder<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs,
            OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder>,
        $OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsInterfaceBuilder {
  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  CurrentOutOfOfficeDataBuilder? _data;
  CurrentOutOfOfficeDataBuilder get data => _$this._data ??= CurrentOutOfOfficeDataBuilder();
  set data(covariant CurrentOutOfOfficeDataBuilder? data) => _$this._data = data;

  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder();

  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs build() => _build();

  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs _build() {
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ??
          _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonInterfaceBuilder {
  void replace($OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonInterface other);
  void update(void Function($OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonInterfaceBuilder) updates);
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder get ocs;
  set ocs(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder? ocs);
}

class _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson
    extends OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson {
  @override
  final OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_Ocs ocs;

  factory _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson(
          [void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder)? updates]) =>
      (OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder()..update(updates))._build();

  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson', 'ocs');
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson rebuild(
          void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder toBuilder() =>
      OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson')
          ..add('ocs', ocs))
        .toString();
  }
}

class OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder
    implements
        Builder<OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson,
            OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder>,
        $OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonInterfaceBuilder {
  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson? _$v;

  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder? _ocs;
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder();
  set ocs(covariant OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder();

  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson;
  }

  @override
  void update(void Function(OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson build() => _build();

  _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson _build() {
    _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeGetCurrentOutOfOfficeDataResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeDataInterfaceBuilder implements $OutOfOfficeDataCommonInterfaceBuilder {
  void replace(covariant $OutOfOfficeDataInterface other);
  void update(void Function($OutOfOfficeDataInterfaceBuilder) updates);
  int? get id;
  set id(covariant int? id);

  String? get firstDay;
  set firstDay(covariant String? firstDay);

  String? get lastDay;
  set lastDay(covariant String? lastDay);

  String? get status;
  set status(covariant String? status);

  String? get userId;
  set userId(covariant String? userId);

  String? get message;
  set message(covariant String? message);
}

class _$OutOfOfficeData extends OutOfOfficeData {
  @override
  final int id;
  @override
  final String firstDay;
  @override
  final String lastDay;
  @override
  final String status;
  @override
  final String userId;
  @override
  final String message;

  factory _$OutOfOfficeData([void Function(OutOfOfficeDataBuilder)? updates]) =>
      (OutOfOfficeDataBuilder()..update(updates))._build();

  _$OutOfOfficeData._(
      {required this.id,
      required this.firstDay,
      required this.lastDay,
      required this.status,
      required this.userId,
      required this.message})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'OutOfOfficeData', 'id');
    BuiltValueNullFieldError.checkNotNull(firstDay, r'OutOfOfficeData', 'firstDay');
    BuiltValueNullFieldError.checkNotNull(lastDay, r'OutOfOfficeData', 'lastDay');
    BuiltValueNullFieldError.checkNotNull(status, r'OutOfOfficeData', 'status');
    BuiltValueNullFieldError.checkNotNull(userId, r'OutOfOfficeData', 'userId');
    BuiltValueNullFieldError.checkNotNull(message, r'OutOfOfficeData', 'message');
  }

  @override
  OutOfOfficeData rebuild(void Function(OutOfOfficeDataBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeDataBuilder toBuilder() => OutOfOfficeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeData &&
        id == other.id &&
        firstDay == other.firstDay &&
        lastDay == other.lastDay &&
        status == other.status &&
        userId == other.userId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, firstDay.hashCode);
    _$hash = $jc(_$hash, lastDay.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OutOfOfficeData')
          ..add('id', id)
          ..add('firstDay', firstDay)
          ..add('lastDay', lastDay)
          ..add('status', status)
          ..add('userId', userId)
          ..add('message', message))
        .toString();
  }
}

class OutOfOfficeDataBuilder
    implements Builder<OutOfOfficeData, OutOfOfficeDataBuilder>, $OutOfOfficeDataInterfaceBuilder {
  _$OutOfOfficeData? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  String? _firstDay;
  String? get firstDay => _$this._firstDay;
  set firstDay(covariant String? firstDay) => _$this._firstDay = firstDay;

  String? _lastDay;
  String? get lastDay => _$this._lastDay;
  set lastDay(covariant String? lastDay) => _$this._lastDay = lastDay;

  String? _status;
  String? get status => _$this._status;
  set status(covariant String? status) => _$this._status = status;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(covariant String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  OutOfOfficeDataBuilder();

  OutOfOfficeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _firstDay = $v.firstDay;
      _lastDay = $v.lastDay;
      _status = $v.status;
      _userId = $v.userId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeData;
  }

  @override
  void update(void Function(OutOfOfficeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeData build() => _build();

  _$OutOfOfficeData _build() {
    final _$result = _$v ??
        _$OutOfOfficeData._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'OutOfOfficeData', 'id'),
            firstDay: BuiltValueNullFieldError.checkNotNull(firstDay, r'OutOfOfficeData', 'firstDay'),
            lastDay: BuiltValueNullFieldError.checkNotNull(lastDay, r'OutOfOfficeData', 'lastDay'),
            status: BuiltValueNullFieldError.checkNotNull(status, r'OutOfOfficeData', 'status'),
            userId: BuiltValueNullFieldError.checkNotNull(userId, r'OutOfOfficeData', 'userId'),
            message: BuiltValueNullFieldError.checkNotNull(message, r'OutOfOfficeData', 'message'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  void replace($OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsInterface other);
  void update(void Function($OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  OutOfOfficeDataBuilder get data;
  set data(OutOfOfficeDataBuilder? data);
}

class _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs
    extends OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final OutOfOfficeData data;

  factory _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs(
          [void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder)? updates]) =>
      (OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs', 'data');
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs rebuild(
          void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder toBuilder() =>
      OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder
    implements
        Builder<OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs,
            OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder>,
        $OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  OutOfOfficeDataBuilder? _data;
  OutOfOfficeDataBuilder get data => _$this._data ??= OutOfOfficeDataBuilder();
  set data(covariant OutOfOfficeDataBuilder? data) => _$this._data = data;

  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder();

  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs build() => _build();

  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs _build() {
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeGetOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  void replace($OutOfOfficeGetOutOfOfficeResponseApplicationJsonInterface other);
  void update(void Function($OutOfOfficeGetOutOfOfficeResponseApplicationJsonInterfaceBuilder) updates);
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder get ocs;
  set ocs(OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder? ocs);
}

class _$OutOfOfficeGetOutOfOfficeResponseApplicationJson extends OutOfOfficeGetOutOfOfficeResponseApplicationJson {
  @override
  final OutOfOfficeGetOutOfOfficeResponseApplicationJson_Ocs ocs;

  factory _$OutOfOfficeGetOutOfOfficeResponseApplicationJson(
          [void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder)? updates]) =>
      (OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder()..update(updates))._build();

  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'OutOfOfficeGetOutOfOfficeResponseApplicationJson', 'ocs');
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson rebuild(
          void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder toBuilder() =>
      OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeGetOutOfOfficeResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeGetOutOfOfficeResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder
    implements
        Builder<OutOfOfficeGetOutOfOfficeResponseApplicationJson,
            OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder>,
        $OutOfOfficeGetOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson? _$v;

  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder? _ocs;
  OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder();
  set ocs(covariant OutOfOfficeGetOutOfOfficeResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder();

  OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeGetOutOfOfficeResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeGetOutOfOfficeResponseApplicationJson;
  }

  @override
  void update(void Function(OutOfOfficeGetOutOfOfficeResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeGetOutOfOfficeResponseApplicationJson build() => _build();

  _$OutOfOfficeGetOutOfOfficeResponseApplicationJson _build() {
    _$OutOfOfficeGetOutOfOfficeResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$OutOfOfficeGetOutOfOfficeResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeGetOutOfOfficeResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  void replace($OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsInterface other);
  void update(void Function($OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  OutOfOfficeDataBuilder get data;
  set data(OutOfOfficeDataBuilder? data);
}

class _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs
    extends OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final OutOfOfficeData data;

  factory _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs(
          [void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder)? updates]) =>
      (OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs', 'data');
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs rebuild(
          void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder toBuilder() =>
      OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder
    implements
        Builder<OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs,
            OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder>,
        $OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  OutOfOfficeDataBuilder? _data;
  OutOfOfficeDataBuilder get data => _$this._data ??= OutOfOfficeDataBuilder();
  set data(covariant OutOfOfficeDataBuilder? data) => _$this._data = data;

  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder();

  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs build() => _build();

  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs _build() {
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs _$result;
    try {
      _$result =
          _$v ?? _$OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeSetOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  void replace($OutOfOfficeSetOutOfOfficeResponseApplicationJsonInterface other);
  void update(void Function($OutOfOfficeSetOutOfOfficeResponseApplicationJsonInterfaceBuilder) updates);
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder get ocs;
  set ocs(OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder? ocs);
}

class _$OutOfOfficeSetOutOfOfficeResponseApplicationJson extends OutOfOfficeSetOutOfOfficeResponseApplicationJson {
  @override
  final OutOfOfficeSetOutOfOfficeResponseApplicationJson_Ocs ocs;

  factory _$OutOfOfficeSetOutOfOfficeResponseApplicationJson(
          [void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder)? updates]) =>
      (OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder()..update(updates))._build();

  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'OutOfOfficeSetOutOfOfficeResponseApplicationJson', 'ocs');
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson rebuild(
          void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder toBuilder() =>
      OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeSetOutOfOfficeResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeSetOutOfOfficeResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder
    implements
        Builder<OutOfOfficeSetOutOfOfficeResponseApplicationJson,
            OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder>,
        $OutOfOfficeSetOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson? _$v;

  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder? _ocs;
  OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder();
  set ocs(covariant OutOfOfficeSetOutOfOfficeResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder();

  OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeSetOutOfOfficeResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeSetOutOfOfficeResponseApplicationJson;
  }

  @override
  void update(void Function(OutOfOfficeSetOutOfOfficeResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeSetOutOfOfficeResponseApplicationJson build() => _build();

  _$OutOfOfficeSetOutOfOfficeResponseApplicationJson _build() {
    _$OutOfOfficeSetOutOfOfficeResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$OutOfOfficeSetOutOfOfficeResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeSetOutOfOfficeResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  void replace($OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsInterface other);
  void update(void Function($OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  JsonObject? get data;
  set data(JsonObject? data);
}

class _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs
    extends OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final JsonObject? data;

  factory _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs(
          [void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder)? updates]) =>
      (OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs._({required this.meta, this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs', 'meta');
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs rebuild(
          void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder toBuilder() =>
      OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder
    implements
        Builder<OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs,
            OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder>,
        $OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsInterfaceBuilder {
  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(covariant JsonObject? data) => _$this._data = data;

  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder();

  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs build() => _build();

  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs _build() {
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs._(meta: meta.build(), data: data);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OutOfOfficeClearOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  void replace($OutOfOfficeClearOutOfOfficeResponseApplicationJsonInterface other);
  void update(void Function($OutOfOfficeClearOutOfOfficeResponseApplicationJsonInterfaceBuilder) updates);
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder get ocs;
  set ocs(OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder? ocs);
}

class _$OutOfOfficeClearOutOfOfficeResponseApplicationJson extends OutOfOfficeClearOutOfOfficeResponseApplicationJson {
  @override
  final OutOfOfficeClearOutOfOfficeResponseApplicationJson_Ocs ocs;

  factory _$OutOfOfficeClearOutOfOfficeResponseApplicationJson(
          [void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder)? updates]) =>
      (OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder()..update(updates))._build();

  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'OutOfOfficeClearOutOfOfficeResponseApplicationJson', 'ocs');
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson rebuild(
          void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder toBuilder() =>
      OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutOfOfficeClearOutOfOfficeResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'OutOfOfficeClearOutOfOfficeResponseApplicationJson')..add('ocs', ocs))
        .toString();
  }
}

class OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder
    implements
        Builder<OutOfOfficeClearOutOfOfficeResponseApplicationJson,
            OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder>,
        $OutOfOfficeClearOutOfOfficeResponseApplicationJsonInterfaceBuilder {
  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson? _$v;

  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder? _ocs;
  OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder();
  set ocs(covariant OutOfOfficeClearOutOfOfficeResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder();

  OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OutOfOfficeClearOutOfOfficeResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OutOfOfficeClearOutOfOfficeResponseApplicationJson;
  }

  @override
  void update(void Function(OutOfOfficeClearOutOfOfficeResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutOfOfficeClearOutOfOfficeResponseApplicationJson build() => _build();

  _$OutOfOfficeClearOutOfOfficeResponseApplicationJson _build() {
    _$OutOfOfficeClearOutOfOfficeResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$OutOfOfficeClearOutOfOfficeResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutOfOfficeClearOutOfOfficeResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities_DavInterfaceBuilder {
  void replace($Capabilities_DavInterface other);
  void update(void Function($Capabilities_DavInterfaceBuilder) updates);
  String? get chunking;
  set chunking(String? chunking);

  String? get bulkupload;
  set bulkupload(String? bulkupload);
}

class _$Capabilities_Dav extends Capabilities_Dav {
  @override
  final String chunking;
  @override
  final String? bulkupload;

  factory _$Capabilities_Dav([void Function(Capabilities_DavBuilder)? updates]) =>
      (Capabilities_DavBuilder()..update(updates))._build();

  _$Capabilities_Dav._({required this.chunking, this.bulkupload}) : super._() {
    BuiltValueNullFieldError.checkNotNull(chunking, r'Capabilities_Dav', 'chunking');
  }

  @override
  Capabilities_Dav rebuild(void Function(Capabilities_DavBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  Capabilities_DavBuilder toBuilder() => Capabilities_DavBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities_Dav && chunking == other.chunking && bulkupload == other.bulkupload;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, chunking.hashCode);
    _$hash = $jc(_$hash, bulkupload.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities_Dav')
          ..add('chunking', chunking)
          ..add('bulkupload', bulkupload))
        .toString();
  }
}

class Capabilities_DavBuilder
    implements Builder<Capabilities_Dav, Capabilities_DavBuilder>, $Capabilities_DavInterfaceBuilder {
  _$Capabilities_Dav? _$v;

  String? _chunking;
  String? get chunking => _$this._chunking;
  set chunking(covariant String? chunking) => _$this._chunking = chunking;

  String? _bulkupload;
  String? get bulkupload => _$this._bulkupload;
  set bulkupload(covariant String? bulkupload) => _$this._bulkupload = bulkupload;

  Capabilities_DavBuilder();

  Capabilities_DavBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chunking = $v.chunking;
      _bulkupload = $v.bulkupload;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities_Dav other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities_Dav;
  }

  @override
  void update(void Function(Capabilities_DavBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities_Dav build() => _build();

  _$Capabilities_Dav _build() {
    final _$result = _$v ??
        _$Capabilities_Dav._(
            chunking: BuiltValueNullFieldError.checkNotNull(chunking, r'Capabilities_Dav', 'chunking'),
            bulkupload: bulkupload);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CapabilitiesInterfaceBuilder {
  void replace($CapabilitiesInterface other);
  void update(void Function($CapabilitiesInterfaceBuilder) updates);
  Capabilities_DavBuilder get dav;
  set dav(Capabilities_DavBuilder? dav);
}

class _$Capabilities extends Capabilities {
  @override
  final Capabilities_Dav dav;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._({required this.dav}) : super._() {
    BuiltValueNullFieldError.checkNotNull(dav, r'Capabilities', 'dav');
  }

  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities && dav == other.dav;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dav.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')..add('dav', dav)).toString();
  }
}

class CapabilitiesBuilder implements Builder<Capabilities, CapabilitiesBuilder>, $CapabilitiesInterfaceBuilder {
  _$Capabilities? _$v;

  Capabilities_DavBuilder? _dav;
  Capabilities_DavBuilder get dav => _$this._dav ??= Capabilities_DavBuilder();
  set dav(covariant Capabilities_DavBuilder? dav) => _$this._dav = dav;

  CapabilitiesBuilder();

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dav = $v.dav.toBuilder();
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
      _$result = _$v ?? _$Capabilities._(dav: dav.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dav';
        dav.build();
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
