// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Header> _$headerSerializer = _$HeaderSerializer();

class _$HeaderSerializer implements StructuredSerializer<Header> {
  @override
  final Iterable<Type> types = const [Header, _$Header];
  @override
  final String wireName = 'Header';

  @override
  Iterable<Object?> serialize(Serializers serializers, Header object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'required',
      serializers.serialize(object.required, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.schema;
    if (value != null) {
      result
        ..add('schema')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    return result;
  }

  @override
  Header deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = HeaderBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'required':
          result.required = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'schema':
          result.schema.replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
      }
    }

    return result.build();
  }
}

class _$Header extends Header {
  @override
  final String? description;
  @override
  final bool required;
  @override
  final Schema? schema;

  factory _$Header([void Function(HeaderBuilder)? updates]) => (HeaderBuilder()..update(updates))._build();

  _$Header._({this.description, required this.required, this.schema}) : super._() {
    BuiltValueNullFieldError.checkNotNull(required, r'Header', 'required');
  }

  @override
  Header rebuild(void Function(HeaderBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  HeaderBuilder toBuilder() => HeaderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Header && required == other.required && schema == other.schema;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, required.hashCode);
    _$hash = $jc(_$hash, schema.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Header')
          ..add('description', description)
          ..add('required', required)
          ..add('schema', schema))
        .toString();
  }
}

class HeaderBuilder implements Builder<Header, HeaderBuilder> {
  _$Header? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _required;
  bool? get required => _$this._required;
  set required(bool? required) => _$this._required = required;

  SchemaBuilder? _schema;
  SchemaBuilder get schema => _$this._schema ??= SchemaBuilder();
  set schema(SchemaBuilder? schema) => _$this._schema = schema;

  HeaderBuilder();

  HeaderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _required = $v.required;
      _schema = $v.schema?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Header other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Header;
  }

  @override
  void update(void Function(HeaderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Header build() => _build();

  _$Header _build() {
    Header._defaults(this);
    _$Header _$result;
    try {
      _$result = _$v ??
          _$Header._(
              description: description,
              required: BuiltValueNullFieldError.checkNotNull(required, r'Header', 'required'),
              schema: _schema?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schema';
        _schema?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Header', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
