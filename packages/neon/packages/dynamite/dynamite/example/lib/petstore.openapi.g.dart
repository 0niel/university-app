// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'petstore.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NewPet> _$newPetSerializer = _$NewPetSerializer();
Serializer<Pet> _$petSerializer = _$PetSerializer();
Serializer<Error> _$errorSerializer = _$ErrorSerializer();

class _$NewPetSerializer implements StructuredSerializer<NewPet> {
  @override
  final Iterable<Type> types = const [NewPet, _$NewPet];
  @override
  final String wireName = 'NewPet';

  @override
  Iterable<Object?> serialize(Serializers serializers, NewPet object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.tag;
    if (value != null) {
      result
        ..add('tag')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  NewPet deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = NewPetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'tag':
          result.tag = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$PetSerializer implements StructuredSerializer<Pet> {
  @override
  final Iterable<Type> types = const [Pet, _$Pet];
  @override
  final String wireName = 'Pet';

  @override
  Iterable<Object?> serialize(Serializers serializers, Pet object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.tag;
    if (value != null) {
      result
        ..add('tag')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Pet deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'tag':
          result.tag = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ErrorSerializer implements StructuredSerializer<Error> {
  @override
  final Iterable<Type> types = const [Error, _$Error];
  @override
  final String wireName = 'Error';

  @override
  Iterable<Object?> serialize(Serializers serializers, Error object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'code',
      serializers.serialize(object.code, specifiedType: const FullType(int)),
      'message',
      serializers.serialize(object.message, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Error deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ErrorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'code':
          result.code = serializers.deserialize(value, specifiedType: const FullType(int))! as int;
          break;
        case 'message':
          result.message = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $NewPetInterfaceBuilder {
  void replace($NewPetInterface other);
  void update(void Function($NewPetInterfaceBuilder) updates);
  String? get name;
  set name(String? name);

  String? get tag;
  set tag(String? tag);
}

class _$NewPet extends NewPet {
  @override
  final String name;
  @override
  final String? tag;

  factory _$NewPet([void Function(NewPetBuilder)? updates]) => (NewPetBuilder()..update(updates))._build();

  _$NewPet._({required this.name, this.tag}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'NewPet', 'name');
  }

  @override
  NewPet rebuild(void Function(NewPetBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  NewPetBuilder toBuilder() => NewPetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewPet && name == other.name && tag == other.tag;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, tag.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NewPet')
          ..add('name', name)
          ..add('tag', tag))
        .toString();
  }
}

class NewPetBuilder implements Builder<NewPet, NewPetBuilder>, $NewPetInterfaceBuilder {
  _$NewPet? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(covariant String? name) => _$this._name = name;

  String? _tag;
  String? get tag => _$this._tag;
  set tag(covariant String? tag) => _$this._tag = tag;

  NewPetBuilder();

  NewPetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _tag = $v.tag;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant NewPet other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NewPet;
  }

  @override
  void update(void Function(NewPetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NewPet build() => _build();

  _$NewPet _build() {
    final _$result = _$v ?? _$NewPet._(name: BuiltValueNullFieldError.checkNotNull(name, r'NewPet', 'name'), tag: tag);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $PetInterfaceBuilder implements $NewPetInterfaceBuilder {
  void replace(covariant $PetInterface other);
  void update(void Function($PetInterfaceBuilder) updates);
  int? get id;
  set id(covariant int? id);

  String? get name;
  set name(covariant String? name);

  String? get tag;
  set tag(covariant String? tag);
}

class _$Pet extends Pet {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? tag;

  factory _$Pet([void Function(PetBuilder)? updates]) => (PetBuilder()..update(updates))._build();

  _$Pet._({required this.id, required this.name, this.tag}) : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Pet', 'id');
    BuiltValueNullFieldError.checkNotNull(name, r'Pet', 'name');
  }

  @override
  Pet rebuild(void Function(PetBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PetBuilder toBuilder() => PetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pet && id == other.id && name == other.name && tag == other.tag;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, tag.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Pet')
          ..add('id', id)
          ..add('name', name)
          ..add('tag', tag))
        .toString();
  }
}

class PetBuilder implements Builder<Pet, PetBuilder>, $PetInterfaceBuilder {
  _$Pet? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(covariant int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(covariant String? name) => _$this._name = name;

  String? _tag;
  String? get tag => _$this._tag;
  set tag(covariant String? tag) => _$this._tag = tag;

  PetBuilder();

  PetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _tag = $v.tag;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Pet other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Pet;
  }

  @override
  void update(void Function(PetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Pet build() => _build();

  _$Pet _build() {
    final _$result = _$v ??
        _$Pet._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Pet', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'Pet', 'name'),
            tag: tag);
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $ErrorInterfaceBuilder {
  void replace($ErrorInterface other);
  void update(void Function($ErrorInterfaceBuilder) updates);
  int? get code;
  set code(int? code);

  String? get message;
  set message(String? message);
}

class _$Error extends Error {
  @override
  final int code;
  @override
  final String message;

  factory _$Error([void Function(ErrorBuilder)? updates]) => (ErrorBuilder()..update(updates))._build();

  _$Error._({required this.code, required this.message}) : super._() {
    BuiltValueNullFieldError.checkNotNull(code, r'Error', 'code');
    BuiltValueNullFieldError.checkNotNull(message, r'Error', 'message');
  }

  @override
  Error rebuild(void Function(ErrorBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ErrorBuilder toBuilder() => ErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Error && code == other.code && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Error')
          ..add('code', code)
          ..add('message', message))
        .toString();
  }
}

class ErrorBuilder implements Builder<Error, ErrorBuilder>, $ErrorInterfaceBuilder {
  _$Error? _$v;

  int? _code;
  int? get code => _$this._code;
  set code(covariant int? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(covariant String? message) => _$this._message = message;

  ErrorBuilder();

  ErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Error other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Error;
  }

  @override
  void update(void Function(ErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Error build() => _build();

  _$Error _build() {
    final _$result = _$v ??
        _$Error._(
            code: BuiltValueNullFieldError.checkNotNull(code, r'Error', 'code'),
            message: BuiltValueNullFieldError.checkNotNull(message, r'Error', 'message'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
