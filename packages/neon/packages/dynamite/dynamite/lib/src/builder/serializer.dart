import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/builder/state.dart';

List<Spec> buildSerializer(State state) => [
      const Code('// coverage:ignore-start\n'),
      Field((b) {
        b
          ..docs.add(r'''
/// Serializer for all values in this library.
/// 
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.''')
          ..annotations.add(refer('visibleForTesting', 'package:meta/meta.dart'))
          ..modifier = FieldModifier.final$
          ..type = refer('Serializers')
          ..name = r'$serializers'
          ..assignment = const Code(r'_$serializers');
      }),
      Field((b) {
        b
          ..modifier = FieldModifier.final$
          ..type = refer('Serializers')
          ..name = r'_$serializers';

        final serializers = state.resolvedTypes.map((type) => type.serializers).expand((element) => element).toSet();

        if (serializers.isEmpty) {
          b.assignment = const Code('Serializers()');
        } else {
          final bodyBuilder = StringBuffer()
            ..writeln('(Serializers().toBuilder()')
            ..writeAll(serializers, '\n')
            ..writeln(').build()');

          b.assignment = Code(bodyBuilder.toString());
        }
      }),
      Field((b) {
        b
          ..docs.add(r'''
/// Serializer for all values in this library.
/// 
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.''')
          ..annotations.add(refer('visibleForTesting', 'package:meta/meta.dart'))
          ..modifier = FieldModifier.final$
          ..type = refer('Serializers')
          ..name = r'$jsonSerializers'
          ..assignment = const Code(r'_$jsonSerializers');
      }),
      Field((b) {
        b
          ..modifier = FieldModifier.final$
          ..type = refer('Serializers')
          ..name = r'_$jsonSerializers'
          ..assignment = refer(r'_$serializers')
              .property('toBuilder')
              .call(const [])
              .cascade('add')
              .call([
                refer('DynamiteDoubleSerializer', 'package:dynamite_runtime/built_value.dart').newInstance(const []),
              ])
              .cascade('addPlugin')
              .call([
                refer('StandardJsonPlugin', 'package:built_value/standard_json_plugin.dart').newInstance(const [], {
                  if (state.uniqueSomeOfTypes.isNotEmpty)
                    'typesToLeaveAsList': literalConstSet(
                      state.uniqueSomeOfTypes
                          .where((e) => e.optimizedSubTypes.length > 1)
                          .map(
                            (e) => refer('_${e.typeName}'),
                          )
                          .toSet(),
                    ),
                }),
              ])
              .cascade('addPlugin')
              .call([refer('HeaderPlugin', 'package:dynamite_runtime/built_value.dart').constInstance(const [])])
              .cascade('addPlugin')
              .call([refer('ContentStringPlugin', 'package:dynamite_runtime/built_value.dart').constInstance(const [])])
              .parenthesized
              .property('build')
              .call(const [])
              .code;
      }),
      const Code('// coverage:ignore-end\n'),
    ];
