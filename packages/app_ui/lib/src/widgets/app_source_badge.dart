import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

enum SourceType { official, telegram, community, rss, vk, app }

enum SourceBadgeSize { sm, md }

class AppSourceBadge extends StatelessWidget {
  const AppSourceBadge({
    required this.type,
    required this.source,
    super.key,
    this.size = SourceBadgeSize.sm,
  });

  final SourceType type;
  final String source;
  final SourceBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = _toneOf(colors);
    final icon = _iconOf(type);
    final isMd = size == SourceBadgeSize.md;

    return Container(
      padding: isMd
          ? const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.gap,
              AppSpacing.xs,
            )
          : EdgeInsets.zero,
      decoration: isMd
          ? BoxDecoration(
              color: colors.tintOf(tone),
              borderRadius: BorderRadius.circular(AppRadius.full),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconTile(
            icon: icon,
            size: 22,
            radius: AppRadius.badge,
            background: tone,
            foreground: colors.onAccent,
            iconSize: AppIconSize.badge,
            strokeWidth: 2.2,
          ),
          const SizedBox(width: AppSpacing.xsm),
          Flexible(
            child: Text(
              source,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.captionStrong.copyWith(
                color: isMd ? tone : colors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _toneOf(AppColors c) => switch (type) {
        SourceType.official => c.accent,
        SourceType.telegram => c.practice,
        SourceType.community => c.lab,
        SourceType.rss => c.warn,
        SourceType.vk => c.accent,
        SourceType.app => c.lecture,
      };

  static AppLineIcon _iconOf(SourceType type) => switch (type) {
        SourceType.official => AppLineIcon.shield,
        SourceType.telegram => AppLineIcon.send,
        SourceType.community => AppLineIcon.people,
        SourceType.rss => AppLineIcon.globe,
        SourceType.vk => AppLineIcon.message,
        SourceType.app => AppLineIcon.spark,
      };
}
