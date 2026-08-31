import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card_info.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card_meta.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_icon_tile.dart';

export 'mini_app_card_skeleton.dart';
export 'mini_app_icon_tile.dart';
export 'mini_app_status_pill.dart';

class MiniAppCard extends StatelessWidget {
  const MiniAppCard({
    required this.app,
    required this.onTap,
    super.key,
    this.onLongPress,
    this.showStatus = false,
  });

  final MiniApp app;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final row = Semantics(
      button: true,
      enabled: !app.isHidden,
      label: app.name,
      child: Opacity(
        opacity: app.isHidden ? 0.55 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: AppPressable(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const .all(16),
              child: Row(
                children: [
                  MiniAppIconTile(
                    emoji: app.iconEmoji,
                    accent: colors.brand,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: MiniAppCardInfo(app: app, showStatus: showStatus),
                  ),
                  const SizedBox(width: 8),
                  MiniAppCardMeta(app: app),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return row;
  }
}
