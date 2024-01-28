import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_files/l10n/localizations.dart';
import 'package:neon_files/src/blocs/browser.dart';
import 'package:neon_files/src/options.dart';
import 'package:neon_files/src/utils/task.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/webdav.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:queue/queue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

sealed class FilesBloc implements InteractiveBloc {
  @internal
  factory FilesBloc(
    FilesOptions options,
    Account account,
  ) =>
      _FilesBloc(
        options,
        account,
      );

  void uploadFile(PathUri uri, String localPath);

  void openFile(PathUri uri, String etag, String? mimeType);

  void shareFileNative(PathUri uri, String etag);

  void delete(PathUri uri);

  void rename(PathUri uri, String name);

  void move(PathUri uri, PathUri destination);

  void copy(PathUri uri, PathUri destination);

  void addFavorite(PathUri uri);

  void removeFavorite(PathUri uri);

  BehaviorSubject<List<FilesTask>> get tasks;

  FilesOptions get options;

  FilesBrowserBloc get browser;

  FilesBrowserBloc getNewFilesBrowserBloc({PathUri? initialUri, FilesBrowserMode? mode});
}

class _FilesBloc extends InteractiveBloc implements FilesBloc {
  _FilesBloc(
    this.options,
    this.account,
  ) {
    options.uploadQueueParallelism.addListener(uploadParallelismListener);
    options.downloadQueueParallelism.addListener(downloadParallelismListener);
  }

  @override
  final FilesOptions options;
  final Account account;
  @override
  late final browser = getNewFilesBrowserBloc();

  final uploadQueue = Queue();
  final downloadQueue = Queue();

  @override
  void dispose() {
    uploadQueue.dispose();
    downloadQueue.dispose();
    unawaited(tasks.close());

    options.uploadQueueParallelism.removeListener(uploadParallelismListener);
    options.downloadQueueParallelism.removeListener(downloadParallelismListener);

    super.dispose();
  }

  @override
  BehaviorSubject<List<FilesTask>> tasks = BehaviorSubject<List<FilesTask>>.seeded([]);

  @override
  void addFavorite(PathUri uri) {
    wrapAction(
      () async => account.client.webdav.proppatch(
        uri,
        set: const WebDavProp(ocfavorite: 1),
      ),
    );
  }

  @override
  void copy(PathUri uri, PathUri destination) {
    wrapAction(() async => account.client.webdav.copy(uri, destination));
  }

  @override
  void delete(PathUri uri) {
    wrapAction(() async => account.client.webdav.delete(uri));
  }

  @override
  void move(PathUri uri, PathUri destination) {
    wrapAction(() async => account.client.webdav.move(uri, destination));
  }

  @override
  void openFile(PathUri uri, String etag, String? mimeType) {
    wrapAction(
      () async {
        final file = await cacheFile(uri, etag);

        final result = await OpenFile.open(file.path, type: mimeType);
        if (result.type != ResultType.done) {
          throw const UnableToOpenFileException();
        }
      },
      disableTimeout: true,
    );
  }

  @override
  void shareFileNative(PathUri uri, String etag) {
    wrapAction(
      () async {
        final file = await cacheFile(uri, etag);

        await Share.shareXFiles([XFile(file.path)]);
      },
      disableTimeout: true,
    );
  }

  @override
  Future<void> refresh() async {
    await browser.refresh();
  }

  @override
  void removeFavorite(PathUri uri) {
    wrapAction(
      () async => account.client.webdav.proppatch(
        uri,
        set: const WebDavProp(ocfavorite: 0),
      ),
    );
  }

  @override
  void rename(PathUri uri, String name) {
    wrapAction(
      () async => account.client.webdav.move(
        uri,
        uri.rename(name),
      ),
    );
  }

  @override
  void uploadFile(PathUri uri, String localPath) {
    wrapAction(
      () async {
        final task = FilesUploadTask(
          uri: uri,
          file: File(localPath),
        );
        tasks.add(tasks.value..add(task));
        await uploadQueue.add(() => task.execute(account.client));
        tasks.add(tasks.value..remove(task));
      },
      disableTimeout: true,
    );
  }

  Future<File> cacheFile(PathUri uri, String etag) async {
    final cacheDir = await getApplicationCacheDirectory();
    final file = File(p.join(cacheDir.path, 'files', etag.replaceAll('"', ''), uri.name));

    if (!file.existsSync()) {
      debugPrint('Downloading $uri since it does not exist');
      if (!file.parent.existsSync()) {
        await file.parent.create(recursive: true);
      }
      await downloadFile(uri, file);
    }

    return file;
  }

  Future<void> downloadFile(
    PathUri uri,
    File file,
  ) async {
    final task = FilesDownloadTask(
      uri: uri,
      file: file,
    );
    tasks.add(tasks.value..add(task));
    await downloadQueue.add(() => task.execute(account.client));
    tasks.add(tasks.value..remove(task));
  }

  @override
  FilesBrowserBloc getNewFilesBrowserBloc({PathUri? initialUri, FilesBrowserMode? mode}) => FilesBrowserBloc(
        options,
        account,
        initialPath: initialUri,
        mode: mode,
      );

  void downloadParallelismListener() {
    downloadQueue.parallel = options.downloadQueueParallelism.value;
  }

  void uploadParallelismListener() {
    uploadQueue.parallel = options.uploadQueueParallelism.value;
  }
}

@immutable
class UnableToOpenFileException extends NeonException {
  const UnableToOpenFileException();

  @override
  NeonExceptionDetails get details => NeonExceptionDetails(
        getText: (context) => FilesLocalizations.of(context).errorUnableToOpenFile,
      );
}
