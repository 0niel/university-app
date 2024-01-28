import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/helpers/docs.dart';
import 'package:dynamite/src/models/openapi/parameter.dart';
import 'package:dynamite/src/models/openapi/request_body.dart';
import 'package:dynamite/src/models/openapi/response.dart';

part 'operation.g.dart';

abstract class Operation implements Built<Operation, OperationBuilder> {
  factory Operation([void Function(OperationBuilder) updates]) = _$Operation;

  const Operation._();

  static Serializer<Operation> get serializer => _$operationSerializer;

  String? get operationId;

  @BuiltValueField(compare: false)
  String? get summary;

  @BuiltValueField(compare: false)
  String? get description;

  bool get deprecated;

  BuiltSet<String>? get tags;

  BuiltList<Parameter>? get parameters;

  RequestBody? get requestBody;

  BuiltMap<String, Response>? get responses;

  BuiltList<BuiltMap<String, BuiltList<String>>>? get security;

  @BuiltValueHook(finalizeBuilder: true)
  static void _defaults(OperationBuilder b) {
    b.deprecated ??= false;
  }

  Iterable<String> formattedDescription(
    String methodName, {
    bool isRawRequest = false,
    bool requiresAuth = false,
  }) sync* {
    if (summary != null && summary!.isNotEmpty) {
      yield* descriptionToDocs(summary);
      yield docsSeparator;
    }

    if (description != null && description!.isNotEmpty) {
      yield* descriptionToDocs(description);
      yield docsSeparator;
    }

    if (isRawRequest) {
      yield '''
$docsSeparator This method and the response it returns is experimental. The API might change without a major version bump.
$docsSeparator
$docsSeparator Returns a [Future] containing a `DynamiteRawResponse` with the raw `HttpClientResponse` and serialization helpers.''';
    } else {
      yield '$docsSeparator Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.';
    }
    yield '$docsSeparator Throws a `DynamiteApiException` if the API call does not return an expected status code.';
    yield docsSeparator;

    if (parameters != null && parameters!.isNotEmpty) {
      yield '$docsSeparator Parameters:';
      for (final parameter in parameters!) {
        yield parameter.formattedDescription;
      }
      yield docsSeparator;
    }

    if (responses != null && responses!.isNotEmpty) {
      yield '$docsSeparator Status codes:';
      for (final response in responses!.entries) {
        final statusCode = response.key;
        final description = response.value.description;

        final buffer = StringBuffer()
          ..write('$docsSeparator ')
          ..write('  * $statusCode');

        if (description.isNotEmpty) {
          buffer
            ..write(': ')
            ..write(description);
        }

        yield buffer.toString();
      }
      yield docsSeparator;
    }

    yield '$docsSeparator See:';
    if (isRawRequest) {
      yield '$docsSeparator  * [$methodName] for an operation that returns a `DynamiteResponse` with a stable API.';
    } else {
      yield '$docsSeparator  * [${methodName}Raw] for an experimental operation that returns a `DynamiteRawResponse` that can be serialized.';
    }
  }
}
