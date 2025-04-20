import 'package:university_app_server_api/src/data/lost_and_found/models/models.dart';

/// {@template lost_and_found_data_source}
/// An abstract class that defines the contract for a lost and found data source.
/// {@endtemplate}
abstract class LostAndFoundDataSource {
  /// {@macro lost_and_found_data_source}
  const LostAndFoundDataSource();

  /// Gets a list of lost and found items.
  Future<List<LostFoundItem>> getItems({int? limit, int? offset, LostFoundItemStatus? status});

  /// Gets a specific lost and found item by ID.
  Future<LostFoundItem?> getItemById(String id);

  /// Creates a new lost and found item.
  Future<LostFoundItem> createItem(LostFoundItem item);

  /// Updates an existing lost and found item.
  Future<LostFoundItem> updateItem(String id, LostFoundItem item);

  /// Deletes a lost and found item by ID.
  Future<void> deleteItem(String id);

  /// Searches for lost and found items based on a query string.
  Future<List<LostFoundItem>> searchItems({
    required String query,
    int? limit,
    int? offset,
    LostFoundItemStatus? status,
  });

  /// Gets lost and found items by author ID.
  Future<List<LostFoundItem>> getItemsByAuthor({
    required String authorId,
    int? limit,
    int? offset,
    LostFoundItemStatus? status,
  });
}
