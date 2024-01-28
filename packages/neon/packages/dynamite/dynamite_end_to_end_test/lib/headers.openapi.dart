// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: public_member_api_docs, unreachable_switch_case
// ignore_for_file: unused_element

/// headers test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:typed_data';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i4;
import 'package:dynamite_runtime/built_value.dart' as _i3;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

part 'headers.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.baseHeaders,
    super.httpClient,
    super.cookieJar,
  });

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(
          client.baseURL,
          baseHeaders: client.baseHeaders,
          httpClient: client.httpClient,
          cookieJar: client.cookieJar,
          authentications: client.authentications,
        );

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns a header only
  ///
  /// See:
  ///  * [$getRaw] for an experimental operation that returns a `DynamiteRawResponse` that can be serialized.
  Future<_i1.DynamiteResponse<void, GetHeaders>> $get() async {
    final rawResponse = $getRaw();

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a `DynamiteRawResponse` with the raw `HttpClientResponse` and serialization helpers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns a header only
  ///
  /// See:
  ///  * [$get] for an operation that returns a `DynamiteResponse` with a stable API.
  @_i2.experimental
  _i1.DynamiteRawResponse<void, GetHeaders> $getRaw() {
    const _path = '/';
    return _i1.DynamiteRawResponse<void, GetHeaders>(
      response: executeRequest(
        'get',
        _path,
        validStatuses: const {200},
      ),
      bodyType: null,
      headersType: const FullType(GetHeaders),
      serializers: _$jsonSerializers,
    );
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns a header only
  ///
  /// See:
  ///  * [withContentOperationIdRaw] for an experimental operation that returns a `DynamiteRawResponse` that can be serialized.
  Future<_i1.DynamiteResponse<void, WithContentOperationIdHeaders>> withContentOperationId() async {
    final rawResponse = withContentOperationIdRaw();

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a `DynamiteRawResponse` with the raw `HttpClientResponse` and serialization helpers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns a header only
  ///
  /// See:
  ///  * [withContentOperationId] for an operation that returns a `DynamiteResponse` with a stable API.
  @_i2.experimental
  _i1.DynamiteRawResponse<void, WithContentOperationIdHeaders> withContentOperationIdRaw() {
    const _path = '/with_content/operation_id';
    return _i1.DynamiteRawResponse<void, WithContentOperationIdHeaders>(
      response: executeRequest(
        'get',
        _path,
        validStatuses: const {200},
      ),
      bodyType: null,
      headersType: const FullType(WithContentOperationIdHeaders),
      serializers: _$jsonSerializers,
    );
  }

  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns both a header and a body.
  ///
  /// See:
  ///  * [getWithContentRaw] for an experimental operation that returns a `DynamiteRawResponse` that can be serialized.
  Future<_i1.DynamiteResponse<Uint8List, GetWithContentHeaders>> getWithContent() async {
    final rawResponse = getWithContentRaw();

    return rawResponse.future;
  }

  /// This method and the response it returns is experimental. The API might change without a major version bump.
  ///
  /// Returns a [Future] containing a `DynamiteRawResponse` with the raw `HttpClientResponse` and serialization helpers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Status codes:
  ///   * 200: Returns both a header and a body.
  ///
  /// See:
  ///  * [getWithContent] for an operation that returns a `DynamiteResponse` with a stable API.
  @_i2.experimental
  _i1.DynamiteRawResponse<Uint8List, GetWithContentHeaders> getWithContentRaw() {
    const _headers = <String, String>{'Accept': 'application/octet-stream'};

    const _path = '/with_content';
    return _i1.DynamiteRawResponse<Uint8List, GetWithContentHeaders>(
      response: executeRequest(
        'get',
        _path,
        headers: _headers,
        validStatuses: const {200},
      ),
      bodyType: const FullType(Uint8List),
      headersType: const FullType(GetWithContentHeaders),
      serializers: _$jsonSerializers,
    );
  }
}

@BuiltValue(instantiable: false)
abstract interface class $GetHeadersInterface {
  @BuiltValueField(wireName: 'my-header')
  String? get myHeader;
}

abstract class GetHeaders implements $GetHeadersInterface, Built<GetHeaders, GetHeadersBuilder> {
  /// Creates a new GetHeaders object using the builder pattern.
  factory GetHeaders([void Function(GetHeadersBuilder)? b]) = _$GetHeaders;

  const GetHeaders._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory GetHeaders.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for GetHeaders.
  static Serializer<GetHeaders> get serializer => _$getHeadersSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $WithContentOperationIdHeadersInterface {
  @BuiltValueField(wireName: 'my-header')
  String? get myHeader;
}

abstract class WithContentOperationIdHeaders
    implements
        $WithContentOperationIdHeadersInterface,
        Built<WithContentOperationIdHeaders, WithContentOperationIdHeadersBuilder> {
  /// Creates a new WithContentOperationIdHeaders object using the builder pattern.
  factory WithContentOperationIdHeaders([void Function(WithContentOperationIdHeadersBuilder)? b]) =
      _$WithContentOperationIdHeaders;

  const WithContentOperationIdHeaders._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory WithContentOperationIdHeaders.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for WithContentOperationIdHeaders.
  static Serializer<WithContentOperationIdHeaders> get serializer => _$withContentOperationIdHeadersSerializer;
}

@BuiltValue(instantiable: false)
abstract interface class $GetWithContentHeadersInterface {
  @BuiltValueField(wireName: 'my-header')
  String? get myHeader;
}

abstract class GetWithContentHeaders
    implements $GetWithContentHeadersInterface, Built<GetWithContentHeaders, GetWithContentHeadersBuilder> {
  /// Creates a new GetWithContentHeaders object using the builder pattern.
  factory GetWithContentHeaders([void Function(GetWithContentHeadersBuilder)? b]) = _$GetWithContentHeaders;

  const GetWithContentHeaders._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory GetWithContentHeaders.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for GetWithContentHeaders.
  static Serializer<GetWithContentHeaders> get serializer => _$getWithContentHeadersSerializer;
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..addBuilderFactory(const FullType(GetHeaders), GetHeadersBuilder.new)
      ..add(GetHeaders.serializer)
      ..addBuilderFactory(const FullType(WithContentOperationIdHeaders), WithContentOperationIdHeadersBuilder.new)
      ..add(WithContentOperationIdHeaders.serializer)
      ..addBuilderFactory(const FullType(GetWithContentHeaders), GetWithContentHeadersBuilder.new)
      ..add(GetWithContentHeaders.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i3.DynamiteDoubleSerializer())
      ..addPlugin(_i4.StandardJsonPlugin())
      ..addPlugin(const _i3.HeaderPlugin())
      ..addPlugin(const _i3.ContentStringPlugin()))
    .build();
// coverage:ignore-end