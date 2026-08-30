import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/month_load.dart';

void main() {
  group('monthCellLoadLevel', () {
    test('an empty day has no load bars', () {
      expect(monthCellLoadLevel(0), 0);
      expect(monthCellLoadLevel(-1), 0);
    });

    test('a light day (1–2 lessons) shows one bar', () {
      expect(monthCellLoadLevel(1), 1);
      expect(monthCellLoadLevel(2), 1);
    });

    test('a medium day (3–5 lessons) shows two bars', () {
      expect(monthCellLoadLevel(3), 2);
      expect(monthCellLoadLevel(5), 2);
    });

    test('a heavy day (> 5 lessons) shows three bars', () {
      expect(monthCellLoadLevel(6), 3);
      expect(monthCellLoadLevel(9), 3);
    });
  });
}
