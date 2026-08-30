import 'package:service_catalog_repository/src/client/service_catalog_client.dart';
import 'package:service_catalog_repository/src/models/service_catalog.dart';
import 'package:supabase/supabase.dart';

class ServiceCatalogRepository {
  factory ServiceCatalogRepository({
    required SupabaseClient supabase,
    required String organizationId,
  }) => ServiceCatalogRepository._(
    ServiceCatalogClient(supabase),
    organizationId,
  );

  const ServiceCatalogRepository._(this._client, this._organizationId);

  final ServiceCatalogClient _client;
  final String _organizationId;

  Future<ServiceCatalog> getCatalog({required String locale}) =>
      _client.getCatalog(organizationId: _organizationId, locale: locale);
}
