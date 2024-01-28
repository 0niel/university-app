import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:universal_io/io.dart';

sealed class FilesTask {
  FilesTask({
    required this.uri,
    required this.file,
  });

  final PathUri uri;

  final File file;

  @protected
  final streamController = StreamController<double>();

  /// Task progress in percent `[0, 1]`.
  late final progress = streamController.stream.asBroadcastStream();
}

class FilesDownloadTask extends FilesTask {
  FilesDownloadTask({
    required super.uri,
    required super.file,
  });

  Future<void> execute(NextcloudClient client) async {
    await client.webdav.getFile(
      uri,
      file,
      onProgress: streamController.add,
    );
    await streamController.close();
  }
}

class FilesUploadTask extends FilesTask {
  FilesUploadTask({
    required super.uri,
    required super.file,
  });

  FileStat? _stat;
  FileStat get stat => _stat ??= file.statSync();

  Future<void> execute(NextcloudClient client) async {
    await client.webdav.putFile(
      file,
      stat,
      uri,
      lastModified: stat.modified,
      onProgress: streamController.add,
    );
    await streamController.close();
  }
}
