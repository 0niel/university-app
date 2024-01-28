// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'any_of.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ObjectAnyOf0> _$objectAnyOf0Serializer = _$ObjectAnyOf0Serializer();
Serializer<ObjectAnyOf1> _$objectAnyOf1Serializer = _$ObjectAnyOf1Serializer();
Serializer<MixedAnyOf1> _$mixedAnyOf1Serializer = _$MixedAnyOf1Serializer();
Serializer<OneObjectAnyOf0> _$oneObjectAnyOf0Serializer = _$OneObjectAnyOf0Serializer();

class _$ObjectAnyOf0Serializer implements StructuredSerializer<ObjectAnyOf0> {
  @override
  final Iterable<Type> types = const [ObjectAnyOf0, _$ObjectAnyOf0];
  @override
  final String wireName = 'ObjectAnyOf0';

  @override
  Iterable<Object?> serialize(Serializers serializers, ObjectAnyOf0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute1-anyOf',
      serializers.serialize(object.attribute1AnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ObjectAnyOf0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ObjectAnyOf0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute1-anyOf':
          result.attribute1AnyOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ObjectAnyOf1Serializer implements StructuredSerializer<ObjectAnyOf1> {
  @override
  final Iterable<Type> types = const [ObjectAnyOf1, _$ObjectAnyOf1];
  @override
  final String wireName = 'ObjectAnyOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, ObjectAnyOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute2-anyOf',
      serializers.serialize(object.attribute2AnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ObjectAnyOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ObjectAnyOf1Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute2-anyOf':
          result.attribute2AnyOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MixedAnyOf1Serializer implements StructuredSerializer<MixedAnyOf1> {
  @override
  final Iterable<Type> types = const [MixedAnyOf1, _$MixedAnyOf1];
  @override
  final String wireName = 'MixedAnyOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, MixedAnyOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-anyOf',
      serializers.serialize(object.attributeAnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MixedAnyOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = MixedAnyOf1Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-anyOf':
          result.attributeAnyOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneObjectAnyOf0Serializer implements StructuredSerializer<OneObjectAnyOf0> {
  @override
  final Iterable<Type> types = const [OneObjectAnyOf0, _$OneObjectAnyOf0];
  @override
  final String wireName = 'OneObjectAnyOf0';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneObjectAnyOf0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-anyOf',
      serializers.serialize(object.attributeAnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneObjectAnyOf0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneObjectAnyOf0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-anyOf':
          result.attributeAnyOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $ObjectAnyOf0InterfaceBuilder {
  void replace($ObjectAnyOf0Interface other);
  void update(void Function($ObjectAnyOf0InterfaceBuilder) updates);
  String? get attribute1AnyOf;
  set attribute1AnyOf(String? attribute1AnyOf);
}

class _$ObjectAnyOf0 extends ObjectAnyOf0 {
  @override
  final String attribute1AnyOf;

  factory _$ObjectAnyOf0([void Function(ObjectAnyOf0Builder)? updates]) =>
      (ObjectAnyOf0Builder()..update(updates))._build();

  _$ObjectAnyOf0._({required this.attribute1AnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attribute1AnyOf, r'ObjectAnyOf0', 'attribute1AnyOf');
  }

  @override
  ObjectAnyOf0 rebuild(void Function(ObjectAnyOf0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  ObjectAnyOf0Builder toBuilder() => ObjectAnyOf0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectAnyOf0 && attribute1AnyOf == other.attribute1AnyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute1AnyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ObjectAnyOf0')..add('attribute1AnyOf', attribute1AnyOf)).toString();
  }
}

class ObjectAnyOf0Builder implements Builder<ObjectAnyOf0, ObjectAnyOf0Builder>, $ObjectAnyOf0InterfaceBuilder {
  _$ObjectAnyOf0? _$v;

  String? _attribute1AnyOf;
  String? get attribute1AnyOf => _$this._attribute1AnyOf;
  set attribute1AnyOf(covariant String? attribute1AnyOf) => _$this._attribute1AnyOf = attribute1AnyOf;

  ObjectAnyOf0Builder();

  ObjectAnyOf0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute1AnyOf = $v.attribute1AnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ObjectAnyOf0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectAnyOf0;
  }

  @override
  void update(void Function(ObjectAnyOf0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectAnyOf0 build() => _build();

  _$ObjectAnyOf0 _build() {
    final _$result = _$v ??
        _$ObjectAnyOf0._(
            attribute1AnyOf:
                BuiltValueNullFieldError.checkNotNull(attribute1AnyOf, r'ObjectAnyOf0', 'attribute1AnyOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ObjectAnyOf1InterfaceBuilder {
  void replace($ObjectAnyOf1Interface other);
  void update(void Function($ObjectAnyOf1InterfaceBuilder) updates);
  String? get attribute2AnyOf;
  set attribute2AnyOf(String? attribute2AnyOf);
}

class _$ObjectAnyOf1 extends ObjectAnyOf1 {
  @override
  final String attribute2AnyOf;

  factory _$ObjectAnyOf1([void Function(ObjectAnyOf1Builder)? updates]) =>
      (ObjectAnyOf1Builder()..update(updates))._build();

  _$ObjectAnyOf1._({required this.attribute2AnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attribute2AnyOf, r'ObjectAnyOf1', 'attribute2AnyOf');
  }

  @override
  ObjectAnyOf1 rebuild(void Function(ObjectAnyOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  ObjectAnyOf1Builder toBuilder() => ObjectAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectAnyOf1 && attribute2AnyOf == other.attribute2AnyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute2AnyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ObjectAnyOf1')..add('attribute2AnyOf', attribute2AnyOf)).toString();
  }
}

class ObjectAnyOf1Builder implements Builder<ObjectAnyOf1, ObjectAnyOf1Builder>, $ObjectAnyOf1InterfaceBuilder {
  _$ObjectAnyOf1? _$v;

  String? _attribute2AnyOf;
  String? get attribute2AnyOf => _$this._attribute2AnyOf;
  set attribute2AnyOf(covariant String? attribute2AnyOf) => _$this._attribute2AnyOf = attribute2AnyOf;

  ObjectAnyOf1Builder();

  ObjectAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute2AnyOf = $v.attribute2AnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ObjectAnyOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectAnyOf1;
  }

  @override
  void update(void Function(ObjectAnyOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectAnyOf1 build() => _build();

  _$ObjectAnyOf1 _build() {
    final _$result = _$v ??
        _$ObjectAnyOf1._(
            attribute2AnyOf:
                BuiltValueNullFieldError.checkNotNull(attribute2AnyOf, r'ObjectAnyOf1', 'attribute2AnyOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $MixedAnyOf1InterfaceBuilder {
  void replace($MixedAnyOf1Interface other);
  void update(void Function($MixedAnyOf1InterfaceBuilder) updates);
  String? get attributeAnyOf;
  set attributeAnyOf(String? attributeAnyOf);
}

class _$MixedAnyOf1 extends MixedAnyOf1 {
  @override
  final String attributeAnyOf;

  factory _$MixedAnyOf1([void Function(MixedAnyOf1Builder)? updates]) =>
      (MixedAnyOf1Builder()..update(updates))._build();

  _$MixedAnyOf1._({required this.attributeAnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'MixedAnyOf1', 'attributeAnyOf');
  }

  @override
  MixedAnyOf1 rebuild(void Function(MixedAnyOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  MixedAnyOf1Builder toBuilder() => MixedAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MixedAnyOf1 && attributeAnyOf == other.attributeAnyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeAnyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MixedAnyOf1')..add('attributeAnyOf', attributeAnyOf)).toString();
  }
}

class MixedAnyOf1Builder implements Builder<MixedAnyOf1, MixedAnyOf1Builder>, $MixedAnyOf1InterfaceBuilder {
  _$MixedAnyOf1? _$v;

  String? _attributeAnyOf;
  String? get attributeAnyOf => _$this._attributeAnyOf;
  set attributeAnyOf(covariant String? attributeAnyOf) => _$this._attributeAnyOf = attributeAnyOf;

  MixedAnyOf1Builder();

  MixedAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeAnyOf = $v.attributeAnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant MixedAnyOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MixedAnyOf1;
  }

  @override
  void update(void Function(MixedAnyOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MixedAnyOf1 build() => _build();

  _$MixedAnyOf1 _build() {
    final _$result = _$v ??
        _$MixedAnyOf1._(
            attributeAnyOf: BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'MixedAnyOf1', 'attributeAnyOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneObjectAnyOf0InterfaceBuilder {
  void replace($OneObjectAnyOf0Interface other);
  void update(void Function($OneObjectAnyOf0InterfaceBuilder) updates);
  String? get attributeAnyOf;
  set attributeAnyOf(String? attributeAnyOf);
}

class _$OneObjectAnyOf0 extends OneObjectAnyOf0 {
  @override
  final String attributeAnyOf;

  factory _$OneObjectAnyOf0([void Function(OneObjectAnyOf0Builder)? updates]) =>
      (OneObjectAnyOf0Builder()..update(updates))._build();

  _$OneObjectAnyOf0._({required this.attributeAnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'OneObjectAnyOf0', 'attributeAnyOf');
  }

  @override
  OneObjectAnyOf0 rebuild(void Function(OneObjectAnyOf0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  OneObjectAnyOf0Builder toBuilder() => OneObjectAnyOf0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneObjectAnyOf0 && attributeAnyOf == other.attributeAnyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeAnyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneObjectAnyOf0')..add('attributeAnyOf', attributeAnyOf)).toString();
  }
}

class OneObjectAnyOf0Builder
    implements Builder<OneObjectAnyOf0, OneObjectAnyOf0Builder>, $OneObjectAnyOf0InterfaceBuilder {
  _$OneObjectAnyOf0? _$v;

  String? _attributeAnyOf;
  String? get attributeAnyOf => _$this._attributeAnyOf;
  set attributeAnyOf(covariant String? attributeAnyOf) => _$this._attributeAnyOf = attributeAnyOf;

  OneObjectAnyOf0Builder();

  OneObjectAnyOf0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeAnyOf = $v.attributeAnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneObjectAnyOf0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneObjectAnyOf0;
  }

  @override
  void update(void Function(OneObjectAnyOf0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneObjectAnyOf0 build() => _build();

  _$OneObjectAnyOf0 _build() {
    final _$result = _$v ??
        _$OneObjectAnyOf0._(
            attributeAnyOf:
                BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'OneObjectAnyOf0', 'attributeAnyOf'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
