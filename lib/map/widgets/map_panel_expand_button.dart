import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapPanelExpandButton extends StatefulWidget {
  const MapPanelExpandButton({
    required this.controller,
    required this.collapsedSize,
    required this.onPressed,
    super.key,
  });

  final DraggableScrollableController controller;
  final double collapsedSize;
  final VoidCallback onPressed;

  @override
  State<MapPanelExpandButton> createState() => _MapPanelExpandButtonState();
}

class _MapPanelExpandButtonState extends State<MapPanelExpandButton> {
  late bool _expanded;

  bool get _isExpanded =>
      widget.controller.isAttached &&
      widget.controller.size > widget.collapsedSize + .08;

  @override
  void initState() {
    super.initState();
    _expanded = _isExpanded;
    widget.controller.addListener(_extentChanged);
  }

  @override
  void didUpdateWidget(MapPanelExpandButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_extentChanged);
      widget.controller.addListener(_extentChanged);
    }
    _expanded = _isExpanded;
  }

  void _extentChanged() {
    final expanded = _isExpanded;
    if (_expanded != expanded) setState(() => _expanded = expanded);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_extentChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppIconButton(
    icon: AnimatedRotation(
      turns: _expanded ? .5 : 0,
      duration: NinjaMotion.of(context),
      child: const AppLineIconWidget(AppLineIcon.chevronU),
    ),
    tooltip: _expanded
        ? context.l10n.mapCollapseSheet
        : context.l10n.mapExpandSheet,
    shape: AppIconButtonShape.circle,
    size: AppIconButtonSize.compact,
    tone: AppIconButtonTone.surface,
    onPressed: widget.onPressed,
  );
}
