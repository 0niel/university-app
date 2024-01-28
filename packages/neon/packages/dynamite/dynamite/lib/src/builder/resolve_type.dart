import 'package:built_collection/built_collection.dart';
import 'package:dynamite/src/builder/resolve_enum.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/resolve_ofs.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';

TypeResult resolveType(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  openapi.Schema schema, {
  bool nullable = false,
}) {
  TypeResult? result;
  if (schema.ref == null && schema.ofs == null && schema.type == null) {
    return TypeResultBase(
      'JsonObject',
      nullable: nullable,
    );
  }
  if (schema.ref != null) {
    final name = schema.ref!.split('/').last;
    final subResult = resolveType(
      spec,
      state,
      toDartName(name, uppercaseFirstCharacter: true),
      spec.components!.schemas![name]!,
      nullable: nullable,
    );

    result = subResult.asTypeDef;
  } else if (schema.allOf != null) {
    result = resolveAllOf(
      spec,
      state,
      identifier,
      schema,
      nullable: nullable,
    );
  } else if (schema.ofs != null) {
    result = resolveSomeOf(
      spec,
      state,
      identifier,
      schema,
      nullable: nullable,
    );
  } else if (schema.isContentString) {
    final subResult = resolveType(
      spec,
      state,
      identifier,
      schema.contentSchema!,
    );

    result = TypeResultObject(
      'ContentString',
      generics: BuiltList([subResult]),
      nullable: nullable,
    );
  } else {
    switch (schema.type) {
      case openapi.SchemaType.boolean:
        result = TypeResultBase(
          'bool',
          nullable: nullable,
        );
      case openapi.SchemaType.integer:
        result = TypeResultBase(
          'int',
          nullable: nullable,
        );

      case openapi.SchemaType.number:
        result = switch (schema.format) {
          'float' || 'double' => TypeResultBase(
              'double',
              nullable: nullable,
            ),
          _ => TypeResultBase(
              'num',
              nullable: nullable,
            ),
        };

      case openapi.SchemaType.string:
        result = switch (schema.format) {
          'binary' => TypeResultBase(
              'Uint8List',
              nullable: nullable,
            ),
          _ => TypeResultBase(
              'String',
              nullable: nullable,
            ),
        };

      case openapi.SchemaType.array:
        final TypeResult subResult;
        if (schema.maxLength == 0) {
          subResult = TypeResultBase('Never');
        } else if (schema.items != null) {
          subResult = resolveType(
            spec,
            state,
            identifier,
            schema.items!,
          );
        } else {
          subResult = TypeResultBase('JsonObject');
        }

        result = TypeResultList(
          'BuiltList',
          subResult,
          nullable: nullable,
        );
      case openapi.SchemaType.object:
        if (schema.properties == null) {
          if (schema.additionalProperties == null) {
            result = TypeResultBase(
              'JsonObject',
              nullable: nullable,
            );
          } else {
            final subResult = resolveType(
              spec,
              state,
              identifier,
              schema.additionalProperties!,
            );
            result = TypeResultMap(
              'BuiltMap',
              subResult,
              nullable: nullable,
            );
          }
        } else if (schema.properties!.isEmpty) {
          result = TypeResultMap(
            'BuiltMap',
            TypeResultBase('JsonObject'),
            nullable: nullable,
          );
        } else {
          result = resolveObject(
            spec,
            state,
            identifier,
            schema,
            nullable: nullable,
          );
        }
    }
  }

  if (result != null) {
    if (schema.$enum != null) {
      result = resolveEnum(
        spec,
        state,
        identifier,
        schema,
        result,
        nullable: nullable,
      );
    }

    state.resolvedTypes.add(result);
    return result;
  }

  throw Exception('Can not convert OpenAPI type "$schema" to a Dart type');
}
