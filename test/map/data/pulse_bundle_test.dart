import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/services/svg_room_parser.dart';

class _NoCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'all imported Pulse plans load offline with matching room coordinates',
    () async {
      final repository = MapDataRepository(
        organizationId: 'mirea',
        cache: _NoCache(),
        bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
        rpc: (_, _) async => throw const MapDataException('API not deployed'),
      );
      addTearDown(repository.dispose);
      final catalog = await repository.loadCatalog();
      expect(
        catalog.entries.map((entry) => entry.id),
        containsAll(['v-78', 'v-86', 's-20']),
      );
      final parser = SvgRoomParser(onLoadSvg: repository.loadSvg);
      var floorCount = 0;
      var roomCount = 0;
      for (final entry in catalog.entries.where(
        (entry) => const {'v-78', 'v-86', 's-20'}.contains(entry.id),
      )) {
        final campus = await repository.loadCampus(entry.id);
        expect(campus.origin, MapDataOrigin.bundled);
        expect(campus.canModerate, isFalse);
        expect(campus.sourceUrl, startsWith('https://pulse.mirea.ru/'));
        for (final floor in campus.floors) {
          final context = '${entry.id}, floor ${floor.floor.number}';
          final (rooms, bounds) = await parser.parseSvg(floor.floor.svgPath);
          final metadata = campus.rooms.where(
            (room) => room.floorId == floor.floor.id,
          );
          expect(
            rooms.map((room) => room.roomId).toSet(),
            metadata.map((room) => room.id).toSet(),
            reason: context,
          );
          expect(bounds.width, closeTo(floor.width, 0.01), reason: context);
          expect(bounds.height, closeTo(floor.height, 0.01), reason: context);
          expect(bounds.left, 0, reason: context);
          expect(bounds.top, 0, reason: context);
          expect(
            rooms.every((room) => !room.path.getBounds().isEmpty),
            isTrue,
            reason: context,
          );
          expect(
            metadata.every(
              (room) =>
                  room.x.isFinite &&
                  room.y.isFinite &&
                  room.x >= 0 &&
                  room.y >= 0 &&
                  room.x <= floor.width &&
                  room.y <= floor.height,
            ),
            isTrue,
            reason: context,
          );
          floorCount++;
          roomCount += rooms.length;
        }
      }
      expect(floorCount, 17);
      expect(roomCount, greaterThan(2000));
    },
  );
}
