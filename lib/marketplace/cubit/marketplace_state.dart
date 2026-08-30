part of 'marketplace_cubit.dart';

@freezed
abstract class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState({
    @Default(MarketplaceStatus.initial) MarketplaceStatus status,
    @Default(<MarketListing>[]) List<MarketListing> items,
    @Default('all') String filterKey,
    @Default(<String>{}) Set<String> pendingSoldIds,
    @Default(<String>{}) Set<String> pendingDeleteIds,
    @Default(false) bool isCreating,
  }) = _MarketplaceState;

  const MarketplaceState._();

  List<MarketListing> get filteredItems => [
    for (final item in items)
      if (filterKey == 'all' || item.category == filterKey) item,
  ];
}
