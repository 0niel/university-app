import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaQrGlassButton extends StatelessWidget {
  const NinjaQrGlassButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.active = false,
    super.key,
  });

  final AppLineIcon icon;
  final String? label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressedScale: 0.92,
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: active,
      child: Container(
        width: AppControlSize.iconButton,
        height: AppControlSize.iconButton,
        alignment: .center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.14),
          shape: .circle,
        ),
        child: AppLineIconWidget(
          icon,
          size: 20,
          color: active ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
