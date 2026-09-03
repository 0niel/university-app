import 'dart:async';
import 'dart:collection';

import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_toast.dart';
import 'package:flutter/material.dart';

class NinjaToast extends StatelessWidget {
  const NinjaToast({
    required this.message,
    super.key,
    this.showCheck = true,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final bool showCheck;
  final AppLineIcon? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => AppToast(
        message: message,
        showIcon: showCheck,
        icon: icon,
        actionLabel: actionLabel,
        onAction: onAction,
      );
}

class NinjaToastData {
  const NinjaToastData({
    required this.message,
    this.showCheck = true,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.duration = const Duration(seconds: 3),
  });

  final String message;
  final bool showCheck;
  final AppLineIcon? icon;
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
      duration: const Duration(milliseconds: 250),
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
                  begin: const Offset(0, 0.22),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                ),
                child: NinjaToast(
                  message: toast.message,
                  showCheck: toast.showCheck,
                  icon: toast.icon,
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
  AppLineIcon? icon,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  NinjaToastHost.of(context).show(
    NinjaToastData(
      message: message,
      showCheck: showCheck,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    ),
  );
}
