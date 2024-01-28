import 'package:flutter/material.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/widgets/dialog.dart';

/// Displays a simple [NeonConfirmationDialog] with the given [title].
///
/// Returns a future whether the action has been accepted.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
}) async =>
    await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => NeonConfirmationDialog(title: title),
    ) ??
    false;

/// Displays a [NeonRenameDialog] with the given [title] and [initialValue].
///
/// Returns a future with the new name of name.
Future<String?> showRenameDialog({
  required BuildContext context,
  required String title,
  required String initialValue,
}) async =>
    showAdaptiveDialog<String?>(
      context: context,
      builder: (context) => NeonRenameDialog(
        title: title,
        value: initialValue,
      ),
    );

/// Displays a [NeonErrorDialog] with the given [message].
Future<void> showErrorDialog({
  required BuildContext context,
  required String message,
  String? title,
}) =>
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => NeonErrorDialog(content: message),
    );

/// Displays a [NeonDialog] with the given [title] informing the user that a
/// feature is not implemented yet.
Future<void> showUnimplementedDialog({
  required BuildContext context,
  required String title,
}) =>
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => NeonDialog(
        automaticallyShowCancel: false,
        title: Text(title),
        actions: [
          NeonDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              NeonLocalizations.of(context).actionClose,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
