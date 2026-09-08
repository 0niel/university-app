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

  void expire() {
    for (final key in values.keys.toList()) {
      final json = jsonDecode(values[key]!) as Map<String, dynamic>;
      json['_map_cache_stored_at'] = '2000-01-01T00:00:00Z';
      values[key] = jsonEncode(json);
    }
  }
}

class _RecordingRepository extends MapDataRepository {
  _RecordingRepository({required super.cache, required super.rpc})
    : super(organizationId: 'mirea');

  final svgLoads = <String>[];

  @override
  Future<String> loadSvg(String path) {
    svgLoads.add(path);
    return super.loadSvg(path);
  }
}

Map<String, Object?> _catalog(int revision) => {
  'campuses': [
    {'id': 'campus', 'short_title': 'В-78', 'revision': revision},
  ],
};

Map<String, Object?> _document(int revision) => {
  'id': 'campus',
  'short_title': 'В-78',
  'revision': revision,
  'floors': [
    for (final level in [1, 2, 3])
      {
        'id': 'f$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"> '
            '<rect data-object="room-$level" x="${revision * 10}" '
            'y="10" width="20" height="20" /> </svg>',
      },
  ],
  'rooms': [
    for (final level in [1, 2, 3])
      {
        'id': 'room-$level',
        'floor_id': 'f$level',
        'label': 'А-${level}01',
        'x': revision * 10 + 10,
        'y': 20,
      },
  ],
};

Future<_MemoryCache> _seedCache() async {
  final cache = _MemoryCache();
  final repository = MapDataRepository(
    organizationId: 'mirea',
    cache: cache,
    rpc: (name, _) async =>
        name == 'get_map_catalog' ? _catalog(1) : _document(1),
  );
  await repository.loadCatalog();
  await repository.loadCampus('campus');
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

Future<void> _initialize(MapBloc bloc) async {
  final ready = bloc.stream.firstWhere(
    (state) => state.status == .loaded && state.roomFloors.length == 3,
  );
  bloc.add(const MapEvent.initialized());
  await ready.timeout(const Duration(seconds: 10));
}

Future<void> _secondFloor(MapBloc bloc) async {
  final selected = bloc.stream.firstWhere(
    (state) => state.status == .loaded && state.selectedFloor?.id == 'f2',
  );
  final campus = bloc.state.selectedCampus!;
  bloc.add(MapEvent.floorSelected(campus: campus, floor: campus.floors[1]));
  await selected.timeout(const Duration(seconds: 10));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'warm startup uses fresh disk cache without network or other floor SVGs',
    () async {
      final cache = await _seedCache();
      var calls = 0;
      final repository = _RecordingRepository(
        cache: cache,
        rpc: (_, _) async {
          calls++;
          throw StateError('Fresh startup must not contact the network');
        },
      );
      final bloc = _bloc(repository);
      addTearDown(() async {
        await bloc.close();
        repository.dispose();
      });
      await _initialize(bloc);
      expect(calls, 0);
      expect(bloc.state.roomFloors, {'А101': 1, 'А201': 2, 'А301': 3});
      expect(repository.svgLoads.toSet(), {bloc.state.selectedFloor!.svgPath});
      expect(bloc.state.campusData!.canModerate, isFalse);
    },
  );

  test(
    'stale startup renders before blocked network and preserves chosen floor',
    () async {
      final cache = await _seedCache()
        ..expire();
      final entered = Completer<void>();
      final response = Completer<Object?>();
      final repository = _RecordingRepository(
        cache: cache,
        rpc: (name, _) async {
          if (name == 'get_map_catalog') return _catalog(2);
          if (!entered.isCompleted) entered.complete();
          return response.future;
        },
      );
      final bloc = _bloc(repository);
      addTearDown(() async {
        if (!response.isCompleted) response.complete(_document(2));
        await bloc.close();
        repository.dispose();
      });
      await _initialize(bloc);
      expect(bloc.state.campusData!.revision, 1);
      await entered.future.timeout(const Duration(seconds: 10));
      expect(bloc.state.status, MapStatus.loaded);
      await _secondFloor(bloc);
      final updated = bloc.stream.firstWhere(
        (state) => state.status == .loaded && state.campusData?.revision == 2,
      );
      response.complete(_document(2));
      await updated.timeout(const Duration(seconds: 10));
      expect(bloc.state.selectedFloor!.id, 'f2');
      expect(bloc.state.rooms.single.path.getBounds().left, 20);
    },
  );

  test(
    'manual refresh bypasses fresh cache and retains selected floor',
    () async {
      final cache = await _seedCache();
      var calls = 0;
      final repository = _RecordingRepository(
        cache: cache,
        rpc: (name, _) async {
          calls++;
          return name == 'get_map_catalog' ? _catalog(2) : _document(2);
        },
      );
      final bloc = _bloc(repository);
      addTearDown(() async {
        await bloc.close();
        repository.dispose();
      });
      await _initialize(bloc);
      await _secondFloor(bloc);
      expect(calls, 0);
      final updated = bloc.stream.firstWhere(
        (state) => state.status == .loaded && state.campusData?.revision == 2,
      );
      bloc.add(const MapEvent.refreshRequested());
      await updated.timeout(const Duration(seconds: 10));
      expect(calls, 2);
      expect(bloc.state.selectedFloor!.id, 'f2');
    },
  );
  for (final moderationChanged in [false, true]) {
    test(
      moderationChanged
          ? 'background validation propagates verified moderation capability'
          : 'unchanged background validation retains map and room identities',
      () async {
        final cache = (await _seedCache())..expire();
        final response = Completer<Object?>();
        final repository = _RecordingRepository(
          cache: cache,
          rpc: (name, _) async =>
              name == 'get_map_catalog' ? _catalog(1) : response.future,
        );
        final bloc = _bloc(repository);
        addTearDown(() async {
          if (!response.isCompleted) response.complete(_document(1));
          await bloc.close();
          repository.dispose();
        });
        await _initialize(bloc);
        final displayed = bloc.state.campusData!;
        final rooms = bloc.state.rooms;
        final verified = bloc.stream.firstWhere((state) => !state.isOffline);
        response.complete({..._document(1), 'can_moderate': moderationChanged});
        await verified.timeout(const Duration(seconds: 10));
        expect(bloc.state.campusData!.canModerate, moderationChanged);
        if (moderationChanged) {
          expect(identical(displayed, bloc.state.campusData), isFalse);
        } else {
          expect(bloc.state.campusData, same(displayed));
          expect(bloc.state.rooms.first, same(rooms.first));
        }
        expect(repository.svgLoads.toSet(), {
          bloc.state.selectedFloor!.svgPath,
        });
      },
    );
  }

  test(
    'background validation replaces changed geometry at the same revision',
    () async {
      final cache = (await _seedCache())..expire();
      final response = Completer<Object?>();
      final repository = _RecordingRepository(
        cache: cache,
        rpc: (name, _) async =>
            name == 'get_map_catalog' ? _catalog(1) : response.future,
      );
      final bloc = _bloc(repository);
      addTearDown(() async {
        if (!response.isCompleted) response.complete(_document(1));
        await bloc.close();
        repository.dispose();
      });
      await _initialize(bloc);
      final displayed = bloc.state.campusData!;
      final updated = bloc.stream.firstWhere(
        (state) =>
            state.status == .loaded && !identical(state.campusData, displayed),
      );
      response.complete({..._document(2), 'revision': 1});
      await updated.timeout(const Duration(seconds: 10));
      expect(bloc.state.campusData!.revision, displayed.revision);
      expect(bloc.state.rooms.single.path.getBounds().left, 20);
    },
  );
}
