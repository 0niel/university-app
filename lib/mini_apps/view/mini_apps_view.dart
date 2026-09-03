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
    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: AppFab.extended(
        icon: AppLineIcon.plus,
        label: l10n.miniAppsCreate,
        onPressed: () => context.go('/services/apps/submit'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _MiniAppsAppBar(
              isModerator: state.isModerator,
              isSearching: state.isSearching,
              onSearchToggled: _toggleSearch,
            ),
            const SizedBox(height: AppSpacing.xlg),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.lg,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _MiniAppsHero(count: state.apps.length),
                    ),
                  ),
                ],
                body: Column(
                  children: [
                    if (state.isSearching)
                      _MiniAppsSearchField(controller: _searchController),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _CategoryChips(category: state.category),
                    Padding(
                      padding: const .fromLTRB(
                        AppSpacing.screen,
                        8,
                        AppSpacing.screen,
                        10,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: _MiniAppsSortButton(
                          label: _miniAppSortLabel(l10n, state.sort),
                          onPressed: () => unawaited(_openSort()),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _CatalogBody(
                        state: state,
                        onOpen: _openApp,
                        onActions: (app) => unawaited(_openActions(app)),
                        onCreate: () => context.go('/services/apps/submit'),
                        onResetFilters: _resetFilters,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
