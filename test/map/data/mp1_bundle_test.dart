import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'MP-1 canonical plans preserve six floors and 488 interactive places',
    () async {
      final source = await rootBundle.loadString(
        'packages/app_ui/assets/maps/pulse/campus_mp-1.json',
      );
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _NoCache(),
        rpc: (_, _) async => jsonDecode(source),
      );
      addTearDown(repository.dispose);
      final campus = await repository.loadCampus('mp-1');
      final parser = SvgRoomParser(onLoadSvg: repository.loadSvg);
      expect(campus.origin, MapDataOrigin.remote);
      expect(campus.floors.map((f) => f.floor.number), [-1, 1, 2, 3, 4, 5]);
      expect(campus.rooms, hasLength(488));
      expect(campus.sourceLabel, contains('МП-1'));
      expect(campus.sourceUrl, isNot(contains('pulse.mirea.ru')));
      expect(campus.graph['nodes'], isEmpty);
      expect(campus.rooms.where((r) => r.label == 'А-005'), hasLength(2));
      expect(campus.rooms.any((r) => r.label == 'Ка-311'), isTrue);
      for (final floor in campus.floors) {
        final structure = MapStructureLayers.fromSvg(
          await repository.loadSvg(floor.floor.svgPath),
        );
        expect(structure.foundationShapes.length, greaterThan(20));
        expect(
          structure.foundationShapes.every(
            (shape) => shape.path.getBounds().isFinite,
          ),
          isTrue,
        );
        final (rooms, bounds) = await parser.parseSvg(floor.floor.svgPath);
        final places = campus.rooms.where((r) => r.floorId == floor.floor.id);
        expect(
          rooms.map((r) => r.roomId).toSet(),
          places.map((r) => r.id).toSet(),
        );
        expect(bounds.width, closeTo(floor.width, 0.01));
        expect(bounds.height, closeTo(floor.height, 0.01));
        for (final place in places) {
          final room = rooms.singleWhere((r) => r.roomId == place.id);
          expect(
            room.path
                .getBounds()
                .inflate(0.01)
                .contains(Offset(place.x, place.y)),
            isTrue,
            reason: '${floor.floor.id}/${place.label}',
          );
          expect(room.name, place.label);
        }
      }
    },
  );
}
