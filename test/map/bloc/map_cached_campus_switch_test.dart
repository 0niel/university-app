import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';

class _MemoryCache implements MapDataCache {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  void expire(String campus) {
    final key = 'mirea:campus:$campus';
    final document = jsonDecode(values[key]!) as Map<String, dynamic>;
    document['_map_cache_stored_at'] = '2000-01-01T00:00:00Z';
    values[key] = jsonEncode(document);
  }
}

Map<String, Object?> _catalog() => {
  'campuses': [
    for (final campus in ['a', 'b', 'c'])
      {'id': campus, 'short_title': campus, 'revision': 1},
  ],
};

Map<String, Object?> _document(String campus) => {
  'id': campus,
  'short_title': campus,
  'revision': 1,
  'floors': [
    for (final level in [1, 2])
      {
        'id': '$campus-$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"> '
            '<rect data-object="room-$campus-$level" x="10" '
            'y="10" width="20" height="20" /> </svg>',
      },
  ],
  'rooms': [
    for (final level in [1, 2])
      {
        'id': 'room-$campus-$level',
        'floor_id': '$campus-$level',
        'label': '$campus-$level',
        'x': 20,
        'y': 20,
      },
  ],
};

Future<_MemoryCache> _seedCache() async {
  final cache = _MemoryCache();
  final repository = MapDataRepository(
    organizationId: 'mirea',
    cache: cache,
    rpc: (name, args) async => name == 'get_map_catalog'
        ? _catalog()
        : _document(args['p_campus_id']! as String),
  );
  await repository.loadCatalog();
  for (final id in ['a', 'b', 'c']) {
    await repository.loadCampus(id);
  }
  repository.dispose();
  return cache;
}

MapBloc _bloc(MapDataRepository repository) => MapBloc(
  availableCampuses: [],
  repository: repository,
  objectsService: ObjectsService(
    onLoadObjects: (_) async => '{"objects":[]}',
  ),
);

Future<MapState> _loaded(MapBloc bloc, String campus) => bloc.stream
    .firstWhere(
      (state) => state.status == .loaded && state.selectedCampus?.id == campus,
    )
    .timeout(const Duration(seconds: 5));

Future<void> _initialize(MapBloc bloc) async {
  final loaded = _loaded(bloc, 'a');
  bloc.add(const MapEvent.initialized());
  await loaded;
}

Future<void> _select(MapBloc bloc, String campus) async {
  final loaded = _loaded(bloc, campus);
  bloc.add(
    MapEvent.campusSelected(
      bloc.state.availableCampuses.firstWhere((item) => item.id == campus),
    ),
  );
  await loaded;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('selecting another fresh saved campus performs no RPC', () async {
    final cache = await _seedCache();
    var calls = 0;
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: cache,
      rpc: (_, _) async {
        calls++;
        throw StateError('A saved fresh campus must open without RPC');
      },
    );
    final bloc = _bloc(repository);
    addTearDown(() async {
      await bloc.close();
      repository.dispose();
    });
    await _initialize(bloc);
    await _select(bloc, 'b');
    expect(calls, 0);
    expect(bloc.state.campusData!.campus.id, 'b');
    expect(bloc.state.rooms.single.name, 'b-1');
    expect(bloc.state.campusData!.canModerate, isFalse);
  });

  for (final missingCache in [false, true]) {
    test(
      missingCache
          ? 'a blocked uncached campus cannot delay selecting a saved campus'
          : 'stale campus renders before revalidation and another selection',
      () async {
        final cache = await _seedCache();
        if (missingCache) {
          cache.values.remove('mirea:campus:b');
        } else {
          cache.expire('b');
        }
        final entered = Completer<void>();
        final response = Completer<Object?>();
        final order = <String>[];
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (name, args) async {
            if (name == 'get_map_catalog') return _catalog();
            final campus = args['p_campus_id']! as String;
            expect(campus, 'b');
            order.add('request-b');
            if (!entered.isCompleted) entered.complete();
            return response.future;
          },
        );
        final bloc = _bloc(repository);
        final subscription = bloc.stream.listen((state) {
          if (state.status == .loaded) {
            order.add('loaded-${state.selectedCampus?.id}');
          }
        });
        addTearDown(() async {
          if (!response.isCompleted) response.complete(_document('b'));
          await bloc.close();
          await subscription.cancel();
          repository.dispose();
        });
        await _initialize(bloc);
        final second = bloc.state.availableCampuses.firstWhere(
          (c) => c.id == 'b',
        );
        if (missingCache) {
          bloc.add(MapEvent.campusSelected(second));
        } else {
          await _select(bloc, 'b');
        }
        await entered.future.timeout(const Duration(seconds: 5));
        if (!missingCache) {
          expect(bloc.state.status, MapStatus.loaded);
          expect(
            order.indexOf('loaded-b'),
            lessThan(order.indexOf('request-b')),
          );
        }
        await _select(bloc, 'c');
        expect(response.isCompleted, isFalse);
        expect(bloc.state.selectedCampus!.id, 'c');
        final completedRemote = repository.loadCampus('b');
        response.complete(_document('b'));
        await completedRemote;
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.selectedCampus!.id, 'c');
        expect(bloc.state.rooms.single.name, 'c-1');
      },
    );
  }

  test(
    'cross-campus floor selection does not wait for older revalidation',
    () async {
      final cache = await _seedCache()
        ..expire('b');
      final entered = Completer<void>();
      final response = Completer<Object?>();
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        rpc: (name, _) async {
          if (name == 'get_map_catalog') return _catalog();
          if (!entered.isCompleted) entered.complete();
          return response.future;
        },
      );
      final bloc = _bloc(repository);
      addTearDown(() async {
        if (!response.isCompleted) response.complete(_document('b'));
        await bloc.close();
        repository.dispose();
      });
      await _initialize(bloc);
      for (final id in ['b', 'c']) {
        final campus = (await repository.loadCachedCampus(id))!.campus;
        final loaded = _loaded(bloc, id);
        bloc.add(
          MapEvent.floorSelected(campus: campus, floor: campus.floors[1]),
        );
        await loaded;
        if (id == 'b') await entered.future.timeout(const Duration(seconds: 5));
      }
      expect(response.isCompleted, isFalse);
      expect(bloc.state.selectedCampus!.id, 'c');
      expect(bloc.state.selectedFloor!.id, 'c-2');
    },
  );
}
