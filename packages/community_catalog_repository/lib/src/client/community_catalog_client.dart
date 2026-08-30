import 'package:community_catalog_repository/src/models/community_catalog.dart';
import 'package:supabase/supabase.dart';

class CommunityCatalogClient {
  const CommunityCatalogClient(this._supabase);

  final SupabaseClient _supabase;

  Future<CommunityCatalog> getCatalog({
    required String organizationId,
    required String locale,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_organization_community_catalog',
      params: {
        'p_organization_id': organizationId,
        'p_locale': locale,
      },
    );
    if (response is! Map<Object?, Object?>) {
      throw const FormatException(
        'Community catalog RPC returned an invalid result',
      );
    }
    return CommunityCatalog.fromJson(response.cast());
  }
}
