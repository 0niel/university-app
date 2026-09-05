part of 'mini_apps_page.dart';

class MiniAppsView extends StatefulWidget {
  const MiniAppsView({super.key});

  @override
  State<MiniAppsView> createState() => _MiniAppsViewState();
}

class _MiniAppsViewState extends State<MiniAppsView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final cubit = context.read<MiniAppsCatalogCubit>();
    if (cubit.state.isSearching) _searchController.clear();
    unawaited(cubit.searchToggled());
  }

  void _openApp(MiniApp app) {
    context.go('/services/apps/${app.slug}/run');
  }

  void _resetFilters() {
    final cubit = context.read<MiniAppsCatalogCubit>();
    _searchController.clear();
    unawaited(cubit.queryChanged(''));
    unawaited(cubit.categoryChanged(null));
  }

  Future<void> _openActions(MiniApp app) async {
    final cubit = context.read<MiniAppsCatalogCubit>();
    await showAppSheet<void>(
      context,
      title: app.name,
      child: BlocProvider.value(
        value: cubit,
        child: _AppActionsSheet(app: app),
      ),
    );
  }

  Future<void> _openSort() async {
    final cubit = context.read<MiniAppsCatalogCubit>();
    final selected = await showAppSheet<MiniAppSort>(
      context,
      title: context.l10n.miniAppsSortTitle,
      backgroundColor: context.colors.canvas,
      contentPadding: EdgeInsets.zero,
      child: _MiniAppsSortSheet(selected: cubit.state.sort),
    );
    if (!mounted || selected == null || selected == cubit.state.sort) return;
    await cubit.sortChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<MiniAppsCatalogCubit>().state;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final searchField = state.isSearching
        ? Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _MiniAppsSearchField(controller: _searchController),
          )
        : const SizedBox.shrink();
    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: AppFab(
        icon: AppLineIcon.plus,
        tooltip: l10n.miniAppsCreate,
        onPressed: () => context.go('/services/apps/submit'),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: RefreshIndicator(
          color: colors.accent,
          backgroundColor: colors.surface,
          onRefresh: () => context.read<MiniAppsCatalogCubit>().load(),
          child: CustomScrollView(
            key: const PageStorageKey('mini-apps-catalog'),
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: _MiniAppsAppBar(
                  isModerator: state.isModerator,
                  isSearching: state.isSearching,
                  onSearchToggled: _toggleSearch,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(
                  child: _MiniAppsHero(count: state.apps.length),
                ),
              ),
              SliverToBoxAdapter(
                child: reduceMotion
                    ? searchField
                    : AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topCenter,
                        child: searchField,
                      ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(child: _CategoryChips(category: state.category)),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.sm,
                          right: AppSpacing.screen,
                        ),
                        child: _MiniAppsSortButton(
                          label: _miniAppSortLabel(l10n, state.sort),
                          onPressed: () => unawaited(_openSort()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _CatalogBody(
                state: state,
                onOpen: _openApp,
                onActions: (app) => unawaited(_openActions(app)),
                onCreate: () => context.go('/services/apps/submit'),
                onResetFilters: _resetFilters,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
