part of 'debug_overlay.dart';

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onClose});

  final DebugAction action;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = action.subtitle;
    final accent = action.isDestructive ? colors.exam : colors.accent;
    return AppPressable(
      onTap: () {
        onClose();
        action.onTap(context);
      },
      child: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 12,
          children: [
            AppLineIconWidget(action.icon, color: accent, size: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    action.label,
                    style: AppText.body.copyWith(
                      color: action.isDestructive ? accent : colors.ink,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const .only(top: 2),
                      child: Text(
                        subtitle,
                        style: AppText.captionSmall.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 14,
              color: colors.muted2,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
