import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_dialog.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/widgets.dart';

typedef AppDialog = NinjaDialog;

Future<T?> showAppDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  double maxWidth = 340,
}) {
  return showNinjaDialog<T>(
    context,
    barrierDismissible: barrierDismissible,
    maxWidth: maxWidth,
    builder: (dialogContext) {
      final radius = BorderRadius.circular(AppRadius.dialog);
      return DecoratedBox(
        decoration: BoxDecoration(
          color: dialogContext.colors.canvas,
          borderRadius: radius,
        ),
        child: ClipRRect(borderRadius: radius, child: builder(dialogContext)),
      );
    },
  );
}

Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
  Widget? icon,
}) async {
  final confirmed = await showNinjaDialog<bool>(
    context,
    builder: (dialogContext) => NinjaDialog(
      title: title,
      message: message,
      icon: icon,
      cancelLabel: cancelLabel,
      onCancel: () => Navigator.of(dialogContext).pop(false),
      confirmLabel: confirmLabel,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      destructive: destructive,
    ),
  );
  return confirmed ?? false;
}
