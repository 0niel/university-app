import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Shows a flat app-styled dialog: a `colors.surface` card with [AppRadius.xl]
/// corners over a dimmed barrier. [builder] provides the card's content.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  double maxWidth = 320,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: .5),
    builder: (dialogContext) {
      final colors = dialogContext.colors;
      return Dialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: builder(dialogContext),
        ),
      );
    },
  );
}

/// Design: flat confirm dialog · replaces raw [AlertDialog] + [TextButton]
/// action pairs so confirmations look identical app-wide.
///
/// Resolves to `true` when [confirmLabel] is tapped, `false` otherwise
/// (cancel tap or barrier dismiss). Set [destructive] for a danger-styled
/// confirm action.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
  Widget? icon,
}) async {
  final confirmed = await showAppDialog<bool>(
    context,
    builder: (dialogContext) {
      final colors = dialogContext.colors;
      final messageText = message;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Center(child: icon),
              const SizedBox(height: 14),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.title.copyWith(
                fontSize: 19,
                color: colors.active,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (messageText != null) ...[
              const SizedBox(height: 6),
              Text(
                messageText,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  color: colors.deactive,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: cancelLabel,
                    expanded: true,
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: destructive
                      ? AppButton.danger(
                          label: confirmLabel,
                          expanded: true,
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                        )
                      : AppButton.primary(
                          label: confirmLabel,
                          expanded: true,
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                        ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  return confirmed ?? false;
}
