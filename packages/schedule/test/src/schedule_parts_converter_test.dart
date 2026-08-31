import 'package:collection/collection.dart';
import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  const converter = SchedulePartsConverter();

  test('decodes schedule parts with string JSON keys', () {
    final parts = converter.fromJson([
      {
        'type': HolidaySchedulePart.identifier,
        'title': 'Holiday',
        'dates': ['2026-07-15'],
      },
    ]);

    expect(parts, hasLength(1));
    expect(
      parts.firstOrNull,
      isA<HolidaySchedulePart>().having(
        (part) => part.title,
        'title',
        'Holiday',
      ),
    );
  });

  test('rejects non-object schedule parts', () {
    expect(
      () => converter.fromJson(['not an object']),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects JSON objects with non-string keys', () {
    expect(
      () => converter.fromJson([
        <Object?, Object?>{1: 'invalid'},
      ]),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'Expected JSON object keys to be strings',
        ),
      ),
    );
  });
}
