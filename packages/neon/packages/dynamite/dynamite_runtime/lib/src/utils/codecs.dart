import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite_runtime/models.dart';

/// A [HeaderCodec] encodes the json representation of a [Header] objects to
/// strings and decodes strings to serialized [Header] objects.
///
/// Examples:
/// ```dart
/// var codec = HeaderCodec(specifiedType: FullType(BuiltList, [FullType(int)]));
/// var encoded = codec.encode([1, 2, 3, 4]);
/// var decoded = codec.decode('1,2,3,4');
/// ```
final class HeaderCodec extends Codec<Object?, String> {
  /// Creates a `HeaderCodec` for the given [specifiedType] and encoding format ([explode]).
  ///
  /// The [specifiedType] is needed to revive the value when in the decoder.
  const HeaderCodec({
    required this.specifiedType,
    this.explode = false,
  });

  /// Whether exploding is used for the codec.
  final bool explode;

  /// The type of the revived object.
  final FullType specifiedType;

  @override
  HeaderDecoder get decoder => HeaderDecoder(
        explode: explode,
        specifiedType: specifiedType,
      );

  @override
  HeaderEncoder get encoder => HeaderEncoder(
        explode: explode,
      );
}

/// This class converts strings to serialized [Header] JSON objects.
final class HeaderDecoder extends Converter<String, Object?> {
  /// Creates a header decoder.
  const HeaderDecoder({
    required this.specifiedType,
    this.explode = false,
  });

  /// Whether exploding is used for the converter.
  final bool explode;

  /// The type of the revived object.
  final FullType specifiedType;

  @override
  Object? convert(String input) => _decode(input, specifiedType);

  Object? _decode(String content, FullType specifiedType) {
    if (explode) {
      throw UnimplementedError();
    }

    switch (specifiedType.root) {
      case const (Header):
        final elementType = specifiedType.parameters.isEmpty ? FullType.unspecified : specifiedType.parameters[0];

        return _decode(content, elementType);
      case const (Map) || const (BuiltMap):
        final values = content.split(',');
        final deserialized = <String, Object?>{};
        final elementType = specifiedType.parameters.isEmpty ? FullType.unspecified : specifiedType.parameters[1];

        for (var i = 0; i < values.length; i += 2) {
          deserialized[values[i]] = _decode(values[i + 1], elementType);
        }

        return deserialized;

      case const (List) || const (BuiltList):
        final elementType = specifiedType.parameters.isEmpty ? FullType.unspecified : specifiedType.parameters[0];

        return content.split(',').map((value) => _decode(value, elementType)).toList();
      default:
        if (specifiedType.root == String) {
          return content;
        } else if (content.isEmpty) {
          return null;
        }

        return jsonDecode(content);
    }
  }
}

/// This class converts serialized [Header] JSON objects to strings.
final class HeaderEncoder extends Converter<Object?, String> {
  /// Creates a header encoder.
  const HeaderEncoder({
    this.explode = false,
  });

  /// Whether exploding is used for the converter.
  final bool explode;

  @override
  String convert(Object? input) {
    if (explode) {
      throw UnimplementedError();
    }

    switch (input) {
      case Map():
        return input.entries.map((entry) => '${entry.key},${convert(entry.value)}').join(',');
      case List():
        return input.map(convert).join(',');

      default:
        if (input is String) {
          return input;
        }
        if (input == null) {
          return '';
        }

        // For primitives `toString` should result in the same.
        // Using the json codec to align with the decode converter.
        return jsonEncode(input);
    }
  }
}
