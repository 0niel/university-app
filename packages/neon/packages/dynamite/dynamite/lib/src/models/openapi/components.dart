import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/openapi/schema.dart';
import 'package:dynamite/src/models/openapi/security_scheme.dart';

part 'components.g.dart';

abstract class Components implements Built<Components, ComponentsBuilder> {
  factory Components([void Function(ComponentsBuilder) updates]) = _$Components;

  const Components._();

  static Serializer<Components> get serializer => _$componentsSerializer;

  BuiltMap<String, SecurityScheme>? get securitySchemes;

  BuiltMap<String, Schema>? get schemas;
}
