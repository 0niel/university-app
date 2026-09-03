import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppCardMeta extends StatelessWidget {
  const MiniAppCardMeta({required this.app, super.key});

  final MiniApp app;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .end,
      spacing: 4,
      children: [
        if (app.ratingCount > 0)
          Row(
            mainAxisSize: .min,
            spacing: 3,
            children: [
              AppLineIconWidget(.star, size: 13, color: colors.accent),
              Text(
                app.ratingAvg.toStringAsFixed(1),
                style: AppText.tabular(
                  AppText.subtext.copyWith(
                    color: colors.ink,
                    fontWeight: .w700,
                  ),
                ),
              ),
            ],
          ),
        Text(
          l10n.miniAppsLaunches(app.launchCount),
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
