part of 'mini_apps_catalog.dart';

class _CatalogFilters extends StatelessWidget {
  const _CatalogFilters({
    required this.state,
    required this.controller,
    required this.focusNode,
    required this.onQueryChanged,
    required this.onQuerySubmitted,
    required this.onCategoryChanged,
  });

  final MiniAppsCatalogState state;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onQuerySubmitted;
  final ValueChanged<MiniAppCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) => AppPinnedHeader(
    extendTopSafeArea: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppExpandingSection(
          expanded: state.isSearching,
          child: _MiniAppsSearchField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onQueryChanged,
            onSubmitted: onQuerySubmitted,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: _CategoryChips(
            category: state.category,
            onChanged: onCategoryChanged,
          ),
        ),
      ],
    ),
  );
}
