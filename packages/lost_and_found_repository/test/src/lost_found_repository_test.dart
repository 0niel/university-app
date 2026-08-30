import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

void main() {
  const userId = '123e4567-e89b-42d3-a456-426614174000';
  const itemId = '123e4567-e89b-42d3-a456-426614174001';
  final now = DateTime.utc(2026, 7, 11);

  LostFoundRepository repository(
    http.Client client, {
    DateTime Function() clock = DateTime.now,
  }) => .new(
    supabase: SupabaseClient(
      'https://project.supabase.co',
      'key',
      httpClient: client,
    ),
    organizationId: 'university',
    now: clock,
    userId: () => userId,
    id: () => itemId,
  );

  http.Response jsonResponse(
    Object? value, {
    required http.BaseRequest request,
    int status = 200,
  }) => http.Response(
    jsonEncode(value),
    status,
    headers: {'content-type': 'application/json'},
    request: request,
  );

  Map<String, Object?> itemJson() => {
    'id': itemId,
    'authorId': userId,
    'authorName': 'Student U.',
    'itemName': 'Keys',
    'status': 'found',
    'createdAt': now.toIso8601String(),
    'isMine': true,
  };

  test('create uses the consent RPC contract and exact item lookup', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      if (request.url.path.endsWith('/rpc/create_lost_found_item')) {
        return jsonResponse({'id': itemId}, request: request);
      }
      if (request.url.path.endsWith('/rpc/get_lost_found_item')) {
        return jsonResponse(itemJson(), request: request);
      }
      return jsonResponse(
        {'message': 'unexpected'},
        request: request,
        status: 500,
      );
    });

    final item = await repository(client).createItem(
      title: ' Keys ',
      status: .found,
      category: 'keys',
      telegram: ' @student ',
      showContact: true,
    );

    expect(item.id, itemId);
    expect(requests, hasLength(2));
    final body = (jsonDecode(requests.firstOrNull?.body ?? '') as Map)
        .cast<String, Object?>();
    expect(body['p_organization_id'], 'university');
    expect(body['p_item_name'], 'Keys');
    expect(body['p_author_email'], '');
    expect(body['p_show_contact'], isTrue);
    expect(body['p_client_id'], itemId);
    expect(body['p_images'], <Object?>[]);
    final exactBody = (jsonDecode(requests.lastOrNull?.body ?? '') as Map)
        .cast<String, Object?>();
    expect(exactBody, {'p_id': itemId});
  });

  test('count uses the server count instead of truncating at 100', () async {
    final client = MockClient((request) async {
      expect(request.url.path, endsWith('/rpc/count_lost_found_items'));
      final body = (jsonDecode(request.body) as Map).cast<String, Object?>();
      expect(body['p_status'], 'lost');
      expect(body['p_query'], 'keys');
      return jsonResponse(321, request: request);
    });

    final count = await repository(client).getItemsCount(
      status: .lost,
      searchQuery: 'keys',
    );

    expect(count, 321);
  });

  test('cleans up the first upload when the next upload fails', () async {
    var uploads = 0;
    Map<String, Object?>? removalBody;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/rpc/reserve_lost_found_image_uploads') ||
          request.url.path.endsWith('/rpc/cancel_lost_found_item') ||
          request.url.path.endsWith('/rpc/ack_lost_found_image_cleanup') ||
          request.url.path.endsWith('/rpc/release_lost_found_image_uploads')) {
        return jsonResponse(null, request: request);
      }
      if (request.method == 'POST' &&
          request.url.path.contains('/storage/v1/object/lost-found-images/')) {
        uploads++;
        if (uploads == 1) {
          return jsonResponse({'Key': 'first'}, request: request);
        }
        return jsonResponse(
          {'message': 'upload failed'},
          request: request,
          status: 500,
        );
      }
      if (request.method == 'DELETE' &&
          request.url.path.endsWith('/storage/v1/object/lost-found-images')) {
        removalBody = (jsonDecode(request.body) as Map).cast<String, Object?>();
        return jsonResponse(<Object?>[], request: request);
      }
      return jsonResponse(
        {'message': 'RPC must not run'},
        request: request,
        status: 500,
      );
    });
    final image = LostFoundImageUpload(
      bytes: Uint8List.fromList([1, 2, 3]),
      contentType: 'image/jpeg',
    );

    await expectLater(
      repository(client, clock: () => now).createItem(
        title: 'Keys',
        status: .found,
        category: 'keys',
        images: [image, image],
      ),
      throwsA(isA<CreateLostFoundItemFailure>()),
    );
    expect(uploads, 2);
    expect(removalBody, isNotNull);
    expect(
      removalBody?['prefixes'],
      [
        '$userId/${now.microsecondsSinceEpoch}_0.jpg',
        '$userId/${now.microsecondsSinceEpoch}_1.jpg',
      ],
    );
  });

  test('keeps a committed item when exact hydration fails', () async {
    var storageDeletes = 0;
    var cancellations = 0;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/rpc/create_lost_found_item')) {
        return jsonResponse({'id': itemId}, request: request);
      }
      if (request.url.path.endsWith('/rpc/get_lost_found_item')) {
        return jsonResponse(
          {'message': 'temporary read failure'},
          request: request,
          status: 503,
        );
      }
      if (request.url.path.endsWith('/rpc/cancel_lost_found_item')) {
        cancellations++;
      }
      if (request.method == 'DELETE') storageDeletes++;
      return jsonResponse(null, request: request);
    });

    final item = await repository(client, clock: () => now).createItem(
      title: 'Keys',
      status: .found,
      category: 'keys',
    );

    expect(item.id, itemId);
    expect(item.itemName, 'Keys');
    expect(item.isMine, isTrue);
    expect(cancellations, 0);
    expect(storageDeletes, 0);
  });

  test('retains uploaded data when create compensation is ambiguous', () async {
    var storageDeletes = 0;
    var releases = 0;
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/rpc/reserve_lost_found_image_uploads')) {
        return jsonResponse(null, request: request);
      }
      if (request.url.path.contains('/storage/v1/object/lost-found-images/')) {
        return jsonResponse({'Key': 'uploaded'}, request: request);
      }
      if (request.url.path.endsWith('/rpc/create_lost_found_item') ||
          request.url.path.endsWith('/rpc/cancel_lost_found_item')) {
        return jsonResponse(
          {'message': 'network result unknown'},
          request: request,
          status: 503,
        );
      }
      if (request.url.path.endsWith('/rpc/release_lost_found_image_uploads')) {
        releases++;
      }
      if (request.method == 'DELETE') storageDeletes++;
      return jsonResponse(null, request: request);
    });
    final image = LostFoundImageUpload(
      bytes: Uint8List.fromList([1, 2, 3]),
      contentType: 'image/jpeg',
    );

    await expectLater(
      repository(client, clock: () => now).createItem(
        title: 'Keys',
        status: .found,
        category: 'keys',
        images: [image],
      ),
      throwsA(
        isA<CreateLostFoundItemFailure>().having(
          (failure) => failure.cleanupPaths,
          'retained paths',
          ['$userId/${now.microsecondsSinceEpoch}_0.jpg'],
        ),
      ),
    );
    expect(storageDeletes, 0);
    expect(releases, 0);
  });

  test('returns cleanup warning when deleted object removal fails', () async {
    const path = '$userId/100_0.jpg';
    final client = MockClient((request) async {
      if (request.url.path.endsWith('/rpc/delete_lost_found_item')) {
        return jsonResponse([path], request: request);
      }
      if (request.method == 'DELETE') {
        return jsonResponse(
          {'message': 'storage unavailable'},
          request: request,
          status: 500,
        );
      }
      return jsonResponse(
        {'message': 'unexpected'},
        request: request,
        status: 500,
      );
    });

    final result = await repository(client).deleteItem(itemId: itemId);

    expect(result.hasCleanupFailure, isTrue);
    expect(result.failedCleanupPaths, [path]);
  });

  test('rejects malformed create ids', () async {
    final client = MockClient(
      (request) async => jsonResponse(
        {'id': 'not-a-uuid'},
        request: request,
      ),
    );

    await expectLater(
      repository(client).createItem(
        title: 'Keys',
        status: .found,
        category: 'keys',
      ),
      throwsA(isA<CreateLostFoundItemFailure>()),
    );
  });

  test('retries queued cleanup before loading items', () async {
    const path = '$userId/100_0.jpg';
    final requests = <String>[];
    final client = MockClient((request) async {
      requests.add(request.url.path);
      if (request.url.path.endsWith(
        '/rpc/get_lost_found_image_cleanup_paths',
      )) {
        return jsonResponse([path], request: request);
      }
      if (request.method == 'DELETE') {
        return jsonResponse(<Object?>[], request: request);
      }
      if (request.url.path.endsWith('/rpc/ack_lost_found_image_cleanup')) {
        return jsonResponse(null, request: request);
      }
      if (request.url.path.endsWith('/rpc/get_lost_found_items')) {
        return jsonResponse(<Object?>[], request: request);
      }
      return jsonResponse(
        {'message': 'unexpected'},
        request: request,
        status: 500,
      );
    });

    expect(await repository(client).getItems(), isEmpty);
    expect(
      requests,
      containsAllInOrder([
        '/rest/v1/rpc/get_lost_found_image_cleanup_paths',
        '/storage/v1/object/lost-found-images',
        '/rest/v1/rpc/ack_lost_found_image_cleanup',
        '/rest/v1/rpc/get_lost_found_items',
      ]),
    );
  });
}
