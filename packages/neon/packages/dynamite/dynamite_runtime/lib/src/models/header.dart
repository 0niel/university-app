import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'header.g.dart';

/// Header data.
///
/// Encoding follows [OpenAPI-Specification](https://swagger.io/docs/specification/serialization/).
abstract class Header<T> implements Built<Header<T>, HeaderBuilder<T>> {
  /// Creates a new header object.
  factory Header([void Function(HeaderBuilder<T>)? b]) = _$Header<T>;
  const Header._();

  /// The decoded value of the header.
  T get content;

  /// The serializer for a header object.
  static Serializer<Header<Object?>> get serializer => _$headerSerializer;
}
