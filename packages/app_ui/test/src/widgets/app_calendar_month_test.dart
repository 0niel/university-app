import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../kit_harness.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final month = DateTime(2026, 9);

  testWidgets('renders a full month grid and reports the tapped day', (
    tester,
  ) async {
    DateTime? tapped;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppCalendarMonth(
            month: month,
            today: DateTime(2026, 9, 3),
            onMonthChanged: (_) {},
            onDaySelected: (day) => tapped = day,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('app-calendar-month-day-2026-9-15')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('app-calendar-month-day-2026-9-15')),
    );
    expect(tapped, DateTime(2026, 9, 15));
  });

  testWidgets('reports the next and previous month on arrow taps', (
    tester,
  ) async {
    DateTime? changedTo;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppCalendarMonth(
            month: month,
            onMonthChanged: (next) => changedTo = next,
            onDaySelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Next month'));
    expect(changedTo, DateTime(2026, 10));

    await tester.tap(find.byTooltip('Previous month'));
    expect(changedTo, DateTime(2026, 8));
  });

  testWidgets('draws a dot per colour returned for the day', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppCalendarMonth(
            month: month,
            onMonthChanged: (_) {},
            onDaySelected: (_) {},
            dotsForDay: (day) =>
                day.day == 10 ? [Colors.red, Colors.blue] : const [],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cell = find.byKey(
      const ValueKey('app-calendar-month-day-2026-9-10'),
    );
    expect(
      find.descendant(of: cell, matching: find.byType(AppDot)),
      findsNWidgets(2),
    );
  });
}
