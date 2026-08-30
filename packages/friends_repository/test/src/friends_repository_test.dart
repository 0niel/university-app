import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:network_location_client/network_location_client.dart';
import 'package:supabase/supabase.dart';

void main() {
  const accessPoints = [
    WifiAccessPointReading(bssid: '00:11:22:33:44:55', rssi: -50),
    WifiAccessPointReading(bssid: '00:11:22:33:44:66', rssi: -60),
  ];

  FriendsRepository repositoryFor(
    Object? response, {
    NetworkLocationClient? networkLocationClient,
    void Function(http.Request)? inspectRequest,
  }) {
    final client = MockClient((request) async {
      inspectRequest?.call(request);
      return http.Response.bytes(
        utf8.encode(jsonEncode(response)),
        200,
        request: request,
        headers: const {'content-type': 'application/json; charset=utf-8'},
      );
    });
    return FriendsRepository(
      supabase: SupabaseClient(
        'https://project.supabase.co',
        'key',
        httpClient: client,
      ),
      networkLocationClient: networkLocationClient,
    );
  }

  test('decodes a valid get_friends response', () async {
    final repository = repositoryFor([
      {
        'friendshipId': 'friendship-1',
        'userId': 'user-1',
        'fullName': 'Иван',
      },
    ]);

    final friends = await repository.getFriends();

    expect(friends, const [
      Friend(
        friendshipId: 'friendship-1',
        userId: 'user-1',
        fullName: 'Иван',
      ),
    ]);
  });

  test('rejects a non-list RPC response', () async {
    final repository = repositoryFor({'unexpected': true});

    await expectLater(
      repository.getFriends(),
      throwsA(
        isA<GetFriendsFailure>().having(
          (failure) => failure.error,
          'error',
          isA<FriendsResponseException>(),
        ),
      ),
    );
  });

  test('wraps a row missing its stable identifiers', () async {
    final repository = repositoryFor([
      {'fullName': 'Иван'},
    ]);

    await expectLater(
      repository.getFriends(),
      throwsA(
        isA<GetFriendsFailure>().having(
          (failure) => failure.error,
          'error',
          isA<FriendsResponseException>(),
        ),
      ),
    );
  });

  test('decodes the durable ghost-mode flag strictly', () async {
    expect(await repositoryFor(true).getGhostMode(), isTrue);
    await expectLater(
      repositoryFor('true').getGhostMode(),
      throwsA(
        isA<GetGhostModeFailure>().having(
          (failure) => failure.error,
          'error',
          isA<FriendsResponseException>(),
        ),
      ),
    );
  });

  test(
    'malformed wifi_resolve never falls back to an external service',
    () async {
      var externalRequests = 0;
      final networkClient = NetworkLocationClient(
        httpClient: MockClient((request) async {
          externalRequests++;
          return http.Response('{}', 200, request: request);
        }),
      );
      final repository = repositoryFor(
        {'latitude': 'invalid', 'longitude': 37},
        networkLocationClient: networkClient,
      );

      await expectLater(
        repository.resolveWifiPosition(accessPoints),
        throwsA(
          isA<ResolveWifiPositionFailure>().having(
            (failure) => failure.error,
            'error',
            isA<FriendsResponseException>(),
          ),
        ),
      );
      expect(externalRequests, 0);
      networkClient.close();
    },
  );

  test('literal null wifi_resolve uses the configured fallback', () async {
    var externalRequests = 0;
    final networkClient = NetworkLocationClient(
      httpClient: MockClient((request) async {
        externalRequests++;
        return http.Response(
          jsonEncode({
            'location': {'lat': 55.75, 'lng': 37.61},
            'accuracy': 100,
          }),
          200,
          request: request,
        );
      }),
    );
    final repository = repositoryFor(
      null,
      networkLocationClient: networkClient,
    );

    final result = await repository.resolveWifiPosition(accessPoints);

    expect(result?.latitude, 55.75);
    expect(externalRequests, 1);
    networkClient.close();
  });

  test(
    'register and unregister device send the expected RPC parameters',
    () async {
      final requests = <http.Request>[];
      final repository = repositoryFor(
        null,
        inspectRequest: requests.add,
      );

      await repository.registerDevice(token: 'token-1', platform: 'android');
      await repository.unregisterDevice('token-1');

      final [registerRequest, unregisterRequest] = requests;
      expect(registerRequest.url.path, endsWith('/rpc/register_device'));
      expect(jsonDecode(registerRequest.body), {
        'p_token': 'token-1',
        'p_platform': 'android',
      });
      expect(unregisterRequest.url.path, endsWith('/rpc/unregister_device'));
      expect(jsonDecode(unregisterRequest.body), {'p_token': 'token-1'});
    },
  );

  test('trims people search and exposes a typed failure', () async {
    http.Request? captured;
    final repository = repositoryFor(
      null,
      inspectRequest: (request) => captured = request,
    );

    await expectLater(
      repository.searchUsers('  Student  '),
      throwsA(isA<SearchFriendsFailure>()),
    );
    expect(jsonDecode(captured?.body ?? '{}'), {'p_query': 'Student'});
  });

  test('wraps friend mutation transport errors by operation', () async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode({'message': 'offline'}),
        503,
        request: request,
        headers: const {'content-type': 'application/json'},
      ),
    );
    final repository = FriendsRepository(
      supabase: SupabaseClient(
        'https://project.supabase.co',
        'key',
        httpClient: client,
      ),
    );

    await expectLater(
      repository.sendFriendRequest('user-2'),
      throwsA(isA<SendFriendRequestFailure>()),
    );
    repository.close();
  });
}
