part of 'mini_apps_page.dart';

class MiniAppsView extends StatelessWidget {
  const MiniAppsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MiniAppsCatalogCubit>();
    final state = context.watch<MiniAppsCatalogCubit>().state;
    return MiniAppsCatalog(
      state: state,
      onRefresh: cubit.load,
      onQueryChanged: (query) => unawaited(cubit.queryChanged(query)),
      onCategoryChanged: (category) =>
          unawaited(cubit.categoryChanged(category)),
      onSortChanged: (sort) => unawaited(cubit.sortChanged(sort)),
      onSearchToggled: () => unawaited(cubit.searchToggled()),
      onOpen: (app) => context.go('/services/apps/${app.slug}/run'),
      onActions: (app) => unawaited(_openActions(context, app)),
      onCreate: () => context.go('/services/apps/submit'),
      onResetFilters: () => unawaited(cubit.resetFilters()),
      onBack: Navigator.of(context).canPop()
          ? () => unawaited(Navigator.of(context).maybePop())
          : null,
      onModerate: () => context.go('/services/apps/moderation'),
    );
  }

  Future<void> _openActions(BuildContext context, MiniApp app) {
    final cubit = context.read<MiniAppsCatalogCubit>();
    return showAppSheet(
      context,
      title: app.name,
      child: BlocProvider.value(
        value: cubit,
        child: _AppActionsSheet(app: app),
      ),
    );
  }
}
