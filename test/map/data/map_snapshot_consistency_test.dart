import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';

class Cache implements MapDataCache {
  final entries = <String, String>{};
  @override
  Future<String?> read(String key) async => entries[key];
  @override
  Future<void> write(String key, String value) async => entries[key] = value;
}

Map<String, Object?> campus({
  int revision = 1,
  bool url = false,
  bool alias = false,
}) => {
  'id': 'v-78',
  'short_title': 'В-78',
  'revision': revision,
  'floors': [
    {
      'id': 'f1',
      'level': 1,
      'width': 100,
      'height': 100,
      if (url)
        'image_url': 'https://maps.example.org/floor.svg'
      else
        'svg':
            '<svg viewBox="0 0 100 100"><rect data-object="old" x="10" y="10" width="20" height="20" /></svg>',
    },
  ],
  'rooms': [
    {
      'id': alias ? 'new' : 'old',
      'floor_id': 'f1',
      'label': 'А-101',
      'x': 20,
      'y': 20,
      if (alias) 'legacy_ids': ['old'],
    },
  ],
};

Future<void> initialize(MapBloc bloc) async {
  final loaded = bloc.stream.firstWhere((s) => s.status == MapStatus.loaded);
  bloc.add(const MapEvent.initialized());
  await loaded;
  await Future<void>.delayed(const Duration(milliseconds: 20));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'legacy complete SVG cache is used without retrying each network URL',
    () async {
      const svg = '<svg viewBox="0 0 100 100" />';
      final cache = Cache()
        ..entries['mirea:campus:v-78'] = jsonEncode(campus(url: true))
        ..entries['mirea:svg:map://v-78/f1/1'] = svg;
      var requests = 0;
      final client = MockClient((_) async {
        requests++;
        throw Exception('No network');
      });
      addTearDown(client.close);
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: client,
        rpc: (_, _) async => throw const MapDataException('No network'),
      );
      final restored = await repository.loadCampus('v-78');
      expect(
        await repository.loadSvg(restored.floors.single.floor.svgPath),
        svg,
      );
      expect(requests, 0);
    },
  );

  test(
    'partial downloads cannot replace or evict a complete snapshot',
    () async {
      final cache = Cache();
      var changed = false;
      final client = MockClient(
        (request) async => request.url.path == '/one.svg'
            ? http.Response('<svg viewBox="0 0 100 100" />', 200)
            : http.Response('unavailable', 503),
      );
      addTearDown(client.close);
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: client,
        rpc: (_, _) async => changed
            ? {
                ...campus(revision: 2),
                'floors': [
                  for (final id in ['one', 'two'])
                    {
                      'id': id,
                      'level': id == 'one' ? 1 : 2,
                      'width': 100,
                      'height': 100,
                      'image_url': 'https://maps.example.org/$id.svg',
                    },
                ],
              }
            : campus(),
      );
      await repository.loadCampus('v-78');
      final previous = Map<String, String>.of(cache.entries);
      changed = true;
      expect((await repository.refreshCampus('v-78')).revision, 1);
      expect(cache.entries, previous);
    },
  );

  test(
    'published URL plans remain fully available after restart offline',
    () async {
      final cache = Cache();
      final client = MockClient(
        (_) async => http.Response(
          '<svg viewBox="0 0 100 100"><rect width="20" height="20" /></svg>',
          200,
        ),
      );
      addTearDown(client.close);
      final online = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: client,
        rpc: (_, _) async => campus(url: true),
      );
      await online.loadCampus('v-78');
      final failingClient = MockClient(
        (_) async => throw Exception('No network'),
      );
      addTearDown(failingClient.close);
      final offline = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: failingClient,
        rpc: (_, _) async => throw const MapDataException('No network'),
      );
      final restored = await offline.loadCampus('v-78');
      expect(
        await offline.loadSvg(restored.floors.single.floor.svgPath),
        contains('<rect'),
      );
    },
  );

  test(
    'broken new image_url must preserve last renderable cached snapshot',
    () async {
      final cache = Cache();
      var current = campus();
      var offline = false;
      final client = MockClient((_) async => http.Response('', 503));
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: client,
        rpc: (_, _) async {
          if (offline) throw const MapDataException('offline');
          return current;
        },
      );
      addTearDown(client.close);
      await repository.loadCampus('v-78');
      current = campus(revision: 2, url: true);
      final recovered = await repository.refreshCampus('v-78');
      expect(recovered.revision, 1);
      expect(
        await repository.loadSvg(recovered.floors.single.floor.svgPath),
        contains('data-object="old"'),
      );
      final stored =
          jsonDecode(cache.entries['mirea:campus:v-78']!)
              as Map<String, Object?>;
      expect(stored['revision'], 1);
      offline = true;
      final fallback = await repository.refreshCampus('v-78');
      expect(fallback.revision, 1);
    },
  );

  test(
    'room metadata alias must still select its source SVG geometry',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: Cache(),
        rpc: (name, _) async => name == 'get_map_catalog'
            ? {
                'campuses': [
                  {'id': 'v-78', 'revision': 1},
                ],
              }
            : campus(alias: true),
      );
      final bloc = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => jsonEncode({'objects': <Object?>[]}),
        ),
      );
      addTearDown(bloc.close);
      addTearDown(repository.dispose);
      await initialize(bloc);
      expect(bloc.state.rooms.single.roomId, 'new');
      bloc.add(const MapEvent.roomTapped('old'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state.rooms.single.isSelected, isTrue);
    },
  );

  test('explicit refresh must discover a newly published campus', () async {
    var published = false;
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: Cache(),
      rpc: (name, _) async => name == 'get_map_catalog'
          ? {
              'campuses': [
                {'id': 'v-78', 'revision': 1},
                if (published) {'id': 'v-86', 'revision': 1},
              ],
            }
          : campus(),
    );
    final bloc = MapBloc(
      availableCampuses: [],
      repository: repository,
      objectsService: ObjectsService(
        onLoadObjects: (_) async => jsonEncode({'objects': <Object?>[]}),
      ),
    );
    addTearDown(bloc.close);
    addTearDown(repository.dispose);
    await initialize(bloc);
    published = true;
    final refreshed = bloc.stream
        .skipWhile((s) => s.status != MapStatus.loading)
        .firstWhere((s) => s.status == MapStatus.loaded);
    bloc.add(const MapEvent.refreshRequested());
    await refreshed;
    expect(bloc.state.availableCampuses.map((c) => c.id), contains('v-86'));
  });
}
