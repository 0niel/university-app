import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';

class _Preferences extends Mock implements PreferencesRepository {}

class _Friends extends Mock implements FriendsRepository {}

class _MapCubit extends Mock implements FriendsMapCubit {}

void main() {
  setUpAll(() => registerFallbackValue(const GeoSharingSettings()));
  late _Preferences preferences;
  late _Friends friends;
  late GeoSharingCubit cubit;

  setUp(() {
    preferences = _Preferences();
    friends = _Friends();
    when(() => preferences.get(any())).thenAnswer((_) async => null);
    when(() => preferences.set(any(), any())).thenAnswer((_) async {});
    when(
      () => friends.setGhostMode(ghost: any(named: 'ghost')),
    ).thenAnswer((_) async {});
    cubit = GeoSharingCubit(
      preferencesRepository: preferences,
      friendsRepository: friends,
    );
  });
  tearDown(() async => cubit.close());

  test(
    'profile uses session map settings and stops the shared publisher',
    () async {
      final map = _MapCubit();
      final updates = StreamController<FriendsMapState>.broadcast();
      var mapState = const FriendsMapState(
        geoSettings: GeoSharingSettings(
          sharing: true,
          visibility: .students,
          precision: .city,
        ),
      );
      when(() => map.stream).thenAnswer((_) => updates.stream);
      when(() => map.state).thenAnswer((_) => mapState);
      when(map.initialize).thenAnswer((_) async {});
      when(() => map.updateGeoSettings(any())).thenAnswer((invocation) async {
        mapState = mapState.copyWith(
          geoSettings:
              invocation.positionalArguments.first as GeoSharingSettings,
        );
        updates.add(mapState);
      });
      final linked = GeoSharingCubit(
        preferencesRepository: preferences,
        friendsRepository: friends,
        mapCubit: map,
      );
      await linked.load();
      expect(linked.state.settings.visibility, GeoVisibility.students);
      expect(linked.state.settings.precision, GeoPrecision.city);
      expect(await linked.setSharing(enabled: false), isTrue);
      expect(mapState.geoSettings.sharing, isFalse);
      expect(mapState.geoSettings.visibility, GeoVisibility.none);
      expect(mapState.geoSettings.precision, GeoPrecision.city);
      verifyNever(() => friends.setGhostMode(ghost: any(named: 'ghost')));
      verifyNever(() => preferences.set(any(), any()));
      await linked.close();
      await updates.close();
    },
  );

  test(
    'defaults off until loaded and remains off without saved consent',
    () async {
      expect(cubit.state.sharing, isFalse);
      expect(cubit.state.loaded, isFalse);
      await cubit.load();
      expect(cubit.state.loaded, isTrue);
      expect(cubit.state.sharing, isFalse);
      verifyNever(() => friends.setGhostMode(ghost: false));
    },
  );

  test('does not enable before persistence and server confirmation', () async {
    final gate = Completer<void>();
    when(
      () => friends.setGhostMode(ghost: false),
    ).thenAnswer((_) => gate.future);
    final operation = cubit.setSharing(enabled: true);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.busy, isTrue);
    expect(cubit.state.sharing, isFalse);
    gate.complete();
    expect(await operation, isTrue);
    expect(cubit.state.sharing, isTrue);
    expect(cubit.state.failed, isFalse);
  });

  test('failed opt-in rolls back the preference and hides remotely', () async {
    when(
      () => friends.setGhostMode(ghost: false),
    ).thenThrow(StateError('not saved'));
    expect(await cubit.setSharing(enabled: true), isFalse);
    expect(cubit.state.sharing, isFalse);
    expect(cubit.state.failed, isTrue);
    expect(cubit.state.busy, isFalse);
    verify(() => friends.setGhostMode(ghost: true)).called(1);
    final values = verify(
      () => preferences.set(any(), captureAny()),
    ).captured.cast<Map<String, dynamic>>();
    expect(values.last['sharing'], isFalse);
  });

  test('failed opt-out stays locally off and exposes failure', () async {
    expect(await cubit.setSharing(enabled: true), isTrue);
    when(
      () => friends.setGhostMode(ghost: true),
    ).thenThrow(StateError('offline'));
    expect(await cubit.setSharing(enabled: false), isFalse);
    expect(cubit.state.sharing, isFalse);
    expect(cubit.state.failed, isTrue);
  });

  test(
    'does not dispatch location changes after account scope is closed',
    () async {
      final gate = Completer<void>();
      when(() => preferences.set(any(), any())).thenAnswer((_) => gate.future);
      final operation = cubit.setSharing(enabled: true);
      await cubit.close();
      gate.complete();
      expect(await operation, isFalse);
      verifyNever(() => friends.setGhostMode(ghost: any(named: 'ghost')));
    },
  );

  test('stops rollback requests after the account scope is closed', () async {
    final gate = Completer<void>();
    var writes = 0;
    when(() => preferences.set(any(), any())).thenAnswer((_) async {
      writes++;
      if (writes == 1) throw StateError('offline');
      await gate.future;
    });
    final operation = cubit.setSharing(enabled: true);
    await Future<void>.delayed(Duration.zero);
    expect(writes, 2);
    await cubit.close();
    gate.complete();
    expect(await operation, isFalse);
    verifyNever(() => friends.setGhostMode(ghost: any(named: 'ghost')));
  });
}
