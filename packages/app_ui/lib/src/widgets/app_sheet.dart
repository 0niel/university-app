import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

Future<T?> showAppSheet<T>(
  BuildContext context, {
  required Widget child,
  String? title,
  String? subtitle,
  bool showClose = true,
  bool showGrabber = true,
  bool isDismissible = true,
  bool scrollable = true,
  double? heightFraction,
  double maxHeightFraction = 0.86,
  Color? backgroundColor,
  Color? barrierColor,
  EdgeInsetsGeometry? contentPadding,
  bool useRootNavigator = true,
  String? primaryAction,
  VoidCallback? onPrimaryAction,
}) {
  final route = ModalSheetRoute<T>(
    swipeDismissible: isDismissible,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? context.colors.scrim,
    builder: (context) => AppSheet(
      title: title,
      subtitle: subtitle,
      showClose: showClose && isDismissible,
      showGrabber: showGrabber,
      scrollable: scrollable,
      heightFraction: heightFraction,
      maxHeightFraction: maxHeightFraction,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
      primaryAction: primaryAction,
      onPrimaryAction: onPrimaryAction,
      child: child,
    ),
  );
  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(route);
}

class AppSheet extends StatelessWidget {
  const AppSheet({
    required this.child,
    super.key,
    this.title,
    this.subtitle,
    this.showClose = true,
    this.showGrabber = true,
    this.scrollable = true,
    this.heightFraction,
    this.maxHeightFraction = 0.86,
    this.backgroundColor,
    this.contentPadding,
    this.primaryAction,
    this.onPrimaryAction,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showClose;
  final bool showGrabber;
  final bool scrollable;
  final double? heightFraction;
  final double maxHeightFraction;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? primaryAction;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SheetKeyboardDismissible(
      dismissBehavior: const SheetKeyboardDismissBehavior.onDragDown(
        isContentScrollAware: true,
      ),
      child: Sheet(
        scrollConfiguration: const SheetScrollConfiguration(),
        decoration: MaterialSheetDecoration(
          size: SheetSize.fit,
          color: backgroundColor ?? colors.canvas,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        child: _AppSheetBody(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          showGrabber: showGrabber,
          scrollable: scrollable,
          heightFraction: heightFraction,
          maxHeightFraction: maxHeightFraction,
          contentPadding: contentPadding,
          primaryAction: primaryAction,
          onPrimaryAction: onPrimaryAction,
          child: child,
        ),
      ),
    );
  }
}

class _AppSheetBody extends StatelessWidget {
  const _AppSheetBody({
    required this.child,
    required this.title,
    required this.subtitle,
    required this.showClose,
    required this.showGrabber,
    required this.scrollable,
    required this.heightFraction,
    required this.maxHeightFraction,
    required this.contentPadding,
    required this.primaryAction,
    required this.onPrimaryAction,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showClose;
  final bool showGrabber;
  final bool scrollable;
  final double? heightFraction;
  final double maxHeightFraction;
  final EdgeInsetsGeometry? contentPadding;
  final String? primaryAction;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final bottomSafe = keyboardInset > 0 ? 0.0 : mediaQuery.viewPadding.bottom;

    final padding = contentPadding ??
        const EdgeInsets.symmetric(horizontal: AppSpacing.screen);
    final action = primaryAction;

    final body = scrollable
        ? Flexible(
            child: SingleChildScrollView(padding: padding, child: child),
          )
        : Flexible(child: Padding(padding: padding, child: child));

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showGrabber)
          const AppSheetGrabber()
        else
          const SizedBox(height: AppSpacing.sectionGap),
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.zero,
              AppSpacing.screen,
              AppSpacing.sectionGap,
            ),
            child: AppSheetTitle(
              title: title ?? '',
              subtitle: subtitle,
              showClose: showClose,
            ),
          ),
        body,
        if (action != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.zero,
            ),
            child: AppSheetAction(label: action, onTap: onPrimaryAction),
          ),
        SizedBox(height: bottomSafe + 28),
      ],
    );

    final maxHeight = screenHeight * maxHeightFraction;
    final fraction = heightFraction;
    final fixedHeight = fraction == null ? null : screenHeight * fraction;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: fixedHeight ?? maxHeight,
          minHeight: fixedHeight ?? 0,
        ),
        child: column,
      ),
    );
  }
}

class AppSheetGrabber extends StatelessWidget {
  const AppSheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin:
            const EdgeInsets.only(top: AppSpacing.gap, bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.muted2,
          borderRadius: BorderRadius.circular(AppRadius.xxs),
        ),
      ),
    );
  }
}

class AppSheetTitle extends StatelessWidget {
  const AppSheetTitle({
    required this.title,
    super.key,
    this.subtitle,
    this.showClose = true,
  });

  final String title;
  final String? subtitle;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.sectionLarge.copyWith(color: colors.ink),
              ),
            ),
            if (showClose) ...[
              const SizedBox(width: AppSpacing.sm),
              const AppSheetCloseButton(),
            ],
          ],
        ),
        if (subtitleText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitleText,
            style:
                AppText.sans(13, FontWeight.w500).copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}

class AppSheetCloseButton extends StatelessWidget {
  const AppSheetCloseButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonLabel,
      child: AppPressable(
        pressedScale: 0.92,
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Container(
              width: AppControlSize.iconButtonSmall,
              height: AppControlSize.iconButtonSmall,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: AppLineIconWidget(
                AppLineIcon.close,
                size: AppIconSize.sm,
                strokeWidth: 2.2,
                color: colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppSheetAction extends StatelessWidget {
  const AppSheetAction({
    required this.label,
    super.key,
    this.onTap,
    this.background,
    this.foreground,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      child: Container(
        height: AppControlSize.buttonLarge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background ?? colors.accent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          label,
          style: AppText.buttonLarge.copyWith(
            color: foreground ?? colors.onAccent,
          ),
        ),
      ),
    );
  }
}
