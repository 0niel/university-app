import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/openapi/schema.dart';

Iterable<Expression> buildPatternCheck(
  openapi.Schema schema,
  String value,
  String name,
) sync* {
  if (schema.type == SchemaType.string) {
    if (schema.pattern != null) {
      yield refer('checkPattern', 'package:dynamite_runtime/utils.dart').call([
        refer(value).asA(refer('String?')),
        refer('RegExp').call([literalString(schema.pattern!, raw: true)]),
        literalString(name),
      ]);
    }
    if (schema.minLength != null) {
      yield refer('checkMinLength', 'package:dynamite_runtime/utils.dart').call([
        refer(value).asA(refer('String?')),
        literalNum(schema.minLength!),
        literalString(name),
      ]);
    }
    if (schema.maxLength != null) {
      yield refer('checkMaxLength', 'package:dynamite_runtime/utils.dart').call([
        refer(value).asA(refer('String?')),
        literalNum(schema.maxLength!),
        literalString(name),
      ]);
    }
  }
}
