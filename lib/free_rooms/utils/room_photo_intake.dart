import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

abstract final class RoomPhotoIntake {
  static const int maxBytes = 8 * 1024 * 1024;
  static const Set<String> allowedTypes = {
    'image/jpeg',
    'image/png',
    'image/webp',
  };

  static Future<RoomPhotoUpload?> read(XFile file) async {
    final contentType = file.mimeType ?? lookupMimeType(file.name);
    if (contentType == null || !allowedTypes.contains(contentType)) {
      return null;
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty || bytes.length > maxBytes) return null;
    return RoomPhotoUpload(bytes: bytes, contentType: contentType);
  }
}

class RoomPhotoUpload {
  const RoomPhotoUpload({required this.bytes, required this.contentType});

  final Uint8List bytes;
  final String contentType;
}
