import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';

import 'mock_friends_repository.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<WifiAccessPointReading>[]);
  });

  group('GeoSharingSettings', () {
    test('defaults to the safe options', () {
      const settings = GeoSharingSettings();
      expect(settings.sharing, isTrue);
      expect(settings.visibility, GeoVisibility.all);
      expect(settings.precision, GeoPrecision.exact);
    });

    test('fromJson(toJson()) round-trips and preserves the wire values', () {
      const settings = GeoSharingSettings(
        sharing: false,
        visibility: .none,
        precision: .campus,
      );
      final json = settings.toJson();
      expect(json['visibility'], 'none');
      expect(json['precision'], 'campus');
      expect(GeoSharingSettings.fromJson(json), equals(settings));
    });

    test('fromJson handles known, unknown and missing enum values', () {
      expect(
        GeoSharingSettings.fromJson(const {'visibility': 'none'}).visibility,
        GeoVisibility.none,
      );
      expect(
        GeoSharingSettings.fromJson(const {'visibility': 'unknown'}).visibility,
        GeoVisibility.all,
      );
      expect(
        GeoSharingSettings.fromJson(const {}).precision,
        GeoPrecision.exact,
      );
      expect(
        GeoSharingSettings.fromJson(const {'precision': 'city'}).precision,
        GeoPrecision.city,
      );
    });
  });

  group('FriendsMapCubit', () {
    late FriendsRepository repository;
    late PreferencesRepository preferences;
    late PermissionClient permissions;

    // МИРЭА, проспект Вернадского 78.
    const baseLat = 55.6699;
    const baseLng = 37.4803;

    Position devicePosition({
      double latitude = baseLat,
      double longitude = baseLng,
      int dtSeconds = 0,
    }) => .new(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime(2026, 6, 12, 12).add(Duration(seconds: dtSeconds)),
      accuracy: 15,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    setUp(() {
      repository = MockFriendsRepository();
      preferences = MockPreferencesRepository();
      permissions = MockPermissionClient();
      when(
        () => permissions.requestNearbyWifiDevices(),
      ).thenAnswer((_) async => PermissionStatus.granted);
      when(
        () => repository.publishLocation(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          accuracyM: any(named: 'accuracyM'),
          heading: any(named: 'heading'),
          speedMps: any(named: 'speedMps'),
        ),
      ).thenAnswer((_) => Future.value());
    });

    FriendsMapCubit buildCubit() => .new(
      repository: repository,
      preferencesRepository: preferences,
      permissionClient: permissions,
    );

    test('initial state is FriendsMapState()', () {
      expect(buildCubit().state, equals(const FriendsMapState()));
    });

    test('load stops quietly when the cubit closes during a request', () async {
      final friends = Completer<List<Friend>>();
      when(() => repository.getFriends()).thenAnswer((_) => friends.future);
      final cubit = buildCubit();

      final load = cubit.load();
      await pumpEventQueue();
      await cubit.close();
      friends.complete(const []);

      await expectLater(load, completes);
    });

    group('updateGeoSettings', () {
      blocTest<FriendsMapCubit, FriendsMapState>(
        'persists the settings and hides an existing server location',
        setUp: () {
          when(
            () => preferences.set(any(), any()),
          ).thenAnswer((_) => Future.value());
          when(
            () => repository.setGhostMode(ghost: true),
          ).thenAnswer((_) => Future.value());
        },
        build: buildCubit,
        act: (cubit) => cubit.updateGeoSettings(
          const GeoSharingSettings(visibility: .none),
        ),
        expect: () => const [
          FriendsMapState(privacyBusy: true),
          FriendsMapState(
            geoSettings: GeoSharingSettings(
              visibility: .none,
              privacyForcedGhost: true,
            ),
            isGhost: true,
            privacyBusy: true,
          ),
          FriendsMapState(
            geoSettings: GeoSharingSettings(
              visibility: .none,
              privacyForcedGhost: true,
            ),
            isGhost: true,
          ),
        ],
        verify: (_) {
          verify(() => preferences.set('geo_sharing', any())).called(1);
          verify(() => repository.setGhostMode(ghost: true)).called(1);
        },
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'fails closed and exposes a sync error when the server update fails',
        setUp: () {
          when(
            () => preferences.set(any(), any()),
          ).thenAnswer((_) => Future.value());
          when(
            () => repository.setGhostMode(ghost: true),
          ).thenThrow(Exception('network'));
        },
        build: buildCubit,
        act: (cubit) => cubit.updateGeoSettings(
          const GeoSharingSettings(visibility: .none),
        ),
        expect: () => const [
          FriendsMapState(privacyBusy: true),
          FriendsMapState(
            geoSettings: GeoSharingSettings(
              visibility: .none,
              privacyForcedGhost: true,
            ),
            isGhost: true,
            privacyBusy: true,
          ),
          FriendsMapState(
            geoSettings: GeoSharingSettings(
              visibility: .none,
              privacyForcedGhost: true,
            ),
            isGhost: true,
            privacySyncFailed: true,
          ),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'restores visibility when a privacy-forced ghost is re-enabled',
        setUp: () {
          when(
            () => preferences.set(any(), any()),
          ).thenAnswer((_) => Future.value());
          when(
            () => repository.setGhostMode(ghost: false),
          ).thenAnswer((_) => Future.value());
        },
        build: buildCubit,
        seed: () => const FriendsMapState(
          isGhost: true,
          geoSettings: GeoSharingSettings(
            sharing: false,
            privacyForcedGhost: true,
          ),
        ),
        act: (cubit) => cubit.updateGeoSettings(const GeoSharingSettings()),
        expect: () => const [
          FriendsMapState(
            isGhost: true,
            geoSettings: GeoSharingSettings(
              sharing: false,
              privacyForcedGhost: true,
            ),
            privacyBusy: true,
          ),
          FriendsMapState(privacyBusy: true),
          FriendsMapState(),
        ],
      );

      test('serializes concurrent privacy transitions', () async {
        final hidden = Completer<void>();
        when(
          () => preferences.set(any(), any()),
        ).thenAnswer((_) => Future.value());
        when(
          () => repository.setGhostMode(ghost: true),
        ).thenAnswer((_) => hidden.future);
        when(
          () => repository.setGhostMode(ghost: false),
        ).thenAnswer((_) => Future.value());
        final cubit = buildCubit();

        final hide = cubit.updateGeoSettings(
          const GeoSharingSettings(visibility: .none),
        );
        await pumpEventQueue();
        final show = cubit.updateGeoSettings(const GeoSharingSettings());
        hidden.complete();
        await Future.wait([hide, show]);

        expect(cubit.state, const FriendsMapState());
        verifyInOrder([
          () => repository.setGhostMode(ghost: true),
          () => repository.setGhostMode(ghost: false),
        ]);
        await cubit.close();
      });
    });

    group('toggleGhostMode', () {
      blocTest<FriendsMapCubit, FriendsMapState>(
        'cannot reveal a location while sharing is disabled',
        build: buildCubit,
        seed: () => const FriendsMapState(
          isGhost: true,
          geoSettings: GeoSharingSettings(sharing: false),
        ),
        act: (cubit) => cubit.toggleGhostMode(),
        expect: () => const <FriendsMapState>[],
        verify: (_) {
          verifyNever(
            () => repository.setGhostMode(ghost: any(named: 'ghost')),
          );
        },
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'emits isGhost=true when the repository succeeds',
        setUp: () => when(
          () => repository.setGhostMode(ghost: any(named: 'ghost')),
        ).thenAnswer((_) => Future.value()),
        build: buildCubit,
        act: (cubit) => cubit.toggleGhostMode(),
        expect: () => const [
          FriendsMapState(isGhost: true, privacyBusy: true),
          FriendsMapState(isGhost: true),
        ],
        verify: (_) {
          verify(() => repository.setGhostMode(ghost: true)).called(1);
        },
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'reverts isGhost when the repository throws',
        setUp: () => when(
          () => repository.setGhostMode(ghost: any(named: 'ghost')),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        act: (cubit) => cubit.toggleGhostMode(),
        expect: () => const [
          FriendsMapState(isGhost: true, privacyBusy: true),
          FriendsMapState(),
        ],
      );

      test('does not run a queued toggle after close', () async {
        final pending = Completer<void>();
        when(
          () => repository.setGhostMode(ghost: true),
        ).thenAnswer((_) => pending.future);
        when(
          () => repository.setGhostMode(ghost: false),
        ).thenAnswer((_) => Future<void>.value());
        final cubit = buildCubit();

        final first = cubit.toggleGhostMode();
        await pumpEventQueue();
        final second = cubit.toggleGhostMode().then<void>((_) => null);
        await cubit.close();
        pending.complete();
        await Future.wait([first, second]);

        verify(() => repository.setGhostMode(ghost: true)).called(1);
        verifyNever(() => repository.setGhostMode(ghost: false));
      });
    });

    group('removeFriend', () {
      blocTest<FriendsMapCubit, FriendsMapState>(
        'removes the friend and reloads the friends list',
        setUp: () {
          when(
            () => repository.removeFriend(any()),
          ).thenAnswer((_) => Future.value());
          when(() => repository.getFriends()).thenAnswer((_) async => const []);
        },
        build: buildCubit,
        act: (cubit) => cubit.removeFriend('user-1'),
        verify: (_) {
          verify(() => repository.removeFriend('user-1')).called(1);
          verify(() => repository.getFriends()).called(1);
        },
        expect: () => const [FriendsMapState()],
      );

      test('resolves false and reports the error on failure', () async {
        when(
          () => repository.removeFriend(any()),
        ).thenThrow(Exception('network'));
        final cubit = buildCubit();

        final removed = await cubit.removeFriend('user-1');

        expect(removed, isFalse);
        expect(cubit.state, equals(const FriendsMapState()));
        verifyNever(() => repository.getFriends());
        await cubit.close();
      });
    });

    group('respondRequest', () {
      const request = FriendRequest(
        friendshipId: 'f-1',
        userId: 'u-1',
        fullName: 'Тест Тестов',
      );
      late Completer<void> pendingRespond;

      setUp(() => pendingRespond = Completer<void>());

      blocTest<FriendsMapCubit, FriendsMapState>(
        'optimistically removes the request, marks it pending, then reloads',
        setUp: () {
          when(
            () => repository.respondFriendRequest(
              friendshipId: any(named: 'friendshipId'),
              accept: any(named: 'accept'),
            ),
          ).thenAnswer((_) => Future.value());
          when(() => repository.getFriends()).thenAnswer((_) async => const []);
          when(
            () => repository.getFriendRequests(),
          ).thenAnswer((_) async => const []);
        },
        build: buildCubit,
        seed: () => const FriendsMapState(requests: [request]),
        act: (cubit) => cubit.respondRequest(friendshipId: 'f-1', accept: true),
        verify: (_) {
          verify(
            () => repository.respondFriendRequest(
              friendshipId: 'f-1',
              accept: true,
            ),
          ).called(1);
        },
        expect: () => const [
          FriendsMapState(pendingResponseIds: {'f-1'}),
          FriendsMapState(),
        ],
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'reverts the optimistic removal and clears pending on failure',
        setUp: () => when(
          () => repository.respondFriendRequest(
            friendshipId: any(named: 'friendshipId'),
            accept: any(named: 'accept'),
          ),
        ).thenThrow(Exception('network')),
        build: buildCubit,
        seed: () => const FriendsMapState(requests: [request]),
        act: (cubit) =>
            cubit.respondRequest(friendshipId: 'f-1', accept: false),
        expect: () => const [
          FriendsMapState(pendingResponseIds: {'f-1'}),
          FriendsMapState(requests: [request]),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<FriendsMapCubit, FriendsMapState>(
        'ignores a duplicate call while a response is pending',
        setUp: () {
          when(
            () => repository.respondFriendRequest(
              friendshipId: any(named: 'friendshipId'),
              accept: any(named: 'accept'),
            ),
          ).thenAnswer((_) => pendingRespond.future);
        },
        build: buildCubit,
        seed: () => const FriendsMapState(requests: [request]),
        act: (cubit) async {
          final first = cubit.respondRequest(friendshipId: 'f-1', accept: true);
          final second = await cubit.respondRequest(
            friendshipId: 'f-1',
            accept: true,
          );
          expect(second, isFalse);
          pendingRespond.complete();
          await first;
        },
        verify: (_) {
          verify(
            () => repository.respondFriendRequest(
              friendshipId: 'f-1',
              accept: true,
            ),
          ).called(1);
        },
      );

      test('resolves false for an unknown friendship id', () async {
        final cubit = buildCubit();

        final result = await cubit.respondRequest(
          friendshipId: 'missing',
          accept: true,
        );

        expect(result, isFalse);
        verifyNever(
          () => repository.respondFriendRequest(
            friendshipId: any(named: 'friendshipId'),
            accept: any(named: 'accept'),
          ),
        );
        await cubit.close();
      });
    });

    group('location fusion (ingestDeviceFix)', () {
      test(
        'does not publish a device fix while ghost mode is active',
        () async {
          when(
            () => repository.setGhostMode(ghost: any(named: 'ghost')),
          ).thenAnswer((_) => Future.value());
          final cubit = buildCubit();

          await cubit.toggleGhostMode();
          cubit.ingestDeviceFix(devicePosition());
          await pumpEventQueue();

          verifyNever(
            () => repository.publishLocation(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              accuracyM: any(named: 'accuracyM'),
              heading: any(named: 'heading'),
              speedMps: any(named: 'speedMps'),
            ),
          );
          await cubit.close();
        },
      );

      test('first finite fix seeds the smoothed position', () {
        final cubit = buildCubit()..ingestDeviceFix(devicePosition());

        expect(cubit.state.myLatitude, baseLat);
        expect(cubit.state.myLongitude, baseLng);
        expect(cubit.state.hasMyLocation, isTrue);
      });

      test('NaN fixes are dropped entirely', () {
        final cubit = buildCubit()
          ..ingestDeviceFix(
            devicePosition(latitude: .nan, longitude: .nan),
          );

        expect(cubit.state.hasMyLocation, isFalse);
      });

      test('a teleport glitch does not move the position', () {
        final cubit = buildCubit()
          ..ingestDeviceFix(devicePosition())
          // Скачок на ~11 км через 1 секунду — глюк сетевой геолокации.
          ..ingestDeviceFix(
            devicePosition(latitude: baseLat + 0.1, dtSeconds: 1),
          );

        expect(cubit.state.myLatitude, closeTo(baseLat, 1e-9));
      });
    });

    group('refineViaWifi', () {
      const aps = [
        WifiAccessPointReading(bssid: '00:11:22:33:44:55', rssi: -48),
        WifiAccessPointReading(bssid: '00:11:22:33:44:66', rssi: -70),
      ];

      test(
        'resolves the position via Wi-Fi when there is no device fix',
        () async {
          when(
            () => repository.scanWifiAccessPoints(),
          ).thenAnswer((_) async => aps);
          when(() => repository.resolveWifiPosition(aps)).thenAnswer(
            (_) async => const NetworkLocationEstimate(
              latitude: baseLat,
              longitude: baseLng,
              accuracyM: 55,
            ),
          );

          final cubit = buildCubit();
          await cubit.refineViaWifi();

          expect(cubit.state.myLatitude, closeTo(baseLat, 1e-9));
          expect(cubit.state.myLongitude, closeTo(baseLng, 1e-9));
          verify(() => repository.resolveWifiPosition(aps)).called(1);
          verifyNever(
            () => repository.submitWifiObservations(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              accuracyM: any(named: 'accuracyM'),
              accessPoints: any(named: 'accessPoints'),
            ),
          );
        },
      );

      test('trains the crowdsourced DB when the device fix is fresh', () async {
        when(
          () => repository.scanWifiAccessPoints(),
        ).thenAnswer((_) async => aps);
        when(
          () => repository.submitWifiObservations(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            accuracyM: any(named: 'accuracyM'),
            accessPoints: any(named: 'accessPoints'),
          ),
        ).thenAnswer((_) => Future.value());

        final cubit = buildCubit()..ingestDeviceFix(devicePosition());
        await cubit.refineViaWifi();

        verify(
          () => repository.submitWifiObservations(
            latitude: baseLat,
            longitude: baseLng,
            accuracyM: 15,
            accessPoints: aps,
          ),
        ).called(1);
        verifyNever(() => repository.resolveWifiPosition(any()));
      });

      test('does not train the DB in ghost mode', () async {
        when(
          () => repository.setGhostMode(ghost: any(named: 'ghost')),
        ).thenAnswer((_) => Future.value());
        when(
          () => repository.scanWifiAccessPoints(),
        ).thenAnswer((_) async => aps);

        final cubit = buildCubit()..ingestDeviceFix(devicePosition());
        await cubit.toggleGhostMode();
        await cubit.refineViaWifi();

        verifyNever(
          () => repository.submitWifiObservations(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            accuracyM: any(named: 'accuracyM'),
            accessPoints: any(named: 'accessPoints'),
          ),
        );
      });

      test('does nothing with fewer than two visible APs', () async {
        when(
          () => repository.scanWifiAccessPoints(),
        ).thenAnswer((_) async => aps.take(1).toList());

        await buildCubit().refineViaWifi();

        verifyNever(() => repository.resolveWifiPosition(any()));
        verifyNever(
          () => repository.submitWifiObservations(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            accuracyM: any(named: 'accuracyM'),
            accessPoints: any(named: 'accessPoints'),
          ),
        );
      });

      test('does not overlap Wi-Fi refinement passes', () async {
        final scan = Completer<List<WifiAccessPointReading>>();
        when(
          () => repository.scanWifiAccessPoints(),
        ).thenAnswer((_) => scan.future);
        final cubit = buildCubit();

        final first = cubit.refineViaWifi();
        await pumpEventQueue();
        await cubit.refineViaWifi();
        scan.complete(const []);
        await first;

        verify(() => repository.scanWifiAccessPoints()).called(1);
        await cubit.close();
      });

      test('swallows repository failures into addError (no crash)', () async {
        when(
          () => repository.scanWifiAccessPoints(),
        ).thenThrow(const ScanWifiAccessPointsFailure('boom'));

        final cubit = buildCubit();
        await expectLater(cubit.refineViaWifi(), completes);
      });
    });

    group('passthrough actions', () {
      test(
        'sendRequest delegates to the repository and resolves true',
        () async {
          when(
            () => repository.sendFriendRequest(any()),
          ).thenAnswer((_) => Future.value());
          final sent = await buildCubit().sendRequest('user-9');
          expect(sent, isTrue);
          verify(() => repository.sendFriendRequest('user-9')).called(1);
        },
      );

      test(
        'sendRequest resolves false and reports the error on failure',
        () async {
          when(
            () => repository.sendFriendRequest(any()),
          ).thenThrow(Exception('network'));
          final cubit = buildCubit();

          final sent = await cubit.sendRequest('user-9');

          expect(sent, isFalse);
          await cubit.close();
        },
      );

      test('search delegates to the repository', () async {
        when(
          () => repository.searchUsers(any()),
        ).thenAnswer((_) async => const []);
        await buildCubit().search('anya');
        verify(() => repository.searchUsers('anya')).called(1);
      });
    });
  });
}
