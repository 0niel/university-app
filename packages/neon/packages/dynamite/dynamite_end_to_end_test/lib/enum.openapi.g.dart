// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnumString _$enumStringTest = EnumString._('test');
const EnumString _$enumString$default = EnumString._('\$default');
const EnumString _$enumStringDollar = EnumString._('dollar');

EnumString _$valueOfEnumString(String name) {
  switch (name) {
    case 'test':
      return _$enumStringTest;
    case '\$default':
      return _$enumString$default;
    case 'dollar':
      return _$enumStringDollar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnumString> _$enumStringValues = BuiltSet<EnumString>(const <EnumString>[
  _$enumStringTest,
  _$enumString$default,
  _$enumStringDollar,
]);

const EnumInt _$enumInt$0 = EnumInt._('\$0');
const EnumInt _$enumInt$1 = EnumInt._('\$1');
const EnumInt _$enumInt$2 = EnumInt._('\$2');

EnumInt _$valueOfEnumInt(String name) {
  switch (name) {
    case '\$0':
      return _$enumInt$0;
    case '\$1':
      return _$enumInt$1;
    case '\$2':
      return _$enumInt$2;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnumInt> _$enumIntValues = BuiltSet<EnumInt>(const <EnumInt>[
  _$enumInt$0,
  _$enumInt$1,
  _$enumInt$2,
]);

const EnumDynamic _$enumDynamic$0 = EnumDynamic._('\$0');
const EnumDynamic _$enumDynamicString = EnumDynamic._('string');
const EnumDynamic _$enumDynamic$false = EnumDynamic._('\$false');

EnumDynamic _$valueOfEnumDynamic(String name) {
  switch (name) {
    case '\$0':
      return _$enumDynamic$0;
    case 'string':
      return _$enumDynamicString;
    case '\$false':
      return _$enumDynamic$false;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnumDynamic> _$enumDynamicValues = BuiltSet<EnumDynamic>(const <EnumDynamic>[
  _$enumDynamic$0,
  _$enumDynamicString,
  _$enumDynamic$false,
]);

const WrappedEnum_$String _$wrappedEnum$StringTest = WrappedEnum_$String._('test');
const WrappedEnum_$String _$wrappedEnum$String$default = WrappedEnum_$String._('\$default');

WrappedEnum_$String _$valueOfWrappedEnum_$String(String name) {
  switch (name) {
    case 'test':
      return _$wrappedEnum$StringTest;
    case '\$default':
      return _$wrappedEnum$String$default;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WrappedEnum_$String> _$wrappedEnum$StringValues =
    BuiltSet<WrappedEnum_$String>(const <WrappedEnum_$String>[
  _$wrappedEnum$StringTest,
  _$wrappedEnum$String$default,
]);

const WrappedEnum_Integer _$wrappedEnumInteger$0 = WrappedEnum_Integer._('\$0');
const WrappedEnum_Integer _$wrappedEnumInteger$1 = WrappedEnum_Integer._('\$1');
const WrappedEnum_Integer _$wrappedEnumInteger$2 = WrappedEnum_Integer._('\$2');

WrappedEnum_Integer _$valueOfWrappedEnum_Integer(String name) {
  switch (name) {
    case '\$0':
      return _$wrappedEnumInteger$0;
    case '\$1':
      return _$wrappedEnumInteger$1;
    case '\$2':
      return _$wrappedEnumInteger$2;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WrappedEnum_Integer> _$wrappedEnumIntegerValues =
    BuiltSet<WrappedEnum_Integer>(const <WrappedEnum_Integer>[
  _$wrappedEnumInteger$0,
  _$wrappedEnumInteger$1,
  _$wrappedEnumInteger$2,
]);

Serializer<WrappedEnum> _$wrappedEnumSerializer = _$WrappedEnumSerializer();
Serializer<EnumReference> _$enumReferenceSerializer = _$EnumReferenceSerializer();

class _$WrappedEnumSerializer implements StructuredSerializer<WrappedEnum> {
  @override
  final Iterable<Type> types = const [WrappedEnum, _$WrappedEnum];
  @override
  final String wireName = 'WrappedEnum';

  @override
  Iterable<Object?> serialize(Serializers serializers, WrappedEnum object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'String',
      serializers.serialize(object.string, specifiedType: const FullType(WrappedEnum_$String)),
      'integer',
      serializers.serialize(object.integer, specifiedType: const FullType(WrappedEnum_Integer)),
    ];

    return result;
  }

  @override
  WrappedEnum deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = WrappedEnumBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'String':
          result.string = serializers.deserialize(value, specifiedType: const FullType(WrappedEnum_$String))!
              as WrappedEnum_$String;
          break;
        case 'integer':
          result.integer = serializers.deserialize(value, specifiedType: const FullType(WrappedEnum_Integer))!
              as WrappedEnum_Integer;
          break;
      }
    }

    return result.build();
  }
}

class _$EnumReferenceSerializer implements StructuredSerializer<EnumReference> {
  @override
  final Iterable<Type> types = const [EnumReference, _$EnumReference];
  @override
  final String wireName = 'EnumReference';

  @override
  Iterable<Object?> serialize(Serializers serializers, EnumReference object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'string',
      serializers.serialize(object.string, specifiedType: const FullType(EnumString)),
    ];

    return result;
  }

  @override
  EnumReference deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = EnumReferenceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'string':
          result.string = serializers.deserialize(value, specifiedType: const FullType(EnumString))! as EnumString;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $WrappedEnumInterfaceBuilder {
  void replace($WrappedEnumInterface other);
  void update(void Function($WrappedEnumInterfaceBuilder) updates);
  WrappedEnum_$String? get string;
  set string(WrappedEnum_$String? string);

  WrappedEnum_Integer? get integer;
  set integer(WrappedEnum_Integer? integer);
}

class _$WrappedEnum extends WrappedEnum {
  @override
  final WrappedEnum_$String string;
  @override
  final WrappedEnum_Integer integer;

  factory _$WrappedEnum([void Function(WrappedEnumBuilder)? updates]) =>
      (WrappedEnumBuilder()..update(updates))._build();

  _$WrappedEnum._({required this.string, required this.integer}) : super._() {
    BuiltValueNullFieldError.checkNotNull(string, r'WrappedEnum', 'string');
    BuiltValueNullFieldError.checkNotNull(integer, r'WrappedEnum', 'integer');
  }

  @override
  WrappedEnum rebuild(void Function(WrappedEnumBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  WrappedEnumBuilder toBuilder() => WrappedEnumBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WrappedEnum && string == other.string && integer == other.integer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jc(_$hash, integer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WrappedEnum')
          ..add('string', string)
          ..add('integer', integer))
        .toString();
  }
}

class WrappedEnumBuilder implements Builder<WrappedEnum, WrappedEnumBuilder>, $WrappedEnumInterfaceBuilder {
  _$WrappedEnum? _$v;

  WrappedEnum_$String? _string;
  WrappedEnum_$String? get string => _$this._string;
  set string(covariant WrappedEnum_$String? string) => _$this._string = string;

  WrappedEnum_Integer? _integer;
  WrappedEnum_Integer? get integer => _$this._integer;
  set integer(covariant WrappedEnum_Integer? integer) => _$this._integer = integer;

  WrappedEnumBuilder();

  WrappedEnumBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _string = $v.string;
      _integer = $v.integer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant WrappedEnum other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WrappedEnum;
  }

  @override
  void update(void Function(WrappedEnumBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WrappedEnum build() => _build();

  _$WrappedEnum _build() {
    final _$result = _$v ??
        _$WrappedEnum._(
            string: BuiltValueNullFieldError.checkNotNull(string, r'WrappedEnum', 'string'),
            integer: BuiltValueNullFieldError.checkNotNull(integer, r'WrappedEnum', 'integer'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $EnumReferenceInterfaceBuilder {
  void replace($EnumReferenceInterface other);
  void update(void Function($EnumReferenceInterfaceBuilder) updates);
  EnumString? get string;
  set string(EnumString? string);
}

class _$EnumReference extends EnumReference {
  @override
  final EnumString string;

  factory _$EnumReference([void Function(EnumReferenceBuilder)? updates]) =>
      (EnumReferenceBuilder()..update(updates))._build();

  _$EnumReference._({required this.string}) : super._() {
    BuiltValueNullFieldError.checkNotNull(string, r'EnumReference', 'string');
  }

  @override
  EnumReference rebuild(void Function(EnumReferenceBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  EnumReferenceBuilder toBuilder() => EnumReferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnumReference && string == other.string;
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
    return (newBuiltValueToStringHelper(r'EnumReference')..add('string', string)).toString();
  }
}

class EnumReferenceBuilder implements Builder<EnumReference, EnumReferenceBuilder>, $EnumReferenceInterfaceBuilder {
  _$EnumReference? _$v;

  EnumString? _string;
  EnumString? get string => _$this._string;
  set string(covariant EnumString? string) => _$this._string = string;

  EnumReferenceBuilder();

  EnumReferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _string = $v.string;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant EnumReference other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$EnumReference;
  }

  @override
  void update(void Function(EnumReferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnumReference build() => _build();

  _$EnumReference _build() {
    final _$result =
        _$v ?? _$EnumReference._(string: BuiltValueNullFieldError.checkNotNull(string, r'EnumReference', 'string'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
