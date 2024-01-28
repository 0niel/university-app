import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dynamite/src/builder/resolve_interface.dart';
import 'package:dynamite/src/builder/resolve_type.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/built_value.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/dynamite.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';

TypeResult resolveSomeOf(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  openapi.Schema schema, {
  bool nullable = false,
}) {
  final subResults = schema.ofs!
      .mapIndexed(
        (index, s) => resolveType(
          spec,
          state,
          '$identifier$index',
          s,
          nullable: true,
        ),
      )
      .toBuiltSet();

  TypeResultSomeOf result;
  if (schema.oneOf != null) {
    result = TypeResultOneOf(
      identifier,
      nullable: nullable,
      subTypes: subResults,
    );
  } else if (schema.anyOf != null) {
    result = TypeResultAnyOf(
      identifier,
      nullable: nullable,
      subTypes: subResults,
    );
  } else {
    throw StateError('allOf should be handled with inheritance');
  }

  if (state.resolvedTypes.add(result) && !result.isSingleValue) {
    final $typedef = TypeDef((b) {
      b
        ..docs.addAll(schema.formattedDescription)
        ..name = result.className
        ..definition = refer(result.dartType.name);
    });

    state.output.add($typedef);
  }

  return result;
}

TypeResult resolveAllOf(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  openapi.Schema schema, {
  bool nullable = false,
}) {
  final result = TypeResultObject(
    identifier,
    nullable: nullable,
  );

  if (state.resolvedTypes.add(result)) {
    final interfaces = <TypeResultObject>{};
    final methods = ListBuilder<Method>();

    for (final s in schema.allOf!) {
      if (s.properties != null) {
        final properties = s.properties!.entries;

        methods.addAll(
          properties.map((property) {
            final propertyName = property.key;
            final propertySchema = property.value;

            final result = resolveType(
              spec,
              state,
              '${identifier}_${toDartName(propertyName, uppercaseFirstCharacter: true)}',
              propertySchema,
              nullable: isDartParameterNullable(
                s.required.contains(propertyName),
                propertySchema,
              ),
            );

            return generateProperty(
              result,
              propertyName,
              propertySchema.formattedDescription,
            );
          }),
        );
      } else {
        final object = resolveType(
          spec,
          state,
          identifier,
          s,
          nullable: nullable,
        );

        if (object is TypeResultObject) {
          interfaces.add(object);
        } else {
          final property = generateProperty(
            object,
            object.className,
            s.formattedDescription,
          );

          methods.add(property);
        }
      }
    }

    final $interface = buildInterface(
      identifier,
      interfaces: interfaces,
      methods: methods.build(),
      documentation: schema.formattedDescription,
    );

    final $class = buildBuiltClass(
      identifier,
      documentation: schema.formattedDescription,
    );

    state.output.addAll([
      $interface,
      $class,
    ]);
  }
  return result;
}
