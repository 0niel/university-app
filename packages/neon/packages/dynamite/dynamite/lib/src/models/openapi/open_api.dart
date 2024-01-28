import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/exceptions.dart';
import 'package:dynamite/src/models/openapi/components.dart';
import 'package:dynamite/src/models/openapi/info.dart';
import 'package:dynamite/src/models/openapi/path_item.dart';
import 'package:dynamite/src/models/openapi/server.dart';
import 'package:dynamite/src/models/openapi/tag.dart';
import 'package:uri/uri.dart';

part 'open_api.g.dart';

abstract class OpenAPI implements Built<OpenAPI, OpenAPIBuilder> {
  factory OpenAPI([void Function(OpenAPIBuilder) updates]) = _$OpenAPI;

  const OpenAPI._();

  static Serializer<OpenAPI> get serializer => _$openAPISerializer;

  @BuiltValueField(wireName: 'openapi')
  String get version;

  Info get info;

  BuiltList<Server> get servers;

  BuiltList<BuiltMap<String, BuiltList<String>>>? get security;

  BuiltSet<Tag>? get tags;

  Components? get components;

  BuiltMap<String, PathItem>? get paths;

  bool get hasAnySecurity => components?.securitySchemes?.isNotEmpty ?? false;

  @BuiltValueHook(finalizeBuilder: true)
  static void _defaults(OpenAPIBuilder b) {
    if (b.servers.isEmpty) {
      b.servers.add(
        Server(
          (b) => b.url = '/',
        ),
      );
    }

    for (final path in b.paths.build().keys) {
      try {
        UriTemplate(path);
      } on ParseException {
        throw OpenAPISpecError(
          'Path parameters must only contain alphanumeric characters, underscores or percent encoded values: $path',
        );
      }
    }
  }
}
