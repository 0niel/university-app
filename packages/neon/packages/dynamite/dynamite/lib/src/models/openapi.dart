import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite/src/models/openapi/components.dart';
import 'package:dynamite/src/models/openapi/contact.dart';
import 'package:dynamite/src/models/openapi/discriminator.dart';
import 'package:dynamite/src/models/openapi/header.dart';
import 'package:dynamite/src/models/openapi/info.dart';
import 'package:dynamite/src/models/openapi/license.dart';
import 'package:dynamite/src/models/openapi/media_type.dart';
import 'package:dynamite/src/models/openapi/open_api.dart';
import 'package:dynamite/src/models/openapi/operation.dart';
import 'package:dynamite/src/models/openapi/parameter.dart';
import 'package:dynamite/src/models/openapi/path_item.dart';
import 'package:dynamite/src/models/openapi/request_body.dart';
import 'package:dynamite/src/models/openapi/response.dart';
import 'package:dynamite/src/models/openapi/schema.dart';
import 'package:dynamite/src/models/openapi/security_scheme.dart';
import 'package:dynamite/src/models/openapi/server.dart';
import 'package:dynamite/src/models/openapi/server_variable.dart';
import 'package:dynamite/src/models/openapi/tag.dart';

export 'openapi/components.dart';
export 'openapi/discriminator.dart';
export 'openapi/header.dart';
export 'openapi/info.dart';
export 'openapi/license.dart';
export 'openapi/media_type.dart';
export 'openapi/open_api.dart';
export 'openapi/operation.dart';
export 'openapi/parameter.dart';
export 'openapi/path_item.dart';
export 'openapi/request_body.dart';
export 'openapi/response.dart';
export 'openapi/schema.dart';
export 'openapi/security_scheme.dart';
export 'openapi/server.dart';
export 'openapi/server_variable.dart';
export 'openapi/tag.dart';

part 'openapi.g.dart';

@SerializersFor([
  Components,
  Contact,
  Discriminator,
  Header,
  Info,
  License,
  MediaType,
  OpenAPI,
  Operation,
  Parameter,
  PathItem,
  RequestBody,
  Response,
  Schema,
  SecurityScheme,
  Server,
  ServerVariable,
  Tag,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(String)]),
        ]),
        MapBuilder<String, BuiltList<String>>.new,
      )
      ..addPlugin(StandardJsonPlugin()))
    .build();
