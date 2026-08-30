import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lost_found_image_upload.freezed.dart';

@freezed
abstract class LostFoundImageUpload with _$LostFoundImageUpload {
  const factory LostFoundImageUpload({
    required Uint8List bytes,
    required String contentType,
  }) = _LostFoundImageUpload;
}
