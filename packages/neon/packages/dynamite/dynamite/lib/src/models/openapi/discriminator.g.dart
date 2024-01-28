// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discriminator.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Discriminator> _$discriminatorSerializer = _$DiscriminatorSerializer();

class _$DiscriminatorSerializer implements StructuredSerializer<Discriminator> {
  @override
  final Iterable<Type> types = const [Discriminator, _$Discriminator];
  @override
  final String wireName = 'Discriminator';

  @override
  Iterable<Object?> serialize(Serializers serializers, Discriminator object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'propertyName',
      serializers.serialize(object.propertyName, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.mapping;
    if (value != null) {
      result
        ..add('mapping')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)])));
    }
    return result;
  }

  @override
  Discriminator deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = DiscriminatorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'propertyName':
          result.propertyName = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'mapping':
          result.mapping.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$Discriminator extends Discriminator {
  @override
  final String propertyName;
  @override
  final BuiltMap<String, String>? mapping;

  factory _$Discriminator([void Function(DiscriminatorBuilder)? updates]) =>
      (DiscriminatorBuilder()..update(updates))._build();

  _$Discriminator._({required this.propertyName, this.mapping}) : super._() {
    BuiltValueNullFieldError.checkNotNull(propertyName, r'Discriminator', 'propertyName');
  }

  @override
  Discriminator rebuild(void Function(DiscriminatorBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  DiscriminatorBuilder toBuilder() => DiscriminatorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Discriminator && propertyName == other.propertyName && mapping == other.mapping;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, propertyName.hashCode);
    _$hash = $jc(_$hash, mapping.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Discriminator')
          ..add('propertyName', propertyName)
          ..add('mapping', mapping))
        .toString();
  }
}

class DiscriminatorBuilder implements Builder<Discriminator, DiscriminatorBuilder> {
  _$Discriminator? _$v;

  String? _propertyName;
  String? get propertyName => _$this._propertyName;
  set propertyName(String? propertyName) => _$this._propertyName = propertyName;

  MapBuilder<String, String>? _mapping;
  MapBuilder<String, String> get mapping => _$this._mapping ??= MapBuilder<String, String>();
  set mapping(MapBuilder<String, String>? mapping) => _$this._mapping = mapping;

  DiscriminatorBuilder();

  DiscriminatorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _propertyName = $v.propertyName;
      _mapping = $v.mapping?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Discriminator other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Discriminator;
  }

  @override
  void update(void Function(DiscriminatorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Discriminator build() => _build();

  _$Discriminator _build() {
    _$Discriminator _$result;
    try {
      _$result = _$v ??
          _$Discriminator._(
              propertyName: BuiltValueNullFieldError.checkNotNull(propertyName, r'Discriminator', 'propertyName'),
              mapping: _mapping?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mapping';
        _mapping?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Discriminator', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
