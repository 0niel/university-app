// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'components.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Components> _$componentsSerializer = _$ComponentsSerializer();

class _$ComponentsSerializer implements StructuredSerializer<Components> {
  @override
  final Iterable<Type> types = const [Components, _$Components];
  @override
  final String wireName = 'Components';

  @override
  Iterable<Object?> serialize(Serializers serializers, Components object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.securitySchemes;
    if (value != null) {
      result
        ..add('securitySchemes')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(SecurityScheme)])));
    }
    value = object.schemas;
    if (value != null) {
      result
        ..add('schemas')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Schema)])));
    }
    return result;
  }

  @override
  Components deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ComponentsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'securitySchemes':
          result.securitySchemes.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(SecurityScheme)]))!);
          break;
        case 'schemas':
          result.schemas.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Schema)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$Components extends Components {
  @override
  final BuiltMap<String, SecurityScheme>? securitySchemes;
  @override
  final BuiltMap<String, Schema>? schemas;

  factory _$Components([void Function(ComponentsBuilder)? updates]) => (ComponentsBuilder()..update(updates))._build();

  _$Components._({this.securitySchemes, this.schemas}) : super._();

  @override
  Components rebuild(void Function(ComponentsBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ComponentsBuilder toBuilder() => ComponentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Components && securitySchemes == other.securitySchemes && schemas == other.schemas;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, securitySchemes.hashCode);
    _$hash = $jc(_$hash, schemas.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Components')
          ..add('securitySchemes', securitySchemes)
          ..add('schemas', schemas))
        .toString();
  }
}

class ComponentsBuilder implements Builder<Components, ComponentsBuilder> {
  _$Components? _$v;

  MapBuilder<String, SecurityScheme>? _securitySchemes;
  MapBuilder<String, SecurityScheme> get securitySchemes =>
      _$this._securitySchemes ??= MapBuilder<String, SecurityScheme>();
  set securitySchemes(MapBuilder<String, SecurityScheme>? securitySchemes) => _$this._securitySchemes = securitySchemes;

  MapBuilder<String, Schema>? _schemas;
  MapBuilder<String, Schema> get schemas => _$this._schemas ??= MapBuilder<String, Schema>();
  set schemas(MapBuilder<String, Schema>? schemas) => _$this._schemas = schemas;

  ComponentsBuilder();

  ComponentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _securitySchemes = $v.securitySchemes?.toBuilder();
      _schemas = $v.schemas?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Components other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Components;
  }

  @override
  void update(void Function(ComponentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Components build() => _build();

  _$Components _build() {
    _$Components _$result;
    try {
      _$result = _$v ?? _$Components._(securitySchemes: _securitySchemes?.build(), schemas: _schemas?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'securitySchemes';
        _securitySchemes?.build();
        _$failedField = 'schemas';
        _schemas?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Components', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
