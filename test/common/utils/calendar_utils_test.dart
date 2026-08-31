import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';

void main() {
  group('CalendarUtils.getSemesterStart', () {
    test('keeps a weekday semester start', () {
      expect(
        CalendarUtils.getSemesterStart(mCurrentDate: DateTime(2026, 9, 10)),
        DateTime(2026, 9),
      );
    });

    test('moves a weekend semester start to the first Monday', () {
      expect(
        CalendarUtils.getSemesterStart(mCurrentDate: DateTime(2024, 9, 5)),
        DateTime(2024, 9, 2),
      );
    });

    test('uses the February semester date before the autumn cutoff', () {
      expect(
        CalendarUtils.getSemesterStart(mCurrentDate: DateTime(2026, 2, 12)),
        DateTime(2026, 2, 9),
      );
    });
  });

  test('getDaysInWeek returns a Monday through Sunday interval', () {
    expect(
      CalendarUtils.getDaysInWeek(1, DateTime(2026, 9, 10)),
      <DateTime>[
        DateTime(2026, 8, 31),
        DateTime(2026, 9),
        DateTime(2026, 9, 2),
        DateTime(2026, 9, 3),
        DateTime(2026, 9, 4),
        DateTime(2026, 9, 5),
        DateTime(2026, 9, 6),
      ],
    );
  });
}
