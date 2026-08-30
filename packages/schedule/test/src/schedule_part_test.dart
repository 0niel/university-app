import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  test(
    'SchedulePart returns UnknownSchedulePart for an unknown discriminator',
    () {
      final part = SchedulePart.fromJson({'type': 'unsupported'});

      expect(part, isA<UnknownSchedulePart>());
    },
  );

  test('SchedulePart normalizes legacy calendar event discriminators', () {
    final part = SchedulePart.fromJson({
      'type': 'exam',
      'title': 'Calculus exam',
      'dates': <String>['2026-07-14'],
    });

    expect(
      part,
      isA<CalendarSchedulePart>()
          .having((value) => value.kind, 'kind', 'exam')
          .having(
            (value) => value.type,
            'type',
            CalendarSchedulePart.identifier,
          ),
    );
  });

  test('CalendarSchedulePart defaults its kind for its own discriminator', () {
    final part = CalendarSchedulePart.fromJson({
      'type': CalendarSchedulePart.identifier,
      'title': 'Open day',
      'dates': <String>['2026-07-14'],
    });

    expect(part.kind, 'event');
  });
}
