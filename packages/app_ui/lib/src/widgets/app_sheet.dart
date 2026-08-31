import 'package:app_ui/app_ui.dart';
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
  double maxHeightFraction = 0.88,
  Color? backgroundColor,
  Color? barrierColor,
  EdgeInsetsGeometry? contentPadding,
  bool useRootNavigator = true,
}) {
  final route = ModalSheetRoute<T>(
    swipeDismissible: isDismissible,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.55),
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
    this.maxHeightFraction = 0.88,
    this.backgroundColor,
    this.contentPadding,
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
          color: backgroundColor ?? colors.surface,
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final bottomSafe = keyboardInset > 0 ? 0.0 : mediaQuery.viewPadding.bottom;

    final padding =
        contentPadding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl);

    final body = scrollable
        ? Flexible(
            child: SingleChildScrollView(
              padding: padding,
              child: child,
            ),
          )
        : Flexible(child: Padding(padding: padding, child: child));

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showGrabber) const _SheetGrabber() else const SizedBox(height: 14),
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              18,
            ),
            child: AppSheetTitle(
              title: title ?? '',
              subtitle: subtitle,
              showClose: showClose,
            ),
          ),
        body,
        SizedBox(height: bottomSafe + AppSpacing.lg),
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

class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(top: 10, bottom: 14),
        decoration: BoxDecoration(
          color: colors.divider,
          borderRadius: BorderRadius.circular(AppRadius.full),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppText.title.copyWith(
                  color: colors.active,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              if (subtitleText != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitleText,
                  style: AppText.caption.copyWith(
                    color: colors.deactiveDarker,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showClose) ...[
          const SizedBox(width: 8),
          AppSheetCloseButton(
            onTap: () => Navigator.of(context).maybePop(),
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
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surfaceHigh,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppLineIconWidget(
                  AppLineIcon.close,
                  size: 16,
                  color: colors.deactive,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
