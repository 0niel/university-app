import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_action_button.dart';
import 'package:flutter/material.dart';

class NinjaDialog extends StatelessWidget {
  const NinjaDialog({
    required this.title,
    super.key,
    this.message,
    this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.destructive = false,
    this.child,
  });

  final String title;
  final String? message;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final bool destructive;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final messageText = message;
    final extra = child;
    final hasActions = confirmLabel != null || cancelLabel != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.dialog),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: NinjaText.dialogTitle.copyWith(color: colors.ink),
            ),
            if (messageText != null) ...[
              const SizedBox(height: 6),
              Text(
                messageText,
                style: NinjaText.body.copyWith(color: colors.mutedDark),
              ),
            ],
            if (extra != null) ...[const SizedBox(height: 14), extra],
            if (hasActions) ...[
              const SizedBox(height: 18),
              _NinjaDialogActions(
                cancelLabel: cancelLabel,
                onCancel: onCancel,
                confirmLabel: confirmLabel,
                onConfirm: onConfirm,
                destructive: destructive,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NinjaDialogActions extends StatelessWidget {
  const _NinjaDialogActions({
    required this.cancelLabel,
    required this.onCancel,
    required this.confirmLabel,
    required this.onConfirm,
    required this.destructive,
  });

  final String? cancelLabel;
  final VoidCallback? onCancel;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final cancel = cancelLabel;
    final confirm = confirmLabel;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final cancelButton = cancel == null
        ? null
        : NinjaActionButton(
            label: cancel,
            onPressed: onCancel,
            tone: NinjaActionTone.surface,
            expanded: true,
            radius: 14,
          );
    final confirmButton = confirm == null
        ? null
        : NinjaActionButton(
            label: confirm,
            onPressed: onConfirm,
            tone: destructive ? NinjaActionTone.scarlet : NinjaActionTone.ink,
            expanded: true,
            radius: 14,
          );

    if (largeText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (confirmButton != null) confirmButton,
          if (confirmButton != null && cancelButton != null)
            const SizedBox(height: 8),
          if (cancelButton != null) cancelButton,
        ],
      );
    }

    return Row(
      children: [
        if (cancelButton != null) Expanded(child: cancelButton),
        if (cancelButton != null && confirmButton != null)
          const SizedBox(width: 8),
        if (confirmButton != null) Expanded(child: confirmButton),
      ],
    );
  }
}

Future<T?> showNinjaDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  double maxWidth = 340,
}) {
  final colors = context.ninja;
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: colors.ink.withValues(alpha: colors.isDark ? 0.68 : 0.48),
    builder: (dialogContext) => Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: builder(dialogContext),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<bool> showNinjaConfirmDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
}) async {
  final confirmed = await showNinjaDialog<bool>(
    context,
    builder: (dialogContext) => NinjaDialog(
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      onCancel: () => Navigator.of(dialogContext).pop(false),
      confirmLabel: confirmLabel,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      destructive: destructive,
    ),
  );
  return confirmed ?? false;
}
