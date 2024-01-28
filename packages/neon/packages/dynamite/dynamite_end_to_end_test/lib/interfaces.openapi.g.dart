// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Base> _$baseSerializer = _$BaseSerializer();
Serializer<BaseInterface> _$baseInterfaceSerializer = _$BaseInterfaceSerializer();

class _$BaseSerializer implements StructuredSerializer<Base> {
  @override
  final Iterable<Type> types = const [Base, _$Base];
  @override
  final String wireName = 'Base';

  @override
  Iterable<Object?> serialize(Serializers serializers, Base object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.attribute;
    if (value != null) {
      result
        ..add('attribute')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Base deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute':
          result.attribute = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$BaseInterfaceSerializer implements StructuredSerializer<BaseInterface> {
  @override
  final Iterable<Type> types = const [BaseInterface, _$BaseInterface];
  @override
  final String wireName = 'BaseInterface';

  @override
  Iterable<Object?> serialize(Serializers serializers, BaseInterface object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.attribute;
    if (value != null) {
      result
        ..add('attribute')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BaseInterface deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = BaseInterfaceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'attribute':
          result.attribute = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $BaseInterfaceBuilder {
  void replace($BaseInterface other);
  void update(void Function($BaseInterfaceBuilder) updates);
  String? get attribute;
  set attribute(String? attribute);
}

class _$Base extends Base {
  @override
  final String? attribute;

  factory _$Base([void Function(BaseBuilder)? updates]) => (BaseBuilder()..update(updates))._build();

  _$Base._({this.attribute}) : super._();

  @override
  Base rebuild(void Function(BaseBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseBuilder toBuilder() => BaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Base && attribute == other.attribute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Base')..add('attribute', attribute)).toString();
  }
}

class BaseBuilder implements Builder<Base, BaseBuilder>, $BaseInterfaceBuilder {
  _$Base? _$v;

  String? _attribute;
  String? get attribute => _$this._attribute;
  set attribute(covariant String? attribute) => _$this._attribute = attribute;

  BaseBuilder();

  BaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute = $v.attribute;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Base other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Base;
  }

  @override
  void update(void Function(BaseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Base build() => _build();

  _$Base _build() {
    final _$result = _$v ?? _$Base._(attribute: attribute);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $BaseInterfaceInterfaceBuilder {
  void replace($BaseInterfaceInterface other);
  void update(void Function($BaseInterfaceInterfaceBuilder) updates);
  String? get attribute;
  set attribute(String? attribute);
}

class _$BaseInterface extends BaseInterface {
  @override
  final String? attribute;

  factory _$BaseInterface([void Function(BaseInterfaceBuilder)? updates]) =>
      (BaseInterfaceBuilder()..update(updates))._build();

  _$BaseInterface._({this.attribute}) : super._();

  @override
  BaseInterface rebuild(void Function(BaseInterfaceBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseInterfaceBuilder toBuilder() => BaseInterfaceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseInterface && attribute == other.attribute;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attribute.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseInterface')..add('attribute', attribute)).toString();
  }
}

class BaseInterfaceBuilder implements Builder<BaseInterface, BaseInterfaceBuilder>, $BaseInterfaceInterfaceBuilder {
  _$BaseInterface? _$v;

  String? _attribute;
  String? get attribute => _$this._attribute;
  set attribute(covariant String? attribute) => _$this._attribute = attribute;

  BaseInterfaceBuilder();

  BaseInterfaceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attribute = $v.attribute;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant BaseInterface other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BaseInterface;
  }

  @override
  void update(void Function(BaseInterfaceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseInterface build() => _build();

  _$BaseInterface _build() {
    final _$result = _$v ?? _$BaseInterface._(attribute: attribute);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
