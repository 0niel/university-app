import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_string.g.dart';

/// Json data encoded in a `String` as defined by [json-schema](https://json-schema.org/understanding-json-schema/reference/non_json_data.html#contentschema).
abstract class ContentString<T> implements Built<ContentString<T>, ContentStringBuilder<T>> {
  /// Creates a new content `String`.
  factory ContentString([void Function(ContentStringBuilder<T>)? b]) = _$ContentString<T>;
  const ContentString._();

  /// The decoded value of the content `String`.
  T get content;

  /// The serializer for a content `String`.
  static Serializer<ContentString<Object?>> get serializer => _$contentStringSerializer;
}
