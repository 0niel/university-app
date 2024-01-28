// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Base> _$baseSerializer = _$BaseSerializer();

class _$BaseSerializer implements StructuredSerializer<Base> {
  @override
  final Iterable<Type> types = const [Base, _$Base];
  @override
  final String wireName = 'Base';

  @override
  Iterable<Object?> serialize(Serializers serializers, Base object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.$bool;
    if (value != null) {
      result
        ..add('bool')
        ..add(serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.integer;
    if (value != null) {
      result
        ..add('integer')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.$double;
    if (value != null) {
      result
        ..add('double')
        ..add(serializers.serialize(value, specifiedType: const FullType(double)));
    }
    value = object.$num;
    if (value != null) {
      result
        ..add('num')
        ..add(serializers.serialize(value, specifiedType: const FullType(num)));
    }
    value = object.string;
    if (value != null) {
      result
        ..add('string')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.contentString;
    if (value != null) {
      result
        ..add('content-string')
        ..add(serializers.serialize(value, specifiedType: const FullType(ContentString, [FullType(int)])));
    }
    value = object.stringBinary;
    if (value != null) {
      result
        ..add('string-binary')
        ..add(serializers.serialize(value, specifiedType: const FullType(Uint8List)));
    }
    value = object.list;
    if (value != null) {
      result
        ..add('list')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonObject)])));
    }
    value = object.listNever;
    if (value != null) {
      result
        ..add('list-never')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Never)])));
    }
    value = object.listString;
    if (value != null) {
      result
        ..add('list-string')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)])));
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
        case 'bool':
          result.$bool = serializers.deserialize(value, specifiedType: const FullType(bool)) as bool?;
          break;
        case 'integer':
          result.integer = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'double':
          result.$double = serializers.deserialize(value, specifiedType: const FullType(double)) as double?;
          break;
        case 'num':
          result.$num = serializers.deserialize(value, specifiedType: const FullType(num)) as num?;
          break;
        case 'string':
          result.string = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'content-string':
          result.contentString.replace(serializers.deserialize(value,
              specifiedType: const FullType(ContentString, [FullType(int)]))! as ContentString<int>);
          break;
        case 'string-binary':
          result.stringBinary = serializers.deserialize(value, specifiedType: const FullType(Uint8List)) as Uint8List?;
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonObject)]))! as BuiltList<Object?>);
          break;
        case 'list-never':
          result.listNever.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Never)]))! as BuiltList<Object?>);
          break;
        case 'list-string':
          result.listString.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $BaseInterfaceBuilder {
  void replace($BaseInterface other);
  void update(void Function($BaseInterfaceBuilder) updates);
  bool? get $bool;
  set $bool(bool? $bool);

  int? get integer;
  set integer(int? integer);

  double? get $double;
  set $double(double? $double);

  num? get $num;
  set $num(num? $num);

  String? get string;
  set string(String? string);

  ContentStringBuilder<int> get contentString;
  set contentString(ContentStringBuilder<int>? contentString);

  Uint8List? get stringBinary;
  set stringBinary(Uint8List? stringBinary);

  ListBuilder<JsonObject> get list;
  set list(ListBuilder<JsonObject>? list);

  ListBuilder<Never> get listNever;
  set listNever(ListBuilder<Never>? listNever);

  ListBuilder<String> get listString;
  set listString(ListBuilder<String>? listString);
}

class _$Base extends Base {
  @override
  final bool? $bool;
  @override
  final int? integer;
  @override
  final double? $double;
  @override
  final num? $num;
  @override
  final String? string;
  @override
  final ContentString<int>? contentString;
  @override
  final Uint8List? stringBinary;
  @override
  final BuiltList<JsonObject>? list;
  @override
  final BuiltList<Never>? listNever;
  @override
  final BuiltList<String>? listString;

  factory _$Base([void Function(BaseBuilder)? updates]) => (BaseBuilder()..update(updates))._build();

  _$Base._(
      {this.$bool,
      this.integer,
      this.$double,
      this.$num,
      this.string,
      this.contentString,
      this.stringBinary,
      this.list,
      this.listNever,
      this.listString})
      : super._();

  @override
  Base rebuild(void Function(BaseBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  BaseBuilder toBuilder() => BaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Base &&
        $bool == other.$bool &&
        integer == other.integer &&
        $double == other.$double &&
        $num == other.$num &&
        string == other.string &&
        contentString == other.contentString &&
        stringBinary == other.stringBinary &&
        list == other.list &&
        listNever == other.listNever &&
        listString == other.listString;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, $bool.hashCode);
    _$hash = $jc(_$hash, integer.hashCode);
    _$hash = $jc(_$hash, $double.hashCode);
    _$hash = $jc(_$hash, $num.hashCode);
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jc(_$hash, contentString.hashCode);
    _$hash = $jc(_$hash, stringBinary.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, listNever.hashCode);
    _$hash = $jc(_$hash, listString.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Base')
          ..add('\$bool', $bool)
          ..add('integer', integer)
          ..add('\$double', $double)
          ..add('\$num', $num)
          ..add('string', string)
          ..add('contentString', contentString)
          ..add('stringBinary', stringBinary)
          ..add('list', list)
          ..add('listNever', listNever)
          ..add('listString', listString))
        .toString();
  }
}

class BaseBuilder implements Builder<Base, BaseBuilder>, $BaseInterfaceBuilder {
  _$Base? _$v;

  bool? _$bool;
  bool? get $bool => _$this._$bool;
  set $bool(covariant bool? $bool) => _$this._$bool = $bool;

  int? _integer;
  int? get integer => _$this._integer;
  set integer(covariant int? integer) => _$this._integer = integer;

  double? _$double;
  double? get $double => _$this._$double;
  set $double(covariant double? $double) => _$this._$double = $double;

  num? _$num;
  num? get $num => _$this._$num;
  set $num(covariant num? $num) => _$this._$num = $num;

  String? _string;
  String? get string => _$this._string;
  set string(covariant String? string) => _$this._string = string;

  ContentStringBuilder<int>? _contentString;
  ContentStringBuilder<int> get contentString => _$this._contentString ??= ContentStringBuilder<int>();
  set contentString(covariant ContentStringBuilder<int>? contentString) => _$this._contentString = contentString;

  Uint8List? _stringBinary;
  Uint8List? get stringBinary => _$this._stringBinary;
  set stringBinary(covariant Uint8List? stringBinary) => _$this._stringBinary = stringBinary;

  ListBuilder<JsonObject>? _list;
  ListBuilder<JsonObject> get list => _$this._list ??= ListBuilder<JsonObject>();
  set list(covariant ListBuilder<JsonObject>? list) => _$this._list = list;

  ListBuilder<Never>? _listNever;
  ListBuilder<Never> get listNever => _$this._listNever ??= ListBuilder<Never>();
  set listNever(covariant ListBuilder<Never>? listNever) => _$this._listNever = listNever;

  ListBuilder<String>? _listString;
  ListBuilder<String> get listString => _$this._listString ??= ListBuilder<String>();
  set listString(covariant ListBuilder<String>? listString) => _$this._listString = listString;

  BaseBuilder();

  BaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _$bool = $v.$bool;
      _integer = $v.integer;
      _$double = $v.$double;
      _$num = $v.$num;
      _string = $v.string;
      _contentString = $v.contentString?.toBuilder();
      _stringBinary = $v.stringBinary;
      _list = $v.list?.toBuilder();
      _listNever = $v.listNever?.toBuilder();
      _listString = $v.listString?.toBuilder();
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
    _$Base _$result;
    try {
      _$result = _$v ??
          _$Base._(
              $bool: $bool,
              integer: integer,
              $double: $double,
              $num: $num,
              string: string,
              contentString: _contentString?.build(),
              stringBinary: stringBinary,
              list: _list?.build(),
              listNever: _listNever?.build(),
              listString: _listString?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contentString';
        _contentString?.build();

        _$failedField = 'list';
        _list?.build();
        _$failedField = 'listNever';
        _listNever?.build();
        _$failedField = 'listString';
        _listString?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Base', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
