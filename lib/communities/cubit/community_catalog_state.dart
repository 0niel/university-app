part of 'community_catalog_cubit.dart';

@freezed
abstract class CommunityCatalogState with _$CommunityCatalogState {
  const factory CommunityCatalogState({
    @Default(CommunityCatalogStatus.initial) CommunityCatalogStatus status,
    CommunityCatalog? catalog,
    @Default(false) bool isRefreshing,
    String? selectedSectionKey,
    @Default('') String query,
  }) = _CommunityCatalogState;

  const CommunityCatalogState._();

  List<CommunityCatalogSection> get visibleSections {
    final normalizedQuery = query.trim().toLowerCase();
    return [
      for (final section
          in catalog?.sections ?? const <CommunityCatalogSection>[])
        if (selectedSectionKey == null || section.key == selectedSectionKey)
          section.copyWith(
            items: [
              for (final item in section.items)
                if (normalizedQuery.isEmpty ||
                    item.title.toLowerCase().contains(normalizedQuery) ||
                    item.description.toLowerCase().contains(normalizedQuery))
                  item,
            ],
          ),
    ].where((section) => section.items.isNotEmpty).toList();
  }

  List<CommunityCatalogEntry> get featured => [
    for (final section in visibleSections)
      ...section.items.where((item) => item.isFeatured),
  ]..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
}
