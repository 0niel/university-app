import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MemoryCache implements MapDataCache {
  final entries = <String, String>{};

  @override
  Future<String?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, String value) async => entries[key] = value;
}

const _svg =
    '<svg viewBox="0 0 100 100"> '
    '<rect data-object="room-1" width="10" height="20" /></svg>';

Map<String, Object?> _campus({int revision = 2}) => {
  'id': 'v-78',
  'title': 'Вернадского, 78',
  'short_title': 'В-78',
  'revision': revision,
  'can_moderate': true,
  'source_url': 'https://pulse.mirea.ru/services/maps',
  'floors': [
    {'id': 'first', 'level': 1, 'svg': _svg, 'width': 100, 'height': 100},
  ],
  'rooms': [
    {
      'id': 'room-1',
      'floor_id': 'first',
      'label': 'А-101',
      'equipment': ['Проектор'],
    },
  ],
};

Map<String, Object?> _sourceCampus(int generation, {int revision = 2}) => {
  ..._campus(revision: revision),
  'source_plan_sha256': 'capture-$generation',
  'source_captured_at': '2026-01-0${generation}T00:00:00Z',
  'source_capture_method': 'authenticated_GetCampus_response',
};

void main() {
  group('MapDataRepository', () {
    test(
      'native place IDs resolve legacy links and unambiguous source IDs',
      () async {
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          rpc: (_, _) async => {
            ..._campus(),
            'rooms': [
              {
                'id': 'native-1',
                'floor_id': 'first',
                'label': 'А-101',
                'legacy_ids': ['old-1', 'shared'],
                'source_db_id': 'pulse-uuid',
              },
              {
                'id': 'native-2',
                'floor_id': 'first',
                'label': 'А-102',
                'legacy_ids': ['shared', 'native-1'],
              },
            ],
          },
        );
        addTearDown(repository.dispose);
        final campus = await repository.loadCampus('v-78');
        expect(campus.placeForId('old-1')?.id, 'native-1');
        expect(campus.placeForId('v-78__r__old-1')?.id, 'native-1');
        expect(campus.placeForId('pulse-uuid')?.id, 'native-1');
        expect(campus.placeForId('native-1')?.label, 'А-101');
        expect(campus.placeForId('shared'), isNull);
        expect(campus.placeForId('prefix-old-1'), isNull);
      },
    );

    test(
      'a newer catalog invalidates a loaded campus without manual refresh',
      () async {
        var revision = 1;
        var campusCalls = 0;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          rpc: (name, _) async {
            if (name == 'get_map_catalog') {
              return {
                'campuses': [
                  {'id': 'v-78', 'revision': revision},
                ],
              };
            }
            campusCalls++;
            return _campus(revision: revision);
          },
        );
        addTearDown(repository.dispose);
        expect((await repository.loadCampus('v-78')).revision, 1);
        revision = 2;
        await repository.loadCatalog();
        expect((await repository.loadCampus('v-78')).revision, 2);
        expect(campusCalls, 2);
      },
    );

    test(
      'catalog reconnect retries offline data and clears its warning',
      () async {
        final cache = _MemoryCache()
          ..entries['mirea:campus:v-78'] = jsonEncode(_campus());
        var offline = true;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (name, _) async {
            if (offline) throw const MapDataException('offline');
            return name == 'get_map_catalog'
                ? {
                    'campuses': [
                      {'id': 'v-78', 'revision': 2},
                    ],
                  }
                : _campus();
          },
        );
        addTearDown(repository.dispose);
        expect((await repository.loadCampus('v-78')).warning, isNotNull);
        offline = false;
        await repository.loadCatalog();
        final online = await repository.loadCampus('v-78');
        expect(online.origin, MapDataOrigin.remote);
        expect(online.warning, isNull);
      },
    );

    test(
      'first publication revision one remains authoritative over bundle two',
      () async {
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          bundledCatalogAsset: 'catalog.json',
          rpc: (name, _) async => name == 'get_map_catalog'
              ? {
                  'campuses': [
                    {'id': 'v-78', 'revision': 1},
                  ],
                }
              : _sourceCampus(2, revision: 1),
          assetLoader: (asset) async => jsonEncode(
            asset == 'catalog.json'
                ? {
                    'campuses': [
                      {'id': 'v-78', 'revision': 2},
                    ],
                  }
                : _sourceCampus(2),
          ),
        );
        addTearDown(repository.dispose);
        expect((await repository.loadCatalog()).entries.single.revision, 1);
        final campus = await repository.loadCampus('v-78');
        expect(campus.revision, 1);
        expect(campus.origin, MapDataOrigin.remote);
        expect(campus.canModerate, isTrue);
        expect(campus.warning, isNull);
      },
    );

    test(
      'bundled and published revision counters never share a parsed plan key',
      () async {
        var offline = true;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          bundledCatalogAsset: 'catalog.json',
          rpc: (_, _) async {
            if (offline) throw const MapDataException('offline');
            return _sourceCampus(2);
          },
          assetLoader: (asset) async => jsonEncode(
            asset == 'catalog.json'
                ? {
                    'campuses': [
                      {'id': 'v-78', 'revision': 2},
                    ],
                  }
                : _sourceCampus(2),
          ),
        );
        addTearDown(repository.dispose);
        final bundled = await repository.loadCampus('v-78');
        offline = false;
        final published = await repository.refreshCampus('v-78');
        expect(bundled.revision, published.revision);
        expect(
          bundled.floors.single.floor.svgPath,
          isNot(published.floors.single.floor.svgPath),
        );
      },
    );

    for (final cachedRevision in [1, 2, 3]) {
      test(
        'offline compares source capture $cachedRevision without counters',
        () async {
          final cache = _MemoryCache()
            ..entries['mirea:campus:v-78'] = jsonEncode(
              _sourceCampus(cachedRevision, revision: 17),
            )
            ..entries['mirea:catalog'] = jsonEncode({
              'campuses': [
                {'id': 'v-78', 'revision': cachedRevision},
              ],
            });
          final repository = MapDataRepository(
            organizationId: 'mirea',
            cache: cache,
            bundledCatalogAsset: 'catalog.json',
            rpc: (_, _) async => throw const MapDataException('offline'),
            assetLoader: (asset) async => jsonEncode(
              asset == 'catalog.json'
                  ? {
                      'campuses': [
                        {'id': 'v-78', 'revision': 2},
                        {'id': 'mp-1', 'revision': 1},
                      ],
                    }
                  : {
                      ..._sourceCampus(2),
                      'rooms': [
                        {
                          'id': 'native-new',
                          'floor_id': 'first',
                          'label': 'А-101',
                          'legacy_ids': ['room-1'],
                        },
                      ],
                    },
            ),
          );
          addTearDown(repository.dispose);
          final catalog = await repository.loadCatalog();
          expect(catalog.entries.map((e) => e.id), contains('mp-1'));
          final campus = await repository.loadCampus('v-78');
          expect(campus.revision, cachedRevision >= 2 ? 17 : 2);
          expect(
            campus.origin,
            cachedRevision >= 2 ? MapDataOrigin.cache : MapDataOrigin.bundled,
          );
          expect(campus.canModerate, isFalse);
          expect(
            campus.placeForId('room-1')?.id,
            cachedRevision >= 2 ? 'room-1' : 'native-new',
          );
        },
      );
    }

    test(
      'malformed newer bundle falls back to the last valid cached plan',
      () async {
        final cache = _MemoryCache()
          ..entries['mirea:campus:v-78'] = jsonEncode(_campus(revision: 1));
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          bundledCatalogAsset: 'catalog.json',
          rpc: (_, _) async => throw const MapDataException('offline'),
          assetLoader: (asset) async => jsonEncode(
            asset == 'catalog.json'
                ? {
                    'campuses': [
                      {'id': 'v-78', 'revision': 2},
                    ],
                  }
                : {..._sourceCampus(2), 'floors': <Object?>[]},
          ),
        );
        addTearDown(repository.dispose);
        final campus = await repository.loadCampus('v-78');
        expect(campus.origin, MapDataOrigin.cache);
        expect(campus.revision, 1);
        expect(
          await repository.loadSvg(campus.floors.single.floor.svgPath),
          _svg,
        );
      },
    );

    test('loads published plans and names from the campus RPC', () async {
      final calls = <String>[];
      final cache = _MemoryCache();
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        rpc: (name, parameters) async {
          calls.add(name);
          expect(parameters['p_campus_id'], 'v-78');
          return _campus();
        },
      );
      addTearDown(repository.dispose);

      final campus = await repository.loadCampus('v-78');
      expect(campus.campus.displayName, 'В-78');
      expect(campus.placeForId('room-1')?.equipment, ['Проектор']);
      expect(campus.canModerate, isTrue);
      expect(campus.origin, MapDataOrigin.remote);
      expect(
        await repository.loadSvg(campus.campus.floors.single.svgPath),
        _svg,
      );
      expect(calls, ['get_map_campus']);
      expect(
        jsonDecode(cache.entries.values.single),
        containsPair('can_moderate', false),
      );
    });

    test(
      'restores persistent offline data without moderator capabilities',
      () async {
        final cache = _MemoryCache();
        final online = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (_, _) async => _campus(),
        );
        addTearDown(online.dispose);
        await online.loadCampus('v-78');

        final offline = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (_, _) async => throw const MapDataException('offline'),
        );
        addTearDown(offline.dispose);
        final restored = await offline.loadCampus('v-78');
        expect(restored.origin, MapDataOrigin.cache);
        expect(restored.canModerate, isFalse);
        expect(restored.warning, isNotEmpty);
        expect(
          await offline.loadSvg(restored.campus.floors.single.svgPath),
          _svg,
        );
      },
    );

    test('explicit refresh fetches a newer revision', () async {
      var requests = 0;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _MemoryCache(),
        rpc: (_, _) async => _campus(revision: ++requests),
      );
      addTearDown(repository.dispose);
      expect((await repository.loadCampus('v-78')).revision, 1);
      expect((await repository.loadCampus('v-78')).revision, 1);
      expect((await repository.refreshCampus('v-78')).revision, 2);
      expect(requests, 2);
    });

    test(
      'malformed refreshed documents preserve the last valid snapshot',
      () async {
        var malformed = false;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          rpc: (_, _) async => {
            ..._campus(),
            if (malformed) 'short_title': 123,
          },
        );
        addTearDown(repository.dispose);
        await repository.loadCampus('v-78');
        malformed = true;
        final recovered = await repository.refreshCampus('v-78');
        expect(recovered.campus.displayName, 'В-78');
        expect(recovered.origin, MapDataOrigin.cache);
        expect(recovered.canModerate, isFalse);
      },
    );

    test(
      'never caches community writes and preserves conflict errors',
      () async {
        final cache = _MemoryCache();
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          rpc: (name, parameters) async => throw const PostgrestException(
            message: 'Revision changed',
            code: '40001',
          ),
        );
        addTearDown(repository.dispose);
        await expectLater(
          repository.reviewProposal('proposal', approve: true),
          throwsA(
            isA<MapDataException>().having(
              (error) => error.code,
              'code',
              '40001',
            ),
          ),
        );
        expect(cache.entries, isEmpty);
      },
    );

    test(
      'proposal summaries preserve keys and load full details separately',
      () async {
        final calls = <String>[];
        final repository = MapDataRepository(
          organizationId: 'mirea',
          rpc: (name, parameters) async {
            calls.add(name);
            if (name == 'get_map_proposals') {
              return {
                'proposals': [
                  {
                    'id': 'proposal',
                    'patch_keys': ['nodes', 'edges'],
                    'patch_bytes': 9053801,
                    'has_full_patch': false,
                  },
                ],
              };
            }
            expect(name, 'get_map_proposal');
            expect(parameters, {'p_proposal_id': 'proposal'});
            return {
              'id': 'proposal',
              'has_full_patch': true,
              'patch': {
                'nodes': <Object?>[],
                'edges': <Object?>[],
              },
            };
          },
        );
        addTearDown(repository.dispose);
        final summary = (await repository.getProposals(
          'v-78',
        )).proposals.single;
        expect(summary.patch, isEmpty);
        expect(summary.hasFullPatch, isFalse);
        expect(summary.patchKeys, ['nodes', 'edges']);
        expect(summary.patchBytes, 9053801);
        expect(calls, ['get_map_proposals']);
        final detail = await repository.getProposal(summary.id);
        expect(detail.hasFullPatch, isTrue);
        expect(detail.patchKeys, ['nodes', 'edges']);
        expect(calls, ['get_map_proposals', 'get_map_proposal']);
      },
    );

    test(
      'proposal detail rejects wrong identity and incomplete responses',
      () async {
        for (final response in [
          {
            'id': 'another',
            'patch': {'label': 'Room'},
          },
          {
            'id': 'proposal',
            'patch_keys': ['label'],
            'has_full_patch': false,
          },
        ]) {
          final repository = MapDataRepository(
            organizationId: 'mirea',
            rpc: (_, _) async => response,
          );
          addTearDown(repository.dispose);
          await expectLater(
            repository.getProposal('proposal'),
            throwsFormatException,
          );
        }
      },
    );

    test('proposal detail preserves permission errors', () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        rpc: (_, _) async => throw const PostgrestException(
          message: 'Unavailable',
          code: '42501',
        ),
      );
      addTearDown(repository.dispose);
      await expectLater(
        repository.getProposal('proposal'),
        throwsA(
          isA<MapDataException>().having(
            (error) => error.code,
            'code',
            '42501',
          ),
        ),
      );
    });

    test('legacy full patch fixtures remain directly reviewable', () {
      final proposal = MapProposal.fromJson({
        'id': 'proposal',
        'patch': {'label': 'А-201'},
      });
      expect(proposal.hasFullPatch, isTrue);
      expect(proposal.patchKeys, ['label']);
    });

    test('deduplicates simultaneous remote SVG downloads', () async {
      var requests = 0;
      final client = MockClient((request) async {
        requests++;
        return http.Response(_svg, 200);
      });
      addTearDown(client.close);
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _MemoryCache(),
        httpClient: client,
        rpc: (_, _) async => null,
      );
      addTearDown(repository.dispose);
      final results = await Future.wait([
        repository.loadSvg('https://example.org/floor.svg'),
        repository.loadSvg('https://example.org/floor.svg'),
      ]);
      expect(results, [_svg, _svg]);
      expect(requests, 1);
    });

    test(
      'a reused image URL never mixes SVG from an older campus revision',
      () async {
        var revision = 1;
        var available = true;
        final cache = _MemoryCache();
        final client = MockClient((request) async {
          expect(request.url.toString(), 'https://example.org/floor.svg');
          return available
              ? http.Response(_svg, 200)
              : http.Response('offline', 503);
        });
        addTearDown(client.close);
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: cache,
          httpClient: client,
          rpc: (_, _) async => {
            ..._campus(revision: revision),
            'floors': [
              {
                'id': 'first',
                'level': 1,
                'image_url': 'https://example.org/floor.svg',
                'width': 100,
                'height': 100,
              },
            ],
          },
        );
        addTearDown(repository.dispose);
        final previous = await repository.loadCampus('v-78');
        expect(
          await repository.loadSvg(previous.campus.floors.single.svgPath),
          _svg,
        );
        revision = 2;
        available = false;
        final current = await repository.refreshCampus('v-78');
        expect(
          current.campus.floors.single.svgPath,
          previous.campus.floors.single.svgPath,
        );
        expect(current.origin, MapDataOrigin.cache);
        expect(current.revision, previous.revision);
        expect(
          await repository.loadSvg(current.campus.floors.single.svgPath),
          _svg,
        );
      },
    );

    test('does not cache a broken or active remote floor plan', () async {
      final cache = _MemoryCache();
      final client = MockClient(
        (_) async => http.Response('<svg><script /></svg>', 200),
      );
      addTearDown(client.close);
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: cache,
        httpClient: client,
        rpc: (_, _) async => null,
      );
      addTearDown(repository.dispose);
      await expectLater(
        repository.loadSvg('https://example.org/floor.svg'),
        throwsFormatException,
      );
      expect(cache.entries, isEmpty);
    });

    test(
      'falls back to bundled catalog when both server and cache fail',
      () async {
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _MemoryCache(),
          rpc: (_, _) async => throw const MapDataException('offline'),
        );
        addTearDown(repository.dispose);
        final catalog = await repository.loadCatalog();
        expect(catalog.origin, MapDataOrigin.bundled);
        expect(catalog.entries, isEmpty);
        expect(catalog.warning, isNotEmpty);
      },
    );
  });

  test('loads an attributed imported campus before backend rollout', () async {
    final cache = _MemoryCache();
    final repository = MapDataRepository(
      organizationId: 'mirea',
      cache: cache,
      bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
      rpc: (_, _) async => throw const MapDataException('not deployed'),
      assetLoader: (path) async {
        if (path == MapDataRepository.pulseCatalogAsset) {
          return jsonEncode({
            'campuses': [
              {'id': 'v-78', 'short_title': 'В-78'},
            ],
          });
        }
        expect(path, 'packages/app_ui/assets/maps/pulse/campus_v-78.json');
        return jsonEncode(_campus());
      },
    );
    addTearDown(repository.dispose);
    final catalog = await repository.loadCatalog();
    expect(catalog.entries.single.id, 'v-78');
    expect(catalog.origin, MapDataOrigin.bundled);
    final campus = await repository.loadCampus('v-78');
    expect(campus.origin, MapDataOrigin.bundled);
    expect(campus.canModerate, isFalse);
    expect(campus.sourceUrl, 'https://pulse.mirea.ru/services/maps');
    expect(await repository.loadSvg(campus.campus.floors.single.svgPath), _svg);
    expect(cache.entries, isEmpty);
  });

  group('SVG validation', () {
    test('accepts a regular plan and local symbol references', () {
      expect(MapDataRepository.validateSvg(_svg), _svg);
      expect(
        MapDataRepository.validateSvg(
          '<svg viewBox="0 0 100 100"><use href="#room" /></svg>',
        ),
        isNotEmpty,
      );
      expect(
        MapDataRepository.validateSvg(
          '<svg viewBox="0 0 100 100"> '
          '<rect fill="url(&quot;#paint&quot;)" /></svg>',
        ),
        isNotEmpty,
      );
    });

    for (final svg in [
      '<svg><script>alert(1)</script></svg>',
      '<svg><rect onclick="bad()" /></svg>',
      '<svg><image href="https://example.org/pixel" /></svg>',
      '<svg><foreignObject /></svg>',
      '<!DOCTYPE svg><svg />',
      '<svg><rect fill="url(https://example.org/resource)" /></svg>',
      '<svg><style>@import url(https://example.org/style)</style></svg>',
      '<svg viewBox="10 20 100 100" />',
      '<svg viewBox="0 0 NaN 100" />',
    ]) {
      test('rejects active or external resource: $svg', () {
        expect(
          () => MapDataRepository.validateSvg(
            svg.replaceFirst('<svg>', '<svg viewBox="0 0 100 100">'),
          ),
          throwsFormatException,
        );
      });
    }
  });
}
