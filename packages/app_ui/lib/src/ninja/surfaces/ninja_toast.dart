import 'dart:async';
import 'dart:collection';

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/material.dart';

class NinjaToast extends StatelessWidget {
  const NinjaToast({
    required this.message,
    super.key,
    this.showCheck = true,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final bool showCheck;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final action = actionLabel;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final stacked = textScale >= 1.5;

    final messageWidget = Semantics(
      label: message,
      liveRegion: true,
      container: true,
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCheck) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.brand,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox.square(
                dimension: 32,
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.check,
                    size: 17,
                    strokeWidth: 2.5,
                    color: colors.onBrand,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                message,
                style: NinjaText.body.copyWith(
                  color: colors.onInk,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final actionWidget = action == null
        ? null
        : Semantics(
            button: true,
            enabled: onAction != null,
            child: AppPressable(
              onTap: onAction,
              enabled: onAction != null,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: NinjaMetrics.minTouchTarget,
                  minHeight: NinjaMetrics.minTouchTarget,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.brand,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        action,
                        textAlign: TextAlign.center,
                        style: NinjaText.button.copyWith(color: colors.onBrand),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: BorderRadius.circular(18),
      ),
      child: stacked && actionWidget != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                messageWidget,
                const SizedBox(height: 8),
                actionWidget,
              ],
            )
          : Row(
              children: [
                Expanded(child: messageWidget),
                if (actionWidget != null) ...[
                  const SizedBox(width: 10),
                  actionWidget,
                ],
              ],
            ),
    );
  }
}

class NinjaToastData {
  const NinjaToastData({
    required this.message,
    this.showCheck = true,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 3),
  });

  final String message;
  final bool showCheck;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
}

class NinjaToastHost extends StatefulWidget {
  const NinjaToastHost({required this.child, super.key, this.bottomInset = 16});

  final Widget child;
  final double bottomInset;

  static NinjaToastHostState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType();

  static NinjaToastHostState of(BuildContext context) {
    final state = maybeOf(context);
    if (state == null) {
      throw FlutterError(
        'NinjaToastHost.of() requires a NinjaToastHost ancestor.',
      );
    }
    return state;
  }

  @override
  NinjaToastHostState createState() => NinjaToastHostState();
}

class NinjaToastHostState extends State<NinjaToastHost>
    with SingleTickerProviderStateMixin {
  final Queue<NinjaToastData> _queue = Queue<NinjaToastData>();
  late final AnimationController _controller;
  NinjaToastData? _current;
  Timer? _timer;

  bool get _reduceMotion =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
      (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);

  bool get _accessibleNavigation =>
      MediaQuery.maybeAccessibleNavigationOf(context) ?? false;

  NinjaToastData? get current => _current;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  void show(NinjaToastData toast) {
    _queue.add(toast);
    if (_current == null) _showNext();
  }

  void dismiss() => _hideCurrent();

  void _showNext() {
    _timer?.cancel();
    if (_queue.isEmpty) {
      setState(() => _current = null);
      return;
    }
    final next = _queue.removeFirst();
    setState(() => _current = next);
    if (_reduceMotion) {
      _controller.value = 1;
    } else {
      unawaited(_controller.forward(from: 0));
    }
    final hasVisibleAction = next.actionLabel != null && next.onAction != null;
    if (!hasVisibleAction || !_accessibleNavigation) {
      _timer = Timer(next.duration, _hideCurrent);
    }
  }

  void _hideCurrent() {
    _timer?.cancel();
    _timer = null;
    if (_current == null) return;
    if (_reduceMotion) {
      _controller.value = 0;
      _showNext();
      return;
    }
    unawaited(
      _controller.reverse().whenComplete(() {
        if (mounted) _showNext();
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toast = _current;
    final bottom = widget.bottomInset + MediaQuery.paddingOf(context).bottom;
    return Stack(
      children: [
        widget.child,
        if (toast != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: bottom,
            child: FadeTransition(
              opacity: _controller,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.18),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOut,
                  ),
                ),
                child: NinjaToast(
                  message: toast.message,
                  showCheck: toast.showCheck,
                  actionLabel: toast.actionLabel,
                  onAction: toast.onAction == null
                      ? null
                      : () {
                          toast.onAction!();
                          _hideCurrent();
                        },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

void showNinjaToast(
  BuildContext context, {
  required String message,
  bool showCheck = true,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  NinjaToastHost.of(context).show(
    NinjaToastData(
      message: message,
      showCheck: showCheck,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    ),
  );
}
