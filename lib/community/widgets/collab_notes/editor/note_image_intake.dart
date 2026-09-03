import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

abstract final class NoteImageIntake {
  static const int maxBytes = 15 * 1024 * 1024;
  static const Map<String, String> allowedExtensions = {
    'image/jpeg': 'jpg',
    'image/png': 'png',
    'image/webp': 'webp',
  };

  static Future<NoteImageUpload?> read(XFile file) async {
    final contentType = file.mimeType ?? lookupMimeType(file.name);
    final extension = allowedExtensions[contentType];
    if (extension == null) return null;
    final length = await file.length();
    if (length <= 0 || length > maxBytes) return null;
    return NoteImageUpload(
      bytes: await file.readAsBytes(),
      contentType: contentType!,
      extension: extension,
    );
  }
}

class NoteImageUpload {
  const NoteImageUpload({
    required this.bytes,
    required this.contentType,
    required this.extension,
  });

  final Uint8List bytes;
  final String contentType;
  final String extension;
}
