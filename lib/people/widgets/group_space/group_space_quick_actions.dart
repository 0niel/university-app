import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class GroupSpaceQuickAction {
  const GroupSpaceQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final AppLineIcon icon;
  final String label;
  final VoidCallback onTap;
}

class GroupSpaceQuickActions extends StatelessWidget {
  const GroupSpaceQuickActions({required this.actions, super.key});

  final List<GroupSpaceQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Row(
        children: [
          for (final action in actions)
            Expanded(
              child: AppPressable(
                onTap: action.onTap,
                semanticsLabel: action.label,
                semanticsButton: true,
                child: Column(
                  children: [
                    AppIconTile(
                      icon: action.icon,
                      size: 48,
                      radius: AppRadius.banner,
                      background: colors.surface,
                      foreground: colors.ink,
                      iconSize: 21,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      action.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppText.captionSmall.copyWith(
                        color: colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
