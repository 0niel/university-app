import 'package:flutter/material.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/widgets/dialog.dart';
import 'package:nextcloud/news.dart';

/// Displays a [NeonConfirmationDialog] to confirm the deletion of the given [feed].
///
/// Returns a future whether the action has been accepted.
Future<bool> showDeleteFeedDialog(BuildContext context, Feed feed) async {
  final content = NewsLocalizations.of(context).feedRemoveConfirm(feed.title);

  final result = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => NeonConfirmationDialog(
      title: NewsLocalizations.of(context).actionDeleteTitle,
      content: Text(content),
    ),
  );

  return result ?? false;
}

/// Displays a [NewsCreateFolderDialog] for creating a new folder.
///
/// Returns a future with the folder name split by `/`.
Future<String?> showFolderCreateDialog({
  required BuildContext context,
}) =>
    showAdaptiveDialog<String>(
      context: context,
      builder: (context) => const NewsCreateFolderDialog(),
    );

/// Displays a [NeonConfirmationDialog] for deleting a folder.
///
/// Returns a future whether the action has been accepted.
Future<bool> showFolderDeleteDialog({
  required BuildContext context,
  required String folderName,
}) async {
  final content = NewsLocalizations.of(context).folderDeleteConfirm(folderName);

  final result = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => NeonConfirmationDialog(
      title: NewsLocalizations.of(context).actionDeleteTitle,
      content: Text(content),
    ),
  );

  return result ?? false;
}

/// Displays a `NeonRenameDialog` for renaming a folder.
///
/// Returns a future with the new name of name.
Future<String?> showFolderRenameDialog({
  required BuildContext context,
  required String folderName,
}) async =>
    showRenameDialog(
      context: context,
      title: NewsLocalizations.of(context).folderRename,
      initialValue: folderName,
    );
