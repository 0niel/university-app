import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

/// Default values for the modal sheet
const _defaultSheetHeight = 500.0;
const _minSheetFraction = 0.33;
const _defaultSheetFraction = 0.75;
const _maxSheetFraction = 1.0;
const _fullScreenFraction = 1.0;

/// A modal sheet with resizable capabilities
class BottomModalSheet extends StatelessWidget {
  const BottomModalSheet({
    required this.title,
    required this.child,
    super.key,
    this.onConfirm,
    this.description,
    this.isExpandable = true,
    this.showFullScreen = false,
    this.isDismissible = true,
    this.barrierColor,
    this.backgroundColor,
    this.initialFraction,
    this.minFraction = _minSheetFraction,
    this.defaultFraction = _defaultSheetFraction,
    this.maxFraction = _maxSheetFraction,
    this.sheetHeight = _defaultSheetHeight,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.physics = const BouncingSheetPhysics(),
    this.showDragHandle = true,
    this.scrollable = false,
    this.scrollConfiguration,
    this.decoration,
    this.elevation = 4,
  });

  /// Confirmation handler
  final VoidCallback? onConfirm;

  /// Sheet title
  final String title;

  /// Description (subtitle)
  final String? description;

  /// Sheet content
  final Widget child;

  /// Allow resize
  final bool isExpandable;

  /// Allow full screen mode
  final bool showFullScreen;

  /// Allow dismiss by tapping the barrier
  final bool isDismissible;

  /// Barrier color
  final Color? barrierColor;

  /// Background color
  final Color? backgroundColor;

  /// Initial height (as screen fraction)
  final double? initialFraction;

  /// Minimum height (as screen fraction)
  final double minFraction;

  /// Default height (as screen fraction)
  final double defaultFraction;

  /// Maximum height (as screen fraction)
  final double maxFraction;

  /// Modal height in pixels
  final double sheetHeight;

  /// Corner radius
  final double borderRadius;

  /// Inner padding
  final EdgeInsets? padding;

  /// Outer margin
  final EdgeInsets? margin;

  /// Animation physics
  final SheetPhysics physics;

  /// Show drag handle
  final bool showDragHandle;

  /// Enable content scrolling
  final bool scrollable;

  /// Scroll configuration
  final SheetScrollConfiguration? scrollConfiguration;

  /// Custom sheet decoration
  final SheetDecoration? decoration;

  /// Shadow elevation (for MaterialSheetDecoration only)
  final double elevation;

  /// Show modal sheet
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    required String title,
    String? description,
    bool isExpandable = false,
    bool showFullScreen = false,
    bool isDismissible = true,
    Color? backgroundColor,
    Color? barrierColor,
    double? initialFraction,
    double minFraction = _minSheetFraction,
    double defaultFraction = _defaultSheetFraction,
    double maxFraction = _maxSheetFraction,
    double sheetHeight = _defaultSheetHeight,
    double borderRadius = 24,
    EdgeInsets? padding,
    EdgeInsets? margin,
    SheetPhysics physics = const BouncingSheetPhysics(),
    bool showDragHandle = true,
    bool scrollable = false,
    SheetScrollConfiguration? scrollConfiguration,
    SheetDecoration? decoration,
    double elevation = 4,
  }) {
    return Navigator.push(
      context,
      ModalSheetRoute(
        swipeDismissible: isDismissible,
        barrierDismissible: isDismissible,
        swipeDismissSensitivity: const SwipeDismissSensitivity(minDragDistance: 100),
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: barrierColor ?? Colors.black54,
        builder: (context) => BottomModalSheet(
          title: title,
          description: description,
          isExpandable: isExpandable,
          showFullScreen: showFullScreen,
          isDismissible: isDismissible,
          backgroundColor: backgroundColor,
          initialFraction: initialFraction,
          minFraction: minFraction,
          defaultFraction: defaultFraction,
          maxFraction: maxFraction,
          sheetHeight: sheetHeight,
          borderRadius: borderRadius,
          padding: padding,
          margin: margin,
          physics: physics,
          showDragHandle: showDragHandle,
          scrollable: scrollable,
          scrollConfiguration: scrollConfiguration,
          decoration: decoration,
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    // Create snap points based on settings
    final snapPoints = <SheetOffset>[SheetOffset(defaultFraction)];

    // If expandable, add maximum snap point
    if (isExpandable) {
      snapPoints.add(SheetOffset(maxFraction));
    }

    // If fullscreen is enabled, add it
    if (showFullScreen) {
      snapPoints.add(const SheetOffset(_fullScreenFraction));
    }

    // Choose snap grid type
    final snapGrid = snapPoints.length > 1 ? MultiSnapGrid(snaps: snapPoints) : SingleSnapGrid(snap: snapPoints.first);

    final bgColor = backgroundColor ?? colors?.background02;

    final defaultDecoration = MaterialSheetDecoration(
      size: SheetSize.stretch,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
      ),
      color: bgColor,
      elevation: elevation,
    );

    final contentWidget = _buildContent(context);

    return SheetKeyboardDismissible(
      dismissBehavior: const SheetKeyboardDismissBehavior.onDragDown(
        isContentScrollAware: true,
      ),
      child: Sheet(
        initialOffset: SheetOffset(initialFraction ?? defaultFraction),
        physics: physics,
        snapGrid: snapGrid,
        decoration: decoration ?? defaultDecoration,
        scrollConfiguration: const SheetScrollConfiguration(),
        child: contentWidget,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final defaultPadding = EdgeInsets.only(
      left: 16,
      right: 16,
      top: 16,
      bottom: bottomPadding + 16,
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors?.background02,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      child: SheetContentScaffold(
        extendBodyBehindBottomBar: true,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: padding ?? defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle)
                Center(
                  child: Container(
                    width: 40,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: colors?.deactive ?? Colors.grey,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              Center(
                child: Text(
                  title,
                  style: AppTextStyle.h5.copyWith(
                    color: colors?.active ?? Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              if (description != null)
                Text(
                  description!,
                  style: AppTextStyle.captionL.copyWith(
                    color: colors?.deactive ?? Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
