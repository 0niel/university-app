import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MiniAppScanGlassButton extends StatelessWidget {
  const MiniAppScanGlassButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.tooltip,
    super.key,
  });

  final AppLineIcon icon;
  final VoidCallback onTap;
  final bool active;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: AppPressable(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.16),
            shape: .circle,
          ),
          child: Center(
            child: AppLineIconWidget(
              icon,
              size: 20,
              color: active ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
