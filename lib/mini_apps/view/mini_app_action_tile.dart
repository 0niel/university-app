part of 'mini_apps_page.dart';

class _MiniAppActionTile extends StatelessWidget {
  const _MiniAppActionTile({
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .only(bottom: 10),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: title,
        semanticsButton: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NinjaMetrics.minTouchTarget,
            ),
            child: Padding(
              padding: const .symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: NinjaText.body.copyWith(
                        color: onTap == null
                            ? colors.disabled
                            : (titleColor ?? colors.ink),
                      ),
                    ),
                  ),
                  AppLineIconWidget(
                    .chevronR,
                    size: 16,
                    color: colors.chevron,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
