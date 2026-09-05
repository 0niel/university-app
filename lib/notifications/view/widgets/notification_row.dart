import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';

class NotificationRow extends StatelessWidget {
  const NotificationRow({
    required this.notification,
    required this.timeLabel,
    this.onTap,
    this.isUnread = true,
    super.key,
  });

  final AppNotification notification;
  final String timeLabel;
  final VoidCallback? onTap;
  final bool isUnread;

  static const double tileSize = 40;
  static const double verticalPadding = 13;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (tile, dot) = switch (notification.kind) {
      AppNotificationKind.warn => (colors.warnTint, colors.warn),
      AppNotificationKind.danger => (colors.examTint, colors.danger),
      AppNotificationKind.accent => (colors.tint, colors.accent),
      AppNotificationKind.lecture => (colors.lectureTint, colors.lecture),
      AppNotificationKind.muted => (colors.surface2, colors.muted),
    };
    final subtitle = notification.subtitle;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final time = Text(
      timeLabel,
      style: AppText.sans(11.5, FontWeight.w600).copyWith(color: colors.muted2),
    );

    return AppPressable(
      onTap: onTap,
      semanticsButton: true,
      semanticsLabel: [
        notification.title,
        ?subtitle,
        timeLabel,
      ].join(', '),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            AppIconTile(
              size: tileSize,
              radius: AppRadius.tile,
              background: isUnread ? tile : colors.surface2,
              child: AppDot(color: isUnread ? dot : colors.muted2),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppText.cell.copyWith(
                      color: isUnread ? colors.ink : colors.muted,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxs),
                      child: Text(
                        subtitle,
                        style: AppText.sans(
                          12.5,
                          FontWeight.w500,
                        ).copyWith(color: colors.muted),
                      ),
                    ),
                  if (largeText) ...[
                    const SizedBox(height: AppSpacing.xs),
                    time,
                  ],
                ],
              ),
            ),
            if (!largeText) ...[
              const SizedBox(width: AppSpacing.md),
              time,
            ],
          ],
        ),
      ),
    );
  }
}
