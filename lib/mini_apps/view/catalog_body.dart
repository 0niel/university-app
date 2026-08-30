part of 'mini_apps_page.dart';

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.state,
    required this.onOpen,
    required this.onActions,
    required this.onCreate,
    required this.onResetFilters,
  });

  final MiniAppsCatalogState state;
  final void Function(MiniApp app) onOpen;
  final void Function(MiniApp app) onActions;
  final VoidCallback onCreate;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    if (state.status == .loading && state.apps.isEmpty) {
      return const _CatalogSkeleton(key: ValueKey('catalog-loading'));
    }
    if (state.status == .failure && state.apps.isEmpty) {
      return Padding(
        key: const ValueKey('catalog-failure'),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(
            context.read<MiniAppsCatalogCubit>().load(),
          ),
        ).animateEmptyState(),
      );
    }
    if (state.apps.isEmpty && state.myApps.isEmpty) {
      return Padding(
        key: const ValueKey('catalog-empty'),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.grid),
          title: l10n.miniAppsEmptyTitle,
          message: l10n.miniAppsEmptySubtitle,
          actionLabel: l10n.miniAppsCreate,
          onAction: onCreate,
        ).animateEmptyState(),
      );
    }
    return RefreshIndicator(
      key: const ValueKey('catalog-ready'),
      color: colors.brand,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<MiniAppsCatalogCubit>().load(),
      child: ListView(
        padding: const .only(bottom: 120),
        children: [
          if (state.recents.isNotEmpty) ...[
            _CatalogSectionLabel(title: l10n.miniAppsRecents),
            _RecentMiniApps(
              apps: state.recents,
              onOpen: onOpen,
            ),
            const SizedBox(height: 10),
          ],
          if (state.myApps.isNotEmpty) ...[
            _CatalogSectionLabel(title: l10n.miniAppsMyApps),
            for (final (index, app) in state.myApps.indexed)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  0,
                  NinjaMetrics.screenPadding,
                  10,
                ),
                child: MiniAppCard(
                  app: app,
                  showStatus: true,
                  onTap: () => onOpen(app),
                  onLongPress: () => onActions(app),
                ).animateListItem(index: index),
              ),
            _CatalogSectionLabel(title: l10n.miniAppsCatalogSection),
          ],
          for (final (index, app) in state.apps.indexed)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                10,
              ),
              child: MiniAppCard(
                app: app,
                onTap: () => onOpen(app),
                onLongPress: () => onActions(app),
              ).animateListItem(index: index),
            ),
          if (state.apps.isEmpty)
            Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                16,
                NinjaMetrics.screenPadding,
                0,
              ),
              child: NinjaEmptyState(
                icon: const AppLineIconWidget(AppLineIcon.search),
                title: l10n.miniAppsNothingFound,
                message: l10n.miniAppsNothingFoundSubtitle,
                actionLabel: l10n.resetFilter,
                onAction: onResetFilters,
                outlinedAction: true,
              ).animateEmptyState(),
            ),
        ],
      ),
    );
  }
}
