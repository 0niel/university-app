import 'dart:convert';
import 'dart:typed_data';

import 'package:campus_repository/campus_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

const _sellerId = '00000000-0000-4000-8000-000000000020';

void main() {
  test('getListings resolves public media urls and telegram handle', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/rest/v1/rpc/get_listings');
      return http.Response(
        jsonEncode([
          {
            'id': '123e4567-e89b-42d3-a456-426614174000',
            'title': 'Book',
            'price': 500,
            'showContact': true,
            'telegramHandle': 'seller_user',
            'media': [
              {'path': 'seller-1/a.jpg', 'kind': 'image'},
            ],
          },
        ]),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });

    final listings = await _repository(client).getListings();

    final [listing] = listings;
    expect(listing.telegramHandle, 'seller_user');
    expect(
      listing.media.single.url,
      'https://project.supabase.co/storage/v1/object/public/'
      'marketplace-media/seller-1/a.jpg',
    );
  });

  test('uses exact marketplace RPC contracts', () async {
    final calls = <(String, Map<String, Object?>)>[];
    final client = MockClient((request) async {
      final method = request.url.pathSegments.lastOrNull ?? '';
      if (request.url.path.startsWith('/rest/v1/rpc/')) {
        final body = Map<String, Object?>.from(jsonDecode(request.body) as Map);
        calls.add((method, body));
      } else {
        return http.Response('[]', 200, request: request);
      }
      final response = switch (method) {
        'get_listings' => jsonEncode(<Object?>[]),
        'create_listing_v2' => jsonEncode(
          '123e4567-e89b-42d3-a456-426614174001',
        ),
        'delete_listing' => jsonEncode(['seller-1/a.jpg']),
        'archive_listing' => jsonEncode(['seller-1/b.jpg']),
        'update_listing' => jsonEncode(['seller-1/c.jpg']),
        _ => 'null',
      };
      return http.Response(
        response,
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });
    final repository = _repository(client);

    await repository.getListings();
    final id = await repository.createListing(
      title: 'Book',
      price: 500,
      category: 'books',
      description: 'Clean',
      telegramContact: 'seller_user',
      showContact: true,
    );
    await repository.updateListing(
      id: '123e4567-e89b-42d3-a456-426614174000',
      title: 'Book',
      price: 0,
      category: 'books',
      description: 'Clean',
      isFree: true,
      media: const [],
      telegramContact: 'seller_user',
      showContact: true,
    );
    await repository.setListingSold(
      id: '123e4567-e89b-42d3-a456-426614174000',
      sold: true,
    );
    await repository.archiveListing('123e4567-e89b-42d3-a456-426614174000');
    await repository.deleteListing('123e4567-e89b-42d3-a456-426614174000');

    expect(id, '123e4567-e89b-42d3-a456-426614174001');
    expect(calls.map((call) => call.$1), [
      'get_listings',
      'create_listing_v2',
      'update_listing',
      'set_listing_sold',
      'archive_listing',
      'delete_listing',
    ]);
    expect(calls.elementAtOrNull(0)?.$2, {'p_organization_id': 'university'});
    expect(calls.elementAtOrNull(1)?.$2, {
      'p_organization_id': 'university',
      'p_title': 'Book',
      'p_price': 500,
      'p_category': 'books',
      'p_description': 'Clean',
      'p_is_free': false,
      'p_media': <Object?>[],
      'p_telegram_contact': 'seller_user',
      'p_show_contact': true,
    });
    expect(calls.elementAtOrNull(2)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
      'p_title': 'Book',
      'p_price': 0,
      'p_category': 'books',
      'p_description': 'Clean',
      'p_is_free': true,
      'p_media': <Object?>[],
      'p_telegram_contact': 'seller_user',
      'p_show_contact': true,
    });
    expect(calls.elementAtOrNull(3)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
      'p_sold': true,
    });
    expect(calls.elementAtOrNull(4)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
    });
    expect(calls.elementAtOrNull(5)?.$2, {
      'p_id': '123e4567-e89b-42d3-a456-426614174000',
    });
  });

  test(
    'createListing sends media items with kind, dimensions and duration',
    () async {
      Map<String, Object?>? body;
      final client = MockClient((request) async {
        body = (jsonDecode(request.body) as Map).cast();
        return http.Response(
          jsonEncode('123e4567-e89b-42d3-a456-426614174001'),
          200,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      });

      await _repository(client).createListing(
        title: 'Book',
        price: 500,
        telegramContact: 'seller_user',
        media: const [
          MarketMediaItem(
            path: 'seller-1/a.jpg',
            kind: MarketMediaKind.image,
            width: 800,
            height: 600,
          ),
          MarketMediaItem(
            path: 'seller-1/b.mp4',
            kind: MarketMediaKind.video,
            duration: 12,
          ),
        ],
      );

      expect(body?['p_media'], [
        {
          'path': 'seller-1/a.jpg',
          'kind': 'image',
          'width': 800,
          'height': 600,
          'duration': 0,
        },
        {
          'path': 'seller-1/b.mp4',
          'kind': 'video',
          'width': 0,
          'height': 0,
          'duration': 12,
        },
      ]);
    },
  );

  test('createListing rejects a malformed RPC id', () async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode('not-a-uuid'),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      ),
    );

    await expectLater(
      _repository(client).createListing(
        title: 'Book',
        price: 500,
        telegramContact: 'seller_user',
      ),
      throwsFormatException,
    );
  });

  test('deleteListing removes the returned media paths from storage', () async {
    var removedPath = '';
    final client = MockClient((request) async {
      final path = request.url.path;
      if (request.method == 'DELETE' && path.contains('/storage/v1/object/')) {
        removedPath = path;
        return http.Response('[]', 200, request: request);
      }
      expect(path, '/rest/v1/rpc/delete_listing');
      return http.Response(
        jsonEncode(['seller-1/a.jpg']),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    });

    await _repository(client).deleteListing('listing-1');

    expect(removedPath, '/storage/v1/object/marketplace-media');
  });

  test('uploadListingMedia stores bytes under the caller folder', () async {
    var uploadPath = '';
    final client = MockClient((request) async {
      if (request.method == 'POST' &&
          request.url.path.contains('/storage/v1/object/')) {
        uploadPath = request.url.path;
        return http.Response(
          jsonEncode({'Key': uploadPath}),
          200,
          request: request,
        );
      }
      return http.Response('null', 200, request: request);
    });
    final repository = await _signedInRepository(client);

    final path = await repository.uploadListingMedia(
      bytes: Uint8List.fromList(const [1, 2, 3]),
      contentType: 'image/jpeg',
      extension: 'jpg',
    );

    expect(path, startsWith('$_sellerId/'));
    expect(path, endsWith('.jpg'));
    expect(
      uploadPath,
      '/storage/v1/object/marketplace-media/$path',
    );
  });
}

CampusRepository _repository(http.Client client) => CampusRepository(
  supabase: SupabaseClient(
    'https://project.supabase.co',
    'key',
    httpClient: client,
  ),
  organizationId: 'university',
);

Future<CampusRepository> _signedInRepository(http.Client client) async {
  final supabase = SupabaseClient(
    'https://project.supabase.co',
    'key',
    httpClient: client,
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );
  addTearDown(supabase.dispose);
  await supabase.auth.setInitialSession(
    jsonEncode({
      'access_token': 'test-access-token',
      'token_type': 'bearer',
      'user': {'id': _sellerId},
    }),
  );
  return CampusRepository(supabase: supabase, organizationId: 'university');
}
