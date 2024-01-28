// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_of.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ObjectAllOf> _$objectAllOfSerializer = _$ObjectAllOfSerializer();
Serializer<OneObjectAllOf> _$oneObjectAllOfSerializer = _$OneObjectAllOfSerializer();
Serializer<PrimitiveAllOf> _$primitiveAllOfSerializer = _$PrimitiveAllOfSerializer();
Serializer<MixedAllOf> _$mixedAllOfSerializer = _$MixedAllOfSerializer();
Serializer<OneValueAllOf> _$oneValueAllOfSerializer = _$OneValueAllOfSerializer();

class _$ObjectAllOfSerializer implements StructuredSerializer<ObjectAllOf> {
  @override
  final Iterable<Type> types = const [ObjectAllOf, _$ObjectAllOf];
  @override
  final String wireName = 'ObjectAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, ObjectAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute1-allOf',
      serializers.serialize(object.attribute1AllOf, specifiedType: const FullType(String)),
      'attribute2-allOf',
      serializers.serialize(object.attribute2AllOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ObjectAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ObjectAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute1-allOf':
          result.attribute1AllOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'attribute2-allOf':
          result.attribute2AllOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneObjectAllOfSerializer implements StructuredSerializer<OneObjectAllOf> {
  @override
  final Iterable<Type> types = const [OneObjectAllOf, _$OneObjectAllOf];
  @override
  final String wireName = 'OneObjectAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneObjectAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-allOf',
      serializers.serialize(object.attributeAllOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneObjectAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneObjectAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-allOf':
          result.attributeAllOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$PrimitiveAllOfSerializer implements StructuredSerializer<PrimitiveAllOf> {
  @override
  final Iterable<Type> types = const [PrimitiveAllOf, _$PrimitiveAllOf];
  @override
  final String wireName = 'PrimitiveAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, PrimitiveAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'int',
      serializers.serialize(object.$int, specifiedType: const FullType(int)),
      'String',
      serializers.serialize(object.string, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  PrimitiveAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PrimitiveAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'int':
          result.$int = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'String':
          result.string = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MixedAllOfSerializer implements StructuredSerializer<MixedAllOf> {
  @override
  final Iterable<Type> types = const [MixedAllOf, _$MixedAllOf];
  @override
  final String wireName = 'MixedAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, MixedAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'String',
      serializers.serialize(object.string, specifiedType: const FullType(String)),
      'attribute-allOf',
      serializers.serialize(object.attributeAllOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MixedAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = MixedAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'String':
          result.string = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'attribute-allOf':
          result.attributeAllOf = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$OneValueAllOfSerializer implements StructuredSerializer<OneValueAllOf> {
  @override
  final Iterable<Type> types = const [OneValueAllOf, _$OneValueAllOf];
  @override
  final String wireName = 'OneValueAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneValueAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'String',
      serializers.serialize(object.string, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  OneValueAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneValueAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'String':
          result.string = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $ObjectAllOfInterfaceBuilder {
  void replace($ObjectAllOfInterface other);
  void update(void Function($ObjectAllOfInterfaceBuilder) updates);
  String? get attribute1AllOf;
  set attribute1AllOf(String? attribute1AllOf);

  String? get attribute2AllOf;
  set attribute2AllOf(String? attribute2AllOf);
}

class _$ObjectAllOf extends ObjectAllOf {
  @override
  final String attribute1AllOf;
  @override
  final String attribute2AllOf;

  factory _$ObjectAllOf([void Function(ObjectAllOfBuilder)? updates]) =>
      (ObjectAllOfBuilder()..update(updates))._build();

  _$ObjectAllOf._({required this.attribute1AllOf, required this.attribute2AllOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attribute1AllOf, r'ObjectAllOf', 'attribute1AllOf');
    BuiltValueNullFieldError.checkNotNull(attribute2AllOf, r'ObjectAllOf', 'attribute2AllOf');
  }

  @override
  ObjectAllOf rebuild(void Function(ObjectAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ObjectAllOfBuilder toBuilder() => ObjectAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectAllOf && attribute1AllOf == other.attribute1AllOf && attribute2AllOf == other.attribute2AllOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute1AllOf.hashCode);
    _$hash = $jc(_$hash, attribute2AllOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ObjectAllOf')
          ..add('attribute1AllOf', attribute1AllOf)
          ..add('attribute2AllOf', attribute2AllOf))
        .toString();
  }
}

class ObjectAllOfBuilder implements Builder<ObjectAllOf, ObjectAllOfBuilder>, $ObjectAllOfInterfaceBuilder {
  _$ObjectAllOf? _$v;

  String? _attribute1AllOf;
  String? get attribute1AllOf => _$this._attribute1AllOf;
  set attribute1AllOf(covariant String? attribute1AllOf) => _$this._attribute1AllOf = attribute1AllOf;

  String? _attribute2AllOf;
  String? get attribute2AllOf => _$this._attribute2AllOf;
  set attribute2AllOf(covariant String? attribute2AllOf) => _$this._attribute2AllOf = attribute2AllOf;

  ObjectAllOfBuilder();

  ObjectAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute1AllOf = $v.attribute1AllOf;
      _attribute2AllOf = $v.attribute2AllOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ObjectAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectAllOf;
  }

  @override
  void update(void Function(ObjectAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectAllOf build() => _build();

  _$ObjectAllOf _build() {
    final _$result = _$v ??
        _$ObjectAllOf._(
            attribute1AllOf: BuiltValueNullFieldError.checkNotNull(attribute1AllOf, r'ObjectAllOf', 'attribute1AllOf'),
            attribute2AllOf: BuiltValueNullFieldError.checkNotNull(attribute2AllOf, r'ObjectAllOf', 'attribute2AllOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneObjectAllOfInterfaceBuilder {
  void replace($OneObjectAllOfInterface other);
  void update(void Function($OneObjectAllOfInterfaceBuilder) updates);
  String? get attributeAllOf;
  set attributeAllOf(String? attributeAllOf);
}

class _$OneObjectAllOf extends OneObjectAllOf {
  @override
  final String attributeAllOf;

  factory _$OneObjectAllOf([void Function(OneObjectAllOfBuilder)? updates]) =>
      (OneObjectAllOfBuilder()..update(updates))._build();

  _$OneObjectAllOf._({required this.attributeAllOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'OneObjectAllOf', 'attributeAllOf');
  }

  @override
  OneObjectAllOf rebuild(void Function(OneObjectAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OneObjectAllOfBuilder toBuilder() => OneObjectAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneObjectAllOf && attributeAllOf == other.attributeAllOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeAllOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneObjectAllOf')..add('attributeAllOf', attributeAllOf)).toString();
  }
}

class OneObjectAllOfBuilder implements Builder<OneObjectAllOf, OneObjectAllOfBuilder>, $OneObjectAllOfInterfaceBuilder {
  _$OneObjectAllOf? _$v;

  String? _attributeAllOf;
  String? get attributeAllOf => _$this._attributeAllOf;
  set attributeAllOf(covariant String? attributeAllOf) => _$this._attributeAllOf = attributeAllOf;

  OneObjectAllOfBuilder();

  OneObjectAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeAllOf = $v.attributeAllOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneObjectAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneObjectAllOf;
  }

  @override
  void update(void Function(OneObjectAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneObjectAllOf build() => _build();

  _$OneObjectAllOf _build() {
    final _$result = _$v ??
        _$OneObjectAllOf._(
            attributeAllOf: BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'OneObjectAllOf', 'attributeAllOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PrimitiveAllOfInterfaceBuilder {
  void replace($PrimitiveAllOfInterface other);
  void update(void Function($PrimitiveAllOfInterfaceBuilder) updates);
  int? get $int;
  set $int(int? $int);

  String? get string;
  set string(String? string);
}

class _$PrimitiveAllOf extends PrimitiveAllOf {
  @override
  final int $int;
  @override
  final String string;

  factory _$PrimitiveAllOf([void Function(PrimitiveAllOfBuilder)? updates]) =>
      (PrimitiveAllOfBuilder()..update(updates))._build();

  _$PrimitiveAllOf._({required this.$int, required this.string}) : super._() {
    BuiltValueNullFieldError.checkNotNull($int, r'PrimitiveAllOf', '\$int');
    BuiltValueNullFieldError.checkNotNull(string, r'PrimitiveAllOf', 'string');
  }

  @override
  PrimitiveAllOf rebuild(void Function(PrimitiveAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PrimitiveAllOfBuilder toBuilder() => PrimitiveAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrimitiveAllOf && $int == other.$int && string == other.string;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, $int.hashCode);
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrimitiveAllOf')
          ..add('\$int', $int)
          ..add('string', string))
        .toString();
  }
}

class PrimitiveAllOfBuilder implements Builder<PrimitiveAllOf, PrimitiveAllOfBuilder>, $PrimitiveAllOfInterfaceBuilder {
  _$PrimitiveAllOf? _$v;

  int? _$int;
  int? get $int => _$this._$int;
  set $int(covariant int? $int) => _$this._$int = $int;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  PrimitiveAllOfBuilder();

  PrimitiveAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _$int = $v.$int;
      _string = $v.string;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant PrimitiveAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PrimitiveAllOf;
  }

  @override
  void update(void Function(PrimitiveAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrimitiveAllOf build() => _build();

  _$PrimitiveAllOf _build() {
    final _$result = _$v ??
        _$PrimitiveAllOf._(
            $int: BuiltValueNullFieldError.checkNotNull($int, r'PrimitiveAllOf', '\$int'),
            string: BuiltValueNullFieldError.checkNotNull(string, r'PrimitiveAllOf', 'string'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $MixedAllOfInterfaceBuilder {
  void replace($MixedAllOfInterface other);
  void update(void Function($MixedAllOfInterfaceBuilder) updates);
  String? get string;
  set string(String? string);

  String? get attributeAllOf;
  set attributeAllOf(String? attributeAllOf);
}

class _$MixedAllOf extends MixedAllOf {
  @override
  final String string;
  @override
  final String attributeAllOf;

  factory _$MixedAllOf([void Function(MixedAllOfBuilder)? updates]) => (MixedAllOfBuilder()..update(updates))._build();

  _$MixedAllOf._({required this.string, required this.attributeAllOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(string, r'MixedAllOf', 'string');
    BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'MixedAllOf', 'attributeAllOf');
  }

  @override
  MixedAllOf rebuild(void Function(MixedAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  MixedAllOfBuilder toBuilder() => MixedAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MixedAllOf && string == other.string && attributeAllOf == other.attributeAllOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jc(_$hash, attributeAllOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MixedAllOf')
          ..add('string', string)
          ..add('attributeAllOf', attributeAllOf))
        .toString();
  }
}

class MixedAllOfBuilder implements Builder<MixedAllOf, MixedAllOfBuilder>, $MixedAllOfInterfaceBuilder {
  _$MixedAllOf? _$v;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  String? _attributeAllOf;
  String? get attributeAllOf => _$this._attributeAllOf;
  set attributeAllOf(covariant String? attributeAllOf) => _$this._attributeAllOf = attributeAllOf;

  MixedAllOfBuilder();

  MixedAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _string = $v.string;
      _attributeAllOf = $v.attributeAllOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant MixedAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MixedAllOf;
  }

  @override
  void update(void Function(MixedAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MixedAllOf build() => _build();

  _$MixedAllOf _build() {
    final _$result = _$v ??
        _$MixedAllOf._(
            string: BuiltValueNullFieldError.checkNotNull(string, r'MixedAllOf', 'string'),
            attributeAllOf: BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'MixedAllOf', 'attributeAllOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $OneValueAllOfInterfaceBuilder {
  void replace($OneValueAllOfInterface other);
  void update(void Function($OneValueAllOfInterfaceBuilder) updates);
  String? get string;
  set string(String? string);
}

class _$OneValueAllOf extends OneValueAllOf {
  @override
  final String string;

  factory _$OneValueAllOf([void Function(OneValueAllOfBuilder)? updates]) =>
      (OneValueAllOfBuilder()..update(updates))._build();

  _$OneValueAllOf._({required this.string}) : super._() {
    BuiltValueNullFieldError.checkNotNull(string, r'OneValueAllOf', 'string');
  }

  @override
  OneValueAllOf rebuild(void Function(OneValueAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OneValueAllOfBuilder toBuilder() => OneValueAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OneValueAllOf && string == other.string;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneValueAllOf')..add('string', string)).toString();
  }
}

class OneValueAllOfBuilder implements Builder<OneValueAllOf, OneValueAllOfBuilder>, $OneValueAllOfInterfaceBuilder {
  _$OneValueAllOf? _$v;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  OneValueAllOfBuilder();

  OneValueAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _string = $v.string;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneValueAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneValueAllOf;
  }

  @override
  void update(void Function(OneValueAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneValueAllOf build() => _build();

  _$OneValueAllOf _build() {
    final _$result =
        _$v ?? _$OneValueAllOf._(string: BuiltValueNullFieldError.checkNotNull(string, r'OneValueAllOf', 'string'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
