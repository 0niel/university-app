import 'package:flutter/material.dart';
import 'package:neon_files/l10n/localizations.dart';
import 'package:neon_files/src/blocs/files.dart';
import 'package:neon_files/src/models/file_details.dart';
import 'package:neon_files/src/pages/details.dart';
import 'package:neon_files/src/utils/dialog.dart';
import 'package:neon_framework/platform.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/webdav.dart';

class FileActions extends StatelessWidget {
  const FileActions({
    required this.details,
    super.key,
  });

  final FileDetails details;

  Future<void> onSelected(BuildContext context, FilesFileAction action) async {
    final bloc = NeonProvider.of<FilesBloc>(context);
    switch (action) {
      case FilesFileAction.share:
        bloc.shareFileNative(details.uri, details.etag!);
      case FilesFileAction.toggleFavorite:
        if (details.isFavorite ?? false) {
          bloc.removeFavorite(details.uri);
        } else {
          bloc.addFavorite(details.uri);
        }
      case FilesFileAction.details:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => FilesDetailsPage(
              bloc: bloc,
              details: details,
            ),
          ),
        );
      case FilesFileAction.rename:
        if (!context.mounted) {
          return;
        }
        final result = await showRenameDialog(
          context: context,
          title: details.isDirectory
              ? FilesLocalizations.of(context).folderRename
              : FilesLocalizations.of(context).fileRename,
          initialValue: details.name,
        );
        if (result != null) {
          bloc.rename(details.uri, result);
        }
      case FilesFileAction.move:
        if (!context.mounted) {
          return;
        }
        final result = await showChooseFolderDialog(context, details);

        if (result != null) {
          bloc.move(details.uri, result.join(PathUri.parse(details.name)));
        }
      case FilesFileAction.copy:
        if (!context.mounted) {
          return;
        }

        final result = await showChooseFolderDialog(context, details);
        if (result != null) {
          bloc.copy(details.uri, result.join(PathUri.parse(details.name)));
        }
      case FilesFileAction.delete:
        if (!context.mounted) {
          return;
        }
        final decision = await showDeleteConfirmationDialog(context, details);
        if (decision) {
          bloc.delete(details.uri);
        }
    }
  }

  @override
  Widget build(BuildContext context) => PopupMenuButton<FilesFileAction>(
        itemBuilder: (context) => [
          if (!details.isDirectory && NeonPlatform.instance.canUseSharing)
            PopupMenuItem(
              value: FilesFileAction.share,
              child: Text(FilesLocalizations.of(context).actionShare),
            ),
          if (details.isFavorite != null)
            PopupMenuItem(
              value: FilesFileAction.toggleFavorite,
              child: Text(
                details.isFavorite!
                    ? FilesLocalizations.of(context).removeFromFavorites
                    : FilesLocalizations.of(context).addToFavorites,
              ),
            ),
          PopupMenuItem(
            value: FilesFileAction.details,
            child: Text(FilesLocalizations.of(context).details),
          ),
          PopupMenuItem(
            value: FilesFileAction.rename,
            child: Text(FilesLocalizations.of(context).actionRename),
          ),
          PopupMenuItem(
            value: FilesFileAction.move,
            child: Text(FilesLocalizations.of(context).actionMove),
          ),
          PopupMenuItem(
            value: FilesFileAction.copy,
            child: Text(FilesLocalizations.of(context).actionCopy),
          ),
          PopupMenuItem(
            value: FilesFileAction.delete,
            child: Text(FilesLocalizations.of(context).actionDelete),
          ),
        ],
        onSelected: (action) async => onSelected(context, action),
      );
}

enum FilesFileAction {
  share,
  toggleFavorite,
  details,
  rename,
  move,
  copy,
  delete,
}
