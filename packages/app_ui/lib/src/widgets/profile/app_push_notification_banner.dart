import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_ninja_mark.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppPushNotificationBanner extends StatelessWidget {
  const AppPushNotificationBanner({
    required this.title,
    required this.message,
    super.key,
    this.timeLabel = 'сейчас',
    this.onTap,
    this.showStackPeek = true,
  });

  final String title;
  final String message;
  final String timeLabel;
  final VoidCallback? onTap;
  final bool showStackPeek;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppPressable(
          onTap: onTap,
          semanticsLabel: title,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.ink,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                AppIconTile(
                  radius: AppRadius.sm,
                  background: colors.accent,
                  child: AppNinjaMark(size: 20, color: colors.onAccent),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.captionStrong
                                  .copyWith(color: colors.canvas),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xsm),
                          Text(
                            timeLabel,
                            style: AppText.captionSmall
                                .copyWith(color: colors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showStackPeek)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.ink.withValues(alpha: .45),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.tile),
                ),
              ),
              child:
                  const SizedBox(height: AppSpacing.sm, width: double.infinity),
            ),
          ),
      ],
    );
  }
}
