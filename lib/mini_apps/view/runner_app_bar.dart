part of 'mini_app_runner_page.dart';

class _RunnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _RunnerAppBar({required this.title, required this.onBack, this.onMenu});

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onMenu;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const .fromLTRB(16, 8, 12, 8),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: context.l10n.back,
                child: AppPressable(
                  onTap: onBack,
                  child: SizedBox.square(
                    dimension: NinjaMetrics.minTouchTarget,
                    child: Center(
                      child: NinjaGlyphIcon(
                        NinjaGlyph.arrowLeft,
                        size: 20,
                        color: colors.ink,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
              ),
              if (onMenu != null)
                NinjaIconButton(
                  icon: const AppLineIconWidget(.more, size: 20),
                  tooltip: context.l10n.miniAppsAbout,
                  onPressed: onMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
