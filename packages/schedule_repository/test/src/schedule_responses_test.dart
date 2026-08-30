import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ScheduleTargetRow', () {
    test('uses generated snake-case JSON and a stable display title', () {
      final row = ScheduleTargetRow.fromJson({
        'external_id': 'group-1',
        'target_title': 'IU7-31B',
        'full_title': '',
      });

      expect(row.title, 'IU7-31B');
      expect(row.toJson(), {
        'external_id': 'group-1',
        'target_title': 'IU7-31B',
        'full_title': '',
      });
      expect(row.copyWith(fullTitle: 'IU7-31B — Databases'), isNot(row));
    });
  });

  group('Schedule responses', () {
    test('have immutable value equality and generated copyWith', () {
      const response = ScheduleResponse(data: []);
      const groups = SearchGroupsResponse(results: []);

      expect(response.copyWith(), response);
      expect(groups.copyWith(), groups);
    });
  });
}
