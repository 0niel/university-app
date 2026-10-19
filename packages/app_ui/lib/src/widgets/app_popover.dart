import 'dart:math' as math;

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:app_ui/src/glass/app_glass_surface.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<T?> showAppPopover<T>(
  BuildContext context, {
  required BuildContext anchorContext,
  required WidgetBuilder builder,
  String? semanticLabel,
  double maxWidth = 360,
  double maxHeight = 440,
  double gap = AppSpacing.sm,
  bool useRootNavigator = true,
}) {
  assert(
    maxWidth > 0 && maxHeight > 0 && gap >= 0,
    'Popover dimensions must be positive and the gap non-negative.',
  );
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final anchor = anchorContext.findRenderObject()! as RenderBox;
  return navigator.push<T>(
    _AppPopoverRoute<T>(
      anchorRect:
          anchor.localToGlobal(Offset.zero, ancestor: overlay) & anchor.size,
      builder: builder,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      semanticLabel: semanticLabel,
      dismissLabel: MaterialLocalizations.of(context).menuDismissLabel,
      duration: NinjaMotion.of(context, NinjaMotion.fast),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      gap: gap,
    ),
  );
}

class AppPopover extends StatefulWidget {
  const AppPopover({required this.child, super.key, this.semanticLabel});

  final Widget child;
  final String? semanticLabel;

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      namesRoute: widget.semanticLabel != null,
      label: widget.semanticLabel,
      explicitChildNodes: true,
      child: AppGlassSurface(
        role: AppGlassRole.overlay,
        borderRadius: AppRadius.card,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Material(
            type: MaterialType.transparency,
            child: Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
                SingleActivator(LogicalKeyboardKey.arrowDown):
                    NextFocusIntent(),
                SingleActivator(LogicalKeyboardKey.arrowUp):
                    PreviousFocusIntent(),
              },
              child: Actions(
                actions: {
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (_) => Navigator.of(context).maybePop(),
                  ),
                },
                child: Focus(
                  autofocus: true,
                  child: FocusTraversalGroup(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: widget.child,
                      ),
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
}

class _AppPopoverRoute<T> extends PopupRoute<T> {
  _AppPopoverRoute({
    required this.anchorRect,
    required this.builder,
    required this.themes,
    required this.dismissLabel,
    required this.duration,
    required this.maxWidth,
    required this.maxHeight,
    required this.gap,
    this.semanticLabel,
  }) : super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final Rect anchorRect;
  final WidgetBuilder builder;
  final CapturedThemes themes;
  final String dismissLabel;
  final Duration duration;
  final double maxWidth;
  final double maxHeight;
  final double gap;
  final String? semanticLabel;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  String get barrierLabel => dismissLabel;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final media = MediaQuery.of(context);
    return CustomSingleChildLayout(
      delegate: _PopoverLayout(
        anchorRect: anchorRect,
        padding: media.viewPadding,
        keyboardInset: media.viewInsets.bottom,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        gap: gap,
        textDirection: Directionality.of(context),
      ),
      child: themes.wrap(
        _transition(
          context,
          animation,
          AppPopover(
            semanticLabel: semanticLabel,
            child: Builder(builder: builder),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;

  Widget _transition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    if (NinjaMotion.of(context, duration) == Duration.zero) return child;
    final curve = animation.drive(CurveTween(curve: NinjaMotion.enter));
    return SlideTransition(
      position: curve.drive(
        Tween(begin: const Offset(0, -.015), end: Offset.zero),
      ),
      child: ScaleTransition(
        alignment: Directionality.of(context) == TextDirection.ltr
            ? Alignment.topRight
            : Alignment.topLeft,
        scale: curve.drive(Tween(begin: .97, end: 1)),
        child: child,
      ),
    );
  }
}

class _PopoverLayout extends SingleChildLayoutDelegate {
  const _PopoverLayout({
    required this.anchorRect,
    required this.padding,
    required this.keyboardInset,
    required this.maxWidth,
    required this.maxHeight,
    required this.gap,
    required this.textDirection,
  });

  final Rect anchorRect;
  final EdgeInsets padding;
  final double keyboardInset;
  final double maxWidth;
  final double maxHeight;
  final double gap;
  final TextDirection textDirection;

  Rect _bounds(Size size) {
    return Rect.fromLTRB(
      math.min(size.width, padding.left + AppSpacing.md),
      math.min(size.height, padding.top + AppSpacing.md),
      math.max(
        padding.left + AppSpacing.md,
        size.width - padding.right - AppSpacing.md,
      ),
      math.max(
        padding.top + AppSpacing.md,
        size.height - math.max(padding.bottom, keyboardInset) - AppSpacing.md,
      ),
    );
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final bounds = _bounds(constraints.biggest);
    final available = math
        .max(
          bounds.bottom - anchorRect.bottom - gap,
          anchorRect.top - gap - bounds.top,
        )
        .clamp(0.0, bounds.height);
    final width = math.min(maxWidth, bounds.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: math.min(maxHeight, available > 0 ? available : bounds.height),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final bounds = _bounds(size);
    final below = anchorRect.bottom + gap;
    final above = anchorRect.top - gap - childSize.height;
    final top = below + childSize.height <= bounds.bottom ? below : above;
    final left = textDirection == TextDirection.ltr
        ? anchorRect.right - childSize.width
        : anchorRect.left;
    return Offset(
      left.clamp(bounds.left, bounds.right - childSize.width),
      top.clamp(bounds.top, bounds.bottom - childSize.height),
    );
  }

  @override
  bool shouldRelayout(_PopoverLayout oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      padding != oldDelegate.padding ||
      keyboardInset != oldDelegate.keyboardInset ||
      maxWidth != oldDelegate.maxWidth ||
      maxHeight != oldDelegate.maxHeight ||
      gap != oldDelegate.gap ||
      textDirection != oldDelegate.textDirection;
}
