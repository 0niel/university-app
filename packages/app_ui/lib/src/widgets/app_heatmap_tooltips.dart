import 'dart:async';

import 'package:flutter/material.dart';

typedef HeatmapTooltipTargetBuilder =
    Widget Function({
      required DateTime day,
      required String message,
      required Widget child,
    });

class AppHeatmapTooltips extends StatefulWidget {
  const AppHeatmapTooltips({required this.builder, super.key});

  final Widget Function(HeatmapTooltipTargetBuilder target) builder;

  @override
  State<AppHeatmapTooltips> createState() => _AppHeatmapTooltipsState();
}

class _AppHeatmapTooltipsState extends State<AppHeatmapTooltips> {
  var _tooltipKey = GlobalKey<TooltipState>();
  DateTime? _activeDay;
  Timer? _hideTimer;
  var _revision = 0;

  @override
  void dispose() {
    _revision++;
    _hideTimer?.cancel();
    super.dispose();
  }

  void _activate(DateTime day) {
    _hideTimer?.cancel();
    if (_activeDay == day) return;
    _revision++;
    setState(() {
      _activeDay = day;
      _tooltipKey = GlobalKey<TooltipState>();
    });
  }

  void _show(DateTime day) {
    _activate(day);
    final revision = ++_revision;
    final feedback = TooltipTheme.of(context).enableFeedback ?? true;
    if (feedback) unawaited(Feedback.forLongPress(context));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || revision != _revision || _activeDay != day) return;
      _tooltipKey.currentState?.ensureTooltipVisible();
    });
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (_activeDay == null) return;
    final delay =
        TooltipTheme.of(context).showDuration ??
        const Duration(milliseconds: 1500);
    _hideTimer = Timer(delay, () {
      if (!mounted) return;
      _revision++;
      setState(() => _activeDay = null);
    });
  }

  Widget _target({
    required DateTime day,
    required String message,
    required Widget child,
  }) {
    if (message.isEmpty || !TooltipVisibility.of(context)) return child;
    return Semantics(
      tooltip: message,
      child: MouseRegion(
        onEnter: (_) => _activate(day),
        child: GestureDetector(
          excludeFromSemantics: true,
          behavior: HitTestBehavior.opaque,
          onLongPressStart: (_) => _show(day),
          onLongPressEnd: (_) => _scheduleHide(),
          onLongPressCancel: _scheduleHide,
          child: _activeDay == day
              ? Tooltip(
                  key: _tooltipKey,
                  message: message,
                  excludeFromSemantics: true,
                  triggerMode: TooltipTriggerMode.manual,
                  child: child,
                )
              : child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.builder(_target);
}
