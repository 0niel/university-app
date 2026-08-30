import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.child,
    super.key,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.pressedScale = 0.97,
    this.pressedOpacity = 0.85,
    this.haptics = false,
    this.behavior = HitTestBehavior.opaque,
    this.semanticsLabel,
    this.semanticsButton,
    this.semanticsSelected,
    this.semanticsToggled,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool enabled;
  final double pressedScale;
  final double pressedOpacity;
  final bool haptics;
  final HitTestBehavior behavior;
  final String? semanticsLabel;
  final bool? semanticsButton;
  final bool? semanticsSelected;
  final bool? semanticsToggled;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  bool get _interactive =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    final pressed = _pressed && _interactive;
    final duration = reduceMotion
        ? Duration.zero
        : Duration(milliseconds: pressed ? 80 : 160);

    Widget child = AnimatedOpacity(
      opacity: pressed ? widget.pressedOpacity : 1,
      duration: duration,
      curve: Curves.easeOut,
      child: widget.child,
    );
    if (!reduceMotion) {
      child = AnimatedScale(
        scale: pressed ? widget.pressedScale : 1,
        duration: duration,
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

    return Semantics(
      label: widget.semanticsLabel,
      button: widget.semanticsButton ??
          (_interactive || widget.semanticsLabel != null),
      selected: widget.semanticsSelected,
      toggled: widget.semanticsToggled,
      enabled: widget.enabled,
      onTap: _interactive && widget.onTap != null ? _handleTap : null,
      onLongPress:
          _interactive && widget.onLongPress != null ? _handleLongPress : null,
      excludeSemantics: widget.semanticsLabel != null,
      child: child,
    );
  }

  void _handleTap() {
    if (widget.haptics) unawaited(HapticFeedback.lightImpact());
    widget.onTap?.call();
  }

  void _handleLongPress() {
    _setPressed(false);
    widget.onLongPress?.call();
  }
}
