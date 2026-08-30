import 'dart:developer';

import 'package:lost_and_found_repository/src/failures/failures.dart';
import 'package:lost_and_found_repository/src/models/models.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

class LostFoundRepository {
  LostFoundRepository({
    required SupabaseClient supabase,
    required this.organizationId,
    DateTime Function()? now,
    String? Function()? userId,
    String Function()? id,
  }) : _supabase = supabase,
       _nowBuilder = now ?? DateTime.now,
       _userIdBuilder = userId ?? (() => supabase.auth.currentUser?.id),
       _idBuilder = id ?? const Uuid().v4;

  static const String _imagesBucket = 'lost-found-images';
  static const int _signedUrlLifetime = 3600;
  static const int _maxImages = 5;
  static const int _maxImageBytes = 8 * 1024 * 1024;
  static final RegExp _uuidPattern = RegExp(
    '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-'
    r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  final SupabaseClient _supabase;
  final String organizationId;
  final DateTime Function() _nowBuilder;
  final String? Function() _userIdBuilder;
  final String Function() _idBuilder;

  Future<List<LostFoundItem>> _fetch({
    LostFoundItemStatus? status,
    String? query,
    String? authorId,
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_lost_found_items',
      params: {
        'p_organization_id': organizationId,
        'p_status': status?.name,
        'p_query': query,
        'p_author_id': authorId,
        'p_limit': limit,
        'p_offset': offset,
      },
    );
    final rows = _jsonList(response, operation: 'get_lost_found_items');
    final items = [
      for (final row in rows) LostFoundItem.fromJson(_jsonMap(row)),
    ];
    return _signImages(items);
  }

  Future<LostFoundItem> createItem({
    required String title,
    required LostFoundItemStatus status,
    required String category,
    String description = '',
    String telegram = '',
    String phoneNumber = '',
    String location = '',
    bool showContact = false,
    List<LostFoundImageUpload> images = const [],
  }) async {
    final userId = _userIdBuilder();
    if (userId == null) {
      throw const CreateLostFoundItemFailure('Unauthenticated user');
    }
    final clientId = _idBuilder();
    final uploads = _prepareUploads(userId: userId, images: images);
    final paths = [for (final upload in uploads) upload.$1];
    try {
      await _reserveUploads(paths);
      await _uploadImages(uploads);
      final response = await _supabase.rpc<Object?>(
        'create_lost_found_item',
        params: {
          'p_organization_id': organizationId,
          'p_item_name': title.trim(),
          'p_status': status.name,
          'p_description': description.trim(),
          'p_telegram': telegram.trim(),
          'p_phone': phoneNumber.trim(),
          'p_author_email': '',
          'p_category': category.trim(),
          'p_location': location.trim(),
          'p_images': paths,
          'p_show_contact': showContact,
          'p_client_id': clientId,
        },
      );
      final id = _uuid(_jsonMap(response)['id'], operation: 'create item');
      if (id != clientId) {
        throw const FormatException('create item returned another id');
      }
      return await _hydrateCreatedItem(
        id: id,
        userId: userId,
        title: title,
        status: status,
        category: category,
        description: description,
        telegram: telegram,
        phoneNumber: phoneNumber,
        location: location,
        showContact: showContact,
        paths: paths,
      );
    } on Object catch (error, stackTrace) {
      final failedCleanup = await _compensateCreate(
        clientId: clientId,
        paths: paths,
      );
      final failure = CreateLostFoundItemFailure(
        error,
        cleanupPaths: failedCleanup,
      );
      Error.throwWithStackTrace(failure, stackTrace);
    }
  }

  List<(String, LostFoundImageUpload)> _prepareUploads({
    required String userId,
    required List<LostFoundImageUpload> images,
  }) {
    if (images.length > _maxImages) {
      throw const FormatException('At most 5 images are allowed');
    }
    return [
      for (final (index, image) in images.indexed)
        (
          '$userId/${_nowBuilder().microsecondsSinceEpoch}_$index.'
              '${_extensionFor(image.contentType)}',
          image,
        ),
    ];
  }

  Future<void> _reserveUploads(List<String> paths) async {
    if (paths.isEmpty) return;
    await _supabase.rpc<void>(
      'reserve_lost_found_image_uploads',
      params: {'p_organization_id': organizationId, 'p_paths': paths},
    );
  }

  Future<void> _uploadImages(
    List<(String, LostFoundImageUpload)> uploads,
  ) async {
    final storage = _supabase.storage.from(_imagesBucket);
    for (final (path, image) in uploads) {
      _validateImage(image);
      await storage.uploadBinary(
        path,
        image.bytes,
        fileOptions: FileOptions(contentType: image.contentType),
      );
    }
  }

  Future<LostFoundItem> _hydrateCreatedItem({
    required String id,
    required String userId,
    required String title,
    required LostFoundItemStatus status,
    required String category,
    required String description,
    required String telegram,
    required String phoneNumber,
    required String location,
    required bool showContact,
    required List<String> paths,
  }) async {
    try {
      return await getItemById(itemId: id);
    } on Object catch (error, stackTrace) {
      log(
        'Created lost and found item could not be hydrated',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return LostFoundItem(
        id: id,
        authorId: userId,
        itemName: title.trim(),
        description: description.trim(),
        status: status,
        telegramContactInfo: telegram.trim(),
        phoneNumberContactInfo: phoneNumber.trim(),
        category: category.trim(),
        location: location.trim(),
        imagePaths: paths,
        showContact: showContact,
        createdAt: _nowBuilder().toUtc(),
        isMine: true,
      );
    }
  }

  Future<List<String>> _compensateCreate({
    required String clientId,
    required List<String> paths,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'cancel_lost_found_item',
        params: {'p_id': clientId},
      );
      final failed = await _removeImages(paths);
      if (failed.isEmpty) await _ackCleanup(paths);
      await _releaseUploads(paths);
      return failed;
    } on Object catch (error, stackTrace) {
      log(
        'Could not reconcile a failed lost and found creation',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return List.unmodifiable(paths);
    }
  }

  void _validateImage(LostFoundImageUpload image) {
    if (image.bytes.isEmpty || image.bytes.length > _maxImageBytes) {
      throw const FormatException('Image size is invalid');
    }
    _extensionFor(image.contentType);
  }

  String _extensionFor(String contentType) => switch (contentType) {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    _ => throw FormatException('Unsupported image type: $contentType'),
  };

  Future<LostFoundItem> updateItem({required LostFoundItem item}) async {
    try {
      await _supabase.rpc<void>(
        'update_lost_found_item',
        params: {
          'p_id': item.id,
          'p_item_name': item.itemName,
          'p_description': item.description,
          'p_status': item.status.name,
          'p_telegram': item.telegramContactInfo,
          'p_phone': item.phoneNumberContactInfo,
          'p_category': item.category,
          'p_location': item.location,
        },
      );
      return await getItemById(itemId: item.id);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateLostFoundItemFailure(error), stackTrace);
    }
  }

  Future<void> updateItemStatus({
    required String itemId,
    required LostFoundItemStatus newStatus,
  }) async {
    try {
      await _supabase.rpc<void>(
        'update_lost_found_item',
        params: {'p_id': itemId, 'p_status': newStatus.name},
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateLostFoundItemFailure(error), stackTrace);
    }
  }

  Future<LostFoundDeleteResult> deleteItem({required String itemId}) async {
    try {
      final response = await _supabase.rpc<Object?>(
        'delete_lost_found_item',
        params: {'p_id': itemId},
      );
      final paths = _jsonList(
        response,
        operation: 'delete_lost_found_item',
      ).whereType<String>().toList(growable: false);
      final failedCleanup = await _removeImages(paths);
      if (failedCleanup.isEmpty) await _ackCleanup(paths);
      return LostFoundDeleteResult(
        failedCleanupPaths: failedCleanup,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteLostFoundItemFailure(error), stackTrace);
    }
  }

  Future<List<String>> _removeImages(List<String> paths) async {
    if (paths.isEmpty) return const [];
    try {
      await _supabase.storage.from(_imagesBucket).remove(paths);
      return const [];
    } on Exception catch (error, stackTrace) {
      log(
        'Could not remove lost and found images',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return List.unmodifiable(paths);
    }
  }

  Future<void> _releaseUploads(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _supabase.rpc<void>(
        'release_lost_found_image_uploads',
        params: {'p_paths': paths},
      );
    } on Object catch (error, stackTrace) {
      log(
        'Could not release lost and found upload reservations',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _ackCleanup(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _supabase.rpc<void>(
        'ack_lost_found_image_cleanup',
        params: {'p_paths': paths},
      );
    } on Object catch (error, stackTrace) {
      log(
        'Could not acknowledge lost and found image cleanup',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _retryPendingCleanup() async {
    try {
      final response = await _supabase.rpc<Object?>(
        'get_lost_found_image_cleanup_paths',
      );
      final paths = _jsonList(
        response,
        operation: 'get_lost_found_image_cleanup_paths',
      ).whereType<String>().toList(growable: false);
      final failed = await _removeImages(paths);
      if (failed.isEmpty) await _ackCleanup(paths);
    } on Object catch (error, stackTrace) {
      log(
        'Could not retry lost and found image cleanup',
        name: 'LostFoundRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<LostFoundItem>> getItems({
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      await _retryPendingCleanup();
      return await _fetch(status: status, limit: limit, offset: offset);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetLostFoundItemsFailure(error), stackTrace);
    }
  }

  Future<LostFoundItem> getItemById({required String itemId}) async {
    try {
      final response = await _supabase.rpc<Object?>(
        'get_lost_found_item',
        params: {'p_id': itemId},
      );
      final item = LostFoundItem.fromJson(_jsonMap(response));
      final [signed] = await _signImages([item]);
      return signed;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetLostFoundItemFailure(error), stackTrace);
    }
  }

  Future<List<LostFoundItem>> searchItems({
    required String query,
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await _fetch(
        query: query,
        status: status,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SearchLostFoundItemsFailure(error), stackTrace);
    }
  }

  Future<List<LostFoundItem>> getUserItems({
    required String authorId,
    LostFoundItemStatus? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await _fetch(
        authorId: authorId,
        status: status,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetLostFoundItemsFailure(error), stackTrace);
    }
  }

  Future<int> getItemsCount({
    LostFoundItemStatus? status,
    String? authorId,
    String? searchQuery,
  }) async {
    try {
      final response = await _supabase.rpc<Object?>(
        'count_lost_found_items',
        params: {
          'p_organization_id': organizationId,
          'p_status': status?.name,
          'p_query': searchQuery,
          'p_author_id': authorId,
        },
      );
      if (response case final int count) return count;
      throw const FormatException('count_lost_found_items returned no integer');
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetLostFoundItemsFailure(error), stackTrace);
    }
  }

  Future<List<LostFoundItem>> _signImages(
    List<LostFoundItem> items,
  ) async {
    final paths = items.expand((item) => item.imagePaths).toSet().toList();
    if (paths.isEmpty) return items;
    final results = await _supabase.storage
        .from(_imagesBucket)
        .createSignedUrlsResult(paths, _signedUrlLifetime);
    final urls = <String, String>{
      for (final result in results)
        if (result is SignedUrlSuccess) result.path: result.signedUrl,
    };
    return [
      for (final item in items)
        item.copyWith(
          imageUrls: [
            for (final path in item.imagePaths) ?urls[path],
          ],
        ),
    ];
  }

  List<Object?> _jsonList(Object? value, {required String operation}) {
    if (value case final List<Object?> rows) return rows;
    throw FormatException('$operation returned no JSON array');
  }

  Map<String, Object?> _jsonMap(Object? value) {
    if (value case final Map<Object?, Object?> map) {
      return map.cast();
    }
    throw const FormatException('RPC returned no JSON object');
  }

  String _uuid(Object? value, {required String operation}) {
    if (value case final String id when _uuidPattern.hasMatch(id)) {
      return id;
    }
    throw FormatException('$operation returned an invalid id');
  }
}
