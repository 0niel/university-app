import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppRecentlyUnlockedBanner extends StatelessWidget {
  const AppRecentlyUnlockedBanner({
    required this.emoji,
    required this.name,
    required this.rarityLabel,
    required this.shurikenReward,
    super.key,
    this.onShare,
    this.title = 'Только что открыто',
    this.shareLabel = 'Поделиться',
  });

  final String emoji;
  final String name;
  final String rarityLabel;
  final int shurikenReward;
  final VoidCallback? onShare;
  final String title;
  final String shareLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final share = onShare;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sectionGap,
      ),
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28, height: 1)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppText.overline.copyWith(color: colors.accent),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  name,
                  style: AppText.bodyStrong.copyWith(color: colors.ink),
                ),
                Text(
                  '$rarityLabel · +$shurikenReward сюрикенов',
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          if (share != null) ...[
            const SizedBox(width: AppSpacing.md),
            AppPressable(
              onTap: share,
              semanticsLabel: shareLabel,
              semanticsButton: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppControlSize.touchTarget,
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    shareLabel,
                    style: AppText.subtextBold.copyWith(color: colors.accent),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
