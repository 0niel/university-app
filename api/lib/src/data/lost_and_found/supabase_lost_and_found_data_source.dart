import 'package:equatable/equatable.dart';
import 'package:supabase/supabase.dart' as supabase;
import 'package:university_app_server_api/src/data/lost_and_found/lost_and_found_data_source.dart';
import 'package:university_app_server_api/src/data/lost_and_found/models/models.dart';

/// {@template lost_and_found_exception}
/// An exception that is thrown when there is an error
/// in the lost and found data source.
/// {@endtemplate}
class LostAndFoundException with EquatableMixin implements Exception {
  /// {@macro lost_and_found_exception}
  const LostAndFoundException(
    this.message, {
    required this.error,
  });

  /// The error message.
  final String message;

  /// The error encountered.
  final Object error;

  @override
  String toString() => 'LostAndFoundException: $message';

  @override
  List<Object?> get props => [message, error];
}

/// {@template supabase_lost_and_found_data_source}
/// A Supabase implementation of [LostAndFoundDataSource]
/// {@endtemplate}
class SupabaseLostAndFoundDataSource implements LostAndFoundDataSource {
  /// {@macro supabase_lost_and_found_data_source}
  SupabaseLostAndFoundDataSource({
    required supabase.SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final supabase.SupabaseClient _supabaseClient;
  static const _tableName = 'lost_and_found_items';

  @override
  Future<List<LostFoundItem>> getItems({int? limit, int? offset, LostFoundItemStatus? status}) async {
    try {
      final query = _supabaseClient.from(_tableName).select();

      final supabase.PostgrestFilterBuilder<List<Map<String, dynamic>>> filteredQuery;

      if (status != null) {
        filteredQuery = query.eq('status', status.toString().split('.').last);
      } else {
        filteredQuery = query;
      }

      final transformedQuery = filteredQuery.order('created_at', ascending: false);

      final paginatedQuery = (limit != null) ? transformedQuery.limit(limit) : transformedQuery;

      final finalQuery = (offset != null) ? paginatedQuery.range(offset, offset + (limit ?? 10) - 1) : paginatedQuery;

      final response = await finalQuery;

      return response.map(LostFoundItem.fromJson).toList();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to retrieve lost and found items: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<LostFoundItem?> getItemById(String id) async {
    try {
      final response = await _supabaseClient.from(_tableName).select().eq('id', id).single();

      return LostFoundItem.fromJson(response);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to retrieve lost and found item: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<LostFoundItem> createItem(LostFoundItem item) async {
    try {
      final response = await _supabaseClient.from(_tableName).insert(item.toJson()).select().single();

      return LostFoundItem.fromJson(response);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to create lost and found item: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<LostFoundItem> updateItem(String id, LostFoundItem item) async {
    try {
      final response = await _supabaseClient.from(_tableName).update(item.toJson()).eq('id', id).select().single();

      return LostFoundItem.fromJson(response);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to update lost and found item: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await _supabaseClient.from(_tableName).delete().eq('id', id);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to delete lost and found item: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<List<LostFoundItem>> searchItems({
    required String query,
    int? limit,
    int? offset,
    LostFoundItemStatus? status,
  }) async {
    try {
      final baseQuery = _supabaseClient.from(_tableName).select();

      final textSearchQuery = baseQuery.or('title.ilike.%$query%,description.ilike.%$query%,location.ilike.%$query%');

      final filteredQuery =
          status != null ? textSearchQuery.eq('status', status.toString().split('.').last) : textSearchQuery;

      final orderedQuery = filteredQuery.order('created_at', ascending: false);

      final paginatedQuery = (limit != null) ? orderedQuery.limit(limit) : orderedQuery;
      final finalQuery = (offset != null) ? paginatedQuery.range(offset, offset + (limit ?? 10) - 1) : paginatedQuery;

      final response = await finalQuery;

      return response.map(LostFoundItem.fromJson).toList();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to search lost and found items: $e', error: e),
        stackTrace,
      );
    }
  }

  @override
  Future<List<LostFoundItem>> getItemsByAuthor({
    required String authorId,
    int? limit,
    int? offset,
    LostFoundItemStatus? status,
  }) async {
    try {
      final authorQuery = _supabaseClient.from(_tableName).select().eq('author_id', authorId);

      final filteredQuery = status != null ? authorQuery.eq('status', status.toString().split('.').last) : authorQuery;

      final orderedQuery = filteredQuery.order('created_at', ascending: false);

      final paginatedQuery = (limit != null) ? orderedQuery.limit(limit) : orderedQuery;
      final finalQuery = (offset != null) ? paginatedQuery.range(offset, offset + (limit ?? 10) - 1) : paginatedQuery;

      final response = await finalQuery;

      return response.map(LostFoundItem.fromJson).toList();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        LostAndFoundException('Failed to retrieve items by author: $e', error: e),
        stackTrace,
      );
    }
  }
}
