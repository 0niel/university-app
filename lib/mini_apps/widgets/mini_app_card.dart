import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card_info.dart';
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
    final colors = context.colors;
    final accent = MiniAppIconTile.resolveAccent(
      app.accentColor,
      fallback: colors.accent,
    );
    return AppPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      pressedScale: .985,
      haptics: true,
      child: AppGlassSurface(
        tone: app.isFeatured ? AppGlassTone.accent : AppGlassTone.subtle,
        tint: accent,
        borderRadius: AppRadius.card,
        padding: const EdgeInsets.all(14),
        child: Opacity(
          opacity: app.isHidden ? 0.55 : 1,
          child: Row(
            children: [
              ExcludeSemantics(
                child: MiniAppIconTile(
                  emoji: app.iconEmoji,
                  accent: accent,
                  size: 48,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MiniAppCardInfo(app: app, showStatus: showStatus),
              ),
              const SizedBox(width: AppSpacing.sm),
              ExcludeSemantics(
                child: AppLineIconWidget(
                  AppLineIcon.chevronR,
                  size: 18,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
