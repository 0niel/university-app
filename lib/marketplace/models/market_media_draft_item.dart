import 'dart:typed_data';

import 'package:campus_repository/campus_repository.dart';

class MarketMediaDraftItem {
  MarketMediaDraftItem({
    required this.key,
    required this.kind,
    this.bytes,
    this.previewUrl,
    this.width = 0,
    this.height = 0,
    this.duration = 0,
    this.uploading = false,
    this.path,
    this.failed = false,
  });

  factory MarketMediaDraftItem.uploading({
    required String key,
    required Uint8List bytes,
    required MarketMediaKind kind,
    int width = 0,
    int height = 0,
    int duration = 0,
  }) => MarketMediaDraftItem(
    key: key,
    bytes: bytes,
    kind: kind,
    width: width,
    height: height,
    duration: duration,
    uploading: true,
  );

  factory MarketMediaDraftItem.uploaded(MarketMediaItem item) =>
      MarketMediaDraftItem(
        key: item.path,
        previewUrl: item.url,
        kind: item.kind,
        width: item.width,
        height: item.height,
        duration: item.duration,
        path: item.path,
      );

  final String key;
  final Uint8List? bytes;
  final String? previewUrl;
  final MarketMediaKind kind;
  final int width;
  final int height;
  final int duration;
  bool uploading;
  String? path;
  bool failed;

  bool get isVideo => kind == MarketMediaKind.video;

  MarketMediaItem? toMediaItem() {
    final path = this.path;
    if (path == null) return null;
    return MarketMediaItem(
      path: path,
      kind: kind,
      width: width,
      height: height,
      duration: duration,
    );
  }
}
