import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_item.dart';
import 'package:share_plus/share_plus.dart';

Future<File> downloadMediaFile(
  String url, {
  ValueChanged<double>? onProgress,
}) async {
  final stream = DefaultCacheManager().getFileStream(url, withProgress: true);
  await for (final response in stream) {
    if (response is DownloadProgress) {
      onProgress?.call(response.progress ?? 0);
    } else if (response is FileInfo) {
      return response.file;
    }
  }
  throw StateError('Download stream ended without a file');
}

Future<void> saveMediaItem(
  MediaItem item, {
  ValueChanged<double>? onProgress,
}) async {
  final file = await downloadMediaFile(item.url, onProgress: onProgress);
  final name = item.fileName ?? file.uri.pathSegments.last;
  try {
    if (!kIsWeb && Platform.isIOS) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, name: name)]),
      );
      return;
    }
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, name: name)]),
      );
    }
  } on Object {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, name: name)]),
    );
  }
}

Future<void> shareMediaItem(
  MediaItem item, {
  ValueChanged<double>? onProgress,
}) async {
  final file = await downloadMediaFile(item.url, onProgress: onProgress);
  final name = item.fileName ?? file.uri.pathSegments.last;
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, name: name)],
      subject: item.title ?? name,
    ),
  );
}
