// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ParameterType _$parameterTypePath = ParameterType._('path');
const ParameterType _$parameterTypeQuery = ParameterType._('query');
const ParameterType _$parameterTypeHeader = ParameterType._('header');
const ParameterType _$parameterTypeCookie = ParameterType._('cookie');

ParameterType _$parameterType(String name) {
  switch (name) {
    case 'path':
      return _$parameterTypePath;
    case 'query':
      return _$parameterTypeQuery;
    case 'header':
      return _$parameterTypeHeader;
    case 'cookie':
      return _$parameterTypeCookie;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ParameterType> _$parameterTypeValues = BuiltSet<ParameterType>(const <ParameterType>[
  _$parameterTypePath,
  _$parameterTypeQuery,
  _$parameterTypeHeader,
  _$parameterTypeCookie,
]);

const ParameterStyle _$parameterStyleMatrix = ParameterStyle._('matrix');
const ParameterStyle _$parameterStyleLabel = ParameterStyle._('label');
const ParameterStyle _$parameterStyleForm = ParameterStyle._('form');
const ParameterStyle _$parameterStyleSimple = ParameterStyle._('simple');
const ParameterStyle _$parameterStyleSpaceDelimited = ParameterStyle._('spaceDelimited');
const ParameterStyle _$parameterStylePipeDelimited = ParameterStyle._('pipeDelimited');
const ParameterStyle _$parameterStyleDeepObject = ParameterStyle._('deepObject');

ParameterStyle _$parameterStyle(String name) {
  switch (name) {
    case 'matrix':
      return _$parameterStyleMatrix;
    case 'label':
      return _$parameterStyleLabel;
    case 'form':
      return _$parameterStyleForm;
    case 'simple':
      return _$parameterStyleSimple;
    case 'spaceDelimited':
      return _$parameterStyleSpaceDelimited;
    case 'pipeDelimited':
      return _$parameterStylePipeDelimited;
    case 'deepObject':
      return _$parameterStyleDeepObject;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ParameterStyle> _$parameterStyleValues = BuiltSet<ParameterStyle>(const <ParameterStyle>[
  _$parameterStyleMatrix,
  _$parameterStyleLabel,
  _$parameterStyleForm,
  _$parameterStyleSimple,
  _$parameterStyleSpaceDelimited,
  _$parameterStylePipeDelimited,
  _$parameterStyleDeepObject,
]);

Serializer<Parameter> _$parameterSerializer = _$ParameterSerializer();
Serializer<ParameterType> _$parameterTypeSerializer = _$ParameterTypeSerializer();
Serializer<ParameterStyle> _$parameterStyleSerializer = _$ParameterStyleSerializer();

class _$ParameterSerializer implements StructuredSerializer<Parameter> {
  @override
  final Iterable<Type> types = const [Parameter, _$Parameter];
  @override
  final String wireName = 'Parameter';

  @override
  Iterable<Object?> serialize(Serializers serializers, Parameter object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'in',
      serializers.serialize(object.$in, specifiedType: const FullType(ParameterType)),
      'required',
      serializers.serialize(object.required, specifiedType: const FullType(bool)),
      'explode',
      serializers.serialize(object.explode, specifiedType: const FullType(bool)),
      'allowReserved',
      serializers.serialize(object.allowReserved, specifiedType: const FullType(bool)),
      'style',
      serializers.serialize(object.style, specifiedType: const FullType(ParameterStyle)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.$schema;
    if (value != null) {
      result
        ..add('schema')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    value = object.content;
    if (value != null) {
      result
        ..add('content')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)])));
    }
    return result;
  }

  @override
  Parameter deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ParameterBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'in':
          result.$in = serializers.deserialize(value, specifiedType: const FullType(ParameterType))! as ParameterType;
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'required':
          result.required = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'schema':
          result.$schema.replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
        case 'content':
          result.content.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)]))!);
          break;
        case 'explode':
          result.explode = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'allowReserved':
          result.allowReserved = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'style':
          result.style =
              serializers.deserialize(value, specifiedType: const FullType(ParameterStyle))! as ParameterStyle;
          break;
      }
    }

    return result.build();
  }
}

class _$ParameterTypeSerializer implements PrimitiveSerializer<ParameterType> {
  @override
  final Iterable<Type> types = const <Type>[ParameterType];
  @override
  final String wireName = 'ParameterType';

  @override
  Object serialize(Serializers serializers, ParameterType object, {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  ParameterType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ParameterType.valueOf(serialized as String);
}

class _$ParameterStyleSerializer implements PrimitiveSerializer<ParameterStyle> {
  @override
  final Iterable<Type> types = const <Type>[ParameterStyle];
  @override
  final String wireName = 'ParameterStyle';

  @override
  Object serialize(Serializers serializers, ParameterStyle object, {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  ParameterStyle deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ParameterStyle.valueOf(serialized as String);
}

class _$Parameter extends Parameter {
  @override
  final String name;
  @override
  final ParameterType $in;
  @override
  final String? description;
  @override
  final bool required;
  @override
  final Schema? $schema;
  @override
  final BuiltMap<String, MediaType>? content;
  @override
  final bool explode;
  @override
  final bool allowReserved;
  @override
  final ParameterStyle style;

  factory _$Parameter([void Function(ParameterBuilder)? updates]) => (ParameterBuilder()..update(updates))._build();

  _$Parameter._(
      {required this.name,
      required this.$in,
      this.description,
      required this.required,
      this.$schema,
      this.content,
      required this.explode,
      required this.allowReserved,
      required this.style})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'Parameter', 'name');
    BuiltValueNullFieldError.checkNotNull($in, r'Parameter', '\$in');
    BuiltValueNullFieldError.checkNotNull(required, r'Parameter', 'required');
    BuiltValueNullFieldError.checkNotNull(explode, r'Parameter', 'explode');
    BuiltValueNullFieldError.checkNotNull(allowReserved, r'Parameter', 'allowReserved');
    BuiltValueNullFieldError.checkNotNull(style, r'Parameter', 'style');
  }

  @override
  Parameter rebuild(void Function(ParameterBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ParameterBuilder toBuilder() => ParameterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Parameter &&
        name == other.name &&
        $in == other.$in &&
        required == other.required &&
        $schema == other.$schema &&
        content == other.content &&
        explode == other.explode &&
        allowReserved == other.allowReserved &&
        style == other.style;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, $in.hashCode);
    _$hash = $jc(_$hash, required.hashCode);
    _$hash = $jc(_$hash, $schema.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, explode.hashCode);
    _$hash = $jc(_$hash, allowReserved.hashCode);
    _$hash = $jc(_$hash, style.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Parameter')
          ..add('name', name)
          ..add('\$in', $in)
          ..add('description', description)
          ..add('required', required)
          ..add('\$schema', $schema)
          ..add('content', content)
          ..add('explode', explode)
          ..add('allowReserved', allowReserved)
          ..add('style', style))
        .toString();
  }
}

class ParameterBuilder implements Builder<Parameter, ParameterBuilder> {
  _$Parameter? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ParameterType? _$in;
  ParameterType? get $in => _$this._$in;
  set $in(ParameterType? $in) => _$this._$in = $in;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _required;
  bool? get required => _$this._required;
  set required(bool? required) => _$this._required = required;

  SchemaBuilder? _$schema;
  SchemaBuilder get $schema => _$this._$schema ??= SchemaBuilder();
  set $schema(SchemaBuilder? $schema) => _$this._$schema = $schema;

  MapBuilder<String, MediaType>? _content;
  MapBuilder<String, MediaType> get content => _$this._content ??= MapBuilder<String, MediaType>();
  set content(MapBuilder<String, MediaType>? content) => _$this._content = content;

  bool? _explode;
  bool? get explode => _$this._explode;
  set explode(bool? explode) => _$this._explode = explode;

  bool? _allowReserved;
  bool? get allowReserved => _$this._allowReserved;
  set allowReserved(bool? allowReserved) => _$this._allowReserved = allowReserved;

  ParameterStyle? _style;
  ParameterStyle? get style => _$this._style;
  set style(ParameterStyle? style) => _$this._style = style;

  ParameterBuilder();

  ParameterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$in = $v.$in;
      _description = $v.description;
      _required = $v.required;
      _$schema = $v.$schema?.toBuilder();
      _content = $v.content?.toBuilder();
      _explode = $v.explode;
      _allowReserved = $v.allowReserved;
      _style = $v.style;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Parameter other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Parameter;
  }

  @override
  void update(void Function(ParameterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Parameter build() => _build();

  _$Parameter _build() {
    Parameter._defaults(this);
    _$Parameter _$result;
    try {
      _$result = _$v ??
          _$Parameter._(
              name: BuiltValueNullFieldError.checkNotNull(name, r'Parameter', 'name'),
              $in: BuiltValueNullFieldError.checkNotNull($in, r'Parameter', '\$in'),
              description: description,
              required: BuiltValueNullFieldError.checkNotNull(required, r'Parameter', 'required'),
              $schema: _$schema?.build(),
              content: _content?.build(),
              explode: BuiltValueNullFieldError.checkNotNull(explode, r'Parameter', 'explode'),
              allowReserved: BuiltValueNullFieldError.checkNotNull(allowReserved, r'Parameter', 'allowReserved'),
              style: BuiltValueNullFieldError.checkNotNull(style, r'Parameter', 'style'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = '\$schema';
        _$schema?.build();
        _$failedField = 'content';
        _content?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Parameter', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
