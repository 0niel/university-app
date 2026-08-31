import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_tone.dart';

class FriendsCircleButton extends StatelessWidget {
  const FriendsCircleButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone = FriendsTone.neutral,
    this.selected,
    super.key,
  });

  final AppLineIcon icon;
  final String label;
  final VoidCallback? onTap;
  final FriendsTone tone;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final enabled = onTap != null;
    final activeTone = (selected ?? false) ? FriendsTone.accent : tone;
    final (background, foreground) = enabled
        ? friendsToneColors(colors, activeTone)
        : (colors.surface, colors.disabled);

    return AppPressable(
      onTap: onTap,
      pressedScale: 0.92,
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: selected,
      child: Container(
        width: NinjaMetrics.minTouchTarget,
        height: NinjaMetrics.minTouchTarget,
        alignment: .center,
        decoration: BoxDecoration(color: background, shape: .circle),
        child: AppLineIconWidget(icon, size: 20, color: foreground),
      ),
    );
  }
}
