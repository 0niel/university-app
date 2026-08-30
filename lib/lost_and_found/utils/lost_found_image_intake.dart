import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mime/mime.dart';

abstract final class LostFoundImageIntake {
  static const int maxImages = 5;
  static const int maxBytes = 8 * 1024 * 1024;
  static const Set<String> allowedTypes = {
    'image/jpeg',
    'image/png',
    'image/webp',
  };

  static Future<LostFoundImageUpload?> read(XFile file) async {
    final contentType = file.mimeType ?? lookupMimeType(file.name);
    final length = await file.length();
    if (!allowedTypes.contains(contentType) ||
        length <= 0 ||
        length > maxBytes) {
      return null;
    }
    return LostFoundImageUpload(
      bytes: await file.readAsBytes(),
      contentType: contentType!,
    );
  }
}
