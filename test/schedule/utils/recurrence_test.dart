import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_repeat.dart';

void main() {
  // A date well inside the autumn semester so getPeriod() is stable.
  final reference = DateTime(2025, 9, 15);

  group('expandRepeat', () {
    test('everyWeek yields dates that all fall on the chosen weekday', () {
      final dates = expandRepeat(
        weekday: DateTime.wednesday,
        repeat: LessonRepeat.everyWeek,
        reference: reference,
      );
      expect(dates, isNotEmpty);
      expect(dates.every((d) => d.weekday == DateTime.wednesday), isTrue);
    });

    test('even and odd weeks partition the every-week set', () {
      final every = expandRepeat(
        weekday: DateTime.monday,
        repeat: LessonRepeat.everyWeek,
        reference: reference,
      );
      final even = expandRepeat(
        weekday: DateTime.monday,
        repeat: LessonRepeat.evenWeek,
        reference: reference,
      );
      final odd = expandRepeat(
        weekday: DateTime.monday,
        repeat: LessonRepeat.oddWeek,
        reference: reference,
      );

      expect(even.length + odd.length, every.length);
      expect({...even, ...odd}.length, every.length);
      expect(even.toSet().intersection(odd.toSet()), isEmpty);
    });

    test('custom generates no dates', () {
      expect(
        expandRepeat(weekday: DateTime.monday, repeat: LessonRepeat.custom),
        isEmpty,
      );
    });
  });

  group('inferRepeat', () {
    test('recognises a generated every-week set', () {
      final dates = expandRepeat(
        weekday: DateTime.tuesday,
        repeat: LessonRepeat.everyWeek,
        reference: reference,
      );
      expect(inferRepeat(dates, DateTime.tuesday), LessonRepeat.everyWeek);
    });

    test('recognises a generated even-week set', () {
      final dates = expandRepeat(
        weekday: DateTime.thursday,
        repeat: LessonRepeat.evenWeek,
        reference: reference,
      );
      expect(inferRepeat(dates, DateTime.thursday), LessonRepeat.evenWeek);
    });

    test('falls back to custom for an arbitrary set', () {
      final dates = [DateTime(2025, 9, 15), DateTime(2025, 9, 17)];
      expect(inferRepeat(dates, DateTime.monday), LessonRepeat.custom);
    });

    test('empty dates are custom', () {
      expect(inferRepeat(const [], DateTime.monday), LessonRepeat.custom);
    });
  });
}
