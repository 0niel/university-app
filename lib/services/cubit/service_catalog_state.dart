part of 'service_catalog_cubit.dart';

@freezed
abstract class ServiceCatalogState with _$ServiceCatalogState {
  const factory ServiceCatalogState({
    ServiceCatalog? catalog,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
  }) = _ServiceCatalogState;
}
