// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Server> _$serverSerializer = _$ServerSerializer();

class _$ServerSerializer implements StructuredSerializer<Server> {
  @override
  final Iterable<Type> types = const [Server, _$Server];
  @override
  final String wireName = 'Server';

  @override
  Iterable<Object?> serialize(Serializers serializers, Server object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.variables;
    if (value != null) {
      result
        ..add('variables')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(ServerVariable)])));
    }
    return result;
  }

  @override
  Server deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ServerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'url':
          result.url = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'variables':
          result.variables.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(ServerVariable)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$Server extends Server {
  @override
  final String url;
  @override
  final BuiltMap<String, ServerVariable>? variables;

  factory _$Server([void Function(ServerBuilder)? updates]) => (ServerBuilder()..update(updates))._build();

  _$Server._({required this.url, this.variables}) : super._() {
    BuiltValueNullFieldError.checkNotNull(url, r'Server', 'url');
  }

  @override
  Server rebuild(void Function(ServerBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ServerBuilder toBuilder() => ServerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Server && url == other.url && variables == other.variables;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, variables.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Server')
          ..add('url', url)
          ..add('variables', variables))
        .toString();
  }
}

class ServerBuilder implements Builder<Server, ServerBuilder> {
  _$Server? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  MapBuilder<String, ServerVariable>? _variables;
  MapBuilder<String, ServerVariable> get variables => _$this._variables ??= MapBuilder<String, ServerVariable>();
  set variables(MapBuilder<String, ServerVariable>? variables) => _$this._variables = variables;

  ServerBuilder();

  ServerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _variables = $v.variables?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Server other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Server;
  }

  @override
  void update(void Function(ServerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Server build() => _build();

  _$Server _build() {
    _$Server _$result;
    try {
      _$result = _$v ??
          _$Server._(url: BuiltValueNullFieldError.checkNotNull(url, r'Server', 'url'), variables: _variables?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'variables';
        _variables?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Server', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
