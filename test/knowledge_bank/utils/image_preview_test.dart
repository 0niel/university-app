import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/image_preview.dart';

const _onePixelPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY'
    '42YAAAAASUVORK5CYII=';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generates a decodable png preview with its dimensions', () async {
    final bytes = base64Decode(_onePixelPngBase64);
    final preview = await generateImagePreview(bytes);
    expect(preview, isNotNull);
    expect(preview!.bytes, isNotEmpty);
    expect(preview.width, greaterThan(0));
    expect(preview.height, greaterThan(0));
  });

  test('returns null for undecodable bytes instead of throwing', () async {
    final preview = await generateImagePreview(
      Uint8List.fromList([1, 2, 3, 4, 5]),
    );
    expect(preview, isNull);
  });
}
