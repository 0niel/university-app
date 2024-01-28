import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dynamite/src/builder/resolve_mime_type.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/resolve_type.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/dynamite.dart';
import 'package:dynamite/src/helpers/pattern_check.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';
import 'package:intersperse/intersperse.dart';
import 'package:source_helper/source_helper.dart';
import 'package:uri/uri.dart';

Iterable<Class> generateClients(
  openapi.OpenAPI spec,
  State state,
) sync* {
  if (spec.paths == null || spec.paths!.isEmpty) {
    return;
  }

  final tags = generateTags(spec);
  yield buildRootClient(spec, state, tags);

  for (final tag in tags) {
    yield buildClient(spec, state, tag);
  }
}

Class buildRootClient(
  openapi.OpenAPI spec,
  State state,
  Set<openapi.Tag> tags,
) =>
    Class(
      (b) {
        final rootTag = spec.tags?.firstWhereOrNull((tag) => tag.name.isEmpty);
        if (rootTag != null) {
          b.docs.addAll(rootTag.formattedDescription);
        }

        b
          ..extend = refer('DynamiteClient', 'package:dynamite_runtime/http_client.dart')
          ..name = r'$Client'
          ..constructors.addAll([
            Constructor(
              (b) => b
                ..docs.add('/// Creates a new `DynamiteClient` for untagged requests.')
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'baseURL'
                      ..toSuper = true,
                  ),
                )
                ..optionalParameters.addAll([
                  Parameter(
                    (b) => b
                      ..name = 'baseHeaders'
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (b) => b
                      ..name = 'httpClient'
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (b) => b
                      ..name = 'cookieJar'
                      ..toSuper = true
                      ..named = true,
                  ),
                  if (spec.hasAnySecurity) ...[
                    Parameter(
                      (b) => b
                        ..name = 'authentications'
                        ..toSuper = true
                        ..named = true,
                    ),
                  ],
                ]),
            ),
            Constructor(
              (b) => b
                ..docs.add(r'/// Creates a new [$Client] from another [client].')
                ..name = 'fromClient'
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'client'
                      ..type = refer('DynamiteClient', 'package:dynamite_runtime/http_client.dart'),
                  ),
                )
                ..initializers.add(
                  const Code('''
super(
  client.baseURL,
  baseHeaders: client.baseHeaders,
  httpClient: client.httpClient,
  cookieJar: client.cookieJar,
  authentications: client.authentications,
)
'''),
                ),
            ),
          ]);

        for (final tag in tags) {
          final client = clientName(tag.name);

          b.fields.add(
            Field(
              (b) => b
                ..docs.addAll(tag.formattedDescription)
                ..name = toDartName(tag.name)
                ..late = true
                ..modifier = FieldModifier.final$
                ..type = refer(client)
                ..assignment = Code('$client(this)'),
            ),
          );
        }

        b.methods.addAll(buildTags(spec, state, null));
      },
    );

Class buildClient(
  openapi.OpenAPI spec,
  State state,
  openapi.Tag tag,
) =>
    Class(
      (b) {
        final name = clientName(tag.name);
        b
          ..docs.addAll(tag.formattedDescription)
          ..name = name
          ..constructors.add(
            Constructor(
              (b) => b
                ..docs.add('/// Creates a new `DynamiteClient` for ${tag.name} requests.')
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = '_rootClient'
                      ..toThis = true,
                  ),
                ),
            ),
          )
          ..fields.add(
            Field(
              (b) => b
                ..name = '_rootClient'
                ..type = refer(r'$Client')
                ..modifier = FieldModifier.final$,
            ),
          );

        b.methods.addAll(buildTags(spec, state, tag.name));
      },
    );

Iterable<Method> buildTags(
  openapi.OpenAPI spec,
  State state,
  String? tag,
) sync* {
  final client = tag == null ? 'this' : '_rootClient';
  final paths = generatePaths(spec, tag);

  for (final pathEntry in paths.entries) {
    for (final operationEntry in pathEntry.value.operations.entries) {
      final httpMethod = operationEntry.key.name;
      final operation = operationEntry.value;
      final operationName = operation.operationId ?? toDartName('$httpMethod-${pathEntry.key}');
      final parameters = [
        ...?pathEntry.value.parameters,
        ...?operation.parameters,
      ]..sort(sortRequiredParameters);
      final name = toDartName(filterMethodName(operationName, tag ?? ''));

      final hasContentEncoding = operation.requestBody?.content?.entries.isNotEmpty ?? false;
      final hasAuthentication = needsAuthCheck(pathEntry, operation, spec, client);
      var hasUriParameters = false;
      var hasHeaderParameters = false;
      for (final parameter in parameters) {
        switch (parameter.$in) {
          case openapi.ParameterType.path:
          case openapi.ParameterType.query:
            hasUriParameters = true;
          case openapi.ParameterType.header:
            hasHeaderParameters = true;
          default:
        }

        // No need to continue searching.
        if (hasHeaderParameters && hasUriParameters) {
          break;
        }
      }

      var responses = <openapi.Response, Set<dynamic>>{};
      if (operation.responses != null) {
        for (final responseEntry in operation.responses!.entries) {
          final statusCode = responseEntry.key;
          final response = responseEntry.value;

          responses[response] ??= {};
          responses[response]!.add(int.tryParse(statusCode) ?? statusCode);
        }

        if (responses.length > 1) {
          print('$operationName uses more than one response schema but we only generate the first one');
          responses = Map.fromEntries([responses.entries.first]);
        }
      }

      final code = StringBuffer();
      final acceptHeader = responses.keys
          .map((response) => response.content?.keys)
          .whereNotNull()
          .expand((element) => element)
          .toSet()
          .join(',');

      if (hasUriParameters) {
        code.writeln('final _parameters = <String, dynamic>{};');
      }

      Expression? headersExpression;
      if (hasHeaderParameters || hasAuthentication || hasContentEncoding) {
        headersExpression = declareFinal('_headers');
      } else if (acceptHeader.isNotEmpty) {
        headersExpression = declareConst('_headers');
      }

      if (headersExpression != null) {
        final headersCode = headersExpression
            .assign(
              literalMap(
                {if (acceptHeader.isNotEmpty) 'Accept': acceptHeader},
                refer('String'),
                refer('String'),
              ),
            )
            .statement
            .accept(state.emitter);

        code.writeln(headersCode);
      }

      if (operation.requestBody != null) {
        code.writeln('Uint8List? _body;');
      }
      // Separate the declarations from the assignments
      code.writeln();

      if (hasAuthentication) {
        buildAuthCheck(
          state,
          pathEntry,
          operation,
          spec,
          client,
        ).forEach(code.writeln);
      }

      final operationParameters = ListBuilder<Parameter>();
      final annotations = operation.deprecated ? refer('Deprecated').call([refer("''")]) : null;
      var returnDataType = 'void';
      var returnHeadersType = 'void';

      for (final parameter in parameters) {
        final parameterRequired = isRequired(
          parameter.required,
          parameter.schema,
        );

        final result = resolveType(
          spec,
          state,
          toDartName(
            '$operationName-${parameter.name}',
            uppercaseFirstCharacter: true,
          ),
          parameter.schema!,
          nullable: !parameterRequired,
        );

        operationParameters.add(
          Parameter(
            (b) {
              b
                ..named = true
                ..name = toDartName(parameter.name)
                ..required = parameterRequired
                ..type = refer(result.nullableName);
            },
          ),
        );

        code.writeln(buildParameterSerialization(result, parameter, state));
      }
      resolveMimeTypeEncode(operation, spec, state, operationName, operationParameters).forEach(code.writeln);

      for (final responseEntry in responses.entries) {
        final response = responseEntry.key;
        final statusCodes = responseEntry.value;

        TypeResult? headersType;

        if (response.headers != null) {
          final identifierBuilder = StringBuffer();
          if (tag != null) {
            identifierBuilder.write(toDartName(tag, uppercaseFirstCharacter: true));
          }
          identifierBuilder
            ..write(toDartName(operationName, uppercaseFirstCharacter: true))
            ..write('Headers');
          headersType = resolveObject(
            spec,
            state,
            identifierBuilder.toString(),
            openapi.Schema(
              (b) => b
                ..properties.replace(
                  response.headers!.map(
                    (headerName, value) => MapEntry(
                      headerName.toLowerCase(),
                      value.schema!,
                    ),
                  ),
                ),
            ),
            isHeader: true,
          );
        }

        final identifierBuilder = StringBuffer()
          ..write(operationName)
          ..write('-response');
        if (responses.entries.length > 1) {
          identifierBuilder
            ..write('-')
            ..write(responses.entries.toList().indexOf(responseEntry));
        }

        final dataType = resolveMimeTypeDecode(
          response,
          spec,
          state,
          toDartName(identifierBuilder.toString(), uppercaseFirstCharacter: true),
        );

        if (!hasUriParameters) {
          code.writeln("const _path = '${pathEntry.key}';");
        } else {
          final queryParams = <String>[];
          for (final parameter in parameters) {
            if (parameter.$in != openapi.ParameterType.query) {
              continue;
            }

            // Default to a plain parameter without exploding.
            queryParams.add(parameter.uriTemplate(withPrefix: false) ?? parameter.pctEncodedName);
          }

          final pathBuilder = StringBuffer()..write(pathEntry.key);

          if (queryParams.isNotEmpty) {
            pathBuilder
              ..write('{?')
              ..writeAll(queryParams, ',')
              ..write('}');
          }

          final path = pathBuilder.toString();
          // Sanity check the uri at build time.
          try {
            UriTemplate(path);
          } on ParseException catch (e) {
            throw Exception('The resulting uri $path is not a valid uri template according to RFC 6570. $e');
          }

          final pathDeclaration = declareFinal('_path')
              .assign(
                refer('UriTemplate', 'package:uri/uri.dart')
                    .newInstance([literalString(path)])
                    .property('expand')
                    .call([refer('_parameters')]),
              )
              .statement
              .accept(state.emitter);

          code.writeln(pathDeclaration);
        }

        if (dataType != null) {
          returnDataType = dataType.name;
        }
        if (headersType != null) {
          returnHeadersType = headersType.name;
        }

        final returnValue = refer(
          'DynamiteRawResponse<$returnDataType, $returnHeadersType>',
          'package:dynamite_runtime/http_client.dart',
        ).newInstance(const [], {
          'response': refer(client).property('executeRequest').call([
            literalString(httpMethod),
            refer('_path'),
          ], {
            if (acceptHeader.isNotEmpty || hasHeaderParameters || hasAuthentication || hasContentEncoding)
              'headers': refer('_headers'),
            if (operation.requestBody != null) 'body': refer('_body'),
            if (responses.values.isNotEmpty && !statusCodes.contains('default'))
              'validStatuses': literalConstSet(statusCodes),
          }),
          'bodyType': refer(dataType?.fullType ?? 'null'),
          'headersType': refer(headersType?.fullType ?? 'null'),
          'serializers': refer(r'_$jsonSerializers'),
        });

        code.writeln(returnValue.returned.statement.accept(state.emitter));
      }

      yield Method((b) {
        b
          ..name = name
          ..modifier = MethodModifier.async
          ..docs.addAll(operation.formattedDescription(name));

        if (annotations != null) {
          b.annotations.add(annotations);
        }

        final parameters = operationParameters.build();
        final rawParameters = parameters.map((p) => '${p.name}: ${p.name},').join('\n');
        final responseType = refer(
          'DynamiteResponse<$returnDataType, $returnHeadersType>',
          'package:dynamite_runtime/http_client.dart',
        ).accept(state.emitter);

        b
          ..optionalParameters.addAll(parameters)
          ..returns = refer('Future<$responseType>')
          ..body = Code('''
final rawResponse = ${name}Raw(
  $rawParameters
);

return rawResponse.future;
''');
      });

      yield Method(
        (b) {
          b
            ..name = '${name}Raw'
            ..docs.addAll(operation.formattedDescription(name, isRawRequest: true))
            ..annotations.add(refer('experimental', 'package:meta/meta.dart'));

          if (annotations != null) {
            b.annotations.add(annotations);
          }

          b
            ..optionalParameters.addAll(operationParameters.build())
            ..returns = refer(
              'DynamiteRawResponse<$returnDataType, $returnHeadersType>',
              'package:dynamite_runtime/http_client.dart',
            )
            ..body = Code(code.toString());
        },
      );
    }
  }
}

String buildParameterSerialization(
  TypeResult result,
  openapi.Parameter parameter,
  State state,
) {
  final $default = parameter.schema?.$default;
  var defaultValueCode = $default?.value;
  if ($default != null && $default.isString) {
    defaultValueCode = escapeDartString($default.asString);
  }
  final dartName = toDartName(parameter.name);
  final serializedName = '\$$dartName';
  final buffer = StringBuffer();

  if ($default != null) {
    buffer
      ..write('var $serializedName = ${result.serialize(dartName)};')
      ..writeln('$serializedName ??= $defaultValueCode;');
  } else {
    buffer.write('final $serializedName = ${result.serialize(dartName)};');
  }

  if (parameter.schema != null) {
    // TODO: migrate the entire client generation to code_builder
    buildPatternCheck(parameter.schema!, serializedName, dartName).forEach(
      (l) => buffer.writeln(
        l.statement.accept(state.emitter),
      ),
    );
  }

  if (parameter.$in == openapi.ParameterType.header) {
    final assignment = refer('_headers')
        .index(literalString(parameter.pctEncodedName))
        .assign(
          refer('HeaderEncoder', 'package:dynamite_runtime/utils.dart')
              .constInstance(const [], {
                'explode': literalBool(parameter.explode),
              })
              .property('convert')
              .call([refer(serializedName)]),
        )
        .statement
        .accept(state.emitter);

    if ($default == null) {
      buffer
        ..writeln('if ($serializedName != null) {')
        ..writeln(assignment)
        ..writeln('}');
    } else {
      buffer.writeln(assignment);
    }
  } else {
    buffer.writeln("_parameters['${parameter.pctEncodedName}'] = $serializedName;");
  }

  return buffer.toString();
}

bool needsAuthCheck(
  MapEntry<String, openapi.PathItem> pathEntry,
  openapi.Operation operation,
  openapi.OpenAPI spec,
  String client,
) {
  final security = operation.security ?? spec.security ?? BuiltList();
  final securityRequirements = security.where((requirement) => requirement.isNotEmpty);

  return securityRequirements.isNotEmpty;
}

Iterable<String> buildAuthCheck(
  State state,
  MapEntry<String, openapi.PathItem> pathEntry,
  openapi.Operation operation,
  openapi.OpenAPI spec,
  String client,
) sync* {
  final security = operation.security ?? spec.security ?? BuiltList();
  final securityRequirements = security.where((requirement) => requirement.isNotEmpty);
  final isOptionalSecurity = securityRequirements.length != security.length;

  if (securityRequirements.isEmpty) {
    return;
  }

  yield '''
// coverage:ignore-start
final authentication = $client.authentications?.firstWhereOrNull(
    (auth) => switch (auth) {
''';

  yield* securityRequirements.map((requirement) {
    final securityScheme = spec.components!.securitySchemes![requirement.keys.single]!;
    final dynamiteAuth = toDartName(
      'Dynamite-${securityScheme.fullName.join('-')}-Authentication',
      uppercaseFirstCharacter: true,
    );
    return refer(dynamiteAuth, 'package:dynamite_runtime/http_client.dart')
        .newInstance(const [])
        .accept(state.emitter)
        .toString();
  }).intersperse(' || ');

  yield '''
        => true,
      _ => false,
    },
  );
''';

  yield '''
if(authentication != null) {
  _headers.addAll(
    authentication.headers,
  );
} 
''';

  if (!isOptionalSecurity) {
    yield '''
else {
  throw Exception('Missing authentication for ${securityRequirements.map((r) => r.keys.single).join(' or ')}');
}
''';
  }
  yield '// coverage:ignore-end';
}

Map<String, openapi.PathItem> generatePaths(openapi.OpenAPI spec, String? tag) {
  final paths = <String, openapi.PathItem>{};

  if (spec.paths != null) {
    for (final path in spec.paths!.entries) {
      for (final operationEntry in path.value.operations.entries) {
        final operation = operationEntry.value;
        if ((operation.tags != null && operation.tags!.contains(tag)) ||
            (tag == null && (operation.tags == null || operation.tags!.isEmpty))) {
          paths[path.key] ??= path.value;
          paths[path.key]!.rebuild((b) {
            switch (operationEntry.key) {
              case openapi.PathItemOperation.get:
                b.get.replace(operation);
              case openapi.PathItemOperation.put:
                b.put.replace(operation);
              case openapi.PathItemOperation.post:
                b.post.replace(operation);
              case openapi.PathItemOperation.delete:
                b.delete.replace(operation);
              case openapi.PathItemOperation.options:
                b.options.replace(operation);
              case openapi.PathItemOperation.head:
                b.head.replace(operation);
              case openapi.PathItemOperation.patch:
                b.patch.replace(operation);
              case openapi.PathItemOperation.trace:
                b.trace.replace(operation);
            }
          });
        }
      }
    }
  }

  return paths;
}

Set<openapi.Tag> generateTags(openapi.OpenAPI spec) {
  final tags = <openapi.Tag>[];

  if (spec.paths != null) {
    for (final pathItem in spec.paths!.values) {
      for (final operation in pathItem.operations.values) {
        if (operation.tags != null) {
          tags.addAll(
            operation.tags!.map((name) {
              final tag = spec.tags?.firstWhereOrNull((tag) => tag.name == name);
              return tag ?? openapi.Tag((b) => b..name = name);
            }),
          );
        }
      }
    }
  }

  tags.sort((a, b) => a.name.compareTo(b.name));
  return tags.toSet();
}
