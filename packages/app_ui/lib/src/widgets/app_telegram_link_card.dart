import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:app_ui/src/widgets/app_dashed_border.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppTelegramLinkCard extends StatelessWidget {
  const AppTelegramLinkCard({
    required this.title,
    required this.handle,
    super.key,
    this.actionLabel = 'Открыть',
    this.onTap,
  })  : isAdd = false,
        addLabel = null;

  const AppTelegramLinkCard.add({
    required String label,
    super.key,
    this.onTap,
  })  : isAdd = true,
        addLabel = label,
        title = '',
        handle = '',
        actionLabel = '';

  final String title;
  final String handle;
  final String actionLabel;
  final bool isAdd;
  final String? addLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (isAdd) {
      final label = addLabel ?? '';
      return AppPressable(
        onTap: onTap,
        semanticsLabel: label,
        child: AppDashedBorder(
          color: colors.line,
          radius: AppRadius.card,
          strokeWidth: 1.5,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sectionGap),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Row(
              children: [
                AppIconTile(
                  icon: AppLineIcon.plus,
                  size: AppControlSize.iconTileLarge,
                  iconSize: AppIconSize.md,
                  foreground: colors.muted2,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyStrong.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      semanticsLabel: '$title, $handle',
      child: Row(
        children: [
          AppIconTile(
            icon: AppLineIcon.send,
            size: AppControlSize.iconTileLarge,
            iconSize: AppIconSize.md,
            background: colors.accent,
            foreground: colors.onAccent,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionGap,
              vertical: AppSpacing.compactGap,
            ),
            decoration: BoxDecoration(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              actionLabel,
              style: AppText.subtextBold.copyWith(color: colors.onAccent),
            ),
          ),
        ],
      ),
    );
  }
}
