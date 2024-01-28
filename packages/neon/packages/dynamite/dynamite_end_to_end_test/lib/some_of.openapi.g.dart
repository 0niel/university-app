// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'some_of.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OneValueSomeOfInObject> _$oneValueSomeOfInObjectSerializer = _$OneValueSomeOfInObjectSerializer();

class _$OneValueSomeOfInObjectSerializer implements StructuredSerializer<OneValueSomeOfInObject> {
  @override
  final Iterable<Type> types = const [OneValueSomeOfInObject, _$OneValueSomeOfInObject];
  @override
  final String wireName = 'OneValueSomeOfInObject';

  @override
  Iterable<Object?> serialize(Serializers serializers, OneValueSomeOfInObject object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'OneValue',
      serializers.serialize(object.oneValue, specifiedType: const FullType(int)),
      'IntDouble',
      serializers.serialize(object.intDouble, specifiedType: const FullType(num)),
    ];
    Object? value;
    value = object.intDoubleString;
    if (value != null) {
      result
        ..add('IntDoubleString')
        ..add(serializers.serialize(value, specifiedType: const FullType(OneValueSomeOfInObject_IntDoubleString)));
    }
    return result;
  }

  @override
  OneValueSomeOfInObject deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OneValueSomeOfInObjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'OneValue':
          result.oneValue = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'IntDouble':
          result.intDouble = serializers.deserialize(value, specifiedType: const FullType(num))! as num;
          break;
        case 'IntDoubleString':
          result.intDoubleString =
              serializers.deserialize(value, specifiedType: const FullType(OneValueSomeOfInObject_IntDoubleString))
                  as OneValueSomeOfInObject_IntDoubleString?;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $OneValueSomeOfInObjectInterfaceBuilder {
  void replace($OneValueSomeOfInObjectInterface other);
  void update(void Function($OneValueSomeOfInObjectInterfaceBuilder) updates);
  int? get oneValue;
  set oneValue(int? oneValue);

  num? get intDouble;
  set intDouble(num? intDouble);

  OneValueSomeOfInObject_IntDoubleString? get intDoubleString;
  set intDoubleString(OneValueSomeOfInObject_IntDoubleString? intDoubleString);
}

class _$OneValueSomeOfInObject extends OneValueSomeOfInObject {
  @override
  final int oneValue;
  @override
  final num intDouble;
  @override
  final OneValueSomeOfInObject_IntDoubleString? intDoubleString;

  factory _$OneValueSomeOfInObject([void Function(OneValueSomeOfInObjectBuilder)? updates]) =>
      (OneValueSomeOfInObjectBuilder()..update(updates))._build();

  _$OneValueSomeOfInObject._({required this.oneValue, required this.intDouble, this.intDoubleString}) : super._() {
    BuiltValueNullFieldError.checkNotNull(oneValue, r'OneValueSomeOfInObject', 'oneValue');
    BuiltValueNullFieldError.checkNotNull(intDouble, r'OneValueSomeOfInObject', 'intDouble');
  }

  @override
  OneValueSomeOfInObject rebuild(void Function(OneValueSomeOfInObjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OneValueSomeOfInObjectBuilder toBuilder() => OneValueSomeOfInObjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final dynamic _$dynamicOther = other;
    return other is OneValueSomeOfInObject &&
        oneValue == other.oneValue &&
        intDouble == other.intDouble &&
        intDoubleString == _$dynamicOther.intDoubleString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneValue.hashCode);
    _$hash = $jc(_$hash, intDouble.hashCode);
    _$hash = $jc(_$hash, intDoubleString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OneValueSomeOfInObject')
          ..add('oneValue', oneValue)
          ..add('intDouble', intDouble)
          ..add('intDoubleString', intDoubleString))
        .toString();
  }
}

class OneValueSomeOfInObjectBuilder
    implements Builder<OneValueSomeOfInObject, OneValueSomeOfInObjectBuilder>, $OneValueSomeOfInObjectInterfaceBuilder {
  _$OneValueSomeOfInObject? _$v;

  int? _oneValue;
  int? get oneValue => _$this._oneValue;
  set oneValue(covariant int? oneValue) => _$this._oneValue = oneValue;

  num? _intDouble;
  num? get intDouble => _$this._intDouble;
  set intDouble(covariant num? intDouble) => _$this._intDouble = intDouble;

  OneValueSomeOfInObject_IntDoubleString? _intDoubleString;
  OneValueSomeOfInObject_IntDoubleString? get intDoubleString => _$this._intDoubleString;
  set intDoubleString(covariant OneValueSomeOfInObject_IntDoubleString? intDoubleString) =>
      _$this._intDoubleString = intDoubleString;

  OneValueSomeOfInObjectBuilder();

  OneValueSomeOfInObjectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneValue = $v.oneValue;
      _intDouble = $v.intDouble;
      _intDoubleString = $v.intDoubleString;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant OneValueSomeOfInObject other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OneValueSomeOfInObject;
  }

  @override
  void update(void Function(OneValueSomeOfInObjectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OneValueSomeOfInObject build() => _build();

  _$OneValueSomeOfInObject _build() {
    OneValueSomeOfInObject._validate(this);
    final _$result = _$v ??
        _$OneValueSomeOfInObject._(
            oneValue: BuiltValueNullFieldError.checkNotNull(oneValue, r'OneValueSomeOfInObject', 'oneValue'),
            intDouble: BuiltValueNullFieldError.checkNotNull(intDouble, r'OneValueSomeOfInObject', 'intDouble'),
            intDoubleString: intDoubleString);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
