import 'dart:async';

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPressState extends StatefulWidget {
  const AppPressState({
    required this.builder,
    super.key,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.pressedScale = 1,
    this.haptics = false,
    this.behavior = HitTestBehavior.opaque,
    this.semanticsLabel,
    this.semanticsButton,
    this.semanticsSelected,
    this.semanticsToggled,
    this.semanticsChecked,
    this.semanticsMixed,
    this.semanticsExclusive = false,
  });

  final Widget Function(BuildContext context, {required bool pressed}) builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final double pressedScale;
  final bool haptics;
  final HitTestBehavior behavior;
  final String? semanticsLabel;
  final bool? semanticsButton;
  final bool? semanticsSelected;
  final bool? semanticsToggled;
  final bool? semanticsChecked;
  final bool? semanticsMixed;
  final bool semanticsExclusive;

  @override
  State<AppPressState> createState() => _AppPressStateState();
}

class _AppPressStateState extends State<AppPressState> {
  final FocusNode _focusNode = FocusNode();
  bool _pressed = false;
  bool _showFocus = false;

  bool get _interactive =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  @override
  void didUpdateWidget(covariant AppPressState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive) _pressed = false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
  }

  void _handleTap() {
    if (!_interactive) return;
    if (widget.haptics) unawaited(HapticFeedback.lightImpact());
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (!_interactive) return;
    _setPressed(false);
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    final pressed = _pressed && _interactive;

    var child = widget.builder(context, pressed: pressed);
    if (!reduceMotion && widget.pressedScale != 1) {
      child = AnimatedScale(
        scale: pressed ? widget.pressedScale : 1,
        duration: Duration(milliseconds: pressed ? 80 : 160),
        curve: Curves.easeOut,
        child: child,
      );
    }

    if (_interactive) {
      child = GestureDetector(
        behavior: widget.behavior,
        excludeFromSemantics: true,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: _handleTap,
        onLongPress: widget.onLongPress == null ? null : _handleLongPress,
        child: child,
      );
    }

    child = FocusableActionDetector(
      enabled: _interactive,
      focusNode: _focusNode,
      includeFocusSemantics: false,
      mouseCursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onShowFocusHighlight: (value) {
        if (_showFocus != value) setState(() => _showFocus = value);
      },
      onFocusChange: (value) {
        setState(() {
          if (!value) _pressed = false;
        });
      },
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleTap();
            return null;
          },
        ),
      },
      child: CustomPaint(
        foregroundPainter: _showFocus && _interactive
            ? _FocusOutline(context.colors.accent)
            : null,
        child: child,
      ),
    );
    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      button: widget.semanticsButton ??
          (_interactive || widget.semanticsLabel != null),
      selected: widget.semanticsSelected,
      toggled: widget.semanticsToggled,
      checked: widget.semanticsChecked,
      mixed: widget.semanticsMixed,
      inMutuallyExclusiveGroup: widget.semanticsExclusive ? true : null,
      enabled: widget.enabled,
      focusable: _interactive,
      focused: _interactive ? _focusNode.hasFocus : null,
      onFocus: _interactive && defaultTargetPlatform != TargetPlatform.iOS
          ? _focusNode.requestFocus
          : null,
      onTap: _interactive && widget.onTap != null ? _handleTap : null,
      onLongPress:
          _interactive && widget.onLongPress != null ? _handleLongPress : null,
      excludeSemantics: widget.semanticsLabel != null,
      child: child,
    );
  }
}

class _FocusOutline extends CustomPainter {
  const _FocusOutline(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        (Offset.zero & size).deflate(AppSpacing.xxxs),
        const Radius.circular(AppRadius.focusOutline),
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.xxs,
    );
  }

  @override
  bool shouldRepaint(_FocusOutline oldDelegate) => color != oldDelegate.color;
}
