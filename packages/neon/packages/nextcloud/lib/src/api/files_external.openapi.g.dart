// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_external.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Mount_Type _$mountTypeDir = Mount_Type._('dir');

Mount_Type _$valueOfMount_Type(String name) {
  switch (name) {
    case 'dir':
      return _$mountTypeDir;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Mount_Type> _$mountTypeValues = BuiltSet<Mount_Type>(const <Mount_Type>[
  _$mountTypeDir,
]);

const Mount_Scope _$mountScopeSystem = Mount_Scope._('system');
const Mount_Scope _$mountScopePersonal = Mount_Scope._('personal');

Mount_Scope _$valueOfMount_Scope(String name) {
  switch (name) {
    case 'system':
      return _$mountScopeSystem;
    case 'personal':
      return _$mountScopePersonal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Mount_Scope> _$mountScopeValues = BuiltSet<Mount_Scope>(const <Mount_Scope>[
  _$mountScopeSystem,
  _$mountScopePersonal,
]);

const StorageConfig_Type _$storageConfigTypePersonal = StorageConfig_Type._('personal');
const StorageConfig_Type _$storageConfigTypeSystem = StorageConfig_Type._('system');

StorageConfig_Type _$valueOfStorageConfig_Type(String name) {
  switch (name) {
    case 'personal':
      return _$storageConfigTypePersonal;
    case 'system':
      return _$storageConfigTypeSystem;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StorageConfig_Type> _$storageConfigTypeValues = BuiltSet<StorageConfig_Type>(const <StorageConfig_Type>[
  _$storageConfigTypePersonal,
  _$storageConfigTypeSystem,
]);

Serializer<OCSMeta> _$oCSMetaSerializer = _$OCSMetaSerializer();
Serializer<StorageConfig> _$storageConfigSerializer = _$StorageConfigSerializer();
Serializer<Mount> _$mountSerializer = _$MountSerializer();
Serializer<ApiGetUserMountsResponseApplicationJson_Ocs> _$apiGetUserMountsResponseApplicationJsonOcsSerializer =
    _$ApiGetUserMountsResponseApplicationJson_OcsSerializer();
Serializer<ApiGetUserMountsResponseApplicationJson> _$apiGetUserMountsResponseApplicationJsonSerializer =
    _$ApiGetUserMountsResponseApplicationJsonSerializer();

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

class _$StorageConfigSerializer implements StructuredSerializer<StorageConfig> {
  @override
  final Iterable<Type> types = const [StorageConfig, _$StorageConfig];
  @override
  final String wireName = 'StorageConfig';

  @override
  Iterable<Object?> serialize(Serializers serializers, StorageConfig object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'authMechanism',
      serializers.serialize(object.authMechanism, specifiedType: const FullType(String)),
      'backend',
      serializers.serialize(object.backend, specifiedType: const FullType(String)),
      'backendOptions',
      serializers.serialize(object.backendOptions,
          specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonObject)])),
      'mountPoint',
      serializers.serialize(object.mountPoint, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(StorageConfig_Type)),
      'userProvided',
      serializers.serialize(object.userProvided, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.applicableGroups;
    if (value != null) {
      result
        ..add('applicableGroups')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)])));
    }
    value = object.applicableUsers;
    if (value != null) {
      result
        ..add('applicableUsers')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)])));
    }
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.mountOptions;
    if (value != null) {
      result
        ..add('mountOptions')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonObject)])));
    }
    value = object.priority;
    if (value != null) {
      result
        ..add('priority')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.statusMessage;
    if (value != null) {
      result
        ..add('statusMessage')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  StorageConfig deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = StorageConfigBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'applicableGroups':
          result.applicableGroups.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'applicableUsers':
          result.applicableUsers.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'authMechanism':
          result.authMechanism = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'backend':
          result.backend = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'backendOptions':
          result.backendOptions.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]))!);
          break;
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'mountOptions':
          result.mountOptions.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]))!);
          break;
        case 'mountPoint':
          result.mountPoint = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'priority':
          result.priority = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'status':
          result.status = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'statusMessage':
          result.statusMessage = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type =
              serializers.deserialize(value, specifiedType: const FullType(StorageConfig_Type))! as StorageConfig_Type;
          break;
        case 'userProvided':
          result.userProvided = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$MountSerializer implements StructuredSerializer<Mount> {
  @override
  final Iterable<Type> types = const [Mount, _$Mount];
  @override
  final String wireName = 'Mount';

  @override
  Iterable<Object?> serialize(Serializers serializers, Mount object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'path',
      serializers.serialize(object.path, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(Mount_Type)),
      'backend',
      serializers.serialize(object.backend, specifiedType: const FullType(String)),
      'scope',
      serializers.serialize(object.scope, specifiedType: const FullType(Mount_Scope)),
      'permissions',
      serializers.serialize(object.permissions, specifiedType: const FullType(int)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'class',
      serializers.serialize(object.$class, specifiedType: const FullType(String)),
      'config',
      serializers.serialize(object.config, specifiedType: const FullType(StorageConfig)),
    ];

    return result;
  }

  @override
  Mount deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = MountBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'path':
          result.path = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(Mount_Type))! as Mount_Type;
          break;
        case 'backend':
          result.backend = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'scope':
          result.scope = serializers.deserialize(value, specifiedType: const FullType(Mount_Scope))! as Mount_Scope;
          break;
        case 'permissions':
          result.permissions = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'class':
          result.$class = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'config':
          result.config
              .replace(serializers.deserialize(value, specifiedType: const FullType(StorageConfig))! as StorageConfig);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiGetUserMountsResponseApplicationJson_OcsSerializer
    implements StructuredSerializer<ApiGetUserMountsResponseApplicationJson_Ocs> {
  @override
  final Iterable<Type> types = const [
    ApiGetUserMountsResponseApplicationJson_Ocs,
    _$ApiGetUserMountsResponseApplicationJson_Ocs
  ];
  @override
  final String wireName = 'ApiGetUserMountsResponseApplicationJson_Ocs';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiGetUserMountsResponseApplicationJson_Ocs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'meta',
      serializers.serialize(object.meta, specifiedType: const FullType(OCSMeta)),
      'data',
      serializers.serialize(object.data, specifiedType: const FullType(BuiltList, [FullType(Mount)])),
    ];

    return result;
  }

  @override
  ApiGetUserMountsResponseApplicationJson_Ocs deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiGetUserMountsResponseApplicationJson_OcsBuilder();

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
              specifiedType: const FullType(BuiltList, [FullType(Mount)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$ApiGetUserMountsResponseApplicationJsonSerializer
    implements StructuredSerializer<ApiGetUserMountsResponseApplicationJson> {
  @override
  final Iterable<Type> types = const [
    ApiGetUserMountsResponseApplicationJson,
    _$ApiGetUserMountsResponseApplicationJson
  ];
  @override
  final String wireName = 'ApiGetUserMountsResponseApplicationJson';

  @override
  Iterable<Object?> serialize(Serializers serializers, ApiGetUserMountsResponseApplicationJson object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'ocs',
      serializers.serialize(object.ocs, specifiedType: const FullType(ApiGetUserMountsResponseApplicationJson_Ocs)),
    ];

    return result;
  }

  @override
  ApiGetUserMountsResponseApplicationJson deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ApiGetUserMountsResponseApplicationJsonBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ocs':
          result.ocs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ApiGetUserMountsResponseApplicationJson_Ocs))!
              as ApiGetUserMountsResponseApplicationJson_Ocs);
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

abstract mixin class $StorageConfigInterfaceBuilder {
  void replace($StorageConfigInterface other);
  void update(void Function($StorageConfigInterfaceBuilder) updates);
  ListBuilder<String> get applicableGroups;
  set applicableGroups(ListBuilder<String>? applicableGroups);

  ListBuilder<String> get applicableUsers;
  set applicableUsers(ListBuilder<String>? applicableUsers);

  String? get authMechanism;
  set authMechanism(String? authMechanism);

  String? get backend;
  set backend(String? backend);

  MapBuilder<String, JsonObject> get backendOptions;
  set backendOptions(MapBuilder<String, JsonObject>? backendOptions);

  int? get id;
  set id(int? id);

  MapBuilder<String, JsonObject> get mountOptions;
  set mountOptions(MapBuilder<String, JsonObject>? mountOptions);

  String? get mountPoint;
  set mountPoint(String? mountPoint);

  int? get priority;
  set priority(int? priority);

  int? get status;
  set status(int? status);

  String? get statusMessage;
  set statusMessage(String? statusMessage);

  StorageConfig_Type? get type;
  set type(StorageConfig_Type? type);

  bool? get userProvided;
  set userProvided(bool? userProvided);
}

class _$StorageConfig extends StorageConfig {
  @override
  final BuiltList<String>? applicableGroups;
  @override
  final BuiltList<String>? applicableUsers;
  @override
  final String authMechanism;
  @override
  final String backend;
  @override
  final BuiltMap<String, JsonObject> backendOptions;
  @override
  final int? id;
  @override
  final BuiltMap<String, JsonObject>? mountOptions;
  @override
  final String mountPoint;
  @override
  final int? priority;
  @override
  final int? status;
  @override
  final String? statusMessage;
  @override
  final StorageConfig_Type type;
  @override
  final bool userProvided;

  factory _$StorageConfig([void Function(StorageConfigBuilder)? updates]) =>
      (StorageConfigBuilder()..update(updates))._build();

  _$StorageConfig._(
      {this.applicableGroups,
      this.applicableUsers,
      required this.authMechanism,
      required this.backend,
      required this.backendOptions,
      this.id,
      this.mountOptions,
      required this.mountPoint,
      this.priority,
      this.status,
      this.statusMessage,
      required this.type,
      required this.userProvided})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(authMechanism, r'StorageConfig', 'authMechanism');
    BuiltValueNullFieldError.checkNotNull(backend, r'StorageConfig', 'backend');
    BuiltValueNullFieldError.checkNotNull(backendOptions, r'StorageConfig', 'backendOptions');
    BuiltValueNullFieldError.checkNotNull(mountPoint, r'StorageConfig', 'mountPoint');
    BuiltValueNullFieldError.checkNotNull(type, r'StorageConfig', 'type');
    BuiltValueNullFieldError.checkNotNull(userProvided, r'StorageConfig', 'userProvided');
  }

  @override
  StorageConfig rebuild(void Function(StorageConfigBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  StorageConfigBuilder toBuilder() => StorageConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StorageConfig &&
        applicableGroups == other.applicableGroups &&
        applicableUsers == other.applicableUsers &&
        authMechanism == other.authMechanism &&
        backend == other.backend &&
        backendOptions == other.backendOptions &&
        id == other.id &&
        mountOptions == other.mountOptions &&
        mountPoint == other.mountPoint &&
        priority == other.priority &&
        status == other.status &&
        statusMessage == other.statusMessage &&
        type == other.type &&
        userProvided == other.userProvided;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, applicableGroups.hashCode);
    _$hash = $jc(_$hash, applicableUsers.hashCode);
    _$hash = $jc(_$hash, authMechanism.hashCode);
    _$hash = $jc(_$hash, backend.hashCode);
    _$hash = $jc(_$hash, backendOptions.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, mountOptions.hashCode);
    _$hash = $jc(_$hash, mountPoint.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, statusMessage.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, userProvided.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StorageConfig')
          ..add('applicableGroups', applicableGroups)
          ..add('applicableUsers', applicableUsers)
          ..add('authMechanism', authMechanism)
          ..add('backend', backend)
          ..add('backendOptions', backendOptions)
          ..add('id', id)
          ..add('mountOptions', mountOptions)
          ..add('mountPoint', mountPoint)
          ..add('priority', priority)
          ..add('status', status)
          ..add('statusMessage', statusMessage)
          ..add('type', type)
          ..add('userProvided', userProvided))
        .toString();
  }
}

class StorageConfigBuilder implements Builder<StorageConfig, StorageConfigBuilder>, $StorageConfigInterfaceBuilder {
  _$StorageConfig? _$v;

  ListBuilder<String>? _applicableGroups;
  ListBuilder<String> get applicableGroups => _$this._applicableGroups ??= ListBuilder<String>();
  set applicableGroups(covariant ListBuilder<String>? applicableGroups) => _$this._applicableGroups = applicableGroups;

  ListBuilder<String>? _applicableUsers;
  ListBuilder<String> get applicableUsers => _$this._applicableUsers ??= ListBuilder<String>();
  set applicableUsers(covariant ListBuilder<String>? applicableUsers) => _$this._applicableUsers = applicableUsers;

  String? _authMechanism;
  String? get authMechanism => _$this._authMechanism;
  set authMechanism(covariant String? authMechanism) => _$this._authMechanism = authMechanism;

  String? _backend;
  String? get backend => _$this._backend;
  set backend(covariant String? backend) => _$this._backend = backend;

  MapBuilder<String, JsonObject>? _backendOptions;
  MapBuilder<String, JsonObject> get backendOptions => _$this._backendOptions ??= MapBuilder<String, JsonObject>();
  set backendOptions(covariant MapBuilder<String, JsonObject>? backendOptions) =>
      _$this._backendOptions = backendOptions;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  MapBuilder<String, JsonObject>? _mountOptions;
  MapBuilder<String, JsonObject> get mountOptions => _$this._mountOptions ??= MapBuilder<String, JsonObject>();
  set mountOptions(covariant MapBuilder<String, JsonObject>? mountOptions) => _$this._mountOptions = mountOptions;

  String? _mountPoint;
  String? get mountPoint => _$this._mountPoint;
  set mountPoint(covariant String? mountPoint) => _$this._mountPoint = mountPoint;

  int? _priority;
  int? get priority => _$this._priority;
  set priority(covariant int? priority) => _$this._priority = priority;

  int? _status;
  int? get status => _$this._status;
  set status(covariant int? status) => _$this._status = status;

  String? _statusMessage;
  String? get statusMessage => _$this._statusMessage;
  set statusMessage(covariant String? statusMessage) => _$this._statusMessage = statusMessage;

  StorageConfig_Type? _type;
  StorageConfig_Type? get type => _$this._type;
  set type(covariant StorageConfig_Type? type) => _$this._type = type;

  bool? _userProvided;
  bool? get userProvided => _$this._userProvided;
  set userProvided(covariant bool? userProvided) => _$this._userProvided = userProvided;

  StorageConfigBuilder();

  StorageConfigBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _applicableGroups = $v.applicableGroups?.toBuilder();
      _applicableUsers = $v.applicableUsers?.toBuilder();
      _authMechanism = $v.authMechanism;
      _backend = $v.backend;
      _backendOptions = $v.backendOptions.toBuilder();
      _id = $v.id;
      _mountOptions = $v.mountOptions?.toBuilder();
      _mountPoint = $v.mountPoint;
      _priority = $v.priority;
      _status = $v.status;
      _statusMessage = $v.statusMessage;
      _type = $v.type;
      _userProvided = $v.userProvided;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant StorageConfig other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$StorageConfig;
  }

  @override
  void update(void Function(StorageConfigBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StorageConfig build() => _build();

  _$StorageConfig _build() {
    _$StorageConfig _$result;
    try {
      _$result = _$v ??
          _$StorageConfig._(
              applicableGroups: _applicableGroups?.build(),
              applicableUsers: _applicableUsers?.build(),
              authMechanism: BuiltValueNullFieldError.checkNotNull(authMechanism, r'StorageConfig', 'authMechanism'),
              backend: BuiltValueNullFieldError.checkNotNull(backend, r'StorageConfig', 'backend'),
              backendOptions: backendOptions.build(),
              id: id,
              mountOptions: _mountOptions?.build(),
              mountPoint: BuiltValueNullFieldError.checkNotNull(mountPoint, r'StorageConfig', 'mountPoint'),
              priority: priority,
              status: status,
              statusMessage: statusMessage,
              type: BuiltValueNullFieldError.checkNotNull(type, r'StorageConfig', 'type'),
              userProvided: BuiltValueNullFieldError.checkNotNull(userProvided, r'StorageConfig', 'userProvided'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'applicableGroups';
        _applicableGroups?.build();
        _$failedField = 'applicableUsers';
        _applicableUsers?.build();

        _$failedField = 'backendOptions';
        backendOptions.build();

        _$failedField = 'mountOptions';
        _mountOptions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'StorageConfig', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $MountInterfaceBuilder {
  void replace($MountInterface other);
  void update(void Function($MountInterfaceBuilder) updates);
  String? get name;
  set name(String? name);

  String? get path;
  set path(String? path);

  Mount_Type? get type;
  set type(Mount_Type? type);

  String? get backend;
  set backend(String? backend);

  Mount_Scope? get scope;
  set scope(Mount_Scope? scope);

  int? get permissions;
  set permissions(int? permissions);

  int? get id;
  set id(int? id);

  String? get $class;
  set $class(String? $class);

  StorageConfigBuilder get config;
  set config(StorageConfigBuilder? config);
}

class _$Mount extends Mount {
  @override
  final String name;
  @override
  final String path;
  @override
  final Mount_Type type;
  @override
  final String backend;
  @override
  final Mount_Scope scope;
  @override
  final int permissions;
  @override
  final int id;
  @override
  final String $class;
  @override
  final StorageConfig config;

  factory _$Mount([void Function(MountBuilder)? updates]) => (MountBuilder()..update(updates))._build();

  _$Mount._(
      {required this.name,
      required this.path,
      required this.type,
      required this.backend,
      required this.scope,
      required this.permissions,
      required this.id,
      required this.$class,
      required this.config})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'Mount', 'name');
    BuiltValueNullFieldError.checkNotNull(path, r'Mount', 'path');
    BuiltValueNullFieldError.checkNotNull(type, r'Mount', 'type');
    BuiltValueNullFieldError.checkNotNull(backend, r'Mount', 'backend');
    BuiltValueNullFieldError.checkNotNull(scope, r'Mount', 'scope');
    BuiltValueNullFieldError.checkNotNull(permissions, r'Mount', 'permissions');
    BuiltValueNullFieldError.checkNotNull(id, r'Mount', 'id');
    BuiltValueNullFieldError.checkNotNull($class, r'Mount', '\$class');
    BuiltValueNullFieldError.checkNotNull(config, r'Mount', 'config');
  }

  @override
  Mount rebuild(void Function(MountBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  MountBuilder toBuilder() => MountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Mount &&
        name == other.name &&
        path == other.path &&
        type == other.type &&
        backend == other.backend &&
        scope == other.scope &&
        permissions == other.permissions &&
        id == other.id &&
        $class == other.$class &&
        config == other.config;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, backend.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, $class.hashCode);
    _$hash = $jc(_$hash, config.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Mount')
          ..add('name', name)
          ..add('path', path)
          ..add('type', type)
          ..add('backend', backend)
          ..add('scope', scope)
          ..add('permissions', permissions)
          ..add('id', id)
          ..add('\$class', $class)
          ..add('config', config))
        .toString();
  }
}

class MountBuilder implements Builder<Mount, MountBuilder>, $MountInterfaceBuilder {
  _$Mount? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(covariant String? name) => _$this._name = name;

  String? _path;
  String? get path => _$this._path;
  set path(covariant String? path) => _$this._path = path;

  Mount_Type? _type;
  Mount_Type? get type => _$this._type;
  set type(covariant Mount_Type? type) => _$this._type = type;

  String? _backend;
  String? get backend => _$this._backend;
  set backend(covariant String? backend) => _$this._backend = backend;

  Mount_Scope? _scope;
  Mount_Scope? get scope => _$this._scope;
  set scope(covariant Mount_Scope? scope) => _$this._scope = scope;

  int? _permissions;
  int? get permissions => _$this._permissions;
  set permissions(covariant int? permissions) => _$this._permissions = permissions;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  String? _$class;
  String? get $class => _$this._$class;
  set $class(covariant String? $class) => _$this._$class = $class;

  StorageConfigBuilder? _config;
  StorageConfigBuilder get config => _$this._config ??= StorageConfigBuilder();
  set config(covariant StorageConfigBuilder? config) => _$this._config = config;

  MountBuilder();

  MountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _path = $v.path;
      _type = $v.type;
      _backend = $v.backend;
      _scope = $v.scope;
      _permissions = $v.permissions;
      _id = $v.id;
      _$class = $v.$class;
      _config = $v.config.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Mount other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Mount;
  }

  @override
  void update(void Function(MountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Mount build() => _build();

  _$Mount _build() {
    _$Mount _$result;
    try {
      _$result = _$v ??
          _$Mount._(
              name: BuiltValueNullFieldError.checkNotNull(name, r'Mount', 'name'),
              path: BuiltValueNullFieldError.checkNotNull(path, r'Mount', 'path'),
              type: BuiltValueNullFieldError.checkNotNull(type, r'Mount', 'type'),
              backend: BuiltValueNullFieldError.checkNotNull(backend, r'Mount', 'backend'),
              scope: BuiltValueNullFieldError.checkNotNull(scope, r'Mount', 'scope'),
              permissions: BuiltValueNullFieldError.checkNotNull(permissions, r'Mount', 'permissions'),
              id: BuiltValueNullFieldError.checkNotNull(id, r'Mount', 'id'),
              $class: BuiltValueNullFieldError.checkNotNull($class, r'Mount', '\$class'),
              config: config.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'config';
        config.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Mount', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiGetUserMountsResponseApplicationJson_OcsInterfaceBuilder {
  void replace($ApiGetUserMountsResponseApplicationJson_OcsInterface other);
  void update(void Function($ApiGetUserMountsResponseApplicationJson_OcsInterfaceBuilder) updates);
  OCSMetaBuilder get meta;
  set meta(OCSMetaBuilder? meta);

  ListBuilder<Mount> get data;
  set data(ListBuilder<Mount>? data);
}

class _$ApiGetUserMountsResponseApplicationJson_Ocs extends ApiGetUserMountsResponseApplicationJson_Ocs {
  @override
  final OCSMeta meta;
  @override
  final BuiltList<Mount> data;

  factory _$ApiGetUserMountsResponseApplicationJson_Ocs(
          [void Function(ApiGetUserMountsResponseApplicationJson_OcsBuilder)? updates]) =>
      (ApiGetUserMountsResponseApplicationJson_OcsBuilder()..update(updates))._build();

  _$ApiGetUserMountsResponseApplicationJson_Ocs._({required this.meta, required this.data}) : super._() {
    BuiltValueNullFieldError.checkNotNull(meta, r'ApiGetUserMountsResponseApplicationJson_Ocs', 'meta');
    BuiltValueNullFieldError.checkNotNull(data, r'ApiGetUserMountsResponseApplicationJson_Ocs', 'data');
  }

  @override
  ApiGetUserMountsResponseApplicationJson_Ocs rebuild(
          void Function(ApiGetUserMountsResponseApplicationJson_OcsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiGetUserMountsResponseApplicationJson_OcsBuilder toBuilder() =>
      ApiGetUserMountsResponseApplicationJson_OcsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiGetUserMountsResponseApplicationJson_Ocs && meta == other.meta && data == other.data;
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
    return (newBuiltValueToStringHelper(r'ApiGetUserMountsResponseApplicationJson_Ocs')
          ..add('meta', meta)
          ..add('data', data))
        .toString();
  }
}

class ApiGetUserMountsResponseApplicationJson_OcsBuilder
    implements
        Builder<ApiGetUserMountsResponseApplicationJson_Ocs, ApiGetUserMountsResponseApplicationJson_OcsBuilder>,
        $ApiGetUserMountsResponseApplicationJson_OcsInterfaceBuilder {
  _$ApiGetUserMountsResponseApplicationJson_Ocs? _$v;

  OCSMetaBuilder? _meta;
  OCSMetaBuilder get meta => _$this._meta ??= OCSMetaBuilder();
  set meta(covariant OCSMetaBuilder? meta) => _$this._meta = meta;

  ListBuilder<Mount>? _data;
  ListBuilder<Mount> get data => _$this._data ??= ListBuilder<Mount>();
  set data(covariant ListBuilder<Mount>? data) => _$this._data = data;

  ApiGetUserMountsResponseApplicationJson_OcsBuilder();

  ApiGetUserMountsResponseApplicationJson_OcsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _meta = $v.meta.toBuilder();
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiGetUserMountsResponseApplicationJson_Ocs other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiGetUserMountsResponseApplicationJson_Ocs;
  }

  @override
  void update(void Function(ApiGetUserMountsResponseApplicationJson_OcsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiGetUserMountsResponseApplicationJson_Ocs build() => _build();

  _$ApiGetUserMountsResponseApplicationJson_Ocs _build() {
    _$ApiGetUserMountsResponseApplicationJson_Ocs _$result;
    try {
      _$result = _$v ?? _$ApiGetUserMountsResponseApplicationJson_Ocs._(meta: meta.build(), data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiGetUserMountsResponseApplicationJson_Ocs', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ApiGetUserMountsResponseApplicationJsonInterfaceBuilder {
  void replace($ApiGetUserMountsResponseApplicationJsonInterface other);
  void update(void Function($ApiGetUserMountsResponseApplicationJsonInterfaceBuilder) updates);
  ApiGetUserMountsResponseApplicationJson_OcsBuilder get ocs;
  set ocs(ApiGetUserMountsResponseApplicationJson_OcsBuilder? ocs);
}

class _$ApiGetUserMountsResponseApplicationJson extends ApiGetUserMountsResponseApplicationJson {
  @override
  final ApiGetUserMountsResponseApplicationJson_Ocs ocs;

  factory _$ApiGetUserMountsResponseApplicationJson(
          [void Function(ApiGetUserMountsResponseApplicationJsonBuilder)? updates]) =>
      (ApiGetUserMountsResponseApplicationJsonBuilder()..update(updates))._build();

  _$ApiGetUserMountsResponseApplicationJson._({required this.ocs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(ocs, r'ApiGetUserMountsResponseApplicationJson', 'ocs');
  }

  @override
  ApiGetUserMountsResponseApplicationJson rebuild(
          void Function(ApiGetUserMountsResponseApplicationJsonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiGetUserMountsResponseApplicationJsonBuilder toBuilder() =>
      ApiGetUserMountsResponseApplicationJsonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiGetUserMountsResponseApplicationJson && ocs == other.ocs;
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
    return (newBuiltValueToStringHelper(r'ApiGetUserMountsResponseApplicationJson')..add('ocs', ocs)).toString();
  }
}

class ApiGetUserMountsResponseApplicationJsonBuilder
    implements
        Builder<ApiGetUserMountsResponseApplicationJson, ApiGetUserMountsResponseApplicationJsonBuilder>,
        $ApiGetUserMountsResponseApplicationJsonInterfaceBuilder {
  _$ApiGetUserMountsResponseApplicationJson? _$v;

  ApiGetUserMountsResponseApplicationJson_OcsBuilder? _ocs;
  ApiGetUserMountsResponseApplicationJson_OcsBuilder get ocs =>
      _$this._ocs ??= ApiGetUserMountsResponseApplicationJson_OcsBuilder();
  set ocs(covariant ApiGetUserMountsResponseApplicationJson_OcsBuilder? ocs) => _$this._ocs = ocs;

  ApiGetUserMountsResponseApplicationJsonBuilder();

  ApiGetUserMountsResponseApplicationJsonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ocs = $v.ocs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ApiGetUserMountsResponseApplicationJson other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ApiGetUserMountsResponseApplicationJson;
  }

  @override
  void update(void Function(ApiGetUserMountsResponseApplicationJsonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiGetUserMountsResponseApplicationJson build() => _build();

  _$ApiGetUserMountsResponseApplicationJson _build() {
    _$ApiGetUserMountsResponseApplicationJson _$result;
    try {
      _$result = _$v ?? _$ApiGetUserMountsResponseApplicationJson._(ocs: ocs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ocs';
        ocs.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ApiGetUserMountsResponseApplicationJson', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
