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
    final l10n = context.l10n;
    if (state.status == .loading &&
        state.apps.isEmpty &&
        state.myApps.isEmpty) {
      return const SliverToBoxAdapter(
        child: _CatalogSkeleton(key: ValueKey('catalog-loading')),
      );
    }
    if (state.status == .failure &&
        state.apps.isEmpty &&
        state.myApps.isEmpty) {
      return _state(
        context,
        NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(context.read<MiniAppsCatalogCubit>().load()),
        ),
      );
    }
    if (state.apps.isEmpty && state.myApps.isEmpty) {
      final filtered = state.query.isNotEmpty || state.category != null;
      return _state(
        context,
        NinjaEmptyState(
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
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.only(bottom: _CatalogLayout.bottomInset(context)),
      sliver: SliverMainAxisGroup(
        slivers: [
          if (state.recents.isNotEmpty &&
              state.query.isEmpty &&
              state.category == null)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _CatalogSectionLabel(title: l10n.miniAppsRecents),
                  _RecentMiniApps(apps: state.recents, onOpen: onOpen),
                  const SizedBox(height: AppSpacing.gap),
                ],
              ),
            ),
          if (state.myApps.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _CatalogSectionLabel(title: l10n.miniAppsMyApps),
            ),
            _cards(state.myApps, showStatus: true),
            SliverToBoxAdapter(
              child: _CatalogSectionLabel(title: l10n.miniAppsCatalogSection),
            ),
          ],
          _cards(state.apps),
          if (state.apps.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              sliver: SliverToBoxAdapter(
                child: NinjaEmptyState(
                  icon: const AppLineIconWidget(AppLineIcon.search),
                  title: l10n.miniAppsNothingFound,
                  message: l10n.miniAppsNothingFoundSubtitle,
                  actionLabel: l10n.resetFilter,
                  onAction: onResetFilters,
                  outlinedAction: true,
                ).animateEmptyState(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _state(BuildContext context, Widget child) => SliverPadding(
    padding: _CatalogLayout.statePadding(context),
    sliver: SliverToBoxAdapter(child: child.animateEmptyState()),
  );

  Widget _cards(List<MiniApp> apps, {bool showStatus = false}) =>
      SliverList.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return Padding(
            key: ValueKey('${showStatus ? 'owned' : 'catalog'}-${app.id}'),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.gap,
            ),
            child: MiniAppCard(
              app: app,
              showStatus: showStatus,
              onTap: () => onOpen(app),
              onLongPress: () => onActions(app),
            ).animateListItem(index: index),
          );
        },
      );
}
