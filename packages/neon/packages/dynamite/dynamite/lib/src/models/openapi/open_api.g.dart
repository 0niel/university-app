// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OpenAPI> _$openAPISerializer = _$OpenAPISerializer();

class _$OpenAPISerializer implements StructuredSerializer<OpenAPI> {
  @override
  final Iterable<Type> types = const [OpenAPI, _$OpenAPI];
  @override
  final String wireName = 'OpenAPI';

  @override
  Iterable<Object?> serialize(Serializers serializers, OpenAPI object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'openapi',
      serializers.serialize(object.version, specifiedType: const FullType(String)),
      'info',
      serializers.serialize(object.info, specifiedType: const FullType(Info)),
      'servers',
      serializers.serialize(object.servers, specifiedType: const FullType(BuiltList, [FullType(Server)])),
    ];
    Object? value;
    value = object.security;
    if (value != null) {
      result
        ..add('security')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, [
              FullType(BuiltMap, [
                FullType(String),
                FullType(BuiltList, [FullType(String)])
              ])
            ])));
    }
    value = object.tags;
    if (value != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltSet, [FullType(Tag)])));
    }
    value = object.components;
    if (value != null) {
      result
        ..add('components')
        ..add(serializers.serialize(value, specifiedType: const FullType(Components)));
    }
    value = object.paths;
    if (value != null) {
      result
        ..add('paths')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(PathItem)])));
    }
    return result;
  }

  @override
  OpenAPI deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OpenAPIBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'openapi':
          result.version = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'info':
          result.info.replace(serializers.deserialize(value, specifiedType: const FullType(Info))! as Info);
          break;
        case 'servers':
          result.servers.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Server)]))! as BuiltList<Object?>);
          break;
        case 'security':
          result.security.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [
                FullType(BuiltMap, [
                  FullType(String),
                  FullType(BuiltList, [FullType(String)])
                ])
              ]))! as BuiltList<Object?>);
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value, specifiedType: const FullType(BuiltSet, [FullType(Tag)]))!
              as BuiltSet<Object?>);
          break;
        case 'components':
          result.components
              .replace(serializers.deserialize(value, specifiedType: const FullType(Components))! as Components);
          break;
        case 'paths':
          result.paths.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(PathItem)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$OpenAPI extends OpenAPI {
  @override
  final String version;
  @override
  final Info info;
  @override
  final BuiltList<Server> servers;
  @override
  final BuiltList<BuiltMap<String, BuiltList<String>>>? security;
  @override
  final BuiltSet<Tag>? tags;
  @override
  final Components? components;
  @override
  final BuiltMap<String, PathItem>? paths;

  factory _$OpenAPI([void Function(OpenAPIBuilder)? updates]) => (OpenAPIBuilder()..update(updates))._build();

  _$OpenAPI._(
      {required this.version,
      required this.info,
      required this.servers,
      this.security,
      this.tags,
      this.components,
      this.paths})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(version, r'OpenAPI', 'version');
    BuiltValueNullFieldError.checkNotNull(info, r'OpenAPI', 'info');
    BuiltValueNullFieldError.checkNotNull(servers, r'OpenAPI', 'servers');
  }

  @override
  OpenAPI rebuild(void Function(OpenAPIBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OpenAPIBuilder toBuilder() => OpenAPIBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenAPI &&
        version == other.version &&
        info == other.info &&
        servers == other.servers &&
        security == other.security &&
        tags == other.tags &&
        components == other.components &&
        paths == other.paths;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, info.hashCode);
    _$hash = $jc(_$hash, servers.hashCode);
    _$hash = $jc(_$hash, security.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jc(_$hash, paths.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenAPI')
          ..add('version', version)
          ..add('info', info)
          ..add('servers', servers)
          ..add('security', security)
          ..add('tags', tags)
          ..add('components', components)
          ..add('paths', paths))
        .toString();
  }
}

class OpenAPIBuilder implements Builder<OpenAPI, OpenAPIBuilder> {
  _$OpenAPI? _$v;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  InfoBuilder? _info;
  InfoBuilder get info => _$this._info ??= InfoBuilder();
  set info(InfoBuilder? info) => _$this._info = info;

  ListBuilder<Server>? _servers;
  ListBuilder<Server> get servers => _$this._servers ??= ListBuilder<Server>();
  set servers(ListBuilder<Server>? servers) => _$this._servers = servers;

  ListBuilder<BuiltMap<String, BuiltList<String>>>? _security;
  ListBuilder<BuiltMap<String, BuiltList<String>>> get security =>
      _$this._security ??= ListBuilder<BuiltMap<String, BuiltList<String>>>();
  set security(ListBuilder<BuiltMap<String, BuiltList<String>>>? security) => _$this._security = security;

  SetBuilder<Tag>? _tags;
  SetBuilder<Tag> get tags => _$this._tags ??= SetBuilder<Tag>();
  set tags(SetBuilder<Tag>? tags) => _$this._tags = tags;

  ComponentsBuilder? _components;
  ComponentsBuilder get components => _$this._components ??= ComponentsBuilder();
  set components(ComponentsBuilder? components) => _$this._components = components;

  MapBuilder<String, PathItem>? _paths;
  MapBuilder<String, PathItem> get paths => _$this._paths ??= MapBuilder<String, PathItem>();
  set paths(MapBuilder<String, PathItem>? paths) => _$this._paths = paths;

  OpenAPIBuilder();

  OpenAPIBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _info = $v.info.toBuilder();
      _servers = $v.servers.toBuilder();
      _security = $v.security?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _components = $v.components?.toBuilder();
      _paths = $v.paths?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenAPI other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OpenAPI;
  }

  @override
  void update(void Function(OpenAPIBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenAPI build() => _build();

  _$OpenAPI _build() {
    OpenAPI._defaults(this);
    _$OpenAPI _$result;
    try {
      _$result = _$v ??
          _$OpenAPI._(
              version: BuiltValueNullFieldError.checkNotNull(version, r'OpenAPI', 'version'),
              info: info.build(),
              servers: servers.build(),
              security: _security?.build(),
              tags: _tags?.build(),
              components: _components?.build(),
              paths: _paths?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'info';
        info.build();
        _$failedField = 'servers';
        servers.build();
        _$failedField = 'security';
        _security?.build();
        _$failedField = 'tags';
        _tags?.build();
        _$failedField = 'components';
        _components?.build();
        _$failedField = 'paths';
        _paths?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'OpenAPI', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
