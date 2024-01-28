import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

/// A stream of bytes.
///
/// Usually a `Stream<Uint8List>`.
typedef BytesStream = Stream<List<int>>;

/// Converter for UTF-8 encoded bytes to JSON.
@visibleForTesting
final jsonBytesConverter = utf8.decoder.fuse(json.decoder);

/// Converter for UTF-8 encoded bytes to XML.
@visibleForTesting
final xmlBytesConverter =
    utf8.decoder.fuse(XmlEventDecoder()).fuse(const XmlNormalizeEvents()).fuse(const XmlNodeDecoder());

/// Extension on byte streams that enable efficient transformations.
extension BytesStreamExtension on BytesStream {
  /// Collects all bytes from this stream into one Uint8List.
  ///
  /// The collector will assume that the bytes in this stream will not change.
  /// See [BytesBuilder] for further information.
  Future<Uint8List> get bytes async {
    final buffer = BytesBuilder(copy: false);

    await forEach(buffer.add);

    return buffer.toBytes();
  }

  /// Converts the stream into a `String` using the [utf8] encoding.
  Future<String> get string => transform(utf8.decoder).join();

  /// Converts the stream into a JSON using the [utf8] encoding.
  Future<Object?> get json => transform(jsonBytesConverter).first;

  /// Converts the stream into XML using the [utf8] encoding.
  ///
  /// Returns the root element of this stream.
  Future<XmlElement> get xml async {
    final element =
        await transform(xmlBytesConverter).expand((events) => events).firstWhere((element) => element is XmlElement);

    return element as XmlElement;
  }
}
