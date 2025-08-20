import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

/// Lightweight controller to manage BottomModalSheet outside of the widget tree.
///
/// Note: This controller focuses on high-level actions like closing the sheet.
/// Low-level snap/expand control depends on Smooth Sheets internals, which
/// might not expose a public controller yet. Once available, we can wire it here.
class BottomModalSheetController {
  BottomModalSheetController();

  BuildContext? _routeContext;
  Completer<void>? _closedCompleter;

  /// Attach a route [BuildContext] so the controller can operate.
  void _attach(BuildContext context) => _routeContext = context;

  /// Bind the controller to the closing future of the route.
  void _bindCloseFuture(Future<dynamic> future) {
    _closedCompleter = Completer<void>();
    future.whenComplete(() {
      if (!(_closedCompleter?.isCompleted ?? true)) {
        _closedCompleter?.complete();
      }
      _routeContext = null;
    });
  }

  /// Dismiss the sheet if possible.
  void close() {
    final context = _routeContext;
    if (context == null) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Future that completes when the sheet is closed.
  Future<void> get closed async => _closedCompleter?.future ?? Future.value();

  /// Whether the sheet is currently open.
  bool get isOpen => _routeContext != null;
}

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
    this.controller,
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

  /// Optional external controller
  final BottomModalSheetController? controller;

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
    BottomModalSheetController? controller,
  }) {
    final route = ModalSheetRoute<void>(
      swipeDismissible: isDismissible,
      barrierDismissible: isDismissible,
      swipeDismissSensitivity:
          const SwipeDismissSensitivity(minDragDistance: 100),
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
        controller: controller,
        child: child,
      ),
    );
    final future = Navigator.push(context, route);
    controller?._bindCloseFuture(future);
    return future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    // Bind controller to current route context so it can close the sheet.
    controller?._attach(context);

    // Create snap points based on settings (min -> default -> max -> fullscreen)
    final fractions = <double>[];
    void addFrac(double f) {
      if (f > 0 && f <= 1.0 && !fractions.contains(f)) fractions.add(f);
    }

    addFrac(minFraction);
    addFrac(defaultFraction);

    // If expandable, add maximum snap point
    if (isExpandable) {
      addFrac(maxFraction);
    }

    // If fullscreen is enabled, add it
    if (showFullScreen) {
      addFrac(_fullScreenFraction);
    }

    final snaps = fractions.map(SheetOffset.new).toList();

    // Choose snap grid type
    final snapGrid = snaps.length > 1
        ? MultiSnapGrid(snaps: snaps)
        : SingleSnapGrid(snap: snaps.first);

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
        initialOffset: SheetOffset(
          initialFraction ??
              (() {
                final screenHeight = MediaQuery.of(context).size.height;
                final heightFraction = (sheetHeight / screenHeight)
                    .clamp(minFraction, maxFraction)
                    ;
                return heightFraction;
              })(),
        ),
        physics: physics,
        snapGrid: snapGrid,
        decoration: decoration ?? defaultDecoration,
        scrollConfiguration:
            scrollConfiguration ?? const SheetScrollConfiguration(),
        child: contentWidget,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom > 0
        ? mediaQuery.viewInsets.bottom
        : mediaQuery.viewPadding.bottom;

    final defaultPadding = EdgeInsets.only(
      left: 16,
      right: 16,
      top: 16,
      bottom: bottomPadding + 16,
    );

    final header = <Widget>[
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
      const SizedBox(height: 24),
    ];

    final content = scrollable
        ? Flexible(
            fit: FlexFit.tight,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),),
              padding: EdgeInsets.zero,
              child: child,
            ),
          )
        : Flexible(
            fit: FlexFit.tight,
            child: child,
          );

    return Container(
      margin: margin,
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
              ...header,
              content,
            ],
          ),
        ),
      ),
    );
  }
}
