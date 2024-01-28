import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/built_value.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';
import 'package:source_helper/source_helper.dart';

TypeResult resolveEnum(
  openapi.OpenAPI spec,
  State state,
  String identifier,
  openapi.Schema schema,
  TypeResult subResult, {
  bool nullable = false,
}) {
  if (state.resolvedTypes.add(TypeResultEnum(identifier, subResult))) {
    final values = <({String dartName, Object? value, String name})>[];
    for (final enumValue in schema.$enum!) {
      final name = enumValue.toString();
      final dartName = toDartName(name);
      var value = jsonEncode(enumValue.value);
      if (enumValue.isString) {
        value = escapeDartString(enumValue.asString);
      }

      values.add((dartName: dartName, value: value, name: name));
    }

    final $class = Class(
      (b) => b
        ..docs.addAll(schema.formattedDescription)
        ..name = identifier
        ..extend = refer('EnumClass')
        ..constructors.add(
          Constructor(
            (b) => b
              ..name = '_'
              ..constant = true
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'name'
                    ..toSuper = true,
                ),
              ),
          ),
        )
        ..fields.addAll(
          values.map(
            (enumValue) => Field(
              (b) {
                b
                  ..docs.add('/// `${enumValue.name}`')
                  ..name = enumValue.dartName
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..type = refer(identifier)
                  ..assignment = Code(
                    '_\$${toCamelCase('$identifier${enumValue.dartName.capitalize()}')}',
                  );

                if (enumValue.name != enumValue.dartName) {
                  b.annotations.add(
                    refer('BuiltValueEnumConst').call([], {
                      'wireName': refer(escapeDartString(enumValue.name)),
                    }),
                  );
                }
              },
            ),
          ),
        )
        ..methods.addAll([
          Method(
            (b) => b
              ..docs.add('/// Returns a set with all values this enum contains.')
              ..name = 'values'
              ..returns = refer('BuiltSet<$identifier>')
              ..lambda = true
              ..static = true
              ..body = Code('_\$${toCamelCase(identifier)}Values')
              ..type = MethodType.getter,
          ),
          Method(
            (b) => b
              ..docs.add('/// Returns the enum value associated to the [name].')
              ..name = 'valueOf'
              ..returns = refer(identifier)
              ..lambda = true
              ..static = true
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'name'
                    ..type = refer('String'),
                ),
              )
              ..body = Code('_\$valueOf$identifier(name)'),
          ),
          Method(
            (b) => b
              ..docs.add('/// Returns the serialized value of this enum value.')
              ..returns = refer(subResult.dartType.className)
              ..name = 'value'
              ..type = MethodType.getter
              ..lambda = true
              ..body = Code('_\$jsonSerializers.serializeWith(serializer, this)! as ${subResult.dartType.className}'),
          ),
          buildSerializer(identifier, 'const _\$${identifier}Serializer()'),
        ]),
    );

    final serializer = Class(
      (b) => b
        ..name = '_\$${identifier}Serializer'
        ..implements.add(refer('PrimitiveSerializer<$identifier>'))
        ..constructors.add(
          Constructor(
            (b) => b..constant = true,
          ),
        )
        ..fields.addAll([
          Field((b) {
            b
              ..static = true
              ..modifier = FieldModifier.constant
              ..type = refer('Map<$identifier, Object>')
              ..name = '_toWire';
            final buffer = StringBuffer()
              ..writeln('<$identifier, Object>{')
              ..writeAll(
                values.map((enumValue) => '$identifier.${enumValue.dartName}: ${enumValue.value}'),
                ',\n',
              )
              ..writeln(',')
              ..write('}');

            b.assignment = Code(buffer.toString());
          }),
          Field((b) {
            b
              ..static = true
              ..modifier = FieldModifier.constant
              ..type = refer('Map<Object, $identifier>')
              ..name = '_fromWire';
            final buffer = StringBuffer()
              ..writeln('<Object, $identifier>{')
              ..writeAll(
                values.map((enumValue) => '${enumValue.value}: $identifier.${enumValue.dartName}'),
                ',\n',
              )
              ..writeln(',')
              ..write('}');

            b.assignment = Code(buffer.toString());
          }),
        ])
        ..methods.addAll([
          Method(
            (b) => b
              ..name = 'types'
              ..lambda = true
              ..type = MethodType.getter
              ..returns = refer('Iterable<Type>')
              ..annotations.add(refer('override'))
              ..body = Code('const [$identifier]'),
          ),
          Method(
            (b) => b
              ..name = 'wireName'
              ..lambda = true
              ..type = MethodType.getter
              ..returns = refer('String')
              ..annotations.add(refer('override'))
              ..body = Code(escapeDartString(identifier)),
          ),
          Method((b) {
            b
              ..name = 'serialize'
              ..returns = refer('Object')
              ..annotations.add(refer('override'))
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (b) => b
                    ..name = 'serializers'
                    ..type = refer('Serializers'),
                ),
                Parameter(
                  (b) => b
                    ..name = 'object'
                    ..type = refer(identifier),
                ),
              ])
              ..optionalParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'specifiedType'
                    ..type = refer('FullType')
                    ..named = true
                    ..defaultTo = const Code('FullType.unspecified'),
                ),
              )
              ..body = const Code('_toWire[object]!');
          }),
          Method((b) {
            b
              ..name = 'deserialize'
              ..returns = refer(identifier)
              ..annotations.add(refer('override'))
              ..lambda = true
              ..requiredParameters.addAll([
                Parameter(
                  (b) => b
                    ..name = 'serializers'
                    ..type = refer('Serializers'),
                ),
                Parameter(
                  (b) => b
                    ..name = 'serialized'
                    ..type = refer('Object'),
                ),
              ])
              ..optionalParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'specifiedType'
                    ..type = refer('FullType')
                    ..named = true
                    ..defaultTo = const Code('FullType.unspecified'),
                ),
              )
              ..body = const Code('_fromWire[serialized]!');
          }),
        ]),
    );

    state.output.addAll([
      $class,
      serializer,
    ]);
  }
  return TypeResultEnum(
    identifier,
    subResult,
    nullable: nullable,
  );
}
