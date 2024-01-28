import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/helpers/docs.dart';
import 'package:dynamite/src/models/exceptions.dart';
import 'package:dynamite/src/models/openapi/discriminator.dart';

part 'schema.g.dart';

abstract class Schema implements Built<Schema, SchemaBuilder> {
  factory Schema([void Function(SchemaBuilder) updates]) = _$Schema;

  const Schema._();

  static Serializer<Schema> get serializer => _$schemaSerializer;

  @BuiltValueField(wireName: r'$ref')
  String? get ref;

  BuiltList<Schema>? get oneOf;

  BuiltList<Schema>? get anyOf;

  BuiltList<Schema>? get allOf;

  BuiltList<Schema>? get ofs => oneOf ?? anyOf ?? allOf;

  @BuiltValueField(compare: false)
  String? get description;

  bool get deprecated;

  SchemaType? get type;

  String? get format;

  @BuiltValueField(wireName: 'default')
  JsonObject? get $default;

  @BuiltValueField(wireName: 'enum')
  BuiltList<JsonObject>? get $enum;

  BuiltMap<String, Schema>? get properties;

  BuiltList<String> get required;

  Schema? get items;

  Schema? get additionalProperties;

  String? get contentMediaType;

  Schema? get contentSchema;

  Discriminator? get discriminator;

  String? get pattern;

  int? get minLength;

  int? get maxLength;

  bool get nullable;

  bool get isContentString =>
      type == SchemaType.string && (contentMediaType?.isNotEmpty ?? false) && contentSchema != null;

  Iterable<String> get formattedDescription => descriptionToDocs(description);

  @BuiltValueHook(finalizeBuilder: true)
  static void _defaults(SchemaBuilder b) {
    b
      ..deprecated ??= false
      ..nullable ??= false;

    const allowedNumberFormats = [null, 'float', 'double'];
    if (b.type == SchemaType.number && !allowedNumberFormats.contains(b.format)) {
      throw OpenAPISpecError('Format "${b.format}" is not allowed for ${b.type}. Use one of $allowedNumberFormats.');
    }
    const allowedIntegerFormats = [null, 'int32', 'int64'];
    if (b.type == SchemaType.integer) {
      if (!allowedIntegerFormats.contains(b.format)) {
        throw OpenAPISpecError('Format "${b.format}" is not allowed for ${b.type}. Use one of $allowedIntegerFormats.');
      } else if (b.format != null) {
        print(
          'All integers are represented as `int` meaning 64bit precision in the VM/wasm and 53bit precision on js.',
        );
      }
    }
  }
}

class SchemaType extends EnumClass {
  const SchemaType._(super.name);

  static const SchemaType boolean = _$schemaTypeBoolean;
  static const SchemaType integer = _$schemaTypeInteger;
  static const SchemaType number = _$schemaTypeNumber;
  static const SchemaType string = _$schemaTypeString;
  static const SchemaType array = _$schemaTypeArray;
  static const SchemaType object = _$schemaTypeObject;

  static BuiltSet<SchemaType> get values => _$schemaTypeValues;

  static SchemaType valueOf(String name) => _$schemaType(name);

  static Serializer<SchemaType> get serializer => _$schemaTypeSerializer;
}
