// ignore_for_file: avoid_positional_boolean_parameters

import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;

String filterMethodName(String operationId, String tag) {
  final expandedTag = tag.split('/').toList();
  final parts = operationId.split('-');
  final output = <String>[];
  for (var i = 0; i < parts.length; i++) {
    if (expandedTag.length <= i || expandedTag[i] != parts[i]) {
      output.add(parts[i]);
    }
  }
  return output.join('-');
}

String clientName(String tag) => '\$${toDartName(tag, uppercaseFirstCharacter: true)}Client';

bool isDartParameterNullable(
  bool required,
  openapi.Schema? schema,
) =>
    (!required && schema?.$default == null) || (schema?.nullable ?? false);

bool isRequired(
  bool required,
  openapi.Schema? schema,
) =>
    required && schema?.$default == null;

int sortRequiredParameters(openapi.Parameter a, openapi.Parameter b) {
  final aRequired = isRequired(a.required, a.schema);
  final bRequired = isRequired(b.required, b.schema);

  if (aRequired != bRequired) {
    if (aRequired && !bRequired) {
      return -1;
    } else {
      return 1;
    }
  }

  return 0;
}
