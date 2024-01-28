// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uppush.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CheckResponseApplicationJson> _$checkResponseApplicationJsonSerializer =
    _$CheckResponseApplicationJsonSerializer();
Serializer<SetKeepaliveResponseApplicationJson> _$setKeepaliveResponseApplicationJsonSerializer =
    _$SetKeepaliveResponseApplicationJsonSerializer();
Serializer<CreateDeviceResponseApplicationJson> _$createDeviceResponseApplicationJsonSerializer =
    _$CreateDeviceResponseApplicationJsonSerializer();
Serializer<SyncDeviceResponseApplicationJson> _$syncDeviceResponseApplicationJsonSerializer =
    _$SyncDeviceResponseApplicationJsonSerializer();
Serializer<DeleteDeviceResponseApplicationJson> _$deleteDeviceResponseApplicationJsonSerializer =
    _$DeleteDeviceResponseApplicationJsonSerializer();
Serializer<CreateAppResponseApplicationJson> _$createAppResponseApplicationJsonSerializer =
    _$CreateAppResponseApplicationJsonSerializer();
Serializer<DeleteAppResponseApplicationJson> _$deleteAppResponseApplicationJsonSerializer =
    _$DeleteAppResponseApplicationJsonSerializer();
Serializer<UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush>
    _$unifiedpushDiscoveryResponseApplicationJsonUnifiedpushSerializer =
    _$UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushSerializer();
Serializer<UnifiedpushDiscoveryResponseApplicationJson> _$unifiedpushDiscoveryResponseApplicationJsonSerializer =
    _$UnifiedpushDiscoveryResponseApplicationJsonSerializer();
Serializer<PushResponseApplicationJson> _$pushResponseApplicationJsonSerializer =
    _$PushResponseApplicationJsonSerializer();
Serializer<GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush>
    _$gatewayMatrixDiscoveryResponseApplicationJsonUnifiedpushSerializer =
    _$GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushSerializer();
Serializer<GatewayMatrixDiscoveryResponseApplicationJson> _$gatewayMatrixDiscoveryResponseApplicationJsonSerializer =
    _$GatewayMatrixDiscoveryResponseApplicationJsonSerializer();
Serializer<GatewayMatrixResponseApplicationJson> _$gatewayMatrixResponseApplicationJsonSerializer =
    _$GatewayMatrixResponseApplicationJsonSerializer();

class _$CheckResponseApplicationJsonSerializer implements StructuredSerializer<CheckResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [CheckResponseApplicationJson, _$CheckResponseApplicationJson];
  @override
  final String wireName = 'CheckResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, CheckResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  CheckResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CheckResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SetKeepaliveResponseApplicationJsonSerializer
    implements StructuredSerializer<SetKeepaliveResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [SetKeepaliveResponseApplicationJson, _$SetKeepaliveResponseApplicationJson];
  @override
  final String wireName = 'SetKeepaliveResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, SetKeepaliveResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SetKeepaliveResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SetKeepaliveResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$CreateDeviceResponseApplicationJsonSerializer
    implements StructuredSerializer<CreateDeviceResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [CreateDeviceResponseApplicationJson, _$CreateDeviceResponseApplicationJson];
  @override
  final String wireName = 'CreateDeviceResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, CreateDeviceResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
      'deviceId',
      serializers.serialize(object.deviceId, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  CreateDeviceResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CreateDeviceResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'deviceId':
          result.deviceId = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SyncDeviceResponseApplicationJsonSerializer implements StructuredSerializer<SyncDeviceResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [SyncDeviceResponseApplicationJson, _$SyncDeviceResponseApplicationJson];
  @override
  final String wireName = 'SyncDeviceResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, SyncDeviceResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SyncDeviceResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SyncDeviceResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$DeleteDeviceResponseApplicationJsonSerializer
    implements StructuredSerializer<DeleteDeviceResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [DeleteDeviceResponseApplicationJson, _$DeleteDeviceResponseApplicationJson];
  @override
  final String wireName = 'DeleteDeviceResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DeleteDeviceResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  DeleteDeviceResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DeleteDeviceResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$CreateAppResponseApplicationJsonSerializer implements StructuredSerializer<CreateAppResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [CreateAppResponseApplicationJson, _$CreateAppResponseApplicationJson];
  @override
  final String wireName = 'CreateAppResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, CreateAppResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
      'token',
      serializers.serialize(object.token, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  CreateAppResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = CreateAppResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'token':
          result.token = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DeleteAppResponseApplicationJsonSerializer implements StructuredSerializer<DeleteAppResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [DeleteAppResponseApplicationJson, _$DeleteAppResponseApplicationJson];
  @override
  final String wireName = 'DeleteAppResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, DeleteAppResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  DeleteAppResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DeleteAppResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushSerializer
    implements StructuredSerializer<UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush> {
  @override
  final Iterable<Type> types = const [
    UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush,
    _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush
  ];
  @override
  final String wireName = 'UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush';

  @override
  Iterable<Object?> serialize(Serializers serializers, UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'version',
      serializers.serialize(object.version, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'version':
          result.version = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$UnifiedpushDiscoveryResponseApplicationJsonSerializer
    implements StructuredSerializer<UnifiedpushDiscoveryResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    UnifiedpushDiscoveryResponseApplicationJson,
    _$UnifiedpushDiscoveryResponseApplicationJson
  ];
  @override
  final String wireName = 'UnifiedpushDiscoveryResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, UnifiedpushDiscoveryResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'unifiedpush',
      serializers.serialize(object.unifiedpush,
          specifiedType: const FullType(UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush)),
    ];

    return result;
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UnifiedpushDiscoveryResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'unifiedpush':
          result.unifiedpush.replace(serializers.deserialize(value,
                  specifiedType: const FullType(UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush))!
              as UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush);
          break;
      }
    }

    return result.build();
  }
}

class _$PushResponseApplicationJsonSerializer implements StructuredSerializer<PushResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [PushResponseApplicationJson, _$PushResponseApplicationJson];
  @override
  final String wireName = 'PushResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, PushResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'success',
      serializers.serialize(object.success, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  PushResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PushResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushSerializer
    implements StructuredSerializer<GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush> {
  @override
  final Iterable<Type> types = const [
    GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush,
    _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush
  ];
  @override
  final String wireName = 'GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush';

  @override
  Iterable<Object?> serialize(Serializers serializers, GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'gateway',
      serializers.serialize(object.gateway, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'gateway':
          result.gateway = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$GatewayMatrixDiscoveryResponseApplicationJsonSerializer
    implements StructuredSerializer<GatewayMatrixDiscoveryResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    GatewayMatrixDiscoveryResponseApplicationJson,
    _$GatewayMatrixDiscoveryResponseApplicationJson
  ];
  @override
  final String wireName = 'GatewayMatrixDiscoveryResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, GatewayMatrixDiscoveryResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'unifiedpush',
      serializers.serialize(object.unifiedpush,
          specifiedType: const FullType(GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush)),
    ];

    return result;
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GatewayMatrixDiscoveryResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'unifiedpush':
          result.unifiedpush.replace(serializers.deserialize(value,
                  specifiedType: const FullType(GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush))!
              as GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush);
          break;
      }
    }

    return result.build();
  }
}

class _$GatewayMatrixResponseApplicationJsonSerializer
    implements StructuredSerializer<GatewayMatrixResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [GatewayMatrixResponseApplicationJson, _$GatewayMatrixResponseApplicationJson];
  @override
  final String wireName = 'GatewayMatrixResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, GatewayMatrixResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'rejected',
      serializers.serialize(object.rejected, specifiedType: const FullType(BuiltList, [FullType(String)])),
    ];

    return result;
  }

  @override
  GatewayMatrixResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GatewayMatrixResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'rejected':
          result.rejected.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $CheckResponseApplicationJsonInterfaceBuilder {
  void replace($CheckResponseApplicationJsonInterface other);
  void update(void Function($CheckResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$CheckResponseApplicationJson extends CheckResponseApplicationJson {
  @override
  final bool success;

  factory _$CheckResponseApplicationJson([void Function(CheckResponseApplicationJsonBuilder)? updates]) =>
      (CheckResponseApplicationJsonBuilder()..update(updates))._build();

  _$CheckResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'CheckResponseApplicationJson', 'success');
  }

  @override
  CheckResponseApplicationJson rebuild(void Function(CheckResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckResponseApplicationJsonBuilder toBuilder() => CheckResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckResponseApplicationJson')..add('success', success)).toString();
  }
}

class CheckResponseApplicationJsonBuilder
    implements
        Builder<CheckResponseApplicationJson, CheckResponseApplicationJsonBuilder>,
        $CheckResponseApplicationJsonInterfaceBuilder {
  _$CheckResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  CheckResponseApplicationJsonBuilder();

  CheckResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CheckResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CheckResponseApplicationJson;
  }

  @override
  void update(void Function(CheckResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckResponseApplicationJson build() => _build();

  _$CheckResponseApplicationJson _build() {
    final _$result = _$v ??
        _$CheckResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'CheckResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $SetKeepaliveResponseApplicationJsonInterfaceBuilder {
  void replace($SetKeepaliveResponseApplicationJsonInterface other);
  void update(void Function($SetKeepaliveResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$SetKeepaliveResponseApplicationJson extends SetKeepaliveResponseApplicationJson {
  @override
  final bool success;

  factory _$SetKeepaliveResponseApplicationJson([void Function(SetKeepaliveResponseApplicationJsonBuilder)? updates]) =>
      (SetKeepaliveResponseApplicationJsonBuilder()..update(updates))._build();

  _$SetKeepaliveResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'SetKeepaliveResponseApplicationJson', 'success');
  }

  @override
  SetKeepaliveResponseApplicationJson rebuild(void Function(SetKeepaliveResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetKeepaliveResponseApplicationJsonBuilder toBuilder() => SetKeepaliveResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetKeepaliveResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetKeepaliveResponseApplicationJson')..add('success', success)).toString();
  }
}

class SetKeepaliveResponseApplicationJsonBuilder
    implements
        Builder<SetKeepaliveResponseApplicationJson, SetKeepaliveResponseApplicationJsonBuilder>,
        $SetKeepaliveResponseApplicationJsonInterfaceBuilder {
  _$SetKeepaliveResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  SetKeepaliveResponseApplicationJsonBuilder();

  SetKeepaliveResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant SetKeepaliveResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SetKeepaliveResponseApplicationJson;
  }

  @override
  void update(void Function(SetKeepaliveResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetKeepaliveResponseApplicationJson build() => _build();

  _$SetKeepaliveResponseApplicationJson _build() {
    final _$result = _$v ??
        _$SetKeepaliveResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'SetKeepaliveResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CreateDeviceResponseApplicationJsonInterfaceBuilder {
  void replace($CreateDeviceResponseApplicationJsonInterface other);
  void update(void Function($CreateDeviceResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);

  String? get deviceId;
  set deviceId(String? deviceId);
}

class _$CreateDeviceResponseApplicationJson extends CreateDeviceResponseApplicationJson {
  @override
  final bool success;
  @override
  final String deviceId;

  factory _$CreateDeviceResponseApplicationJson([void Function(CreateDeviceResponseApplicationJsonBuilder)? updates]) =>
      (CreateDeviceResponseApplicationJsonBuilder()..update(updates))._build();

  _$CreateDeviceResponseApplicationJson._({required this.success, required this.deviceId}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'CreateDeviceResponseApplicationJson', 'success');
    BuiltValueNullFieldError.checkNotNull(deviceId, r'CreateDeviceResponseApplicationJson', 'deviceId');
  }

  @override
  CreateDeviceResponseApplicationJson rebuild(void Function(CreateDeviceResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateDeviceResponseApplicationJsonBuilder toBuilder() => CreateDeviceResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateDeviceResponseApplicationJson && success == other.success && deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateDeviceResponseApplicationJson')
          ..add('success', success)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class CreateDeviceResponseApplicationJsonBuilder
    implements
        Builder<CreateDeviceResponseApplicationJson, CreateDeviceResponseApplicationJsonBuilder>,
        $CreateDeviceResponseApplicationJsonInterfaceBuilder {
  _$CreateDeviceResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(covariant String? deviceId) => _$this._deviceId = deviceId;

  CreateDeviceResponseApplicationJsonBuilder();

  CreateDeviceResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CreateDeviceResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateDeviceResponseApplicationJson;
  }

  @override
  void update(void Function(CreateDeviceResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateDeviceResponseApplicationJson build() => _build();

  _$CreateDeviceResponseApplicationJson _build() {
    final _$result = _$v ??
        _$CreateDeviceResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'CreateDeviceResponseApplicationJson', 'success'),
            deviceId:
                BuiltValueNullFieldError.checkNotNull(deviceId, r'CreateDeviceResponseApplicationJson', 'deviceId'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $SyncDeviceResponseApplicationJsonInterfaceBuilder {
  void replace($SyncDeviceResponseApplicationJsonInterface other);
  void update(void Function($SyncDeviceResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$SyncDeviceResponseApplicationJson extends SyncDeviceResponseApplicationJson {
  @override
  final bool success;

  factory _$SyncDeviceResponseApplicationJson([void Function(SyncDeviceResponseApplicationJsonBuilder)? updates]) =>
      (SyncDeviceResponseApplicationJsonBuilder()..update(updates))._build();

  _$SyncDeviceResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'SyncDeviceResponseApplicationJson', 'success');
  }

  @override
  SyncDeviceResponseApplicationJson rebuild(void Function(SyncDeviceResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncDeviceResponseApplicationJsonBuilder toBuilder() => SyncDeviceResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncDeviceResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncDeviceResponseApplicationJson')..add('success', success)).toString();
  }
}

class SyncDeviceResponseApplicationJsonBuilder
    implements
        Builder<SyncDeviceResponseApplicationJson, SyncDeviceResponseApplicationJsonBuilder>,
        $SyncDeviceResponseApplicationJsonInterfaceBuilder {
  _$SyncDeviceResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  SyncDeviceResponseApplicationJsonBuilder();

  SyncDeviceResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant SyncDeviceResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SyncDeviceResponseApplicationJson;
  }

  @override
  void update(void Function(SyncDeviceResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncDeviceResponseApplicationJson build() => _build();

  _$SyncDeviceResponseApplicationJson _build() {
    final _$result = _$v ??
        _$SyncDeviceResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'SyncDeviceResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DeleteDeviceResponseApplicationJsonInterfaceBuilder {
  void replace($DeleteDeviceResponseApplicationJsonInterface other);
  void update(void Function($DeleteDeviceResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$DeleteDeviceResponseApplicationJson extends DeleteDeviceResponseApplicationJson {
  @override
  final bool success;

  factory _$DeleteDeviceResponseApplicationJson([void Function(DeleteDeviceResponseApplicationJsonBuilder)? updates]) =>
      (DeleteDeviceResponseApplicationJsonBuilder()..update(updates))._build();

  _$DeleteDeviceResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'DeleteDeviceResponseApplicationJson', 'success');
  }

  @override
  DeleteDeviceResponseApplicationJson rebuild(void Function(DeleteDeviceResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteDeviceResponseApplicationJsonBuilder toBuilder() => DeleteDeviceResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteDeviceResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteDeviceResponseApplicationJson')..add('success', success)).toString();
  }
}

class DeleteDeviceResponseApplicationJsonBuilder
    implements
        Builder<DeleteDeviceResponseApplicationJson, DeleteDeviceResponseApplicationJsonBuilder>,
        $DeleteDeviceResponseApplicationJsonInterfaceBuilder {
  _$DeleteDeviceResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  DeleteDeviceResponseApplicationJsonBuilder();

  DeleteDeviceResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DeleteDeviceResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DeleteDeviceResponseApplicationJson;
  }

  @override
  void update(void Function(DeleteDeviceResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteDeviceResponseApplicationJson build() => _build();

  _$DeleteDeviceResponseApplicationJson _build() {
    final _$result = _$v ??
        _$DeleteDeviceResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'DeleteDeviceResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $CreateAppResponseApplicationJsonInterfaceBuilder {
  void replace($CreateAppResponseApplicationJsonInterface other);
  void update(void Function($CreateAppResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);

  String? get token;
  set token(String? token);
}

class _$CreateAppResponseApplicationJson extends CreateAppResponseApplicationJson {
  @override
  final bool success;
  @override
  final String token;

  factory _$CreateAppResponseApplicationJson([void Function(CreateAppResponseApplicationJsonBuilder)? updates]) =>
      (CreateAppResponseApplicationJsonBuilder()..update(updates))._build();

  _$CreateAppResponseApplicationJson._({required this.success, required this.token}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'CreateAppResponseApplicationJson', 'success');
    BuiltValueNullFieldError.checkNotNull(token, r'CreateAppResponseApplicationJson', 'token');
  }

  @override
  CreateAppResponseApplicationJson rebuild(void Function(CreateAppResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAppResponseApplicationJsonBuilder toBuilder() => CreateAppResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAppResponseApplicationJson && success == other.success && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAppResponseApplicationJson')
          ..add('success', success)
          ..add('token', token))
        .toString();
  }
}

class CreateAppResponseApplicationJsonBuilder
    implements
        Builder<CreateAppResponseApplicationJson, CreateAppResponseApplicationJsonBuilder>,
        $CreateAppResponseApplicationJsonInterfaceBuilder {
  _$CreateAppResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  String? _token;
  String? get token => _$this._token;
  set token(covariant String? token) => _$this._token = token;

  CreateAppResponseApplicationJsonBuilder();

  CreateAppResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CreateAppResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CreateAppResponseApplicationJson;
  }

  @override
  void update(void Function(CreateAppResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAppResponseApplicationJson build() => _build();

  _$CreateAppResponseApplicationJson _build() {
    final _$result = _$v ??
        _$CreateAppResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'CreateAppResponseApplicationJson', 'success'),
            token: BuiltValueNullFieldError.checkNotNull(token, r'CreateAppResponseApplicationJson', 'token'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $DeleteAppResponseApplicationJsonInterfaceBuilder {
  void replace($DeleteAppResponseApplicationJsonInterface other);
  void update(void Function($DeleteAppResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$DeleteAppResponseApplicationJson extends DeleteAppResponseApplicationJson {
  @override
  final bool success;

  factory _$DeleteAppResponseApplicationJson([void Function(DeleteAppResponseApplicationJsonBuilder)? updates]) =>
      (DeleteAppResponseApplicationJsonBuilder()..update(updates))._build();

  _$DeleteAppResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'DeleteAppResponseApplicationJson', 'success');
  }

  @override
  DeleteAppResponseApplicationJson rebuild(void Function(DeleteAppResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteAppResponseApplicationJsonBuilder toBuilder() => DeleteAppResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteAppResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteAppResponseApplicationJson')..add('success', success)).toString();
  }
}

class DeleteAppResponseApplicationJsonBuilder
    implements
        Builder<DeleteAppResponseApplicationJson, DeleteAppResponseApplicationJsonBuilder>,
        $DeleteAppResponseApplicationJsonInterfaceBuilder {
  _$DeleteAppResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  DeleteAppResponseApplicationJsonBuilder();

  DeleteAppResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant DeleteAppResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DeleteAppResponseApplicationJson;
  }

  @override
  void update(void Function(DeleteAppResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteAppResponseApplicationJson build() => _build();

  _$DeleteAppResponseApplicationJson _build() {
    final _$result = _$v ??
        _$DeleteAppResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'DeleteAppResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder {
  void replace($UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushInterface other);
  void update(void Function($UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder) updates);
  int? get version;
  set version(int? version);
}

class _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush
    extends UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush {
  @override
  final int version;

  factory _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush(
          [void Function(UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder)? updates]) =>
      (UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder()..update(updates))._build();

  _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush._({required this.version}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        version, r'UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush', 'version');
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush rebuild(
          void Function(UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder toBuilder() =>
      UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush && version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush')
          ..add('version', version))
        .toString();
  }
}

class UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder
    implements
        Builder<UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush,
            UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder>,
        $UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder {
  _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(covariant int? version) => _$this._version = version;

  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder();

  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush;
  }

  @override
  void update(void Function(UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush build() => _build();

  _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush _build() {
    final _$result = _$v ??
        _$UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush', 'version'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $UnifiedpushDiscoveryResponseApplicationJsonInterfaceBuilder {
  void replace($UnifiedpushDiscoveryResponseApplicationJsonInterface other);
  void update(void Function($UnifiedpushDiscoveryResponseApplicationJsonInterfaceBuilder) updates);
  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder get unifiedpush;
  set unifiedpush(UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder? unifiedpush);
}

class _$UnifiedpushDiscoveryResponseApplicationJson extends UnifiedpushDiscoveryResponseApplicationJson {
  @override
  final UnifiedpushDiscoveryResponseApplicationJson_Unifiedpush unifiedpush;

  factory _$UnifiedpushDiscoveryResponseApplicationJson(
          [void Function(UnifiedpushDiscoveryResponseApplicationJsonBuilder)? updates]) =>
      (UnifiedpushDiscoveryResponseApplicationJsonBuilder()..update(updates))._build();

  _$UnifiedpushDiscoveryResponseApplicationJson._({required this.unifiedpush}) : super._() {
    BuiltValueNullFieldError.checkNotNull(unifiedpush, r'UnifiedpushDiscoveryResponseApplicationJson', 'unifiedpush');
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson rebuild(
          void Function(UnifiedpushDiscoveryResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnifiedpushDiscoveryResponseApplicationJsonBuilder toBuilder() =>
      UnifiedpushDiscoveryResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnifiedpushDiscoveryResponseApplicationJson && unifiedpush == other.unifiedpush;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unifiedpush.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnifiedpushDiscoveryResponseApplicationJson')
          ..add('unifiedpush', unifiedpush))
        .toString();
  }
}

class UnifiedpushDiscoveryResponseApplicationJsonBuilder
    implements
        Builder<UnifiedpushDiscoveryResponseApplicationJson, UnifiedpushDiscoveryResponseApplicationJsonBuilder>,
        $UnifiedpushDiscoveryResponseApplicationJsonInterfaceBuilder {
  _$UnifiedpushDiscoveryResponseApplicationJson? _$v;

  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder? _unifiedpush;
  UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder get unifiedpush =>
      _$this._unifiedpush ??= UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder();
  set unifiedpush(covariant UnifiedpushDiscoveryResponseApplicationJson_UnifiedpushBuilder? unifiedpush) =>
      _$this._unifiedpush = unifiedpush;

  UnifiedpushDiscoveryResponseApplicationJsonBuilder();

  UnifiedpushDiscoveryResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unifiedpush = $v.unifiedpush.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant UnifiedpushDiscoveryResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UnifiedpushDiscoveryResponseApplicationJson;
  }

  @override
  void update(void Function(UnifiedpushDiscoveryResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnifiedpushDiscoveryResponseApplicationJson build() => _build();

  _$UnifiedpushDiscoveryResponseApplicationJson _build() {
    _$UnifiedpushDiscoveryResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$UnifiedpushDiscoveryResponseApplicationJson._(unifiedpush: unifiedpush.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'unifiedpush';
        unifiedpush.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'UnifiedpushDiscoveryResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PushResponseApplicationJsonInterfaceBuilder {
  void replace($PushResponseApplicationJsonInterface other);
  void update(void Function($PushResponseApplicationJsonInterfaceBuilder) updates);
  bool? get success;
  set success(bool? success);
}

class _$PushResponseApplicationJson extends PushResponseApplicationJson {
  @override
  final bool success;

  factory _$PushResponseApplicationJson([void Function(PushResponseApplicationJsonBuilder)? updates]) =>
      (PushResponseApplicationJsonBuilder()..update(updates))._build();

  _$PushResponseApplicationJson._({required this.success}) : super._() {
    BuiltValueNullFieldError.checkNotNull(success, r'PushResponseApplicationJson', 'success');
  }

  @override
  PushResponseApplicationJson rebuild(void Function(PushResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PushResponseApplicationJsonBuilder toBuilder() => PushResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushResponseApplicationJson && success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PushResponseApplicationJson')..add('success', success)).toString();
  }
}

class PushResponseApplicationJsonBuilder
    implements
        Builder<PushResponseApplicationJson, PushResponseApplicationJsonBuilder>,
        $PushResponseApplicationJsonInterfaceBuilder {
  _$PushResponseApplicationJson? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(covariant bool? success) => _$this._success = success;

  PushResponseApplicationJsonBuilder();

  PushResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PushResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PushResponseApplicationJson;
  }

  @override
  void update(void Function(PushResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushResponseApplicationJson build() => _build();

  _$PushResponseApplicationJson _build() {
    final _$result = _$v ??
        _$PushResponseApplicationJson._(
            success: BuiltValueNullFieldError.checkNotNull(success, r'PushResponseApplicationJson', 'success'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder {
  void replace($GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushInterface other);
  void update(void Function($GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder) updates);
  String? get gateway;
  set gateway(String? gateway);
}

class _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush
    extends GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush {
  @override
  final String gateway;

  factory _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush(
          [void Function(GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder)? updates]) =>
      (GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder()..update(updates))._build();

  _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush._({required this.gateway}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        gateway, r'GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush', 'gateway');
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush rebuild(
          void Function(GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder toBuilder() =>
      GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush && gateway == other.gateway;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gateway.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush')
          ..add('gateway', gateway))
        .toString();
  }
}

class GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder
    implements
        Builder<GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush,
            GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder>,
        $GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushInterfaceBuilder {
  _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush? _$v;

  String? _gateway;
  String? get gateway => _$this._gateway;
  set gateway(covariant String? gateway) => _$this._gateway = gateway;

  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder();

  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gateway = $v.gateway;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush;
  }

  @override
  void update(void Function(GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush build() => _build();

  _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush _build() {
    final _$result = _$v ??
        _$GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush._(
            gateway: BuiltValueNullFieldError.checkNotNull(
                gateway, r'GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush', 'gateway'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $GatewayMatrixDiscoveryResponseApplicationJsonInterfaceBuilder {
  void replace($GatewayMatrixDiscoveryResponseApplicationJsonInterface other);
  void update(void Function($GatewayMatrixDiscoveryResponseApplicationJsonInterfaceBuilder) updates);
  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder get unifiedpush;
  set unifiedpush(GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder? unifiedpush);
}

class _$GatewayMatrixDiscoveryResponseApplicationJson extends GatewayMatrixDiscoveryResponseApplicationJson {
  @override
  final GatewayMatrixDiscoveryResponseApplicationJson_Unifiedpush unifiedpush;

  factory _$GatewayMatrixDiscoveryResponseApplicationJson(
          [void Function(GatewayMatrixDiscoveryResponseApplicationJsonBuilder)? updates]) =>
      (GatewayMatrixDiscoveryResponseApplicationJsonBuilder()..update(updates))._build();

  _$GatewayMatrixDiscoveryResponseApplicationJson._({required this.unifiedpush}) : super._() {
    BuiltValueNullFieldError.checkNotNull(unifiedpush, r'GatewayMatrixDiscoveryResponseApplicationJson', 'unifiedpush');
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson rebuild(
          void Function(GatewayMatrixDiscoveryResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GatewayMatrixDiscoveryResponseApplicationJsonBuilder toBuilder() =>
      GatewayMatrixDiscoveryResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GatewayMatrixDiscoveryResponseApplicationJson && unifiedpush == other.unifiedpush;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unifiedpush.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GatewayMatrixDiscoveryResponseApplicationJson')
          ..add('unifiedpush', unifiedpush))
        .toString();
  }
}

class GatewayMatrixDiscoveryResponseApplicationJsonBuilder
    implements
        Builder<GatewayMatrixDiscoveryResponseApplicationJson, GatewayMatrixDiscoveryResponseApplicationJsonBuilder>,
        $GatewayMatrixDiscoveryResponseApplicationJsonInterfaceBuilder {
  _$GatewayMatrixDiscoveryResponseApplicationJson? _$v;

  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder? _unifiedpush;
  GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder get unifiedpush =>
      _$this._unifiedpush ??= GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder();
  set unifiedpush(covariant GatewayMatrixDiscoveryResponseApplicationJson_UnifiedpushBuilder? unifiedpush) =>
      _$this._unifiedpush = unifiedpush;

  GatewayMatrixDiscoveryResponseApplicationJsonBuilder();

  GatewayMatrixDiscoveryResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unifiedpush = $v.unifiedpush.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant GatewayMatrixDiscoveryResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GatewayMatrixDiscoveryResponseApplicationJson;
  }

  @override
  void update(void Function(GatewayMatrixDiscoveryResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GatewayMatrixDiscoveryResponseApplicationJson build() => _build();

  _$GatewayMatrixDiscoveryResponseApplicationJson _build() {
    _$GatewayMatrixDiscoveryResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$GatewayMatrixDiscoveryResponseApplicationJson._(unifiedpush: unifiedpush.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'unifiedpush';
        unifiedpush.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'GatewayMatrixDiscoveryResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $GatewayMatrixResponseApplicationJsonInterfaceBuilder {
  void replace($GatewayMatrixResponseApplicationJsonInterface other);
  void update(void Function($GatewayMatrixResponseApplicationJsonInterfaceBuilder) updates);
  ListBuilder<String> get rejected;
  set rejected(ListBuilder<String>? rejected);
}

class _$GatewayMatrixResponseApplicationJson extends GatewayMatrixResponseApplicationJson {
  @override
  final BuiltList<String> rejected;

  factory _$GatewayMatrixResponseApplicationJson(
          [void Function(GatewayMatrixResponseApplicationJsonBuilder)? updates]) =>
      (GatewayMatrixResponseApplicationJsonBuilder()..update(updates))._build();

  _$GatewayMatrixResponseApplicationJson._({required this.rejected}) : super._() {
    BuiltValueNullFieldError.checkNotNull(rejected, r'GatewayMatrixResponseApplicationJson', 'rejected');
  }

  @override
  GatewayMatrixResponseApplicationJson rebuild(void Function(GatewayMatrixResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GatewayMatrixResponseApplicationJsonBuilder toBuilder() =>
      GatewayMatrixResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GatewayMatrixResponseApplicationJson && rejected == other.rejected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GatewayMatrixResponseApplicationJson')..add('rejected', rejected)).toString();
  }
}

class GatewayMatrixResponseApplicationJsonBuilder
    implements
        Builder<GatewayMatrixResponseApplicationJson, GatewayMatrixResponseApplicationJsonBuilder>,
        $GatewayMatrixResponseApplicationJsonInterfaceBuilder {
  _$GatewayMatrixResponseApplicationJson? _$v;

  ListBuilder<String>? _rejected;
  ListBuilder<String> get rejected => _$this._rejected ??= ListBuilder<String>();
  set rejected(covariant ListBuilder<String>? rejected) => _$this._rejected = rejected;

  GatewayMatrixResponseApplicationJsonBuilder();

  GatewayMatrixResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rejected = $v.rejected.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant GatewayMatrixResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GatewayMatrixResponseApplicationJson;
  }

  @override
  void update(void Function(GatewayMatrixResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GatewayMatrixResponseApplicationJson build() => _build();

  _$GatewayMatrixResponseApplicationJson _build() {
    _$GatewayMatrixResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$GatewayMatrixResponseApplicationJson._(rejected: rejected.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rejected';
        rejected.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'GatewayMatrixResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
