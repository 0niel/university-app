import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Cache implements MapDataCache {
  final entries = <String, String>{};
  final reads = <String, int>{};
  Completer<String?>? pendingRead;

  @override
  Future<String?> read(String key) async {
    reads.update(key, (value) => value + 1, ifAbsent: () => 1);
    if (pendingRead != null && key.endsWith('campus:v-78')) {
      return pendingRead!.future;
    }
    return entries[key];
  }

  @override
  Future<void> write(String key, String value) async => entries[key] = value;
}

const _svg = '<svg viewBox="0 0 100 100"><rect width="30" height="30"/></svg>';

Map<String, Object?> _campus({String svg = _svg}) => {
  'id': 'v-78',
  'revision': 2,
  'can_moderate': false,
  'source_plan_sha256': 'same-source',
  'floors': [
    {'id': 'one', 'level': 1, 'width': 100, 'height': 100, 'svg': svg},
  ],
  'rooms': [
    {'id': 'room', 'floor_id': 'one', 'label': 'А-101', 'x': 15, 'y': 15},
  ],
  'graph': {'nodes': <Object>[], 'edges': <Object>[]},
};

Map<String, Object?> _catalog() => {
  'campuses': [
    {'id': 'v-78', 'revision': 2, 'source_plan_sha256': 'same-source'},
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fresh disk startup avoids RPC and expires after 30 minutes',
    () async {
      final cache = _Cache();
      var now = DateTime.utc(2026, 9, 8, 12);
      final online = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        clock: () => now,
        rpc: (name, _) async =>
            name == 'get_map_catalog' ? _catalog() : _campus(),
      );
      addTearDown(online.dispose);
      await online.loadCatalog();
      await online.loadCampus('v-78');
      var calls = 0;
      final reopened = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        clock: () => now,
        rpc: (_, _) async {
          calls++;
          return Completer<Object?>().future;
        },
      );
      addTearDown(reopened.dispose);
      final catalog = await reopened.loadCachedCatalog();
      final campus = await reopened.loadCachedCampus('v-78');
      expect(catalog!.origin, MapDataOrigin.cache);
      expect(catalog.warning, isNull);
      expect(campus!.origin, MapDataOrigin.cache);
      expect(campus.warning, isNull);
      expect(campus.canModerate, isFalse);
      expect(calls, 0);
      expect(reopened.isCatalogCacheFresh, isTrue);
      expect(reopened.isCampusCacheFresh('v-78'), isTrue);
      now = now.add(const Duration(minutes: 31));
      expect(reopened.isCatalogCacheFresh, isFalse);
      expect(reopened.isCampusCacheFresh('v-78'), isFalse);
      expect(await reopened.loadCachedCampus('v-78'), same(campus));
      expect(calls, 0);
    },
  );

  test(
    'a cold cache returns immediately without making a remote request',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        rpc: (_, _) async => fail('Cached startup must not start an RPC'),
      );
      addTearDown(repository.dispose);
      expect(await repository.loadCachedCatalog(), isNull);
      expect(await repository.loadCachedCampus('v-78'), isNull);
      expect(repository.isCatalogCacheFresh, isFalse);
    },
  );

  test(
    'concurrent disk loads share parsing without decoding a duplicate bundle',
    () async {
      final cache = _Cache()
        ..entries['mirea:campus:v-78'] = jsonEncode(_campus());
      final assets = <String>[];
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        bundledCatalogAsset: 'catalog.json',
        assetLoader: (path) async {
          assets.add(path);
          if (path != 'catalog.json') fail('The duplicate bundle was decoded');
          return jsonEncode(_catalog());
        },
        rpc: (_, _) async => fail('Cached startup must not start an RPC'),
      );
      addTearDown(repository.dispose);
      final results = await Future.wait([
        repository.loadCachedCampus('v-78'),
        repository.loadCachedCampus('v-78'),
      ]);
      expect(results.first, isNotNull);
      expect(results.first, same(results.last));
      expect(cache.reads['mirea:campus:v-78'], 1);
      expect(assets, ['catalog.json']);
      expect(repository.isCampusCacheFresh('v-78'), isFalse);
    },
  );

  test(
    'manual refresh bypasses fresh disk data and compares full plan contents',
    () async {
      final cache = _Cache()
        ..entries['mirea:campus:v-78'] = jsonEncode(_campus());
      var svg = _svg;
      var calls = 0;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        rpc: (_, _) async {
          calls++;
          return _campus(svg: svg);
        },
      );
      addTearDown(repository.dispose);
      final local = (await repository.loadCachedCampus('v-78'))!;
      final first = await repository.refreshCampus('v-78');
      final second = await repository.refreshCampus('v-78');
      expect(repository.sameCampusContent(local, first), isTrue);
      expect(repository.sameCampusContent(first, second), isTrue);
      svg = _svg.replaceFirst('width="30"', 'width="40"');
      final changed = await repository.refreshCampus('v-78');
      expect(repository.sameCampusContent(first, changed), isFalse);
      expect(calls, 3);
    },
  );

  test('cached image references never trigger a network download', () async {
    final document = _campus();
    (document['floors']! as List<Map<String, Object?>>).single
      ..remove('svg')
      ..['image_url'] = 'https://example.org/floor.svg';
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: _Cache()..entries['mirea:campus:v-78'] = jsonEncode(document),
      httpClient: MockClient((_) async => fail('Unexpected SVG request')),
      rpc: (_, _) async => fail('Unexpected RPC'),
    );
    addTearDown(repository.dispose);
    expect(await repository.loadCachedCampus('v-78'), isNull);
  });

  for (final remoteFirst in [false, true]) {
    test(
      'pending disk cannot overwrite remote refresh '
      '(remote first: $remoteFirst)',
      () async {
        final cache = _Cache()..pendingRead = Completer<String?>();
        final response = Completer<Object?>();
        final nextSvg = _svg.replaceFirst('width="30"', 'width="50"');
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (_, _) => response.future,
        );
        addTearDown(repository.dispose);
        final earlyRefresh = remoteFirst
            ? repository.refreshCampus('v-78')
            : null;
        final pending = repository.loadCachedCampus('v-78');
        final refreshed = earlyRefresh ?? repository.refreshCampus('v-78');
        response.complete(_campus(svg: nextSvg));
        final remote = await refreshed;
        cache.pendingRead!.complete(jsonEncode(_campus()));
        expect(await pending, isNull);
        expect(await repository.loadCampus('v-78'), same(remote));
        expect(
          await repository.loadSvg(remote.floors.single.floor.svgPath),
          nextSvg,
        );
      },
    );
  }

  test('preferences retain all four real campus documents together', () async {
    SharedPreferences.setMockInitialValues({});
    final cache = PreferencesMapDataCache();
    final documents = <String, String>{};
    for (final campus in ['v-78', 'v-86', 's-20', 'mp-1']) {
      documents[campus] = File(
        'packages/app_ui/assets/maps/pulse/campus_$campus.json',
      ).readAsStringSync();
      await cache.write('mirea:campus:$campus', documents[campus]!);
    }
    for (final entry in documents.entries) {
      expect(await cache.read('mirea:campus:${entry.key}'), entry.value);
    }
    final preferences = await SharedPreferences.getInstance();
    final sizes =
        jsonDecode(preferences.getString('campus_map_v1:sizes')!) as Map;
    for (final entry in documents.entries) {
      expect(
        sizes['campus_map_v1:mirea:campus:${entry.key}'],
        utf8.encode(entry.value).length,
      );
    }
  });

  test(
    'corrupt catalog data cannot prevent the bundled catalog from opening',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache()..entries['mirea:catalog'] = '{"campuses":[{"id":17}]}',
        bundledCatalogAsset: 'catalog.json',
        assetLoader: (_) async => jsonEncode(_catalog()),
        rpc: (_, _) async => http.Response('', 500),
      );
      addTearDown(repository.dispose);
      expect((await repository.loadCachedCatalog())!.entries.single.id, 'v-78');
    },
  );
}
