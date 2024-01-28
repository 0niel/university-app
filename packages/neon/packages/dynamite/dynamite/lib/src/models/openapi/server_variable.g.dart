// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_variable.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ServerVariable> _$serverVariableSerializer = _$ServerVariableSerializer();

class _$ServerVariableSerializer implements StructuredSerializer<ServerVariable> {
  @override
  final Iterable<Type> types = const [ServerVariable, _$ServerVariable];
  @override
  final String wireName = 'ServerVariable';

  @override
  Iterable<Object?> serialize(Serializers serializers, ServerVariable object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'default',
      serializers.serialize(object.$default, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.$enum;
    if (value != null) {
      result
        ..add('enum')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)])));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ServerVariable deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ServerVariableBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'default':
          result.$default = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'enum':
          result.$enum.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ServerVariable extends ServerVariable {
  @override
  final String $default;
  @override
  final BuiltList<String>? $enum;
  @override
  final String? description;

  factory _$ServerVariable([void Function(ServerVariableBuilder)? updates]) =>
      (ServerVariableBuilder()..update(updates))._build();

  _$ServerVariable._({required this.$default, this.$enum, this.description}) : super._() {
    BuiltValueNullFieldError.checkNotNull($default, r'ServerVariable', '\$default');
  }

  @override
  ServerVariable rebuild(void Function(ServerVariableBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ServerVariableBuilder toBuilder() => ServerVariableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServerVariable && $default == other.$default && $enum == other.$enum;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, $default.hashCode);
    _$hash = $jc(_$hash, $enum.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ServerVariable')
          ..add('\$default', $default)
          ..add('\$enum', $enum)
          ..add('description', description))
        .toString();
  }
}

class ServerVariableBuilder implements Builder<ServerVariable, ServerVariableBuilder> {
  _$ServerVariable? _$v;

  String? _$default;
  String? get $default => _$this._$default;
  set $default(String? $default) => _$this._$default = $default;

  ListBuilder<String>? _$enum;
  ListBuilder<String> get $enum => _$this._$enum ??= ListBuilder<String>();
  set $enum(ListBuilder<String>? $enum) => _$this._$enum = $enum;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ServerVariableBuilder();

  ServerVariableBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _$default = $v.$default;
      _$enum = $v.$enum?.toBuilder();
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ServerVariable other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ServerVariable;
  }

  @override
  void update(void Function(ServerVariableBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ServerVariable build() => _build();

  _$ServerVariable _build() {
    _$ServerVariable _$result;
    try {
      _$result = _$v ??
          _$ServerVariable._(
              $default: BuiltValueNullFieldError.checkNotNull($default, r'ServerVariable', '\$default'),
              $enum: _$enum?.build(),
              description: description);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = '\$enum';
        _$enum?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'ServerVariable', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
