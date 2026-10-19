import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'missing preferences use ordered defaults without storing a selection',
    () async {
      final cubit = FavoriteServicesCubit();
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.loaded, isTrue);
      expect(cubit.state.ids.toList(), HomeServiceDefaults.routes);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('services.favorites'), isFalse);
    },
  );

  test('an explicitly empty selection stays empty', () async {
    SharedPreferences.setMockInitialValues({'services.favorites': <String>[]});
    final cubit = FavoriteServicesCubit();
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state.ids, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('services.favorites'), isEmpty);
  });

  test(
    'existing selections are kept even when they match legacy defaults',
    () async {
      const legacySelection = [
        '/services/map',
        '/services/nfc',
        '/services/free-rooms',
        '/services/deadlines',
        '/schedule/session',
        '/services/collab-notes',
        '/services/tools',
        '/services/knowledge-bank',
        '/services/communities',
        '/services/events',
      ];
      SharedPreferences.setMockInitialValues({
        'services.favorites': legacySelection,
      });
      final cubit = FavoriteServicesCubit();
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.ids.toList(), legacySelection);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('services.favorites'), legacySelection);
    },
  );

  test('toggle preserves insertion order when saved and reloaded', () async {
    const stored = [
      '/services/polls',
      '/services/deadlines',
      '/services/events',
    ];
    SharedPreferences.setMockInitialValues({'services.favorites': stored});
    final cubit = FavoriteServicesCubit();
    addTearDown(cubit.close);
    const service = ServiceModel(
      title: 'Events',
      icon: AppLineIcon.spark,
      color: Color(0xFF086A81),
      isExternal: false,
      routePath: '/services/events',
    );
    const map = ServiceModel(
      title: 'Map',
      icon: AppLineIcon.map,
      color: Color(0xFF086A81),
      isExternal: false,
      routePath: '/services/map',
    );

    await cubit.load();
    await cubit.toggle(service);
    await cubit.toggle(map);
    await cubit.toggle(service);
    final restored = FavoriteServicesCubit();
    addTearDown(restored.close);
    await restored.load();

    const expected = [
      '/services/polls',
      '/services/deadlines',
      '/services/map',
      '/services/events',
    ];
    expect(cubit.state.ids.toList(), expected);
    expect(restored.state.ids.toList(), expected);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('services.favorites'), expected);
  });

  test('loads persisted favorites and toggles them', () async {
    SharedPreferences.setMockInitialValues({
      'services.favorites': ['/services/map'],
    });
    final cubit = FavoriteServicesCubit();
    addTearDown(cubit.close);

    await cubit.load();
    expect(cubit.state.loaded, isTrue);
    expect(cubit.state.ids, {'/services/map'});

    const service = ServiceModel(
      title: 'Map',
      icon: AppLineIcon.map,
      color: Color(0xFF086A81),
      isExternal: false,
      routePath: '/services/map',
    );
    await cubit.toggle(service);

    expect(cubit.state.ids, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('services.favorites'), isEmpty);
  });

  test(
    'a toggle waits for loading and preserves the loaded favorites',
    () async {
      final repository = _DelayedFavoriteServicesRepository();
      final cubit = FavoriteServicesCubit(repository: repository);
      addTearDown(cubit.close);
      const service = ServiceModel(
        title: 'Map',
        icon: AppLineIcon.map,
        color: Color(0xFF086A81),
        isExternal: false,
        routePath: '/services/map',
      );

      final loading = cubit.load();
      final toggling = cubit.toggle(service);
      repository.loaded.complete({'/services/events'});
      await Future.wait([loading, toggling]);

      expect(cubit.state.ids, {'/services/events', '/services/map'});
      expect(repository.saves.single, {'/services/events', '/services/map'});
    },
  );
}

class _DelayedFavoriteServicesRepository extends FavoriteServicesRepository {
  final Completer<Set<String>> loaded = Completer();
  final List<Set<String>> saves = [];

  @override
  Future<Set<String>> load() => loaded.future;

  @override
  Future<void> save(Set<String> ids) async => saves.add(Set.of(ids));
}
