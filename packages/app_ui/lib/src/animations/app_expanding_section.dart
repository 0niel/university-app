import 'dart:async';

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/widgets.dart';

class AppExpandingSection extends StatefulWidget {
  const AppExpandingSection({
    required this.expanded,
    required this.child,
    super.key,
    this.duration = NinjaMotion.base,
  });

  final bool expanded;
  final Widget child;
  final Duration duration;

  @override
  State<AppExpandingSection> createState() => _AppExpandingSectionState();
}

class _AppExpandingSectionState extends State<AppExpandingSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _height;
  final _focusScope = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.expanded ? 1 : 0,
    );
    _height = _controller.drive(CurveTween(curve: NinjaMotion.emphasized));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configure();
  }

  @override
  void didUpdateWidget(AppExpandingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _configure();
    if (widget.expanded == oldWidget.expanded) return;
    if (!widget.expanded && _focusScope.hasFocus) _focusScope.unfocus();
    if (_controller.duration == Duration.zero) return;
    unawaited(widget.expanded ? _controller.forward() : _controller.reverse());
  }

  void _configure() {
    final duration = NinjaMotion.of(context, widget.duration);
    _controller.duration = duration;
    if (duration == Duration.zero) _controller.value = widget.expanded ? 1 : 0;
  }

  @override
  void dispose() {
    _focusScope.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
    sizeFactor: _height,
    alignment: Alignment.topCenter,
    child: ExcludeSemantics(
      excluding: !widget.expanded,
      child: IgnorePointer(
        ignoring: !widget.expanded,
        child: ExcludeFocus(
          excluding: !widget.expanded,
          child: FocusScope(node: _focusScope, child: widget.child),
        ),
      ),
    ),
  );
}
