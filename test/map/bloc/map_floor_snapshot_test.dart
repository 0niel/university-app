import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';

class _Cache implements MapDataCache {
  final _entries = <String, String>{};

  @override
  Future<String?> read(String key) async => _entries[key];

  @override
  Future<void> write(String key, String value) async => _entries[key] = value;
}

class _UnavailableFloorRepository extends MapDataRepository {
  _UnavailableFloorRepository({required super.rpc})
    : super(organizationId: 'mirea', cache: _Cache());

  bool unavailable = true;

  @override
  Future<String> loadSvg(String path, {CampusMapData? campus}) {
    if (unavailable && path.contains('/f2/')) {
      throw const FormatException('Floor plan is unavailable');
    }
    return super.loadSvg(path, campus: campus);
  }
}

class _PendingFloorRepository extends MapDataRepository {
  _PendingFloorRepository({required super.rpc})
    : super(organizationId: 'mirea', cache: _Cache());

  final entered = Completer<void>();
  final pending = Completer<String>();

  @override
  Future<String> loadSvg(String path, {CampusMapData? campus}) {
    if (path.contains('/f2/')) {
      if (!entered.isCompleted) entered.complete();
      return pending.future;
    }
    if (path.contains('/f3/')) {
      throw const FormatException('Floor plan is unavailable');
    }
    return super.loadSvg(path, campus: campus);
  }
}

Map<String, Object?> _campus({
  required int revision,
  required int position,
  bool includeThirdFloor = false,
}) => {
  'id': 'campus',
  'revision': revision,
  'floors': [
    for (final level in [1, 2, if (includeThirdFloor) 3])
      {
        'id': 'f$level',
        'level': level,
        'width': 100,
        'height': 100,
        'svg':
            '<svg viewBox="0 0 100 100"><rect data-object="room-$level" '
            'x="$position" y="10" width="20" height="20" /></svg>',
      },
  ],
  'rooms': [
    for (final level in [1, 2, if (includeThirdFloor) 3])
      {
        'id': 'room-$level',
        'floor_id': 'f$level',
        'label': '$position-$level',
      },
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final nextRevision in [1, 2]) {
    test(
      'floor selection pins the displayed snapshot after repository refresh '
      'to revision $nextRevision',
      () async {
        var revision = 1;
        var position = 10;
        final repository = MapDataRepository(
          organizationId: 'mirea',
          cache: _Cache(),
          rpc: (name, _) async => name == 'get_map_catalog'
              ? {
                  'campuses': [
                    {'id': 'campus', 'revision': revision},
                  ],
                }
              : _campus(revision: revision, position: position),
        );
        final bloc = MapBloc(
          availableCampuses: [],
          repository: repository,
          objectsService: ObjectsService(
            onLoadObjects: (_) async => '{"objects":[]}',
          ),
        );
        addTearDown(() async {
          await bloc.close();
          repository.dispose();
        });
        final initialized = bloc.stream.firstWhere(
          (state) => state.status == .loaded && state.roomFloors.length == 2,
        );
        bloc.add(const MapEvent.initialized());
        await initialized;
        final displayed = bloc.state.campusData!;
        final campus = bloc.state.selectedCampus!;
        expect(bloc.state.selectedFloor?.id, 'f1');

        revision = nextRevision;
        position = 20;
        final refreshed = await repository.refreshCampus('campus');
        expect(refreshed, isNot(same(displayed)));
        expect(bloc.state.campusData, same(displayed));
        final selected = bloc.stream.firstWhere(
          (state) => state.status == .loaded || state.status == .failure,
        );
        bloc.add(
          MapEvent.floorSelected(campus: campus, floor: campus.floors.last),
        );
        final floor = await selected;
        expect(floor.status, MapStatus.loaded, reason: floor.errorMessage);
        expect(floor.selectedFloor?.id, 'f2');
        expect(floor.campusData, same(displayed));
        expect(floor.rooms.single.path.getBounds().left, 10);
        expect(floor.rooms.single.name, '10-2');
        expect(floor.svgContent, contains('x="10"'));

        final updated = bloc.stream.firstWhere(
          (state) => state.status == .loaded || state.status == .failure,
        );
        bloc.add(const MapEvent.refreshRequested());
        final current = await updated;
        expect(current.status, MapStatus.loaded, reason: current.errorMessage);
        expect(current.selectedFloor?.id, 'f2');
        expect(current.campusData?.revision, nextRevision);
        expect(current.rooms.single.path.getBounds().left, 20);
        expect(current.rooms.single.name, '20-2');
        expect(current.svgContent, contains('x="20"'));
      },
    );
  }

  test(
    'a failed floor switch restores the complete plan and can retry',
    () async {
      final repository = _UnavailableFloorRepository(
        rpc: (name, _) async => name == 'get_map_catalog'
            ? {
                'campuses': [
                  {'id': 'campus', 'revision': 1},
                ],
              }
            : _campus(revision: 1, position: 10),
      );
      final bloc = MapBloc(
        availableCampuses: [],
        repository: repository,
        objectsService: ObjectsService(
          onLoadObjects: (_) async => '{"objects":[]}',
        ),
      );
      addTearDown(() async {
        await bloc.close();
        repository.dispose();
      });
      final initialized = bloc.stream.firstWhere(
        (state) => state.status == .loaded && state.roomFloors.length == 2,
      );
      bloc.add(const MapEvent.initialized());
      await initialized;
      final previous = bloc.state;
      final campus = previous.selectedCampus!;
      final failed = bloc.stream.firstWhere(
        (state) => state.errorMessage != null,
      );
      bloc.add(
        MapEvent.floorSelected(campus: campus, floor: campus.floors.last),
      );
      final restored = await failed;
      expect(restored.status, MapStatus.loaded);
      expect(restored.copyWith(errorMessage: null), previous);
      expect(restored.errorMessage, contains('Floor plan is unavailable'));

      repository.unavailable = false;
      final retried = bloc.stream.firstWhere(
        (state) => state.status == .loaded && state.selectedFloor?.id == 'f2',
      );
      bloc.add(
        MapEvent.floorSelected(campus: campus, floor: campus.floors.last),
      );
      final selected = await retried;
      expect(selected.errorMessage, isNull);
      expect(selected.campusData, same(previous.campusData));
      expect(selected.rooms.single.name, '10-2');
      expect(selected.svgContent, contains('x="10"'));
    },
  );

  test('an initial failed floor selection remains a loading failure', () async {
    final repository = _UnavailableFloorRepository(
      rpc: (_, _) async => _campus(revision: 1, position: 10),
    );
    final campus = (await repository.loadCampus('campus')).campus;
    final bloc = MapBloc(
      availableCampuses: [],
      repository: repository,
      objectsService: ObjectsService(
        onLoadObjects: (_) async => '{"objects":[]}',
      ),
    );
    addTearDown(() async {
      await bloc.close();
      repository.dispose();
    });
    final failed = bloc.stream.firstWhere((state) => state.status == .failure);
    bloc.add(
      MapEvent.floorSelected(campus: campus, floor: campus.floors.last),
    );
    final state = await failed;
    expect(state.selectedFloor, isNull);
    expect(state.campusData, isNull);
    expect(state.svgContent, isNull);
    expect(state.errorMessage, contains('Floor plan is unavailable'));
  });

  test('a superseding failed floor restores the plan during loading', () async {
    const pendingSvg =
        '<svg viewBox="0 0 100 100"><rect data-object="room-2" '
        'x="10" y="10" width="20" height="20" /></svg>';
    final repository = _PendingFloorRepository(
      rpc: (name, _) async => name == 'get_map_catalog'
          ? {
              'campuses': [
                {'id': 'campus', 'revision': 1},
              ],
            }
          : _campus(revision: 1, position: 10, includeThirdFloor: true),
    );
    final bloc = MapBloc(
      availableCampuses: [],
      repository: repository,
      objectsService: ObjectsService(
        onLoadObjects: (_) async => '{"objects":[]}',
      ),
    );
    addTearDown(() async {
      if (!repository.pending.isCompleted) {
        repository.pending.complete(pendingSvg);
      }
      await bloc.close();
      repository.dispose();
    });
    final initialized = bloc.stream.firstWhere(
      (state) => state.status == .loaded && state.roomFloors.length == 3,
    );
    bloc.add(const MapEvent.initialized());
    await initialized;
    final previous = bloc.state;
    final campus = previous.selectedCampus!;
    bloc.add(
      MapEvent.floorSelected(campus: campus, floor: campus.floors[1]),
    );
    await repository.entered.future;
    expect(bloc.state.status, MapStatus.loading);
    final failed = bloc.stream.firstWhere(
      (state) => state.errorMessage != null,
    );
    bloc.add(
      MapEvent.floorSelected(campus: campus, floor: campus.floors.last),
    );
    final restored = await failed;
    expect(restored.status, MapStatus.loaded);
    expect(restored.copyWith(errorMessage: null), previous);
    repository.pending.complete(pendingSvg);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, restored);
  });
}
