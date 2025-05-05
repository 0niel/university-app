import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:university_app_server_api/client.dart';

/// {@template lost_found_failure}
/// Base failure class for the lost and found feature.
/// {@endtemplate}
abstract class LostFoundFailure with EquatableMixin implements Exception {
  /// {@macro lost_found_failure}
  const LostFoundFailure(this.error);

  /// The error encountered.
  final Object error;

  @override
  List<Object?> get props => [error];
}

class CreateLostFoundItemFailure extends LostFoundFailure {
  const CreateLostFoundItemFailure(super.error);
}

class UpdateLostFoundItemFailure extends LostFoundFailure {
  const UpdateLostFoundItemFailure(super.error);
}

class DeleteLostFoundItemFailure extends LostFoundFailure {
  const DeleteLostFoundItemFailure(super.error);
}

class GetLostFoundItemsFailure extends LostFoundFailure {
  const GetLostFoundItemsFailure(super.error);
}

class SearchLostFoundItemsFailure extends LostFoundFailure {
  const SearchLostFoundItemsFailure(super.error);
}

class GetLostFoundItemFailure extends LostFoundFailure {
  const GetLostFoundItemFailure(super.error);
}

/// {@template lost_and_found_repository}
/// A repository that manages lost and found items.
/// Allows creating, updating, deleting, and querying lost and found items.
/// {@endtemplate}
class LostFoundRepository {
  /// {@macro lost_and_found_repository}
  const LostFoundRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Creates a new lost and found item.
  ///
  /// [authorId]: ID of the user creating the item
  /// [authorEmail]: Email of the user creating the item
  /// [title]: The name/title of the item.
  /// [description]: Additional details.
  /// [telegram]: Telegram contact info.
  /// [phoneNumber]: Phone number contact info.
  /// [status]: The status of the item.
  /// [images]: A list of image files.
  ///
  /// Returns the created LostFoundItem.
  /// Throws a [CreateLostFoundItemFailure] if any error occurs.
  Future<LostFoundItem> createItem({
    required String authorId,
    required String authorEmail,
    required String title,
    required LostFoundItemStatus status,
    List<File>? images,
    String? description,
    String? telegram,
    String? phoneNumber,
  }) async {
    try {
      final item = LostFoundItem(
        authorId: authorId,
        authorEmail: authorEmail,
        itemName: title,
        status: status,
        description: description,
        telegramContactInfo: telegram,
        phoneNumberContactInfo: phoneNumber,
        images: images != null ? [] : null, // Placeholder for uploaded images
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await _apiClient.createLostFoundItem(item: item);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        CreateLostFoundItemFailure(error),
        stackTrace,
      );
    }
  }

  /// Updates an existing lost and found item.
  ///
  /// [item]: The updated item data.
  ///
  /// Returns the updated LostFoundItem.
  /// Throws an [UpdateLostFoundItemFailure] if any error occurs.
  Future<LostFoundItem> updateItem({
    required LostFoundItem item,
  }) async {
    try {
      final itemId = item.id;
      if (itemId == null) {
        throw ArgumentError('Item ID cannot be null when updating an item');
      }

      return await _apiClient.updateLostFoundItem(
        itemId: itemId,
        item: item,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UpdateLostFoundItemFailure(error),
        stackTrace,
      );
    }
  }

  /// Updates only the status of an existing lost and found item.
  ///
  /// This is a more efficient alternative to the full update when
  /// only the status needs to be changed.
  ///
  /// [itemId]: ID of the item to update.
  /// [newStatus]: The new status to set.
  ///
  /// Returns the updated LostFoundItem.
  /// Throws an [UpdateLostFoundItemFailure] if any error occurs.
  Future<LostFoundItem> updateItemStatus({
    required String itemId,
    required LostFoundItemStatus newStatus,
  }) async {
    try {
      return await _apiClient.updateLostFoundItemStatus(
        itemId: itemId,
        status: newStatus,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UpdateLostFoundItemFailure(error),
        stackTrace,
      );
    }
  }

  /// Deletes a lost and found item.
  ///
  /// [itemId]: The ID of the item to delete.
  ///
  /// Throws a [DeleteLostFoundItemFailure] if any error occurs.
  Future<void> deleteItem({
    required String itemId,
  }) async {
    try {
      await _apiClient.deleteLostFoundItem(itemId: itemId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        DeleteLostFoundItemFailure(error),
        stackTrace,
      );
    }
  }

  /// Retrieves a list of lost and found items.
  ///
  /// [status]: Optionally filter items by status.
  /// [limit]: Maximum number of items to return.
  /// [offset]: The starting index for pagination.
  ///
  /// Returns a list of LostFoundItems.
  /// Throws a [GetLostFoundItemsFailure] if any error occurs.
  Future<List<LostFoundItem>> getItems({
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.getLostFoundItems(
        status: status,
        limit: limit,
        offset: offset,
      );
      return response.items;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetLostFoundItemsFailure(error),
        stackTrace,
      );
    }
  }

  /// Gets a specific lost and found item by ID.
  ///
  /// [itemId]: The unique identifier of the item to retrieve.
  ///
  /// Returns the LostFoundItem if found.
  /// Throws a [GetLostFoundItemFailure] if any error occurs.
  Future<LostFoundItem> getItemById({
    required String itemId,
  }) async {
    try {
      return await _apiClient.getLostFoundItem(itemId: itemId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetLostFoundItemFailure(error),
        stackTrace,
      );
    }
  }

  /// Searches for lost and found items based on a query string.
  ///
  /// [query]: The search query to match against item names and descriptions.
  /// [status]: Optionally filter items by status.
  /// [limit]: Maximum number of items to return.
  /// [offset]: The starting index for pagination.
  ///
  /// Returns a list of matching LostFoundItems.
  /// Throws a [SearchLostFoundItemsFailure] if any error occurs.
  Future<List<LostFoundItem>> searchItems({
    required String query,
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.searchLostFoundItems(
        query: query,
        status: status,
        limit: limit,
        offset: offset,
      );
      return response.items;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SearchLostFoundItemsFailure(error),
        stackTrace,
      );
    }
  }

  /// Retrieves items from a specific user.
  ///
  /// [authorId]: The ID of the author whose items to fetch.
  /// [status]: Optionally filter items by status.
  /// [limit]: Maximum number of items to return.
  /// [offset]: The starting index for pagination.
  ///
  /// Returns a list of LostFoundItems.
  /// Throws a [GetLostFoundItemsFailure] if any error occurs.
  Future<List<LostFoundItem>> getUserItems({
    required String authorId,
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.getUserLostFoundItems(
        authorId: authorId,
        status: status,
        limit: limit,
        offset: offset,
      );
      return response.items;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetLostFoundItemsFailure(error),
        stackTrace,
      );
    }
  }

  /// Gets the count of total items matching criteria.
  ///
  /// [status]: Optionally filter by status.
  /// [authorId]: Optionally filter by author ID.
  /// [searchQuery]: Optionally filter by search query.
  ///
  /// Returns the count of matching items.
  /// Throws a [GetLostFoundItemsFailure] if any error occurs.
  Future<int> getItemsCount({
    LostFoundItemStatus? status,
    String? authorId,
    String? searchQuery,
  }) async {
    try {
      return await _apiClient.getLostFoundItemsCount(
        status: status,
        authorId: authorId,
        searchQuery: searchQuery,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetLostFoundItemsFailure(error),
        stackTrace,
      );
    }
  }
}
