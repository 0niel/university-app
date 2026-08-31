import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class EditorToolbarAction extends StatelessWidget {
  const EditorToolbarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.destructive = false,
  });

  final AppLineIcon icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final disabled = onPressed == null;
    final tint = disabled
        ? colors.disabled
        : (destructive ? colors.scarlet : colors.ink);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: !disabled,
        label: tooltip,
        child: AppPressable(
          pressedScale: 0.92,
          onTap: onPressed,
          child: Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: disabled ? colors.surface : colors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: AppLineIconWidget(icon, size: 19, color: tint),
          ),
        ),
      ),
    );
  }
}
