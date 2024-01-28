// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_defs.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Base> _$baseSerializer = _$BaseSerializer();
Serializer<NestedRedirect> _$nestedRedirectSerializer = _$NestedRedirectSerializer();

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

class _$NestedRedirectSerializer implements StructuredSerializer<NestedRedirect> {
  @override
  final Iterable<Type> types = const [NestedRedirect, _$NestedRedirect];
  @override
  final String wireName = 'NestedRedirect';

  @override
  Iterable<Object?> serialize(Serializers serializers, NestedRedirect object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.redirect;
    if (value != null) {
      result
        ..add('redirect')
        ..add(serializers.serialize(value, specifiedType: const FullType(Base)));
    }
    value = object.redirectBaseType;
    if (value != null) {
      result
        ..add('redirectBaseType')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.redirectEmptyType;
    if (value != null) {
      result
        ..add('redirectEmptyType')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonObject)));
    }
    return result;
  }

  @override
  NestedRedirect deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = NestedRedirectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'redirect':
          result.redirect.replace(serializers.deserialize(value, specifiedType: const FullType(Base))! as Base);
          break;
        case 'redirectBaseType':
          result.redirectBaseType = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'redirectEmptyType':
          result.redirectEmptyType =
              serializers.deserialize(value, specifiedType: const FullType(JsonObject)) as JsonObject?;
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

abstract mixin class $NestedRedirectInterfaceBuilder {
  void replace($NestedRedirectInterface other);
  void update(void Function($NestedRedirectInterfaceBuilder) updates);
  BaseBuilder get redirect;
  set redirect(BaseBuilder? redirect);

  int? get redirectBaseType;
  set redirectBaseType(int? redirectBaseType);

  JsonObject? get redirectEmptyType;
  set redirectEmptyType(JsonObject? redirectEmptyType);
}

class _$NestedRedirect extends NestedRedirect {
  @override
  final Base? redirect;
  @override
  final int? redirectBaseType;
  @override
  final JsonObject? redirectEmptyType;

  factory _$NestedRedirect([void Function(NestedRedirectBuilder)? updates]) =>
      (NestedRedirectBuilder()..update(updates))._build();

  _$NestedRedirect._({this.redirect, this.redirectBaseType, this.redirectEmptyType}) : super._();

  @override
  NestedRedirect rebuild(void Function(NestedRedirectBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  NestedRedirectBuilder toBuilder() => NestedRedirectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NestedRedirect &&
        redirect == other.redirect &&
        redirectBaseType == other.redirectBaseType &&
        redirectEmptyType == other.redirectEmptyType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, redirect.hashCode);
    _$hash = $jc(_$hash, redirectBaseType.hashCode);
    _$hash = $jc(_$hash, redirectEmptyType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NestedRedirect')
          ..add('redirect', redirect)
          ..add('redirectBaseType', redirectBaseType)
          ..add('redirectEmptyType', redirectEmptyType))
        .toString();
  }
}

class NestedRedirectBuilder implements Builder<NestedRedirect, NestedRedirectBuilder>, $NestedRedirectInterfaceBuilder {
  _$NestedRedirect? _$v;

  BaseBuilder? _redirect;
  BaseBuilder get redirect => _$this._redirect ??= BaseBuilder();
  set redirect(covariant BaseBuilder? redirect) => _$this._redirect = redirect;

  int? _redirectBaseType;
  int? get redirectBaseType => _$this._redirectBaseType;
  set redirectBaseType(covariant int? redirectBaseType) => _$this._redirectBaseType = redirectBaseType;

  JsonObject? _redirectEmptyType;
  JsonObject? get redirectEmptyType => _$this._redirectEmptyType;
  set redirectEmptyType(covariant JsonObject? redirectEmptyType) => _$this._redirectEmptyType = redirectEmptyType;

  NestedRedirectBuilder();

  NestedRedirectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _redirect = $v.redirect?.toBuilder();
      _redirectBaseType = $v.redirectBaseType;
      _redirectEmptyType = $v.redirectEmptyType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant NestedRedirect other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NestedRedirect;
  }

  @override
  void update(void Function(NestedRedirectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NestedRedirect build() => _build();

  _$NestedRedirect _build() {
    _$NestedRedirect _$result;
    try {
      _$result = _$v ??
          _$NestedRedirect._(
              redirect: _redirect?.build(), redirectBaseType: redirectBaseType, redirectEmptyType: redirectEmptyType);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'redirect';
        _redirect?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'NestedRedirect', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
