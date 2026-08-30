import 'package:app_ui/app_ui.dart';
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
    final colors = Theme.of(context).colors;
    final bg =
        picked ? colors.primary.withValues(alpha: 0.14) : colors.surfaceHigh;
    final fg = picked ? colors.primary : colors.deactive;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$emoji $count',
      semanticsSelected: picked,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Center(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 14, height: 1),
                ),
                const SizedBox(width: 6),
                Text(
                  '$count',
                  style: AppText.tabular(AppText.button).copyWith(
                    color: fg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
