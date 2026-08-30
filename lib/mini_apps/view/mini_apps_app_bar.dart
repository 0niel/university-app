part of 'mini_apps_page.dart';

class _MiniAppsAppBar extends StatelessWidget {
  const _MiniAppsAppBar({
    required this.isModerator,
    required this.isSearching,
    required this.onSearchToggled,
  });

  final bool isModerator;
  final bool isSearching;
  final VoidCallback onSearchToggled;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final compact = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: compact ? 64 : 68,
      backgroundColor: colors.canvas,
      surfaceTintColor: Colors.transparent,
      titleSpacing: NinjaMetrics.screenPadding,
      title: Text(
        l10n.miniAppsTitle,
        maxLines: 1,
        overflow: .ellipsis,
        style: (compact ? NinjaText.title : NinjaText.display).copyWith(
          color: colors.ink,
        ),
      ),
      actions: [
        if (isModerator) ...[
          NinjaIconButton(
            icon: const AppLineIconWidget(.shield, size: 20),
            tooltip: l10n.miniAppsModeration,
            onPressed: () => context.go('/services/apps/moderation'),
          ),
          const SizedBox(width: 8),
        ],
        NinjaIconButton(
          icon: const AppLineIconWidget(.search, size: 20),
          variant: isSearching ? .filled : .outline,
          tooltip: l10n.miniAppsSearch,
          onPressed: onSearchToggled,
        ),
        const SizedBox(width: NinjaMetrics.screenPadding),
      ],
    );
  }
}
