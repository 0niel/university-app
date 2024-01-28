// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_ofs.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BaseAllOf> _$baseAllOfSerializer = _$BaseAllOfSerializer();
Serializer<BaseOneOf1> _$baseOneOf1Serializer = _$BaseOneOf1Serializer();
Serializer<BaseAnyOf1> _$baseAnyOf1Serializer = _$BaseAnyOf1Serializer();
Serializer<BaseNestedAllOf> _$baseNestedAllOfSerializer = _$BaseNestedAllOfSerializer();
Serializer<BaseNestedOneOf3> _$baseNestedOneOf3Serializer = _$BaseNestedOneOf3Serializer();
Serializer<BaseNestedAnyOf3> _$baseNestedAnyOf3Serializer = _$BaseNestedAnyOf3Serializer();

class _$BaseAllOfSerializer implements StructuredSerializer<BaseAllOf> {
  @override
  final Iterable<Type> types = const [BaseAllOf, _$BaseAllOf];
  @override
  final String wireName = 'BaseAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseAllOf object,
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
  BaseAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseAllOfBuilder();

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

class _$BaseOneOf1Serializer implements StructuredSerializer<BaseOneOf1> {
  @override
  final Iterable<Type> types = const [BaseOneOf1, _$BaseOneOf1];
  @override
  final String wireName = 'BaseOneOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseOneOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-oneOf',
      serializers.serialize(object.attributeOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BaseOneOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseOneOf1Builder();

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

class _$BaseAnyOf1Serializer implements StructuredSerializer<BaseAnyOf1> {
  @override
  final Iterable<Type> types = const [BaseAnyOf1, _$BaseAnyOf1];
  @override
  final String wireName = 'BaseAnyOf1';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseAnyOf1 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-anyOf',
      serializers.serialize(object.attributeAnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BaseAnyOf1 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseAnyOf1Builder();

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

class _$BaseNestedAllOfSerializer implements StructuredSerializer<BaseNestedAllOf> {
  @override
  final Iterable<Type> types = const [BaseNestedAllOf, _$BaseNestedAllOf];
  @override
  final String wireName = 'BaseNestedAllOf';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseNestedAllOf object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'BaseOneOf',
      serializers.serialize(object.baseOneOf, specifiedType: const FullType(BaseOneOf)),
      'BaseAnyOf',
      serializers.serialize(object.baseAnyOf, specifiedType: const FullType(BaseAnyOf)),
      'attribute-nested-allOf',
      serializers.serialize(object.attributeNestedAllOf, specifiedType: const FullType(String)),
      'String',
      serializers.serialize(object.string, specifiedType: const FullType(String)),
      'attribute-allOf',
      serializers.serialize(object.attributeAllOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BaseNestedAllOf deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseNestedAllOfBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'BaseOneOf':
          result.baseOneOf = serializers.deserialize(value, specifiedType: const FullType(BaseOneOf))! as BaseOneOf;
          break;
        case 'BaseAnyOf':
          result.baseAnyOf = serializers.deserialize(value, specifiedType: const FullType(BaseAnyOf))! as BaseAnyOf;
          break;
        case 'attribute-nested-allOf':
          result.attributeNestedAllOf =
              serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
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

class _$BaseNestedOneOf3Serializer implements StructuredSerializer<BaseNestedOneOf3> {
  @override
  final Iterable<Type> types = const [BaseNestedOneOf3, _$BaseNestedOneOf3];
  @override
  final String wireName = 'BaseNestedOneOf3';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseNestedOneOf3 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-nested-oneOf',
      serializers.serialize(object.attributeNestedOneOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BaseNestedOneOf3 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseNestedOneOf3Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-nested-oneOf':
          result.attributeNestedOneOf =
              serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BaseNestedAnyOf3Serializer implements StructuredSerializer<BaseNestedAnyOf3> {
  @override
  final Iterable<Type> types = const [BaseNestedAnyOf3, _$BaseNestedAnyOf3];
  @override
  final String wireName = 'BaseNestedAnyOf3';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseNestedAnyOf3 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'attribute-nested-anyOf',
      serializers.serialize(object.attributeNestedAnyOf, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  BaseNestedAnyOf3 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseNestedAnyOf3Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute-nested-anyOf':
          result.attributeNestedAnyOf =
              serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $BaseAllOfInterfaceBuilder {
  void replace($BaseAllOfInterface other);
  void update(void Function($BaseAllOfInterfaceBuilder) updates);
  String? get string;
  set string(String? string);

  String? get attributeAllOf;
  set attributeAllOf(String? attributeAllOf);
}

class _$BaseAllOf extends BaseAllOf {
  @override
  final String string;
  @override
  final String attributeAllOf;

  factory _$BaseAllOf([void Function(BaseAllOfBuilder)? updates]) => (BaseAllOfBuilder()..update(updates))._build();

  _$BaseAllOf._({required this.string, required this.attributeAllOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(string, r'BaseAllOf', 'string');
    BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'BaseAllOf', 'attributeAllOf');
  }

  @override
  BaseAllOf rebuild(void Function(BaseAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseAllOfBuilder toBuilder() => BaseAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseAllOf && string == other.string && attributeAllOf == other.attributeAllOf;
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
    return (newBuiltValueToStringHelper(r'BaseAllOf')
          ..add('string', string)
          ..add('attributeAllOf', attributeAllOf))
        .toString();
  }
}

class BaseAllOfBuilder implements Builder<BaseAllOf, BaseAllOfBuilder>, $BaseAllOfInterfaceBuilder {
  _$BaseAllOf? _$v;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  String? _attributeAllOf;
  String? get attributeAllOf => _$this._attributeAllOf;
  set attributeAllOf(covariant String? attributeAllOf) => _$this._attributeAllOf = attributeAllOf;

  BaseAllOfBuilder();

  BaseAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _string = $v.string;
      _attributeAllOf = $v.attributeAllOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseAllOf;
  }

  @override
  void update(void Function(BaseAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseAllOf build() => _build();

  _$BaseAllOf _build() {
    final _$result = _$v ??
        _$BaseAllOf._(
            string: BuiltValueNullFieldError.checkNotNull(string, r'BaseAllOf', 'string'),
            attributeAllOf: BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'BaseAllOf', 'attributeAllOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseOneOf1InterfaceBuilder {
  void replace($BaseOneOf1Interface other);
  void update(void Function($BaseOneOf1InterfaceBuilder) updates);
  String? get attributeOneOf;
  set attributeOneOf(String? attributeOneOf);
}

class _$BaseOneOf1 extends BaseOneOf1 {
  @override
  final String attributeOneOf;

  factory _$BaseOneOf1([void Function(BaseOneOf1Builder)? updates]) => (BaseOneOf1Builder()..update(updates))._build();

  _$BaseOneOf1._({required this.attributeOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'BaseOneOf1', 'attributeOneOf');
  }

  @override
  BaseOneOf1 rebuild(void Function(BaseOneOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseOneOf1Builder toBuilder() => BaseOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseOneOf1 && attributeOneOf == other.attributeOneOf;
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
    return (newBuiltValueToStringHelper(r'BaseOneOf1')..add('attributeOneOf', attributeOneOf)).toString();
  }
}

class BaseOneOf1Builder implements Builder<BaseOneOf1, BaseOneOf1Builder>, $BaseOneOf1InterfaceBuilder {
  _$BaseOneOf1? _$v;

  String? _attributeOneOf;
  String? get attributeOneOf => _$this._attributeOneOf;
  set attributeOneOf(covariant String? attributeOneOf) => _$this._attributeOneOf = attributeOneOf;

  BaseOneOf1Builder();

  BaseOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeOneOf = $v.attributeOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseOneOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseOneOf1;
  }

  @override
  void update(void Function(BaseOneOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseOneOf1 build() => _build();

  _$BaseOneOf1 _build() {
    final _$result = _$v ??
        _$BaseOneOf1._(
            attributeOneOf: BuiltValueNullFieldError.checkNotNull(attributeOneOf, r'BaseOneOf1', 'attributeOneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseAnyOf1InterfaceBuilder {
  void replace($BaseAnyOf1Interface other);
  void update(void Function($BaseAnyOf1InterfaceBuilder) updates);
  String? get attributeAnyOf;
  set attributeAnyOf(String? attributeAnyOf);
}

class _$BaseAnyOf1 extends BaseAnyOf1 {
  @override
  final String attributeAnyOf;

  factory _$BaseAnyOf1([void Function(BaseAnyOf1Builder)? updates]) => (BaseAnyOf1Builder()..update(updates))._build();

  _$BaseAnyOf1._({required this.attributeAnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'BaseAnyOf1', 'attributeAnyOf');
  }

  @override
  BaseAnyOf1 rebuild(void Function(BaseAnyOf1Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseAnyOf1Builder toBuilder() => BaseAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseAnyOf1 && attributeAnyOf == other.attributeAnyOf;
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
    return (newBuiltValueToStringHelper(r'BaseAnyOf1')..add('attributeAnyOf', attributeAnyOf)).toString();
  }
}

class BaseAnyOf1Builder implements Builder<BaseAnyOf1, BaseAnyOf1Builder>, $BaseAnyOf1InterfaceBuilder {
  _$BaseAnyOf1? _$v;

  String? _attributeAnyOf;
  String? get attributeAnyOf => _$this._attributeAnyOf;
  set attributeAnyOf(covariant String? attributeAnyOf) => _$this._attributeAnyOf = attributeAnyOf;

  BaseAnyOf1Builder();

  BaseAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeAnyOf = $v.attributeAnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseAnyOf1 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseAnyOf1;
  }

  @override
  void update(void Function(BaseAnyOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseAnyOf1 build() => _build();

  _$BaseAnyOf1 _build() {
    final _$result = _$v ??
        _$BaseAnyOf1._(
            attributeAnyOf: BuiltValueNullFieldError.checkNotNull(attributeAnyOf, r'BaseAnyOf1', 'attributeAnyOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseNestedAllOfInterfaceBuilder implements $BaseAllOfInterfaceBuilder {
  void replace(covariant $BaseNestedAllOfInterface other);
  void update(void Function($BaseNestedAllOfInterfaceBuilder) updates);
  BaseOneOf? get baseOneOf;
  set baseOneOf(covariant BaseOneOf? baseOneOf);

  BaseAnyOf? get baseAnyOf;
  set baseAnyOf(covariant BaseAnyOf? baseAnyOf);

  String? get attributeNestedAllOf;
  set attributeNestedAllOf(covariant String? attributeNestedAllOf);

  String? get string;
  set string(covariant String? string);

  String? get attributeAllOf;
  set attributeAllOf(covariant String? attributeAllOf);
}

class _$BaseNestedAllOf extends BaseNestedAllOf {
  @override
  final BaseOneOf baseOneOf;
  @override
  final BaseAnyOf baseAnyOf;
  @override
  final String attributeNestedAllOf;
  @override
  final String string;
  @override
  final String attributeAllOf;

  factory _$BaseNestedAllOf([void Function(BaseNestedAllOfBuilder)? updates]) =>
      (BaseNestedAllOfBuilder()..update(updates))._build();

  _$BaseNestedAllOf._(
      {required this.baseOneOf,
      required this.baseAnyOf,
      required this.attributeNestedAllOf,
      required this.string,
      required this.attributeAllOf})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(baseOneOf, r'BaseNestedAllOf', 'baseOneOf');
    BuiltValueNullFieldError.checkNotNull(baseAnyOf, r'BaseNestedAllOf', 'baseAnyOf');
    BuiltValueNullFieldError.checkNotNull(attributeNestedAllOf, r'BaseNestedAllOf', 'attributeNestedAllOf');
    BuiltValueNullFieldError.checkNotNull(string, r'BaseNestedAllOf', 'string');
    BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'BaseNestedAllOf', 'attributeAllOf');
  }

  @override
  BaseNestedAllOf rebuild(void Function(BaseNestedAllOfBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseNestedAllOfBuilder toBuilder() => BaseNestedAllOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is BaseNestedAllOf &&
        baseOneOf == _$dynamicOther.baseOneOf &&
        baseAnyOf == _$dynamicOther.baseAnyOf &&
        attributeNestedAllOf == other.attributeNestedAllOf &&
        string == other.string &&
        attributeAllOf == other.attributeAllOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseOneOf.hashCode);
    _$hash = $jc(_$hash, baseAnyOf.hashCode);
    _$hash = $jc(_$hash, attributeNestedAllOf.hashCode);
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jc(_$hash, attributeAllOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseNestedAllOf')
          ..add('baseOneOf', baseOneOf)
          ..add('baseAnyOf', baseAnyOf)
          ..add('attributeNestedAllOf', attributeNestedAllOf)
          ..add('string', string)
          ..add('attributeAllOf', attributeAllOf))
        .toString();
  }
}

class BaseNestedAllOfBuilder
    implements Builder<BaseNestedAllOf, BaseNestedAllOfBuilder>, $BaseNestedAllOfInterfaceBuilder {
  _$BaseNestedAllOf? _$v;

  BaseOneOf? _baseOneOf;
  BaseOneOf? get baseOneOf => _$this._baseOneOf;
  set baseOneOf(covariant BaseOneOf? baseOneOf) => _$this._baseOneOf = baseOneOf;

  BaseAnyOf? _baseAnyOf;
  BaseAnyOf? get baseAnyOf => _$this._baseAnyOf;
  set baseAnyOf(covariant BaseAnyOf? baseAnyOf) => _$this._baseAnyOf = baseAnyOf;

  String? _attributeNestedAllOf;
  String? get attributeNestedAllOf => _$this._attributeNestedAllOf;
  set attributeNestedAllOf(covariant String? attributeNestedAllOf) =>
      _$this._attributeNestedAllOf = attributeNestedAllOf;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  String? _attributeAllOf;
  String? get attributeAllOf => _$this._attributeAllOf;
  set attributeAllOf(covariant String? attributeAllOf) => _$this._attributeAllOf = attributeAllOf;

  BaseNestedAllOfBuilder();

  BaseNestedAllOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseOneOf = $v.baseOneOf;
      _baseAnyOf = $v.baseAnyOf;
      _attributeNestedAllOf = $v.attributeNestedAllOf;
      _string = $v.string;
      _attributeAllOf = $v.attributeAllOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseNestedAllOf other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseNestedAllOf;
  }

  @override
  void update(void Function(BaseNestedAllOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseNestedAllOf build() => _build();

  _$BaseNestedAllOf _build() {
    final _$result = _$v ??
        _$BaseNestedAllOf._(
            baseOneOf: BuiltValueNullFieldError.checkNotNull(baseOneOf, r'BaseNestedAllOf', 'baseOneOf'),
            baseAnyOf: BuiltValueNullFieldError.checkNotNull(baseAnyOf, r'BaseNestedAllOf', 'baseAnyOf'),
            attributeNestedAllOf:
                BuiltValueNullFieldError.checkNotNull(attributeNestedAllOf, r'BaseNestedAllOf', 'attributeNestedAllOf'),
            string: BuiltValueNullFieldError.checkNotNull(string, r'BaseNestedAllOf', 'string'),
            attributeAllOf:
                BuiltValueNullFieldError.checkNotNull(attributeAllOf, r'BaseNestedAllOf', 'attributeAllOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseNestedOneOf3InterfaceBuilder {
  void replace($BaseNestedOneOf3Interface other);
  void update(void Function($BaseNestedOneOf3InterfaceBuilder) updates);
  String? get attributeNestedOneOf;
  set attributeNestedOneOf(String? attributeNestedOneOf);
}

class _$BaseNestedOneOf3 extends BaseNestedOneOf3 {
  @override
  final String attributeNestedOneOf;

  factory _$BaseNestedOneOf3([void Function(BaseNestedOneOf3Builder)? updates]) =>
      (BaseNestedOneOf3Builder()..update(updates))._build();

  _$BaseNestedOneOf3._({required this.attributeNestedOneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeNestedOneOf, r'BaseNestedOneOf3', 'attributeNestedOneOf');
  }

  @override
  BaseNestedOneOf3 rebuild(void Function(BaseNestedOneOf3Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseNestedOneOf3Builder toBuilder() => BaseNestedOneOf3Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseNestedOneOf3 && attributeNestedOneOf == other.attributeNestedOneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeNestedOneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseNestedOneOf3')..add('attributeNestedOneOf', attributeNestedOneOf))
        .toString();
  }
}

class BaseNestedOneOf3Builder
    implements Builder<BaseNestedOneOf3, BaseNestedOneOf3Builder>, $BaseNestedOneOf3InterfaceBuilder {
  _$BaseNestedOneOf3? _$v;

  String? _attributeNestedOneOf;
  String? get attributeNestedOneOf => _$this._attributeNestedOneOf;
  set attributeNestedOneOf(covariant String? attributeNestedOneOf) =>
      _$this._attributeNestedOneOf = attributeNestedOneOf;

  BaseNestedOneOf3Builder();

  BaseNestedOneOf3Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeNestedOneOf = $v.attributeNestedOneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseNestedOneOf3 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseNestedOneOf3;
  }

  @override
  void update(void Function(BaseNestedOneOf3Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseNestedOneOf3 build() => _build();

  _$BaseNestedOneOf3 _build() {
    final _$result = _$v ??
        _$BaseNestedOneOf3._(
            attributeNestedOneOf: BuiltValueNullFieldError.checkNotNull(
                attributeNestedOneOf, r'BaseNestedOneOf3', 'attributeNestedOneOf'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseNestedAnyOf3InterfaceBuilder {
  void replace($BaseNestedAnyOf3Interface other);
  void update(void Function($BaseNestedAnyOf3InterfaceBuilder) updates);
  String? get attributeNestedAnyOf;
  set attributeNestedAnyOf(String? attributeNestedAnyOf);
}

class _$BaseNestedAnyOf3 extends BaseNestedAnyOf3 {
  @override
  final String attributeNestedAnyOf;

  factory _$BaseNestedAnyOf3([void Function(BaseNestedAnyOf3Builder)? updates]) =>
      (BaseNestedAnyOf3Builder()..update(updates))._build();

  _$BaseNestedAnyOf3._({required this.attributeNestedAnyOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(attributeNestedAnyOf, r'BaseNestedAnyOf3', 'attributeNestedAnyOf');
  }

  @override
  BaseNestedAnyOf3 rebuild(void Function(BaseNestedAnyOf3Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseNestedAnyOf3Builder toBuilder() => BaseNestedAnyOf3Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseNestedAnyOf3 && attributeNestedAnyOf == other.attributeNestedAnyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attributeNestedAnyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseNestedAnyOf3')..add('attributeNestedAnyOf', attributeNestedAnyOf))
        .toString();
  }
}

class BaseNestedAnyOf3Builder
    implements Builder<BaseNestedAnyOf3, BaseNestedAnyOf3Builder>, $BaseNestedAnyOf3InterfaceBuilder {
  _$BaseNestedAnyOf3? _$v;

  String? _attributeNestedAnyOf;
  String? get attributeNestedAnyOf => _$this._attributeNestedAnyOf;
  set attributeNestedAnyOf(covariant String? attributeNestedAnyOf) =>
      _$this._attributeNestedAnyOf = attributeNestedAnyOf;

  BaseNestedAnyOf3Builder();

  BaseNestedAnyOf3Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attributeNestedAnyOf = $v.attributeNestedAnyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseNestedAnyOf3 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseNestedAnyOf3;
  }

  @override
  void update(void Function(BaseNestedAnyOf3Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseNestedAnyOf3 build() => _build();

  _$BaseNestedAnyOf3 _build() {
    final _$result = _$v ??
        _$BaseNestedAnyOf3._(
            attributeNestedAnyOf: BuiltValueNullFieldError.checkNotNull(
                attributeNestedAnyOf, r'BaseNestedAnyOf3', 'attributeNestedAnyOf'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
