// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headers.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GetHeaders> _$getHeadersSerializer = _$GetHeadersSerializer();
Serializer<WithContentOperationIdHeaders> _$withContentOperationIdHeadersSerializer =
    _$WithContentOperationIdHeadersSerializer();
Serializer<GetWithContentHeaders> _$getWithContentHeadersSerializer = _$GetWithContentHeadersSerializer();

class _$GetHeadersSerializer implements StructuredSerializer<GetHeaders> {
  @override
  final Iterable<Type> types = const [GetHeaders, _$GetHeaders];
  @override
  final String wireName = 'GetHeaders';

  @override
  Iterable<Object?> serialize(Serializers serializers, GetHeaders object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.myHeader;
    if (value != null) {
      result
        ..add('my-header')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GetHeaders deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GetHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'my-header':
          result.myHeader = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$WithContentOperationIdHeadersSerializer implements StructuredSerializer<WithContentOperationIdHeaders> {
  @override
  final Iterable<Type> types = const [WithContentOperationIdHeaders, _$WithContentOperationIdHeaders];
  @override
  final String wireName = 'WithContentOperationIdHeaders';

  @override
  Iterable<Object?> serialize(Serializers serializers, WithContentOperationIdHeaders object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.myHeader;
    if (value != null) {
      result
        ..add('my-header')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  WithContentOperationIdHeaders deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = WithContentOperationIdHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'my-header':
          result.myHeader = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GetWithContentHeadersSerializer implements StructuredSerializer<GetWithContentHeaders> {
  @override
  final Iterable<Type> types = const [GetWithContentHeaders, _$GetWithContentHeaders];
  @override
  final String wireName = 'GetWithContentHeaders';

  @override
  Iterable<Object?> serialize(Serializers serializers, GetWithContentHeaders object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.myHeader;
    if (value != null) {
      result
        ..add('my-header')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GetWithContentHeaders deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = GetWithContentHeadersBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'my-header':
          result.myHeader = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $GetHeadersInterfaceBuilder {
  void replace($GetHeadersInterface other);
  void update(void Function($GetHeadersInterfaceBuilder) updates);
  String? get myHeader;
  set myHeader(String? myHeader);
}

class _$GetHeaders extends GetHeaders {
  @override
  final String? myHeader;

  factory _$GetHeaders([void Function(GetHeadersBuilder)? updates]) => (GetHeadersBuilder()..update(updates))._build();

  _$GetHeaders._({this.myHeader}) : super._();

  @override
  GetHeaders rebuild(void Function(GetHeadersBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  GetHeadersBuilder toBuilder() => GetHeadersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetHeaders && myHeader == other.myHeader;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, myHeader.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetHeaders')..add('myHeader', myHeader)).toString();
  }
}

class GetHeadersBuilder implements Builder<GetHeaders, GetHeadersBuilder>, $GetHeadersInterfaceBuilder {
  _$GetHeaders? _$v;

  String? _myHeader;
  String? get myHeader => _$this._myHeader;
  set myHeader(covariant String? myHeader) => _$this._myHeader = myHeader;

  GetHeadersBuilder();

  GetHeadersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _myHeader = $v.myHeader;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant GetHeaders other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GetHeaders;
  }

  @override
  void update(void Function(GetHeadersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetHeaders build() => _build();

  _$GetHeaders _build() {
    final _$result = _$v ?? _$GetHeaders._(myHeader: myHeader);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $WithContentOperationIdHeadersInterfaceBuilder {
  void replace($WithContentOperationIdHeadersInterface other);
  void update(void Function($WithContentOperationIdHeadersInterfaceBuilder) updates);
  String? get myHeader;
  set myHeader(String? myHeader);
}

class _$WithContentOperationIdHeaders extends WithContentOperationIdHeaders {
  @override
  final String? myHeader;

  factory _$WithContentOperationIdHeaders([void Function(WithContentOperationIdHeadersBuilder)? updates]) =>
      (WithContentOperationIdHeadersBuilder()..update(updates))._build();

  _$WithContentOperationIdHeaders._({this.myHeader}) : super._();

  @override
  WithContentOperationIdHeaders rebuild(void Function(WithContentOperationIdHeadersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithContentOperationIdHeadersBuilder toBuilder() => WithContentOperationIdHeadersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithContentOperationIdHeaders && myHeader == other.myHeader;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, myHeader.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithContentOperationIdHeaders')..add('myHeader', myHeader)).toString();
  }
}

class WithContentOperationIdHeadersBuilder
    implements
        Builder<WithContentOperationIdHeaders, WithContentOperationIdHeadersBuilder>,
        $WithContentOperationIdHeadersInterfaceBuilder {
  _$WithContentOperationIdHeaders? _$v;

  String? _myHeader;
  String? get myHeader => _$this._myHeader;
  set myHeader(covariant String? myHeader) => _$this._myHeader = myHeader;

  WithContentOperationIdHeadersBuilder();

  WithContentOperationIdHeadersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _myHeader = $v.myHeader;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant WithContentOperationIdHeaders other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WithContentOperationIdHeaders;
  }

  @override
  void update(void Function(WithContentOperationIdHeadersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithContentOperationIdHeaders build() => _build();

  _$WithContentOperationIdHeaders _build() {
    final _$result = _$v ?? _$WithContentOperationIdHeaders._(myHeader: myHeader);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $GetWithContentHeadersInterfaceBuilder {
  void replace($GetWithContentHeadersInterface other);
  void update(void Function($GetWithContentHeadersInterfaceBuilder) updates);
  String? get myHeader;
  set myHeader(String? myHeader);
}

class _$GetWithContentHeaders extends GetWithContentHeaders {
  @override
  final String? myHeader;

  factory _$GetWithContentHeaders([void Function(GetWithContentHeadersBuilder)? updates]) =>
      (GetWithContentHeadersBuilder()..update(updates))._build();

  _$GetWithContentHeaders._({this.myHeader}) : super._();

  @override
  GetWithContentHeaders rebuild(void Function(GetWithContentHeadersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetWithContentHeadersBuilder toBuilder() => GetWithContentHeadersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetWithContentHeaders && myHeader == other.myHeader;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, myHeader.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetWithContentHeaders')..add('myHeader', myHeader)).toString();
  }
}

class GetWithContentHeadersBuilder
    implements Builder<GetWithContentHeaders, GetWithContentHeadersBuilder>, $GetWithContentHeadersInterfaceBuilder {
  _$GetWithContentHeaders? _$v;

  String? _myHeader;
  String? get myHeader => _$this._myHeader;
  set myHeader(covariant String? myHeader) => _$this._myHeader = myHeader;

  GetWithContentHeadersBuilder();

  GetWithContentHeadersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _myHeader = $v.myHeader;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant GetWithContentHeaders other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GetWithContentHeaders;
  }

  @override
  void update(void Function(GetWithContentHeadersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetWithContentHeaders build() => _build();

  _$GetWithContentHeaders _build() {
    final _$result = _$v ?? _$GetWithContentHeaders._(myHeader: myHeader);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
