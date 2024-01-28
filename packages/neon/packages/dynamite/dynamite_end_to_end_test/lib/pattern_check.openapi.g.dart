// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pattern_check.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TestObject> _$testObjectSerializer = _$TestObjectSerializer();

class _$TestObjectSerializer implements StructuredSerializer<TestObject> {
  @override
  final Iterable<Type> types = const [TestObject, _$TestObject];
  @override
  final String wireName = 'TestObject';

  @override
  Iterable<Object?> serialize(Serializers serializers, TestObject object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.onlyNumbers;
    if (value != null) {
      result
        ..add('only-numbers')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.minLength;
    if (value != null) {
      result
        ..add('min-length')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.maxLength;
    if (value != null) {
      result
        ..add('max-length')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.multipleChecks;
    if (value != null) {
      result
        ..add('multiple-checks')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TestObject deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = TestObjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'only-numbers':
          result.onlyNumbers = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'min-length':
          result.minLength = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'max-length':
          result.maxLength = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'multiple-checks':
          result.multipleChecks = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $TestObjectInterfaceBuilder {
  void replace($TestObjectInterface other);
  void update(void Function($TestObjectInterfaceBuilder) updates);
  String? get onlyNumbers;
  set onlyNumbers(String? onlyNumbers);

  String? get minLength;
  set minLength(String? minLength);

  String? get maxLength;
  set maxLength(String? maxLength);

  String? get multipleChecks;
  set multipleChecks(String? multipleChecks);
}

class _$TestObject extends TestObject {
  @override
  final String? onlyNumbers;
  @override
  final String? minLength;
  @override
  final String? maxLength;
  @override
  final String? multipleChecks;

  factory _$TestObject([void Function(TestObjectBuilder)? updates]) => (TestObjectBuilder()..update(updates))._build();

  _$TestObject._({this.onlyNumbers, this.minLength, this.maxLength, this.multipleChecks}) : super._();

  @override
  TestObject rebuild(void Function(TestObjectBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  TestObjectBuilder toBuilder() => TestObjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TestObject &&
        onlyNumbers == other.onlyNumbers &&
        minLength == other.minLength &&
        maxLength == other.maxLength &&
        multipleChecks == other.multipleChecks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, onlyNumbers.hashCode);
    _$hash = $jc(_$hash, minLength.hashCode);
    _$hash = $jc(_$hash, maxLength.hashCode);
    _$hash = $jc(_$hash, multipleChecks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TestObject')
          ..add('onlyNumbers', onlyNumbers)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength)
          ..add('multipleChecks', multipleChecks))
        .toString();
  }
}

class TestObjectBuilder implements Builder<TestObject, TestObjectBuilder>, $TestObjectInterfaceBuilder {
  _$TestObject? _$v;

  String? _onlyNumbers;
  String? get onlyNumbers => _$this._onlyNumbers;
  set onlyNumbers(covariant String? onlyNumbers) => _$this._onlyNumbers = onlyNumbers;

  String? _minLength;
  String? get minLength => _$this._minLength;
  set minLength(covariant String? minLength) => _$this._minLength = minLength;

  String? _maxLength;
  String? get maxLength => _$this._maxLength;
  set maxLength(covariant String? maxLength) => _$this._maxLength = maxLength;

  String? _multipleChecks;
  String? get multipleChecks => _$this._multipleChecks;
  set multipleChecks(covariant String? multipleChecks) => _$this._multipleChecks = multipleChecks;

  TestObjectBuilder();

  TestObjectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _onlyNumbers = $v.onlyNumbers;
      _minLength = $v.minLength;
      _maxLength = $v.maxLength;
      _multipleChecks = $v.multipleChecks;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant TestObject other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TestObject;
  }

  @override
  void update(void Function(TestObjectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TestObject build() => _build();

  _$TestObject _build() {
    TestObject._validate(this);
    final _$result = _$v ??
        _$TestObject._(
            onlyNumbers: onlyNumbers, minLength: minLength, maxLength: maxLength, multipleChecks: multipleChecks);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
