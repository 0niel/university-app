import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/map.dart';

void main() {
  group('ObjectsService', () {
    test('indexes room names and ignores other object types', () async {
      final service = ObjectsService(
        onLoadObjects: (_) async => '''
          {
            "objects": [
              {"id": "101", "name": "А-101", "type": "room"},
              {"id": "stairs", "name": "Лестница", "type": "stairs"},
              {"id": 42, "name": "Invalid", "type": "room"}
            ]
          }
        ''',
      );

      await service.loadObjects();

      expect(service.getNameById('101'), 'А-101');
      expect(service.getNameById('stairs'), isNull);
      expect(service.getNameById('42'), isNull);
    });

    test('keeps the previous index when a refresh is malformed', () async {
      var calls = 0;
      final service = ObjectsService(
        onLoadObjects: (_) async => switch (calls++) {
          0 => '{"objects":[{"id":"101","name":"А-101","type":"room"}]}',
          _ => '{"objects":"invalid"}',
        },
      );
      await service.loadObjects();

      await expectLater(service.loadObjects(), throwsFormatException);

      expect(service.getNameById('101'), 'А-101');
    });

    test('rejects a non-object manifest', () async {
      final service = ObjectsService(onLoadObjects: (_) async => '[]');

      await expectLater(service.loadObjects(), throwsFormatException);
    });
  });
}
