import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapActionButton extends StatelessWidget {
  const MapActionButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String tooltip;
  final AppLineIcon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AnimatedOpacity(
      opacity: onTap == null ? .45 : 1,
      duration: NinjaMotion.of(context, NinjaMotion.fast),
      child: Tooltip(
        message: tooltip,
        child: AppPressable(
          pressedScale: 0.94,
          haptics: true,
          onTap: onTap,
          semanticsLabel: tooltip,
          semanticsButton: true,
          child: Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              shape: .circle,
            ),
            child: AppLineIconWidget(icon, size: 20, color: colors.ink),
          ),
        ),
      ),
    );
  }
}
