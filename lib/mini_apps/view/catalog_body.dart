part of 'mini_apps_catalog.dart';

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.state,
    required this.onOpen,
    required this.onActions,
    required this.onCreate,
    required this.onResetFilters,
    required this.onRetry,
  });

  final MiniAppsCatalogState state;
  final ValueChanged<MiniApp> onOpen;
  final ValueChanged<MiniApp> onActions;
  final VoidCallback onCreate;
  final VoidCallback onResetFilters;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final owned = state.visibleOwnedApps;
    final hasContent = state.apps.isNotEmpty || owned.isNotEmpty;
    final showRecents =
        state.showRecents && !_CatalogLayout.compactHeight(context);
    return SliverPadding(
      padding: EdgeInsets.only(bottom: _CatalogLayout.bottomInset(context)),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: AppStateSwitcher(
              child: hasContent
                  ? const SizedBox.shrink(key: ValueKey('catalog-content'))
                  : _statePanel(context),
            ),
          ),
          if (hasContent) ...[
            if (showRecents)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CatalogSectionLabel(title: l10n.miniAppsRecents),
                    _RecentMiniApps(apps: state.recents, onOpen: onOpen),
                  ],
                ),
              ),
            if (owned.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _CatalogSectionLabel(title: l10n.miniAppsMyApps),
              ),
              _cards(owned, showStatus: true),
            ],
            if (state.apps.isNotEmpty) ...[
              if (owned.isNotEmpty || showRecents)
                SliverToBoxAdapter(
                  child: _CatalogSectionLabel(
                    title: l10n.miniAppsCatalogSection,
                  ),
                )
              else
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.sm),
                ),
              _cards(state.apps),
            ],
          ],
        ],
      ),
    );
  }

  Widget _statePanel(BuildContext context) {
    final l10n = context.l10n;
    final panel = switch (state.status) {
      MiniAppsCatalogStatus.initial || MiniAppsCatalogStatus.loading =>
        const _CatalogSkeleton(key: ValueKey('catalog-loading')),
      MiniAppsCatalogStatus.failure => NinjaErrorState(
        key: const ValueKey('catalog-error'),
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      ),
      MiniAppsCatalogStatus.populated => NinjaEmptyState(
        key: ValueKey(
          state.hasFilters ? 'catalog-no-results' : 'catalog-empty',
        ),
        icon: AppLineIconWidget(
          state.hasFilters ? AppLineIcon.search : AppLineIcon.grid,
        ),
        title: state.hasFilters
            ? l10n.miniAppsNothingFound
            : l10n.miniAppsEmptyTitle,
        message: state.hasFilters
            ? l10n.miniAppsNothingFoundSubtitle
            : l10n.miniAppsEmptySubtitle,
        actionLabel: state.hasFilters ? l10n.resetFilter : l10n.miniAppsCreate,
        onAction: state.hasFilters ? onResetFilters : onCreate,
        outlinedAction: state.hasFilters,
      ),
    };
    if (panel is _CatalogSkeleton) return panel;
    return Padding(
      key: panel.key,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: panel,
    );
  }

  Widget _cards(List<MiniApp> apps, {bool showStatus = false}) {
    final prefix = showStatus ? 'owned' : 'catalog';
    final positions = {
      for (var index = 0; index < apps.length; index++)
        ValueKey('$prefix-${apps[index].id}'): index,
    };
    return SliverList.builder(
      itemCount: apps.length,
      findChildIndexCallback: (key) => positions[key],
      itemBuilder: (context, index) {
        final app = apps[index];
        return Padding(
          key: ValueKey('$prefix-${app.id}'),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.sm,
          ),
          child: AppReveal(
            index: index,
            child: MiniAppCard(
              app: app,
              showStatus: showStatus,
              onTap: () => onOpen(app),
              onLongPress: () => onActions(app),
            ),
          ),
        );
      },
    );
  }
}

abstract final class _CatalogLayout {
  static bool compactHeight(BuildContext context) =>
      MediaQuery.heightOf(context) < 500;

  static double bottomInset(BuildContext context) =>
      ninjaBottomInset(context) + AppSpacing.xxlg;
}
