import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

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
