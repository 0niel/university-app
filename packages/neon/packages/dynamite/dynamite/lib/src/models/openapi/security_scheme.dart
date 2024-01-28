import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:collection/collection.dart';

part 'security_scheme.g.dart';

abstract class SecurityScheme implements Built<SecurityScheme, SecuritySchemeBuilder> {
  factory SecurityScheme([void Function(SecuritySchemeBuilder) updates]) = _$SecurityScheme;

  const SecurityScheme._();

  static Serializer<SecurityScheme> get serializer => _$securitySchemeSerializer;

  String get type;

  @BuiltValueField(compare: false)
  String? get description;

  String? get scheme;

  String? get $in;

  String? get name;

  Iterable<String> get fullName => [type, scheme, $in, name].whereNotNull();
}
