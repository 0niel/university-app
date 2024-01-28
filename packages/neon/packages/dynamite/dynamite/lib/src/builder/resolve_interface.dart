import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/helpers/built_value.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/type_result.dart';

Method generateProperty(
  TypeResult type,
  String propertyName,
  Iterable<String> description,
) =>
    Method(
      (b) {
        final name = toFieldName(toDartName(propertyName), type.name);
        b
          ..name = name
          ..type = MethodType.getter
          ..docs.addAll(description);

        if (type is TypeResultSomeOf && type.isSingleValue) {
          b.returns = refer(type.dartType.name);
        } else {
          b.returns = refer(type.nullableName);
        }

        final builtValueFieldAnnotations = <String, Expression>{};
        if (name != propertyName) {
          builtValueFieldAnnotations['wireName'] = literalString(propertyName);
        }

        if (builtValueFieldAnnotations.isNotEmpty) {
          b.annotations.add(
            refer('BuiltValueField').call([], builtValueFieldAnnotations),
          );
        }
      },
    );

Spec buildInterface(
  String identifier, {
  BuiltList<Method>? methods,
  Iterable<TypeResultObject>? interfaces,
  Iterable<String>? documentation,
}) {
  assert((interfaces == null) != (methods == null), 'Either provide an interface or methods.');
  final className = '\$$identifier$interfaceSuffix';

  return Class((b) {
    if (documentation != null) {
      b.docs.addAll(documentation);
    }

    b
      ..abstract = true
      ..modifier = ClassModifier.interface
      ..name = className
      ..annotations.add(refer('BuiltValue').call([], {'instantiable': literalFalse}));

    if (interfaces != null) {
      b.implements.addAll(
        interfaces.map((i) => refer('\$${i.name}$interfaceSuffix')),
      );
    }

    if (methods != null) {
      b.methods.addAll(methods);
    }
  });
}
