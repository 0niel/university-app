import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/openapi/media_type.dart';

part 'request_body.g.dart';

abstract class RequestBody implements Built<RequestBody, RequestBodyBuilder> {
  factory RequestBody([void Function(RequestBodyBuilder) updates]) = _$RequestBody;

  const RequestBody._();

  static Serializer<RequestBody> get serializer => _$requestBodySerializer;

  @BuiltValueField(compare: false)
  String? get description;

  BuiltMap<String, MediaType>? get content;

  bool get required;

  @BuiltValueHook(finalizeBuilder: true)
  static void _defaults(RequestBodyBuilder b) {
    b.required ??= false;
  }
}
