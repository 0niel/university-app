// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_of.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ObjectOneOf0> _$objectOneOf0Serializer = _$ObjectOneOf0Serializer();
Serializer<ObjectOneOf1> _$objectOneOf1Serializer = _$ObjectOneOf1Serializer();
Serializer<MixedOneOf1> _$mixedOneOf1Serializer = _$MixedOneOf1Serializer();
Serializer<OneObjectOneOf0> _$oneObjectOneOf0Serializer = _$OneObjectOneOf0Serializer();
Serializer<OneOfUnspecifiedArray0> _$oneOfUnspecifiedArray0Serializer = _$OneOfUnspecifiedArray0Serializer();
Serializer<OneOfStringArray0> _$oneOfStringArray0Serializer = _$OneOfStringArray0Serializer();

class _$ObjectOneOf0Serializer implements StructuredSerializer<ObjectOneOf0> {
  @override
  final Iterable<Type> types = const [ObjectOneOf0, _$ObjectOneOf0];
  @override
  final String wireName = 'ObjectOneOf0';

  @override
  Iterable<Object?> serialize(Serializers serializers, ObjectOneOf0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute1-oneOf',
      serializers.serialize(object.attribute1OneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ObjectOneOf0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ObjectOneOf0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute1-oneOf':
          result.attribute1OneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ObjectOneOf1Serializer implements StructuredSerializer<ObjectOneOf1> {
  @override
  final Iterable<Type> types = const [ObjectOneOf1, _$ObjectOneOf1];
  @override
  final String wireName = 'ObjectOneOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, ObjectOneOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute2-oneOf',
      serializers.serialize(object.attribute2OneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ObjectOneOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ObjectOneOf1Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute2-oneOf':
          result.attribute2OneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MixedOneOf1Serializer implements StructuredSerializer<MixedOneOf1> {
  @override
  final Iterable<Type> types = const [MixedOneOf1, _$MixedOneOf1];
  @override
  final String wireName = 'MixedOneOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, MixedOneOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-oneOf',
      serializers.serialize(object.attributeOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MixedOneOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = MixedOneOf1Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-oneOf':
          result.attributeOneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneObjectOneOf0Serializer implements StructuredSerializer<OneObjectOneOf0> {
  @override
  final Iterable<Type> types = const [OneObjectOneOf0, _$OneObjectOneOf0];
  @override
  final String wireName = 'OneObjectOneOf0';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneObjectOneOf0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-oneOf',
      serializers.serialize(object.attributeOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneObjectOneOf0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneObjectOneOf0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-oneOf':
          result.attributeOneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneOfUnspecifiedArray0Serializer implements StructuredSerializer<OneOfUnspecifiedArray0> {
  @override
  final Iterable<Type> types = const [OneOfUnspecifiedArray0, _$OneOfUnspecifiedArray0];
  @override
  final String wireName = 'OneOfUnspecifiedArray0';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneOfUnspecifiedArray0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-oneOf',
      serializers.serialize(object.attributeOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneOfUnspecifiedArray0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneOfUnspecifiedArray0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-oneOf':
          result.attributeOneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneOfStringArray0Serializer implements StructuredSerializer<OneOfStringArray0> {
  @override
  final Iterable<Type> types = const [OneOfStringArray0, _$OneOfStringArray0];
  @override
  final String wireName = 'OneOfStringArray0';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneOfStringArray0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-oneOf',
      serializers.serialize(object.attributeOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneOfStringArray0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneOfStringArray0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-oneOf':
          result.attributeOneOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $ObjectOneOf0InterfaceBuilder {
  void replace($ObjectOneOf0Interface other);
  void update(void Function($ObjectOneOf0InterfaceBuilder) updates);
  String? get attribute1OneOf;
  set attribute1OneOf(String? attribute1OneOf);
}

class _$ObjectOneOf0 extends ObjectOneOf0 {
  @override
  final String attribute1OneOf;

  factory _$ObjectOneOf0([void Function(ObjectOneOf0Builder)? updates]) =>
      (ObjectOneOf0Builder()..update(updates))._build();

  _$ObjectOneOf0._({required this.attribute1OneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attribute1OneOf, r'ObjectOneOf0', 'attribute1OneOf');
  }

  @override
  ObjectOneOf0 rebuild(void Function(ObjectOneOf0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  ObjectOneOf0Builder toBuilder() => ObjectOneOf0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectOneOf0 && attribute1OneOf == other.attribute1OneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute1OneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ObjectOneOf0')..add('attribute1OneOf', attribute1OneOf)).toString();
  }
}

class ObjectOneOf0Builder implements Builder<ObjectOneOf0, ObjectOneOf0Builder>, $ObjectOneOf0InterfaceBuilder {
  _$ObjectOneOf0? _$v;

  String? _attribute1OneOf;
  String? get attribute1OneOf => _$this._attribute1OneOf;
  set attribute1OneOf(covariant String? attribute1OneOf) => _$this._attribute1OneOf = attribute1OneOf;

  ObjectOneOf0Builder();

  ObjectOneOf0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute1OneOf = $v.attribute1OneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ObjectOneOf0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectOneOf0;
  }

  @override
  void update(void Function(ObjectOneOf0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectOneOf0 build() => _build();

  _$ObjectOneOf0 _build() {
    final _$result = _$v ??
        _$ObjectOneOf0._(
            attribute1OneOf:
                BuiltValueNullFieldError.checkNotNull(attribute1OneOf, r'ObjectOneOf0', 'attribute1OneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ObjectOneOf1InterfaceBuilder {
  void replace($ObjectOneOf1Interface other);
  void update(void Function($ObjectOneOf1InterfaceBuilder) updates);
  String? get attribute2OneOf;
  set attribute2OneOf(String? attribute2OneOf);
}

class _$ObjectOneOf1 extends ObjectOneOf1 {
  @override
  final String attribute2OneOf;

  factory _$ObjectOneOf1([void Function(ObjectOneOf1Builder)? updates]) =>
      (ObjectOneOf1Builder()..update(updates))._build();

  _$ObjectOneOf1._({required this.attribute2OneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attribute2OneOf, r'ObjectOneOf1', 'attribute2OneOf');
  }

  @override
  ObjectOneOf1 rebuild(void Function(ObjectOneOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  ObjectOneOf1Builder toBuilder() => ObjectOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectOneOf1 && attribute2OneOf == other.attribute2OneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute2OneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ObjectOneOf1')..add('attribute2OneOf', attribute2OneOf)).toString();
  }
}

class ObjectOneOf1Builder implements Builder<ObjectOneOf1, ObjectOneOf1Builder>, $ObjectOneOf1InterfaceBuilder {
  _$ObjectOneOf1? _$v;

  String? _attribute2OneOf;
  String? get attribute2OneOf => _$this._attribute2OneOf;
  set attribute2OneOf(covariant String? attribute2OneOf) => _$this._attribute2OneOf = attribute2OneOf;

  ObjectOneOf1Builder();

  ObjectOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute2OneOf = $v.attribute2OneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ObjectOneOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectOneOf1;
  }

  @override
  void update(void Function(ObjectOneOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectOneOf1 build() => _build();

  _$ObjectOneOf1 _build() {
    final _$result = _$v ??
        _$ObjectOneOf1._(
            attribute2OneOf:
                BuiltValueNullFieldError.checkNotNull(attribute2OneOf, r'ObjectOneOf1', 'attribute2OneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $MixedOneOf1InterfaceBuilder {
  void replace($MixedOneOf1Interface other);
  void update(void Function($MixedOneOf1InterfaceBuilder) updates);
  String? get attributeOneOf;
  set attributeOneOf(String? attributeOneOf);
}

class _$MixedOneOf1 extends MixedOneOf1 {
  @override
  final String attributeOneOf;

  factory _$MixedOneOf1([void Function(MixedOneOf1Builder)? updates]) =>
      (MixedOneOf1Builder()..update(updates))._build();

  _$MixedOneOf1._({required this.attributeOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'MixedOneOf1', 'attributeOneOf');
  }

  @override
  MixedOneOf1 rebuild(void Function(MixedOneOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  MixedOneOf1Builder toBuilder() => MixedOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MixedOneOf1 && attributeOneOf == other.attributeOneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeOneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MixedOneOf1')..add('attributeOneOf', attributeOneOf)).toString();
  }
}

class MixedOneOf1Builder implements Builder<MixedOneOf1, MixedOneOf1Builder>, $MixedOneOf1InterfaceBuilder {
  _$MixedOneOf1? _$v;

  String? _attributeOneOf;
  String? get attributeOneOf => _$this._attributeOneOf;
  set attributeOneOf(covariant String? attributeOneOf) => _$this._attributeOneOf = attributeOneOf;

  MixedOneOf1Builder();

  MixedOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeOneOf = $v.attributeOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant MixedOneOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MixedOneOf1;
  }

  @override
  void update(void Function(MixedOneOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MixedOneOf1 build() => _build();

  _$MixedOneOf1 _build() {
    final _$result = _$v ??
        _$MixedOneOf1._(
            attributeOneOf: BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'MixedOneOf1', 'attributeOneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneObjectOneOf0InterfaceBuilder {
  void replace($OneObjectOneOf0Interface other);
  void update(void Function($OneObjectOneOf0InterfaceBuilder) updates);
  String? get attributeOneOf;
  set attributeOneOf(String? attributeOneOf);
}

class _$OneObjectOneOf0 extends OneObjectOneOf0 {
  @override
  final String attributeOneOf;

  factory _$OneObjectOneOf0([void Function(OneObjectOneOf0Builder)? updates]) =>
      (OneObjectOneOf0Builder()..update(updates))._build();

  _$OneObjectOneOf0._({required this.attributeOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneObjectOneOf0', 'attributeOneOf');
  }

  @override
  OneObjectOneOf0 rebuild(void Function(OneObjectOneOf0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  OneObjectOneOf0Builder toBuilder() => OneObjectOneOf0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneObjectOneOf0 && attributeOneOf == other.attributeOneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeOneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneObjectOneOf0')..add('attributeOneOf', attributeOneOf)).toString();
  }
}

class OneObjectOneOf0Builder
    implements Builder<OneObjectOneOf0, OneObjectOneOf0Builder>, $OneObjectOneOf0InterfaceBuilder {
  _$OneObjectOneOf0? _$v;

  String? _attributeOneOf;
  String? get attributeOneOf => _$this._attributeOneOf;
  set attributeOneOf(covariant String? attributeOneOf) => _$this._attributeOneOf = attributeOneOf;

  OneObjectOneOf0Builder();

  OneObjectOneOf0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeOneOf = $v.attributeOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneObjectOneOf0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneObjectOneOf0;
  }

  @override
  void update(void Function(OneObjectOneOf0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneObjectOneOf0 build() => _build();

  _$OneObjectOneOf0 _build() {
    final _$result = _$v ??
        _$OneObjectOneOf0._(
            attributeOneOf:
                BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneObjectOneOf0', 'attributeOneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneOfUnspecifiedArray0InterfaceBuilder {
  void replace($OneOfUnspecifiedArray0Interface other);
  void update(void Function($OneOfUnspecifiedArray0InterfaceBuilder) updates);
  String? get attributeOneOf;
  set attributeOneOf(String? attributeOneOf);
}

class _$OneOfUnspecifiedArray0 extends OneOfUnspecifiedArray0 {
  @override
  final String attributeOneOf;

  factory _$OneOfUnspecifiedArray0([void Function(OneOfUnspecifiedArray0Builder)? updates]) =>
      (OneOfUnspecifiedArray0Builder()..update(updates))._build();

  _$OneOfUnspecifiedArray0._({required this.attributeOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneOfUnspecifiedArray0', 'attributeOneOf');
  }

  @override
  OneOfUnspecifiedArray0 rebuild(void Function(OneOfUnspecifiedArray0Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OneOfUnspecifiedArray0Builder toBuilder() => OneOfUnspecifiedArray0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneOfUnspecifiedArray0 && attributeOneOf == other.attributeOneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeOneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneOfUnspecifiedArray0')..add('attributeOneOf', attributeOneOf)).toString();
  }
}

class OneOfUnspecifiedArray0Builder
    implements Builder<OneOfUnspecifiedArray0, OneOfUnspecifiedArray0Builder>, $OneOfUnspecifiedArray0InterfaceBuilder {
  _$OneOfUnspecifiedArray0? _$v;

  String? _attributeOneOf;
  String? get attributeOneOf => _$this._attributeOneOf;
  set attributeOneOf(covariant String? attributeOneOf) => _$this._attributeOneOf = attributeOneOf;

  OneOfUnspecifiedArray0Builder();

  OneOfUnspecifiedArray0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeOneOf = $v.attributeOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneOfUnspecifiedArray0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneOfUnspecifiedArray0;
  }

  @override
  void update(void Function(OneOfUnspecifiedArray0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneOfUnspecifiedArray0 build() => _build();

  _$OneOfUnspecifiedArray0 _build() {
    final _$result = _$v ??
        _$OneOfUnspecifiedArray0._(
            attributeOneOf:
                BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneOfUnspecifiedArray0', 'attributeOneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneOfStringArray0InterfaceBuilder {
  void replace($OneOfStringArray0Interface other);
  void update(void Function($OneOfStringArray0InterfaceBuilder) updates);
  String? get attributeOneOf;
  set attributeOneOf(String? attributeOneOf);
}

class _$OneOfStringArray0 extends OneOfStringArray0 {
  @override
  final String attributeOneOf;

  factory _$OneOfStringArray0([void Function(OneOfStringArray0Builder)? updates]) =>
      (OneOfStringArray0Builder()..update(updates))._build();

  _$OneOfStringArray0._({required this.attributeOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneOfStringArray0', 'attributeOneOf');
  }

  @override
  OneOfStringArray0 rebuild(void Function(OneOfStringArray0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  OneOfStringArray0Builder toBuilder() => OneOfStringArray0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneOfStringArray0 && attributeOneOf == other.attributeOneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeOneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneOfStringArray0')..add('attributeOneOf', attributeOneOf)).toString();
  }
}

class OneOfStringArray0Builder
    implements Builder<OneOfStringArray0, OneOfStringArray0Builder>, $OneOfStringArray0InterfaceBuilder {
  _$OneOfStringArray0? _$v;

  String? _attributeOneOf;
  String? get attributeOneOf => _$this._attributeOneOf;
  set attributeOneOf(covariant String? attributeOneOf) => _$this._attributeOneOf = attributeOneOf;

  OneOfStringArray0Builder();

  OneOfStringArray0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeOneOf = $v.attributeOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneOfStringArray0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneOfStringArray0;
  }

  @override
  void update(void Function(OneOfStringArray0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneOfStringArray0 build() => _build();

  _$OneOfStringArray0 _build() {
    final _$result = _$v ??
        _$OneOfStringArray0._(
            attributeOneOf:
                BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'OneOfStringArray0', 'attributeOneOf'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
