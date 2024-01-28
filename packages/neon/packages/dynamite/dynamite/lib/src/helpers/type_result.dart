import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/type_result.dart';
import 'package:source_helper/source_helper.dart';

/// Escapes a [value] using the type specific syntax from [result].
///
/// Use [forceString] to ensure the returned value is a `String`.
String valueToEscapedValue(TypeResult result, String value, {bool forceString = false}) {
  if ((result is TypeResultBase && result.name == 'String') || forceString) {
    return escapeDartString(value);
  }
  if (result is TypeResultList) {
    return 'const <${result.subType.name}>$value';
  }
  if (result is TypeResultEnum) {
    return '${result.name}.${toDartName(value)}';
  }
  return value;
}
