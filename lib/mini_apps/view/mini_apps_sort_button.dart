part of 'mini_apps_page.dart';

class _MiniAppsSortButton extends StatelessWidget {
  const _MiniAppsSortButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: '${l10n.miniAppsSortTitle}: $label',
      child: AppPressable(
        key: const ValueKey('mini-apps-sort-button'),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppControlSize.touchTarget,
          ),
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.gap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLineIconWidget(
                  .filter,
                  size: AppIconSize.sm,
                  color: colors.accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.buttonSmall.copyWith(
                      color: colors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                AppLineIconWidget(
                  .chevronD,
                  size: AppIconSize.xs,
                  color: colors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
