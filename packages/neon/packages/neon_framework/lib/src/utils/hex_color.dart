import 'dart:ui';

/// A [Color] from a hex string.
class HexColor extends Color {
  /// Creates a new [Color] from the given [hexColor] string.
  HexColor(String hexColor) : super(_parse(hexColor));

  static int _parse(String hexColor) {
    final formatted = hexColor.toUpperCase().replaceAll('#', '').padLeft(8, 'F');

    return int.parse(formatted, radix: 16);
  }
}
