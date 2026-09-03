import 'dart:typed_data';
import 'dart:ui' as ui;

class GeneratedImagePreview {
  const GeneratedImagePreview({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
}

Future<GeneratedImagePreview?> generateImagePreview(
  Uint8List bytes, {
  int targetWidth = 480,
}) async {
  ui.Image? image;
  try {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    return GeneratedImagePreview(
      bytes: byteData.buffer.asUint8List(),
      width: image.width,
      height: image.height,
    );
  } on Object {
    return null;
  } finally {
    image?.dispose();
  }
}
