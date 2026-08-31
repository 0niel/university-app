part of 'mini_apps_page.dart';

class _MiniAppsSortButton extends StatelessWidget {
  const _MiniAppsSortButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: '${l10n.miniAppsSortTitle}: $label',
      child: AppPressable(
        key: const ValueKey('mini-apps-sort-button'),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: NinjaMetrics.minTouchTarget,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppLineIconWidget(.filter, size: 16, color: colors.brandInk),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NinjaText.buttonSmall.copyWith(
                      color: colors.brandInk,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                AppLineIconWidget(.chevronD, size: 14, color: colors.brandInk),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
