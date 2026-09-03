import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_pill_button.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';

class NinjaDialog extends StatelessWidget {
  const NinjaDialog({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.destructive = false,
    this.child,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final bool destructive;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final messageText = message;
    final extra = child;
    final hasActions = confirmLabel != null || cancelLabel != null;
    final iconWidget = icon;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.canvas,
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.contentGap,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconWidget != null) ...[
              Center(child: iconWidget),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            Text(
              title,
              style: AppText.sans(17, FontWeight.w700, height: 1.2)
                  .copyWith(color: colors.ink),
            ),
            if (messageText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                messageText,
                style: AppText.compact.copyWith(
                  color: colors.muted,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
            ],
            if (extra != null) ...[
              const SizedBox(height: AppSpacing.sectionGap),
              extra,
            ],
            if (hasActions) ...[
              const SizedBox(height: AppSpacing.fieldGap),
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
        : NinjaPillButton(
            label: cancel,
            onPressed: onCancel,
            tone: NinjaPillTone.surface,
            height: AppControlSize.buttonMedium,
            expanded: true,
            textStyle: AppText.bodyStrong,
          );
    final confirmButton = confirm == null
        ? null
        : NinjaPillButton(
            label: confirm,
            onPressed: onConfirm,
            tone: destructive ? NinjaPillTone.danger : NinjaPillTone.primary,
            height: AppControlSize.buttonMedium,
            expanded: true,
            textStyle: AppText.bodyStrong,
          );

    if (largeText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (confirmButton != null) confirmButton,
          if (confirmButton != null && cancelButton != null)
            const SizedBox(height: AppSpacing.sm),
          if (cancelButton != null) cancelButton,
        ],
      );
    }

    return Row(
      children: [
        if (cancelButton != null) Expanded(child: cancelButton),
        if (cancelButton != null && confirmButton != null)
          const SizedBox(width: AppSpacing.sm),
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
  final colors = context.colors;
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: colors.scrim,
    builder: (dialogContext) => Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xlg),
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
