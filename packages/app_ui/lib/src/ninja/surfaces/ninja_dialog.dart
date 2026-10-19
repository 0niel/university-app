import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_control_surface.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
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

    return AppGlassSurface(
      role: AppGlassRole.overlay,
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
              style: AppText.sans(
                17,
                FontWeight.w700,
                height: 1.2,
              ).copyWith(color: colors.ink),
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
        : _NinjaDialogAction(
            label: cancel,
            onPressed: onCancel,
          );
    final confirmButton = confirm == null
        ? null
        : _NinjaDialogAction(
            label: confirm,
            onPressed: onConfirm,
            primary: true,
            destructive: destructive,
          );

    if (largeText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?confirmButton,
          if (confirmButton != null && cancelButton != null)
            const SizedBox(height: AppSpacing.sm),
          ?cancelButton,
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

class _NinjaDialogAction extends StatelessWidget {
  const _NinjaDialogAction({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = primary
        ? (destructive ? colors.danger : colors.accent)
        : colors.surface;
    final foreground = primary
        ? (destructive ? colors.white : colors.onAccent)
        : colors.ink;
    return AppPressable(
      onTap: onPressed,
      enabled: onPressed != null,
      semanticsLabel: label,
      semanticsButton: true,
      child: AppControlSurface(
        color: background,
        borderRadius: AppRadius.full,
        tone: primary
            ? AppControlSurfaceTone.accent
            : AppControlSurfaceTone.neutral,
        enabled: onPressed != null,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppControlSize.buttonMedium,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.fieldGap,
            vertical: AppSpacing.sm,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.bodyStrong.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showNinjaDialog<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  double maxWidth = 340,
  bool useRootNavigator = true,
}) {
  final colors = context.colors;
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final mediaQuery = MediaQuery.of(context);
  final navigatorMediaQuery = MediaQuery.of(navigator.context);
  final direction = Directionality.of(context);
  final duration = NinjaMotion.of(context, NinjaMotion.fast);
  return showRawDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    routeBuilder: (routeContext, dialogBuilder) => _NinjaDialogRoute<T>(
      context: routeContext,
      builder: dialogBuilder,
      themes: themes,
      barrierColor: colors.scrim,
      barrierDismissible: barrierDismissible,
      duration: duration,
    ),
    builder: (routeContext) => MediaQuery(
      data: MediaQuery.of(routeContext).copyWith(
        textScaler: mediaQuery.textScaler == navigatorMediaQuery.textScaler
            ? null
            : mediaQuery.textScaler,
        disableAnimations:
            mediaQuery.disableAnimations ==
                navigatorMediaQuery.disableAnimations
            ? null
            : mediaQuery.disableAnimations,
        accessibleNavigation:
            mediaQuery.accessibleNavigation ==
                navigatorMediaQuery.accessibleNavigation
            ? null
            : mediaQuery.accessibleNavigation,
        boldText: mediaQuery.boldText == navigatorMediaQuery.boldText
            ? null
            : mediaQuery.boldText,
      ),
      child: Directionality(
        textDirection: direction,
        child: Builder(
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
        ),
      ),
    ),
  );
}

class _NinjaDialogRoute<T> extends DialogRoute<T> {
  _NinjaDialogRoute({
    required super.context,
    required super.builder,
    required super.themes,
    required super.barrierColor,
    required super.barrierDismissible,
    required Duration duration,
  }) : super(
         traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
         animationStyle: AnimationStyle(duration: duration),
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (transitionDuration == Duration.zero ||
        NinjaMotion.of(context) == Duration.zero) {
      return child;
    }
    return ScaleTransition(
      scale: animation
          .drive(CurveTween(curve: NinjaMotion.enter))
          .drive(
            Tween<double>(begin: .96, end: 1),
          ),
      child: child,
    );
  }
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
