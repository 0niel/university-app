import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppPromoCard extends StatelessWidget {
  const AppPromoCard({
    required this.title,
    required this.accent,
    super.key,
    this.emoji,
    this.kicker,
    this.subtitle,
    this.actionLabel,
    this.solid = true,
    this.compact = false,
    this.onTap,
    this.onClose,
    this.closeSemanticsLabel,
  });

  final String title;
  final Color accent;
  final String? emoji;
  final String? kicker;
  final String? subtitle;
  final String? actionLabel;
  final bool solid;
  final bool compact;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final String? closeSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = solid ? accent : colors.tintOf(accent);
    final ink = solid ? colors.white : colors.ink;
    final muted = solid ? colors.white.withValues(alpha: .78) : colors.muted;
    final tile = solid
        ? colors.white.withValues(alpha: .18)
        : colors.tintOf(accent, colors.tint2Mix);
    final pillBackground = solid ? colors.white : accent;
    final pillForeground = solid ? accent : colors.white;
    final kicker = this.kicker;
    final subtitle = this.subtitle;
    final actionLabel = this.actionLabel;
    final emoji = this.emoji;

    if (compact) {
      return _CompactPromoCard(
        title: title,
        subtitle: subtitle,
        emoji: emoji,
        background: background,
        ink: ink,
        muted: muted,
        tile: tile,
        onTap: onTap,
        onClose: onClose,
        closeSemanticsLabel: closeSemanticsLabel,
      );
    }

    final card = Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (emoji != null) ...[
            Container(
              width: AppControlSize.iconTileLarge + 6,
              height: AppControlSize.iconTileLarge + 6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile,
                borderRadius: BorderRadius.circular(AppRadius.tile),
              ),
              child: Text(
                emoji,
                style: AppText.sans(24, FontWeight.w400, height: 1),
              ),
            ),
            const SizedBox(width: AppSpacing.sectionGap),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kicker != null) ...[
                  Text(
                    kicker.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      11,
                      FontWeight.w700,
                      height: 1.2,
                      letterSpacingEm: .06,
                    ).copyWith(color: muted),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                    17,
                    FontWeight.w700,
                    height: 1.2,
                    letterSpacingEm: -.01,
                  ).copyWith(color: ink),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      13,
                      FontWeight.w500,
                      height: 1.35,
                    ).copyWith(color: muted),
                  ),
                ],
                if (actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sectionGap,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: pillBackground,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          actionLabel,
                          style: AppText.subtextBold.copyWith(
                            color: pillForeground,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        AppLineIconWidget(
                          AppLineIcon.arrowRight,
                          size: AppIconSize.xs,
                          color: pillForeground,
                          strokeWidth: 2.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: AppSpacing.sm),
            AppPressable(
              onTap: onClose,
              semanticsLabel: closeSemanticsLabel,
              semanticsButton: true,
              child: Container(
                width: AppControlSize.iconTileCompact,
                height: AppControlSize.iconTileCompact,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tile,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: AppLineIconWidget(
                  AppLineIcon.close,
                  size: AppIconSize.xs,
                  color: ink,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: actionLabel == null ? title : '$title, $actionLabel',
      semanticsButton: true,
      child: card,
    );
  }
}

class _CompactPromoCard extends StatelessWidget {
  const _CompactPromoCard({
    required this.title,
    required this.background,
    required this.ink,
    required this.muted,
    required this.tile,
    this.subtitle,
    this.emoji,
    this.onTap,
    this.onClose,
    this.closeSemanticsLabel,
  });

  final String title;
  final String? subtitle;
  final String? emoji;
  final Color background;
  final Color ink;
  final Color muted;
  final Color tile;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final String? closeSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final emoji = this.emoji;
    final card = Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: Row(
        children: [
          if (emoji != null) ...[
            Container(
              width: AppControlSize.iconTileCompact,
              height: AppControlSize.iconTileCompact,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile,
                borderRadius: BorderRadius.circular(AppRadius.iconTile),
              ),
              child: Text(
                emoji,
                style: AppText.sans(18, FontWeight.w400, height: 1),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                    14,
                    FontWeight.w700,
                    height: 1.2,
                    letterSpacingEm: -.01,
                  ).copyWith(color: ink),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      12,
                      FontWeight.w500,
                      height: 1.25,
                    ).copyWith(color: muted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (onTap != null)
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.xs,
              color: muted,
              strokeWidth: 2.5,
            ),
          if (onClose != null) ...[
            const SizedBox(width: AppSpacing.xs),
            AppPressable(
              onTap: onClose,
              semanticsLabel: closeSemanticsLabel,
              semanticsButton: true,
              child: SizedBox(
                width: AppControlSize.iconTileCompact,
                height: AppControlSize.iconTileCompact,
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.close,
                    size: AppIconSize.xs,
                    color: muted,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: title,
      semanticsButton: true,
      child: card,
    );
  }
}
