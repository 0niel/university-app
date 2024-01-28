// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SchemaType _$schemaTypeBoolean = SchemaType._('boolean');
const SchemaType _$schemaTypeInteger = SchemaType._('integer');
const SchemaType _$schemaTypeNumber = SchemaType._('number');
const SchemaType _$schemaTypeString = SchemaType._('string');
const SchemaType _$schemaTypeArray = SchemaType._('array');
const SchemaType _$schemaTypeObject = SchemaType._('object');

SchemaType _$schemaType(String name) {
  switch (name) {
    case 'boolean':
      return _$schemaTypeBoolean;
    case 'integer':
      return _$schemaTypeInteger;
    case 'number':
      return _$schemaTypeNumber;
    case 'string':
      return _$schemaTypeString;
    case 'array':
      return _$schemaTypeArray;
    case 'object':
      return _$schemaTypeObject;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SchemaType> _$schemaTypeValues = BuiltSet<SchemaType>(const <SchemaType>[
  _$schemaTypeBoolean,
  _$schemaTypeInteger,
  _$schemaTypeNumber,
  _$schemaTypeString,
  _$schemaTypeArray,
  _$schemaTypeObject,
]);

Serializer<Schema> _$schemaSerializer = _$SchemaSerializer();
Serializer<SchemaType> _$schemaTypeSerializer = _$SchemaTypeSerializer();

class _$SchemaSerializer implements StructuredSerializer<Schema> {
  @override
  final Iterable<Type> types = const [Schema, _$Schema];
  @override
  final String wireName = 'Schema';

  @override
  Iterable<Object?> serialize(Serializers serializers, Schema object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'deprecated',
      serializers.serialize(object.deprecated, specifiedType: const FullType(bool)),
      'required',
      serializers.serialize(object.required, specifiedType: const FullType(BuiltList, [FullType(String)])),
      'nullable',
      serializers.serialize(object.nullable, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.ref;
    if (value != null) {
      result
        ..add('\$ref')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.oneOf;
    if (value != null) {
      result
        ..add('oneOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Schema)])));
    }
    value = object.anyOf;
    if (value != null) {
      result
        ..add('anyOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Schema)])));
    }
    value = object.allOf;
    if (value != null) {
      result
        ..add('allOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Schema)])));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value, specifiedType: const FullType(SchemaType)));
    }
    value = object.format;
    if (value != null) {
      result
        ..add('format')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.$default;
    if (value != null) {
      result
        ..add('default')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonObject)));
    }
    value = object.$enum;
    if (value != null) {
      result
        ..add('enum')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonObject)])));
    }
    value = object.properties;
    if (value != null) {
      result
        ..add('properties')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Schema)])));
    }
    value = object.items;
    if (value != null) {
      result
        ..add('items')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    value = object.additionalProperties;
    if (value != null) {
      result
        ..add('additionalProperties')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    value = object.contentMediaType;
    if (value != null) {
      result
        ..add('contentMediaType')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.contentSchema;
    if (value != null) {
      result
        ..add('contentSchema')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    value = object.discriminator;
    if (value != null) {
      result
        ..add('discriminator')
        ..add(serializers.serialize(value, specifiedType: const FullType(Discriminator)));
    }
    value = object.pattern;
    if (value != null) {
      result
        ..add('pattern')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.minLength;
    if (value != null) {
      result
        ..add('minLength')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.maxLength;
    if (value != null) {
      result
        ..add('maxLength')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Schema deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SchemaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '\$ref':
          result.ref = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'oneOf':
          result.oneOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Schema)]))! as BuiltList<Object?>);
          break;
        case 'anyOf':
          result.anyOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Schema)]))! as BuiltList<Object?>);
          break;
        case 'allOf':
          result.allOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Schema)]))! as BuiltList<Object?>);
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'deprecated':
          result.deprecated = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(SchemaType)) as SchemaType?;
          break;
        case 'format':
          result.format = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'default':
          result.$default = serializers.deserialize(value, specifiedType: const FullType(JsonObject)) as JsonObject?;
          break;
        case 'enum':
          result.$enum.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonObject)]))! as BuiltList<Object?>);
          break;
        case 'properties':
          result.properties.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Schema)]))!);
          break;
        case 'required':
          result.required.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'items':
          result.items.replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
        case 'additionalProperties':
          result.additionalProperties
              .replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
        case 'contentMediaType':
          result.contentMediaType = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'contentSchema':
          result.contentSchema
              .replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
        case 'discriminator':
          result.discriminator
              .replace(serializers.deserialize(value, specifiedType: const FullType(Discriminator))! as Discriminator);
          break;
        case 'pattern':
          result.pattern = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'minLength':
          result.minLength = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'maxLength':
          result.maxLength = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'nullable':
          result.nullable = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SchemaTypeSerializer implements PrimitiveSerializer<SchemaType> {
  @override
  final Iterable<Type> types = const <Type>[SchemaType];
  @override
  final String wireName = 'SchemaType';

  @override
  Object serialize(Serializers serializers, SchemaType object, {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  SchemaType deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) =>
      SchemaType.valueOf(serialized as String);
}

class _$Schema extends Schema {
  @override
  final String? ref;
  @override
  final BuiltList<Schema>? oneOf;
  @override
  final BuiltList<Schema>? anyOf;
  @override
  final BuiltList<Schema>? allOf;
  @override
  final String? description;
  @override
  final bool deprecated;
  @override
  final SchemaType? type;
  @override
  final String? format;
  @override
  final JsonObject? $default;
  @override
  final BuiltList<JsonObject>? $enum;
  @override
  final BuiltMap<String, Schema>? properties;
  @override
  final BuiltList<String> required;
  @override
  final Schema? items;
  @override
  final Schema? additionalProperties;
  @override
  final String? contentMediaType;
  @override
  final Schema? contentSchema;
  @override
  final Discriminator? discriminator;
  @override
  final String? pattern;
  @override
  final int? minLength;
  @override
  final int? maxLength;
  @override
  final bool nullable;

  factory _$Schema([void Function(SchemaBuilder)? updates]) => (SchemaBuilder()..update(updates))._build();

  _$Schema._(
      {this.ref,
      this.oneOf,
      this.anyOf,
      this.allOf,
      this.description,
      required this.deprecated,
      this.type,
      this.format,
      this.$default,
      this.$enum,
      this.properties,
      required this.required,
      this.items,
      this.additionalProperties,
      this.contentMediaType,
      this.contentSchema,
      this.discriminator,
      this.pattern,
      this.minLength,
      this.maxLength,
      required this.nullable})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(deprecated, r'Schema', 'deprecated');
    BuiltValueNullFieldError.checkNotNull(required, r'Schema', 'required');
    BuiltValueNullFieldError.checkNotNull(nullable, r'Schema', 'nullable');
  }

  @override
  Schema rebuild(void Function(SchemaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SchemaBuilder toBuilder() => SchemaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Schema &&
        ref == other.ref &&
        oneOf == other.oneOf &&
        anyOf == other.anyOf &&
        allOf == other.allOf &&
        deprecated == other.deprecated &&
        type == other.type &&
        format == other.format &&
        $default == other.$default &&
        $enum == other.$enum &&
        properties == other.properties &&
        required == other.required &&
        items == other.items &&
        additionalProperties == other.additionalProperties &&
        contentMediaType == other.contentMediaType &&
        contentSchema == other.contentSchema &&
        discriminator == other.discriminator &&
        pattern == other.pattern &&
        minLength == other.minLength &&
        maxLength == other.maxLength &&
        nullable == other.nullable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ref.hashCode);
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jc(_$hash, allOf.hashCode);
    _$hash = $jc(_$hash, deprecated.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, $default.hashCode);
    _$hash = $jc(_$hash, $enum.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jc(_$hash, required.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, additionalProperties.hashCode);
    _$hash = $jc(_$hash, contentMediaType.hashCode);
    _$hash = $jc(_$hash, contentSchema.hashCode);
    _$hash = $jc(_$hash, discriminator.hashCode);
    _$hash = $jc(_$hash, pattern.hashCode);
    _$hash = $jc(_$hash, minLength.hashCode);
    _$hash = $jc(_$hash, maxLength.hashCode);
    _$hash = $jc(_$hash, nullable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Schema')
          ..add('ref', ref)
          ..add('oneOf', oneOf)
          ..add('anyOf', anyOf)
          ..add('allOf', allOf)
          ..add('description', description)
          ..add('deprecated', deprecated)
          ..add('type', type)
          ..add('format', format)
          ..add('\$default', $default)
          ..add('\$enum', $enum)
          ..add('properties', properties)
          ..add('required', required)
          ..add('items', items)
          ..add('additionalProperties', additionalProperties)
          ..add('contentMediaType', contentMediaType)
          ..add('contentSchema', contentSchema)
          ..add('discriminator', discriminator)
          ..add('pattern', pattern)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength)
          ..add('nullable', nullable))
        .toString();
  }
}

class SchemaBuilder implements Builder<Schema, SchemaBuilder> {
  _$Schema? _$v;

  String? _ref;
  String? get ref => _$this._ref;
  set ref(String? ref) => _$this._ref = ref;

  ListBuilder<Schema>? _oneOf;
  ListBuilder<Schema> get oneOf => _$this._oneOf ??= ListBuilder<Schema>();
  set oneOf(ListBuilder<Schema>? oneOf) => _$this._oneOf = oneOf;

  ListBuilder<Schema>? _anyOf;
  ListBuilder<Schema> get anyOf => _$this._anyOf ??= ListBuilder<Schema>();
  set anyOf(ListBuilder<Schema>? anyOf) => _$this._anyOf = anyOf;

  ListBuilder<Schema>? _allOf;
  ListBuilder<Schema> get allOf => _$this._allOf ??= ListBuilder<Schema>();
  set allOf(ListBuilder<Schema>? allOf) => _$this._allOf = allOf;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _deprecated;
  bool? get deprecated => _$this._deprecated;
  set deprecated(bool? deprecated) => _$this._deprecated = deprecated;

  SchemaType? _type;
  SchemaType? get type => _$this._type;
  set type(SchemaType? type) => _$this._type = type;

  String? _format;
  String? get format => _$this._format;
  set format(String? format) => _$this._format = format;

  JsonObject? _$default;
  JsonObject? get $default => _$this._$default;
  set $default(JsonObject? $default) => _$this._$default = $default;

  ListBuilder<JsonObject>? _$enum;
  ListBuilder<JsonObject> get $enum => _$this._$enum ??= ListBuilder<JsonObject>();
  set $enum(ListBuilder<JsonObject>? $enum) => _$this._$enum = $enum;

  MapBuilder<String, Schema>? _properties;
  MapBuilder<String, Schema> get properties => _$this._properties ??= MapBuilder<String, Schema>();
  set properties(MapBuilder<String, Schema>? properties) => _$this._properties = properties;

  ListBuilder<String>? _required;
  ListBuilder<String> get required => _$this._required ??= ListBuilder<String>();
  set required(ListBuilder<String>? required) => _$this._required = required;

  SchemaBuilder? _items;
  SchemaBuilder get items => _$this._items ??= SchemaBuilder();
  set items(SchemaBuilder? items) => _$this._items = items;

  SchemaBuilder? _additionalProperties;
  SchemaBuilder get additionalProperties => _$this._additionalProperties ??= SchemaBuilder();
  set additionalProperties(SchemaBuilder? additionalProperties) => _$this._additionalProperties = additionalProperties;

  String? _contentMediaType;
  String? get contentMediaType => _$this._contentMediaType;
  set contentMediaType(String? contentMediaType) => _$this._contentMediaType = contentMediaType;

  SchemaBuilder? _contentSchema;
  SchemaBuilder get contentSchema => _$this._contentSchema ??= SchemaBuilder();
  set contentSchema(SchemaBuilder? contentSchema) => _$this._contentSchema = contentSchema;

  DiscriminatorBuilder? _discriminator;
  DiscriminatorBuilder get discriminator => _$this._discriminator ??= DiscriminatorBuilder();
  set discriminator(DiscriminatorBuilder? discriminator) => _$this._discriminator = discriminator;

  String? _pattern;
  String? get pattern => _$this._pattern;
  set pattern(String? pattern) => _$this._pattern = pattern;

  int? _minLength;
  int? get minLength => _$this._minLength;
  set minLength(int? minLength) => _$this._minLength = minLength;

  int? _maxLength;
  int? get maxLength => _$this._maxLength;
  set maxLength(int? maxLength) => _$this._maxLength = maxLength;

  bool? _nullable;
  bool? get nullable => _$this._nullable;
  set nullable(bool? nullable) => _$this._nullable = nullable;

  SchemaBuilder();

  SchemaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ref = $v.ref;
      _oneOf = $v.oneOf?.toBuilder();
      _anyOf = $v.anyOf?.toBuilder();
      _allOf = $v.allOf?.toBuilder();
      _description = $v.description;
      _deprecated = $v.deprecated;
      _type = $v.type;
      _format = $v.format;
      _$default = $v.$default;
      _$enum = $v.$enum?.toBuilder();
      _properties = $v.properties?.toBuilder();
      _required = $v.required.toBuilder();
      _items = $v.items?.toBuilder();
      _additionalProperties = $v.additionalProperties?.toBuilder();
      _contentMediaType = $v.contentMediaType;
      _contentSchema = $v.contentSchema?.toBuilder();
      _discriminator = $v.discriminator?.toBuilder();
      _pattern = $v.pattern;
      _minLength = $v.minLength;
      _maxLength = $v.maxLength;
      _nullable = $v.nullable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Schema other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Schema;
  }

  @override
  void update(void Function(SchemaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Schema build() => _build();

  _$Schema _build() {
    Schema._defaults(this);
    _$Schema _$result;
    try {
      _$result = _$v ??
          _$Schema._(
              ref: ref,
              oneOf: _oneOf?.build(),
              anyOf: _anyOf?.build(),
              allOf: _allOf?.build(),
              description: description,
              deprecated: BuiltValueNullFieldError.checkNotNull(deprecated, r'Schema', 'deprecated'),
              type: type,
              format: format,
              $default: $default,
              $enum: _$enum?.build(),
              properties: _properties?.build(),
              required: required.build(),
              items: _items?.build(),
              additionalProperties: _additionalProperties?.build(),
              contentMediaType: contentMediaType,
              contentSchema: _contentSchema?.build(),
              discriminator: _discriminator?.build(),
              pattern: pattern,
              minLength: minLength,
              maxLength: maxLength,
              nullable: BuiltValueNullFieldError.checkNotNull(nullable, r'Schema', 'nullable'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'oneOf';
        _oneOf?.build();
        _$failedField = 'anyOf';
        _anyOf?.build();
        _$failedField = 'allOf';
        _allOf?.build();

        _$failedField = '\$enum';
        _$enum?.build();
        _$failedField = 'properties';
        _properties?.build();
        _$failedField = 'required';
        required.build();
        _$failedField = 'items';
        _items?.build();
        _$failedField = 'additionalProperties';
        _additionalProperties?.build();

        _$failedField = 'contentSchema';
        _contentSchema?.build();
        _$failedField = 'discriminator';
        _discriminator?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Schema', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
