import 'package:service_catalog_repository/src/models/service_catalog.dart';
import 'package:supabase/supabase.dart';

class ServiceCatalogClient {
  const ServiceCatalogClient(this._supabase);

  final SupabaseClient _supabase;

  Future<ServiceCatalog> getCatalog({
    required String organizationId,
    required String locale,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_organization_service_catalog',
      params: {
        'p_organization_id': organizationId,
        'p_locale': locale,
      },
    );
    if (response is! Map<Object?, Object?>) {
      throw const FormatException(
        'Service catalog RPC returned an invalid result',
      );
    }
    return ServiceCatalog.fromJson(response.cast());
  }
}
