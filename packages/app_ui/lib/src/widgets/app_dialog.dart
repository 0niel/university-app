import 'package:app_ui/src/glass/app_glass_surface.dart';
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
  return showNinjaDialog(
    context,
    barrierDismissible: barrierDismissible,
    maxWidth: maxWidth,
    builder: (dialogContext) {
      final child = builder(dialogContext);
      if (child is NinjaDialog) return child;
      final radius = BorderRadius.circular(AppRadius.dialog);
      return AppGlassSurface(
        role: AppGlassRole.overlay,
        child: ClipRRect(borderRadius: radius, child: child),
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
  bool useRootNavigator = true,
}) async {
  final confirmed = await showNinjaDialog<bool>(
    context,
    useRootNavigator: useRootNavigator,
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
