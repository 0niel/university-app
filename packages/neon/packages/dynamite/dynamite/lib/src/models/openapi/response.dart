import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/openapi/header.dart';
import 'package:dynamite/src/models/openapi/media_type.dart';

part 'response.g.dart';

abstract class Response implements Built<Response, ResponseBuilder> {
  factory Response([void Function(ResponseBuilder) updates]) = _$Response;

  const Response._();

  static Serializer<Response> get serializer => _$responseSerializer;

  @BuiltValueField(compare: false)
  String get description;

  BuiltMap<String, MediaType>? get content;

  BuiltMap<String, Header>? get headers;
}
