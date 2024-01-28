import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_io/io.dart';

/// A [BytesLoader] that decodes SVG data from a file in an isolate and creates
/// a vector_graphics binary representation.
///
/// It has the same logic as [SvgFileLoader], but uses universal_io to also work on web.
class UniversalSvgFileLoader extends SvgLoader<void> {
  /// Creates a new universal SVG file loader.
  const UniversalSvgFileLoader(
    this.file, {
    super.theme,
    super.colorMapper,
  });

  /// The file containing the SVG data to decode and render.
  final File file;

  @override
  String provideSvg(void message) => utf8.decode(file.readAsBytesSync(), allowMalformed: true);

  @override
  int get hashCode => Object.hash(file, theme, colorMapper);

  @override
  bool operator ==(Object other) =>
      other is UniversalSvgFileLoader && other.file == file && other.theme == theme && other.colorMapper == colorMapper;
}
