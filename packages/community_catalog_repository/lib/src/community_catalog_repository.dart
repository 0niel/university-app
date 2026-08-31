import 'package:community_catalog_repository/src/client/community_catalog_client.dart';
import 'package:community_catalog_repository/src/models/community_catalog.dart';
import 'package:supabase/supabase.dart';

class CommunityCatalogRepository {
  factory CommunityCatalogRepository({
    required SupabaseClient supabase,
    required String organizationId,
  }) => CommunityCatalogRepository._(
    client: CommunityCatalogClient(supabase),
    organizationId: organizationId,
  );

  const CommunityCatalogRepository._({
    required this._client,
    required this._organizationId,
  });

  final CommunityCatalogClient _client;
  final String _organizationId;

  Future<CommunityCatalog> getCatalog({required String locale}) =>
      _client.getCatalog(organizationId: _organizationId, locale: locale);
}
