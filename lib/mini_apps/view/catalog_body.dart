part of 'mini_apps_page.dart';

abstract final class _CatalogLayout {
  static double bottomInset(BuildContext context) =>
      ninjaBottomInset(context) + AppControlSize.fab + AppSpacing.xxlg;

  static EdgeInsets statePadding(BuildContext context) => EdgeInsets.fromLTRB(
    AppSpacing.screen,
    AppSpacing.zero,
    AppSpacing.screen,
    bottomInset(context),
  );
}

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
    final colors = context.colors;
    final l10n = context.l10n;
    if (state.status == .loading && state.apps.isEmpty) {
      return const _CatalogSkeleton(key: ValueKey('catalog-loading'));
    }
    if (state.status == .failure && state.apps.isEmpty) {
      return SingleChildScrollView(
        key: const ValueKey('catalog-failure'),
        padding: _CatalogLayout.statePadding(context),
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
      final filtered = state.query.isNotEmpty || state.category != null;
      return SingleChildScrollView(
        key: const ValueKey('catalog-empty'),
        padding: _CatalogLayout.statePadding(context),
        child: NinjaEmptyState(
          icon: AppLineIconWidget(
            filtered ? AppLineIcon.search : AppLineIcon.grid,
          ),
          title: filtered ? l10n.miniAppsNothingFound : l10n.miniAppsEmptyTitle,
          message: filtered
              ? l10n.miniAppsNothingFoundSubtitle
              : l10n.miniAppsEmptySubtitle,
          actionLabel: filtered ? l10n.resetFilter : l10n.miniAppsCreate,
          onAction: filtered ? onResetFilters : onCreate,
          outlinedAction: filtered,
        ).animateEmptyState(),
      );
    }
    return RefreshIndicator(
      key: const ValueKey('catalog-ready'),
      color: colors.accent,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<MiniAppsCatalogCubit>().load(),
      child: ListView(
        padding: EdgeInsets.only(bottom: _CatalogLayout.bottomInset(context)),
        children: [
          if (state.recents.isNotEmpty) ...[
            _CatalogSectionLabel(title: l10n.miniAppsRecents),
            _RecentMiniApps(
              apps: state.recents,
              onOpen: onOpen,
            ),
            const SizedBox(height: AppSpacing.gap),
          ],
          if (state.myApps.isNotEmpty) ...[
            _CatalogSectionLabel(title: l10n.miniAppsMyApps),
            for (final (index, app) in state.myApps.indexed)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  AppSpacing.gap,
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
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.gap,
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
                AppSpacing.screen,
                16,
                AppSpacing.screen,
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
