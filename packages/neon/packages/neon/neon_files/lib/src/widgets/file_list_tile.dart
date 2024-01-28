import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:neon_files/src/blocs/browser.dart';
import 'package:neon_files/src/blocs/files.dart';
import 'package:neon_files/src/models/file_details.dart';
import 'package:neon_files/src/utils/dialog.dart';
import 'package:neon_files/src/utils/task.dart';
import 'package:neon_files/src/widgets/actions.dart';
import 'package:neon_files/src/widgets/file_preview.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/widgets.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({
    required this.bloc,
    required this.browserBloc,
    required this.details,
    super.key,
  });

  final FilesBloc bloc;
  final FilesBrowserBloc browserBloc;
  final FileDetails details;

  Future<void> _onTap(BuildContext context, FileDetails details) async {
    if (details.isDirectory) {
      browserBloc.setPath(details.uri);
    } else if (browserBloc.mode == FilesBrowserMode.browser) {
      final sizeWarning = bloc.options.downloadSizeWarning.value;
      if (sizeWarning != null && details.size != null && details.size! > sizeWarning) {
        final decision = await showDownloadConfirmationDialog(context, sizeWarning, details.size!);

        if (!decision) {
          return;
        }
      }
      bloc.openFile(details.uri, details.etag!, details.mimeType);
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        // When the ETag is null it means we are uploading this file right now
        onTap: details.isDirectory || details.etag != null ? () async => _onTap(context, details) : null,
        title: Text(
          details.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).listTileTheme.subtitleTextStyle,
        ),
        subtitle: Row(
          children: [
            if (details.lastModified != null)
              RelativeTime(
                date: details.lastModified!,
                style: Theme.of(context).listTileTheme.subtitleTextStyle?.copyWith(fontSize: 12),
              ),
            if (details.size != null && details.size! > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Text(filesize(details.size, 1), style: Theme.of(context).listTileTheme.titleTextStyle),
            ],
          ],
        ),
        leading: _FileIcon(
          details: details,
          bloc: bloc,
        ),
        trailing: !details.hasTask && browserBloc.mode == FilesBrowserMode.browser
            ? FileActions(details: details)
            : const SizedBox.square(
                dimension: largeIconSize,
              ),
      );
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({
    required this.details,
    required this.bloc,
  });

  final FileDetails details;
  final FilesBloc bloc;

  @override
  Widget build(BuildContext context) {
    Widget icon = Center(
      child: details.hasTask
          ? StreamBuilder<double>(
              stream: details.task!.progress,
              builder: (context, progress) => Column(
                children: [
                  Icon(
                    switch (details.task!) {
                      FilesUploadTask() => MdiIcons.upload,
                      FilesDownloadTask() => MdiIcons.download,
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  LinearProgressIndicator(
                    value: progress.data,
                  ),
                ],
              ),
            )
          : FilePreview(
              bloc: bloc,
              details: details,
              withBackground: true,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
    );

    if (details.isFavorite ?? false) {
      icon = Stack(
        children: [
          icon,
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.star,
              size: smallIconSize,
              color: Colors.yellow,
            ),
          ),
        ],
      );
    }

    return SizedBox.square(
      dimension: largeIconSize,
      child: icon,
    );
  }
}
