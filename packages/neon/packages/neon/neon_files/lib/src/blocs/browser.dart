import 'dart:async';

import 'package:meta/meta.dart';
import 'package:neon_files/src/options.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/webdav.dart';
import 'package:rxdart/rxdart.dart';

/// Mode to operate the `FilesBrowserView` in.
enum FilesBrowserMode {
  /// Default file browser mode.
  ///
  /// When a file is selected it will be opened or downloaded.
  browser,

  /// Select directory.
  selectDirectory,

  /// Do not show file actions.
  noActions,
}

sealed class FilesBrowserBloc implements InteractiveBloc {
  @internal
  factory FilesBrowserBloc(
    FilesOptions options,
    Account account, {
    PathUri? initialPath,
    FilesBrowserMode? mode,
  }) =>
      _FilesBrowserBloc(
        options,
        account,
        initialPath: initialPath,
        mode: mode,
      );

  void setPath(PathUri uri);

  void createFolder(PathUri uri);

  BehaviorSubject<Result<List<WebDavFile>>> get files;

  BehaviorSubject<PathUri> get uri;

  FilesOptions get options;

  /// Mode to operate the `FilesBrowserView` in.
  FilesBrowserMode get mode;
}

class _FilesBrowserBloc extends InteractiveBloc implements FilesBrowserBloc {
  _FilesBrowserBloc(
    this.options,
    this.account, {
    this.initialPath,
    FilesBrowserMode? mode,
  }) : mode = mode ?? FilesBrowserMode.browser {
    final parent = initialPath?.parent;
    if (parent != null) {
      uri.add(parent);
    }

    options.showHiddenFilesOption.addListener(refresh);

    unawaited(refresh());
  }

  @override
  final FilesOptions options;
  final Account account;

  @override
  final FilesBrowserMode mode;

  final PathUri? initialPath;

  @override
  void dispose() {
    options.showHiddenFilesOption.removeListener(refresh);

    unawaited(files.close());
    unawaited(uri.close());
    super.dispose();
  }

  @override
  BehaviorSubject<Result<List<WebDavFile>>> files = BehaviorSubject<Result<List<WebDavFile>>>();

  @override
  BehaviorSubject<PathUri> uri = BehaviorSubject.seeded(PathUri.cwd());

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapWebDav<List<WebDavFile>>(
      account: account,
      cacheKey: 'files-${uri.value.path}',
      subject: files,
      request: () => account.client.webdav.propfind(
        uri.value,
        prop: const WebDavPropWithoutValues.fromBools(
          davgetcontenttype: true,
          davgetetag: true,
          davgetlastmodified: true,
          nchaspreview: true,
          ocsize: true,
          ocfavorite: true,
        ),
        depth: WebDavDepth.one,
      ),
      unwrap: (response) {
        final unwrapped = response.toWebDavFiles();

        return unwrapped.where((file) {
          // Do not show files when selecting a directory
          if (mode == FilesBrowserMode.selectDirectory && !file.isDirectory) {
            return false;
          }

          // Do not show itself when selecting a directory
          if (mode == FilesBrowserMode.selectDirectory && initialPath == file.path) {
            return false;
          }

          // Do not show hidden files unless the option is enabled
          if (!options.showHiddenFilesOption.value && file.isHidden) {
            return false;
          }

          return true;
        }).toList();
      },
    );
  }

  @override
  Future<void> setPath(PathUri uri) async {
    this.uri.add(uri);
    await refresh();

    // When the request fails (i.e by being offline) and the requested path
    // is not cached return an empty list. To avoid re emitting the parent
    // data.
    final currentFiles = files.valueOrNull;
    if (currentFiles != null && currentFiles.data?.first.path != uri) {
      files.add(Result(null, currentFiles.error, isCached: true, isLoading: false));
    }
  }

  @override
  void createFolder(PathUri uri) {
    wrapAction(() async => account.client.webdav.mkcol(uri));
  }
}
