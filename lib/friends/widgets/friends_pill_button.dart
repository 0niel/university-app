import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_tone.dart';

class FriendsPillButton extends StatelessWidget {
  const FriendsPillButton({
    required this.label,
    required this.onTap,
    this.tone = FriendsTone.accent,
    this.icon,
    this.expanded = false,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final FriendsTone tone;
  final AppLineIcon? icon;
  final bool expanded;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final enabled = onTap != null && !loading;
    final (background, foreground) = enabled || loading
        ? friendsToneColors(colors, tone)
        : (colors.surface, colors.disabled);
    final leading = icon;

    final pill = Container(
      constraints: const BoxConstraints(
        minHeight: NinjaMetrics.minTouchTarget,
      ),
      padding: const .symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: background,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Row(
        mainAxisSize: expanded ? .max : .min,
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          if (loading)
            NinjaSpinner(size: 16, strokeWidth: 2, color: foreground)
          else if (leading != null)
            AppLineIconWidget(leading, size: 16, color: foreground),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: NinjaText.button.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );

    final button = AppPressable(
      onTap: enabled ? onTap : null,
      semanticsLabel: label,
      semanticsButton: true,
      child: pill,
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
