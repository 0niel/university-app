import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:rtu_mirea_app/knowledge_bank/utils/generated_image_preview.dart';

export 'generated_image_preview.dart';

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
