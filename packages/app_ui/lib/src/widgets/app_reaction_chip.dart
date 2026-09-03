import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppReactionChip extends StatelessWidget {
  const AppReactionChip({
    required this.emoji,
    required this.count,
    super.key,
    this.picked = false,
    this.onTap,
  });

  final String emoji;
  final int count;
  final bool picked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = picked ? colors.tint : colors.surface2;
    final foreground = picked ? colors.accent : colors.muted;

    return AppPressState(
      onTap: onTap,
      semanticsLabel: '$emoji $count',
      semanticsButton: true,
      semanticsSelected: picked,
      builder: (context, {required pressed}) => SizedBox(
        height: AppControlSize.touchTarget,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: pressed ? colors.canvas : background,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14, height: 1)),
                const SizedBox(width: AppSpacing.xsm),
                Text(
                  '$count',
                  style: AppText.sans(13, FontWeight.w600, tabular: true)
                      .copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
