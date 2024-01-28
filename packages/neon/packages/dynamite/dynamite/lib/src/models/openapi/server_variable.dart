import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_variable.g.dart';

abstract class ServerVariable implements Built<ServerVariable, ServerVariableBuilder> {
  factory ServerVariable([void Function(ServerVariableBuilder) updates]) = _$ServerVariable;

  const ServerVariable._();

  static Serializer<ServerVariable> get serializer => _$serverVariableSerializer;

  @BuiltValueField(wireName: 'default')
  String get $default;

  @BuiltValueField(wireName: 'enum')
  BuiltList<String>? get $enum;

  @BuiltValueField(compare: false)
  String? get description;
}
