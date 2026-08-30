import 'package:supabase/supabase.dart';

/// Reads organization-scoped news data from a remote source.
abstract interface class NewsRemoteDataSource {
  /// Fetches a page of feed rows and their page metadata.
  Future<Object?> fetchFeed({
    required String organizationId,
    required String category,
    required int limit,
    required int offset,
  });

  /// Fetches the active sources exposed as feed categories.
  Future<Object?> fetchCategories({required String organizationId});
}

/// Supabase RPC implementation of [NewsRemoteDataSource].
final class SupabaseNewsRemoteDataSource implements NewsRemoteDataSource {
  /// Creates a data source backed by [SupabaseClient].
  const SupabaseNewsRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<Object?> fetchFeed({
    required String organizationId,
    required String category,
    required int limit,
    required int offset,
  }) {
    return _supabase.rpc<Object?>(
      'get_news_feed',
      params: {
        'p_organization_id': organizationId,
        'p_category': category,
        'p_limit': limit,
        'p_offset': offset,
      },
    );
  }

  @override
  Future<Object?> fetchCategories({required String organizationId}) {
    return _supabase.rpc<Object?>(
      'get_news_categories',
      params: {'p_organization_id': organizationId},
    );
  }
}
