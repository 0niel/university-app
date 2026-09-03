import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_status_pill.dart';

class MiniAppCardInfo extends StatelessWidget {
  const MiniAppCardInfo({
    required this.app,
    required this.showStatus,
    super.key,
  });

  final MiniApp app;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            if (app.isFeatured) ...[
              AppLineIconWidget(
                .star,
                size: AppIconSize.xs,
                color: colors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                app.name,
                maxLines: 1,
                overflow: .ellipsis,
                style: AppText.headline.copyWith(color: colors.ink),
              ),
            ),
            if (showStatus) ...[
              const SizedBox(width: AppSpacing.sm),
              MiniAppStatusPill(status: app.status),
            ],
          ],
        ),
        if (app.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            app.description,
            maxLines: 2,
            overflow: .ellipsis,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}
