import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppRecentlyUnlockedBanner extends StatelessWidget {
  const AppRecentlyUnlockedBanner({
    required this.emoji,
    required this.name,
    required this.rarityLabel,
    required this.shurikenReward,
    super.key,
    this.onShare,
  });

  final String emoji;
  final String name;
  final String rarityLabel;
  final int shurikenReward;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md + 4),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Только что открыто',
                  style: AppText.overline.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: AppText.bodyStrong.copyWith(
                    color: colors.active,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$rarityLabel · +$shurikenReward сюрикенов',
                  style: AppText.captionSmall.copyWith(
                    color: colors.deactiveDarker,
                  ),
                ),
              ],
            ),
          ),
          if (onShare != null)
            AppPressable(
              onTap: onShare,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'Поделиться',
                  style: AppText.caption.copyWith(
                    color: colors.onAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
