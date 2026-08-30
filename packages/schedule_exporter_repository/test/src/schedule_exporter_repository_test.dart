import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';

void main() {
  group('ScheduleExporterRepository', () {
    test('can be instantiated', () {
      expect(ScheduleExporterRepository(), isA<ScheduleExporterRepository>());
    });
  });
}
