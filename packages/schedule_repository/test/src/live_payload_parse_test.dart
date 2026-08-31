import 'dart:convert';
import 'dart:io';

import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  // Regression harness: parses a captured production get_schedule_for_entity
  // payload. Skipped when the capture file is absent (CI).
  const capturePath = String.fromEnvironment('SCHEDULE_PAYLOAD');

  test('parses a captured production schedule payload', () {
    final path = capturePath.isNotEmpty
        ? capturePath
        : Platform.environment['SCHEDULE_PAYLOAD'] ?? '';
    if (path.isEmpty || !File(path).existsSync()) return;
    final raw = jsonDecode(File(path).readAsStringSync()) as List<dynamic>;
    var parsed = 0;
    for (final row in raw) {
      final part = SchedulePart.fromJson(
        Map<String, dynamic>.from(row as Map),
      );
      expect(part, isNotNull);
      parsed++;
    }
    expect(parsed, raw.length);
  });
}
