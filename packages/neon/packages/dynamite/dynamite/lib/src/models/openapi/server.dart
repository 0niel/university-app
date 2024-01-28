import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/openapi/server_variable.dart';

part 'server.g.dart';

abstract class Server implements Built<Server, ServerBuilder> {
  factory Server([void Function(ServerBuilder) updates]) = _$Server;

  const Server._();

  static Serializer<Server> get serializer => _$serverSerializer;

  String get url;

  BuiltMap<String, ServerVariable>? get variables;
}
