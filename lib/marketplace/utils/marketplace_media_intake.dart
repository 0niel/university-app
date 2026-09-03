import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:campus_repository/campus_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class MarketMediaPick {
  const MarketMediaPick({
    required this.bytes,
    required this.contentType,
    required this.extension,
    required this.kind,
    this.width = 0,
    this.height = 0,
    this.duration = 0,
  });

  final Uint8List bytes;
  final String contentType;
  final String extension;
  final MarketMediaKind kind;
  final int width;
  final int height;
  final int duration;
}

abstract final class MarketplaceMediaIntake {
  static const int maxImages = 6;
  static const int maxVideos = 1;
  static const int maxVideoBytes = 50 * 1024 * 1024;
  static const int maxVideoSeconds = 60;
  static const Set<String> allowedImageTypes = {
    'image/jpeg',
    'image/png',
    'image/webp',
  };
  static const Set<String> allowedVideoTypes = {
    'video/mp4',
    'video/quicktime',
  };

  static Future<MarketMediaPick?> readImage(XFile file) async {
    final contentType = file.mimeType ?? lookupMimeType(file.name);
    if (!allowedImageTypes.contains(contentType)) return null;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;
    final (width, height) = await _imageSize(bytes);
    return MarketMediaPick(
      bytes: bytes,
      contentType: contentType!,
      extension: _imageExtension(contentType),
      kind: MarketMediaKind.image,
      width: width,
      height: height,
    );
  }

  static Future<MarketMediaPick?> readVideo(XFile file) async {
    final contentType = file.mimeType ?? lookupMimeType(file.name);
    if (!allowedVideoTypes.contains(contentType)) return null;
    final length = await file.length();
    if (length <= 0 || length > maxVideoBytes) return null;
    final controller = VideoPlayerController.file(File(file.path));
    try {
      await controller.initialize();
      final duration = controller.value.duration.inSeconds;
      if (duration <= 0 || duration > maxVideoSeconds) return null;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return null;
      return MarketMediaPick(
        bytes: bytes,
        contentType: contentType!,
        extension: _videoExtension(contentType),
        kind: MarketMediaKind.video,
        width: controller.value.size.width.round(),
        height: controller.value.size.height.round(),
        duration: duration,
      );
    } finally {
      await controller.dispose();
    }
  }

  static Future<(int, int)> _imageSize(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final size = (frame.image.width, frame.image.height);
      frame.image.dispose();
      return size;
    } on Object {
      return (0, 0);
    }
  }

  static String _imageExtension(String contentType) => switch (contentType) {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    _ => throw FormatException('Unsupported image type: $contentType'),
  };

  static String _videoExtension(String contentType) => switch (contentType) {
    'video/mp4' => 'mp4',
    'video/quicktime' => 'mov',
    _ => throw FormatException('Unsupported video type: $contentType'),
  };
}
