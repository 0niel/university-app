import 'package:flutter/foundation.dart';

enum MediaKind { image, video, pdf, file }

@immutable
class MediaItem {
  const MediaItem({
    required this.url,
    required this.kind,
    this.title,
    this.fileName,
    this.mimeType,
    this.sizeBytes,
    this.previewUrl,
    this.heroTag,
  });

  final String url;
  final MediaKind kind;
  final String? title;
  final String? fileName;
  final String? mimeType;
  final int? sizeBytes;
  final String? previewUrl;
  final Object? heroTag;

  static MediaKind kindOf({String? mimeType, String? fileName}) {
    final mime = (mimeType ?? '').toLowerCase();
    final name = (fileName ?? '').toLowerCase();
    if (mime.startsWith('image/') ||
        RegExp(r'\.(jpe?g|png|webp|gif|heic)$').hasMatch(name)) {
      return MediaKind.image;
    }
    if (mime.startsWith('video/') ||
        RegExp(r'\.(mp4|mov|webm|m4v)$').hasMatch(name)) {
      return MediaKind.video;
    }
    if (mime == 'application/pdf' || name.endsWith('.pdf')) {
      return MediaKind.pdf;
    }
    return MediaKind.file;
  }

  @override
  bool operator ==(Object other) =>
      other is MediaItem && other.url == url && other.kind == kind;

  @override
  int get hashCode => Object.hash(url, kind);
}
