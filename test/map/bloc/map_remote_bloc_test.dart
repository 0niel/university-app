import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';

class _Cache implements MapDataCache {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'remote catalog retains local MP-1 without duplicate campuses or RPC',
    () async {
      final campusRequests = <String>[];
      const svg =
          '<svg viewBox="0 0 100 100"> <rect data-object="r1" width="10" height="10" /></svg>';
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        assetLoader: (_) async => svg,
        rpc: (name, params) async {
          if (name == 'get_map_catalog') {
            return {
              'campuses': [
                {'id': 'v-78', 'short_title': 'В-78'},
                {'id': 'v-86', 'short_title': 'В-86'},
                {'id': 's-20', 'short_title': 'С-20'},
              ],
            };
          }
          campusRequests.add(params['p_campus_id']! as String);
          return {
            'id': 'v-78',
            'short_title': 'В-78',
            'revision': 1,
            'floors': [
              {'id': 'f1', 'level': 1, 'width': 100, 'height': 100, 'svg': svg},
            ],
          };
        },
      );
      addTearDown(repository.dispose);
      const localFloor = FloorModel(
        id: 'local1',
        number: 1,
        svgPath: 'local.svg',
      );
      const mp = CampusModel(
        id: 'mp-1',
        displayName: 'МП-1',
        floors: [localFloor],
      );
      final bloc = MapBloc(
        availableCampuses: const [
          CampusModel(
            id: 'legacy-v78',
            displayName: 'В-78',
            floors: [localFloor],
          ),
          mp,
        ],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      addTearDown(bloc.close);
      final initialized = bloc.stream.firstWhere(
        (state) => state.status == MapStatus.loaded,
      );
      bloc.add(const MapEvent.initialized());
      await initialized;
      expect(bloc.state.availableCampuses.map((campus) => campus.id), [
        'v-78',
        'v-86',
        's-20',
        'mp-1',
      ]);
      final selected = bloc.stream.firstWhere(
        (state) =>
            state.status == MapStatus.loaded &&
            state.selectedCampus?.id == 'mp-1',
      );
      bloc.add(const MapEvent.campusSelected(mp));
      await selected;
      expect(campusRequests, ['v-78']);
      expect(bloc.state.rooms.single.roomId, 'r1');
    },
  );

  test(
    'adds bounded hit areas only for missing geometry on the active floor',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        rpc: (name, _) async => name == 'get_map_catalog'
            ? {
                'campuses': [
                  {'id': 'v-86', 'short_title': 'В-86'},
                ],
              }
            : {
                'id': 'v-86',
                'short_title': 'В-86',
                'revision': 1,
                'floors': [
                  {
                    'id': 'f1',
                    'level': 1,
                    'width': 100,
                    'height': 100,
                    'svg':
                        '<svg viewBox="0 0 100 100"> <rect data-object="existing" x="40" y="40" width="10" height="10" /></svg>',
                  },
                ],
                'rooms': [
                  {
                    'id': 'existing',
                    'floor_id': 'f1',
                    'label': '101',
                    'x': 45,
                    'y': 45,
                  },
                  {
                    'id': 'new',
                    'floor_id': 'f1',
                    'label': 'Банкомат',
                    'x': 1,
                    'y': 1,
                  },
                  {
                    'id': 'other-floor',
                    'floor_id': 'f2',
                    'label': 'Буфет',
                    'x': 30,
                    'y': 30,
                  },
                  {
                    'id': 'outside',
                    'floor_id': 'f1',
                    'label': 'Ошибка',
                    'x': -1,
                    'y': 30,
                  },
                  {'id': 'unknown', 'floor_id': 'f1', 'label': 'Без координат'},
                ],
              },
      );
      addTearDown(repository.dispose);
      final bloc = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      addTearDown(bloc.close);
      final initialized = bloc.stream.firstWhere(
        (state) => state.status == MapStatus.loaded,
      );
      bloc.add(const MapEvent.initialized());
      await initialized;
      expect(bloc.state.rooms.map((room) => room.roomId), ['existing', 'new']);
      expect(bloc.syntheticRoomIds, {'new'});
      expect(
        bloc.state.rooms.first.path.getBounds(),
        const Rect.fromLTWH(40, 40, 10, 10),
      );
      final markerBounds = bloc.state.rooms.last.path.getBounds();
      expect(markerBounds.left, greaterThanOrEqualTo(-0.000001));
      expect(markerBounds.top, greaterThanOrEqualTo(-0.000001));
      expect(markerBounds.right, lessThanOrEqualTo(100));
      expect(markerBounds.bottom, lessThanOrEqualTo(100));
    },
  );

  test(
    'loads remote geometry and labels, refresh keeps the selected floor',
    () async {
      var revision = 1;
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        rpc: (name, parameters) async {
          if (name == 'get_map_catalog') {
            return {
              'campuses': [
                {'id': 'v-86', 'short_title': 'В-86'},
              ],
            };
          }
          return {
            'id': 'v-86',
            'short_title': 'В-86',
            'revision': revision,
            'source_url': 'https://pulse.mirea.ru/services/maps',
            'floors': [
              for (final level in [1, 2])
                {
                  'id': 'f$level',
                  'level': level,
                  'width': 100,
                  'height': 100,
                  'svg':
                      '<svg viewBox="0 0 100 100"> <rect data-object="r$level" width="10" height="10" /></svg>',
                },
            ],
            'rooms': [
              {'id': 'r1', 'floor_id': 'f1', 'label': 'А-101'},
              {'id': 'r2', 'floor_id': 'f2', 'label': 'А-20$revision'},
            ],
          };
        },
      );
      addTearDown(repository.dispose);
      final bloc = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      addTearDown(bloc.close);
      final initialized = bloc.stream.firstWhere(
        (state) => state.status == MapStatus.loaded,
      );
      bloc.add(const MapEvent.initialized());
      await initialized;
      expect(bloc.state.rooms.single.name, 'А-101');
      expect(bloc.state.svgContent, contains('data-object="r1"'));
      expect(bloc.state.isOffline, isFalse);

      final campus = bloc.state.selectedCampus!;
      final secondFloor = campus.floors.last;
      final selected = bloc.stream.firstWhere(
        (state) =>
            state.status == MapStatus.loaded && state.selectedFloor?.id == 'f2',
      );
      bloc.add(MapEvent.floorSelected(floor: secondFloor, campus: campus));
      await selected;
      revision = 2;
      final refreshed = bloc.stream.firstWhere(
        (state) =>
            state.status == MapStatus.loaded && state.campusData?.revision == 2,
      );
      bloc.add(const MapEvent.refreshRequested());
      await refreshed;
      expect(bloc.state.selectedFloor?.id, 'f2');
      expect(bloc.state.rooms.single.name, 'А-202');
      expect(bloc.state.svgContent, contains('data-object="r2"'));
    },
  );

  test(
    'empty server and bundled catalogs report failure',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _Cache(),
        rpc: (_, _) async => {'campuses': <Object?>[]},
      );
      addTearDown(repository.dispose);
      final bloc = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      addTearDown(bloc.close);
      final failed = bloc.stream.firstWhere(
        (state) => state.status == MapStatus.failure,
      );
      bloc.add(const MapEvent.initialized());
      expect((await failed).errorMessage, contains('Нет доступных планов'));
    },
  );
}
