import 'package:built_value/serializer.dart';
import 'package:dynamite_runtime/models.dart';
import 'package:dynamite_runtime/src/utils/codecs.dart';

/// Serialization plugin for decoding [Header]s.
///
/// This plugin must be after the `StandardJsonPlugin`.
class HeaderPlugin implements SerializerPlugin {
  /// Creates a new serialization plugin for decoding [Header]s.
  ///
  /// This plugin must be after the `StandardJsonPlugin`.
  const HeaderPlugin();

  @override
  Object? afterDeserialize(Object? object, FullType specifiedType) => object;

  @override
  Object? afterSerialize(Object? object, FullType specifiedType) {
    if (specifiedType.root != Header) {
      return object;
    }

    if (object == null) {
      return object;
    }

    if (object is! Map<String, dynamic>) {
      throw StateError('HeaderPlugin can only be applied to Map<String, dynamic>. '
          'Please ensure the StandardJsonPlugin is applied and run before.');
    }

    final content = object['content'];
    return const HeaderEncoder().convert(content);
  }

  @override
  Object? beforeDeserialize(Object? object, FullType specifiedType) {
    if (specifiedType.root != Header) {
      return object;
    }

    if (object == null) {
      return object;
    }

    if (object is! String) {
      throw StateError('The serialized Header must be of type String. '
          'Please ensure the StandardJsonPlugin is applied and run before.');
    }

    final elementType = specifiedType.parameters.isEmpty ? FullType.unspecified : specifiedType.parameters[0];
    final content = HeaderDecoder(specifiedType: elementType).convert(object);

    return ['content', content];
  }

  @override
  Object? beforeSerialize(Object? object, FullType specifiedType) => object;
}
