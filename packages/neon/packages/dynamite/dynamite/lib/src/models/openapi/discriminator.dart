import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discriminator.g.dart';

abstract class Discriminator implements Built<Discriminator, DiscriminatorBuilder> {
  factory Discriminator([void Function(DiscriminatorBuilder) updates]) = _$Discriminator;

  const Discriminator._();

  static Serializer<Discriminator> get serializer => _$discriminatorSerializer;

  String get propertyName;

  BuiltMap<String, String>? get mapping;
}
