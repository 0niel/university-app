import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/builder/resolve_type.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/dynamite.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';

TypeResult? resolveMimeTypeDecode(
  openapi.Response response,
  openapi.OpenAPI spec,
  State state,
  String identifier,
) {
  if (response.content != null) {
    if (response.content!.length > 1) {
      print('Can not work with multiple mime types right now. Using the first supported.');
    }

    for (final content in response.content!.entries) {
      final mimeType = content.key;
      final mediaType = content.value;

      final result = resolveType(
        spec,
        state,
        toDartName('$identifier-$mimeType', uppercaseFirstCharacter: true),
        mediaType.schema!,
      );

      if (mimeType == '*/*' || mimeType == 'application/octet-stream' || mimeType.startsWith('image/')) {
        return TypeResultObject('Uint8List');
      } else if (mimeType.startsWith('text/') || mimeType == 'application/javascript') {
        return TypeResultBase('String');
      } else if (mimeType == 'application/json') {
        return result;
      }
    }
    throw Exception('Can not parse any mime type of Operation: "$identifier"');
  }
  return null;
}

Iterable<String> resolveMimeTypeEncode(
  openapi.Operation operation,
  openapi.OpenAPI spec,
  State state,
  String identifier,
  ListBuilder<Parameter> b,
) sync* {
  if (operation.requestBody != null) {
    if (operation.requestBody!.content!.length > 1) {
      print('Can not work with multiple mime types right now. Using the first supported.');
    }
    for (final content in operation.requestBody!.content!.entries) {
      final mimeType = content.key;
      final mediaType = content.value;

      yield "_headers['Content-Type'] = '$mimeType';";

      final dartParameterNullable = isDartParameterNullable(
        operation.requestBody!.required,
        mediaType.schema,
      );

      final result = resolveType(
        spec,
        state,
        toDartName('$identifier-request-$mimeType', uppercaseFirstCharacter: true),
        mediaType.schema!,
        nullable: dartParameterNullable,
      );
      final parameterName = toDartName(result.name);
      switch (mimeType) {
        case 'application/json':
        case 'application/x-www-form-urlencoded':
          final dartParameterRequired = isRequired(
            operation.requestBody!.required,
            mediaType.schema,
          );
          b.add(
            Parameter(
              (b) => b
                ..name = parameterName
                ..type = refer(result.nullableName)
                ..named = true
                ..required = dartParameterRequired,
            ),
          );

          if (dartParameterNullable) {
            yield 'if ($parameterName != null) {';
          }
          yield '_body = utf8.encode(${result.encode(parameterName, mimeType: mimeType)});';
          if (dartParameterNullable) {
            yield '}';
          }
          return;
        case 'application/octet-stream':
          final dartParameterRequired = isRequired(
            operation.requestBody!.required,
            mediaType.schema,
          );
          b.add(
            Parameter(
              (b) => b
                ..name = parameterName
                ..type = refer(result.nullableName)
                ..named = true
                ..required = dartParameterRequired,
            ),
          );

          if (dartParameterNullable) {
            yield 'if ($parameterName != null) {';
          }
          yield '_body = ${result.encode(parameterName, mimeType: mimeType)};';
          if (dartParameterNullable) {
            yield '}';
          }
          return;
      }
    }

    throw Exception('Can not parse any mime type of Operation: "$identifier"');
  }
}
