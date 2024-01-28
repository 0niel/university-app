import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';

const interfaceSuffix = 'Interface';

/// Builds a [Class] representing a built_value object.
///
/// Attributes must be defined in a separate interface called `\$$className$interfaceSuffix`.
Spec buildBuiltClass(
  String className, {
  Iterable<String>? documentation,
  Iterable<String>? defaults,
  Iterable<Expression>? validators,
  Iterable<Method>? methods,
}) =>
    Class(
      (b) {
        b
          ..name = className
          ..abstract = true
          ..implements.addAll([
            refer('\$$className$interfaceSuffix'),
            refer(
              'Built<$className, ${className}Builder>',
            ),
          ])
          ..constructors.addAll([
            builtValueConstructor(className),
            hiddenConstructor,
            fromJsonConstructor,
          ])
          ..methods.addAll([
            toJsonMethod,
            buildSerializer(className),
          ]);

        if (methods != null) {
          b.methods.addAll(methods);
        }

        if (documentation != null) {
          b.docs.addAll(documentation);
        }

        if (defaults != null && defaults.isNotEmpty) {
          b.methods.add(
            Method(
              (b) => b
                ..name = '_defaults'
                ..returns = refer('void')
                ..static = true
                ..lambda = true
                ..annotations.add(
                  refer('BuiltValueHook').call([], {
                    'initializeBuilder': literalTrue,
                  }),
                )
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'b'
                      ..type = refer('${className}Builder'),
                  ),
                )
                ..body = Code(
                  <String?>[
                    'b',
                    ...defaults,
                  ].join(),
                ),
            ),
          );
        }

        if (validators != null && validators.isNotEmpty) {
          b.methods.add(
            Method((b) {
              b
                ..name = '_validate'
                ..returns = refer('void')
                ..annotations.add(
                  refer('BuiltValueHook').call([], {'finalizeBuilder': literalTrue}),
                )
                ..static = true
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'b'
                      ..type = refer('${className}Builder'),
                  ),
                )
                ..body = Block.of(
                  validators.map((v) => v.statement),
                );
            }),
          );
        }
      },
    );

Method get toJsonMethod => Method(
      (b) => b
        ..docs.addAll([
          '/// Parses this object into a json like map.',
          '///',
          '/// Use the fromJson factory to revive it again.',
        ])
        ..name = 'toJson'
        ..returns = refer('Map<String, dynamic>')
        ..lambda = true
        ..body = const Code(r'_$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>'),
    );

/// Builds the serializer getter for a built class.
Method buildSerializer(String className, [String? serializerName]) => Method((b) {
      b
        ..docs.add('/// Serializer for $className.')
        ..name = 'serializer'
        ..returns = refer('Serializer<$className>')
        ..lambda = true
        ..static = true
        ..body = Code(
          serializerName ?? '_\$${toCamelCase(className)}Serializer',
        )
        ..type = MethodType.getter;
      if (serializerName != null) {
        b.annotations.add(refer('BuiltValueSerializer').call([], {'custom': literalTrue}));
      }
    });

Constructor builtValueConstructor(String className) => Constructor(
      (b) => b
        ..docs.add('/// Creates a new $className object using the builder pattern.')
        ..factory = true
        ..lambda = true
        ..optionalParameters.add(
          Parameter(
            (b) => b
              ..name = 'b'
              ..type = refer('void Function(${className}Builder)?'),
          ),
        )
        ..redirect = refer('_\$$className'),
    );

Constructor get hiddenConstructor => Constructor(
      (b) => b
        ..name = '_'
        ..constant = true,
    );

Constructor get fromJsonConstructor => Constructor(
      (b) => b
        ..docs.addAll([
          '/// Creates a new object from the given [json] data.',
          '///',
          '/// Use [toJson] to serialize it back into json.',
        ])
        ..factory = true
        ..name = 'fromJson'
        ..lambda = true
        ..requiredParameters.add(
          Parameter(
            (b) => b
              ..name = 'json'
              ..type = refer('Map<String, dynamic>'),
          ),
        )
        ..body = const Code(r'_$jsonSerializers.deserializeWith(serializer, json)!'),
    );
