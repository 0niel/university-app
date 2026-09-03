import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/view/events/events_calendar_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

void main() {
  final today = DateTime.now();

  DateTime sameMonthDay(int day) => DateTime(today.year, today.month, day);

  final otherDay = today.day <= 15
      ? sameMonthDay(today.day + 10)
      : sameMonthDay(today.day - 10);

  final todayEvent = CampusEvent(
    id: 'today-event',
    title: 'Сегодняшний ивент',
    startsAt: DateTime(today.year, today.month, today.day, 18),
    category: 'career',
  );
  final otherDayEvent = CampusEvent(
    id: 'other-event',
    title: 'Другой ивент',
    startsAt: DateTime(otherDay.year, otherDay.month, otherDay.day, 12),
    category: 'sport',
  );

  Finder dayCell(DateTime day) => find.byKey(
    ValueKey('app-calendar-month-day-${day.year}-${day.month}-${day.day}'),
  );

  Widget buildSubject(EventsState state) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: EventsCalendarView(
            state: state,
            onToggleRsvp: (_) {},
            onOpen: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('defaults to today and lists the events happening today', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(EventsState(status: .ready, events: [todayEvent])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Сегодняшний ивент'), findsOneWidget);
  });

  testWidgets('selecting an empty day shows the compact empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(EventsState(status: .ready, events: [todayEvent])),
    );
    await tester.pumpAndSettle();

    await tester.tap(dayCell(otherDay));
    await tester.pumpAndSettle();

    expect(find.text('Сегодняшний ивент'), findsNothing);
    expect(find.text('В этот день событий нет'), findsOneWidget);
  });

  testWidgets('selecting a day with an event swaps the day list', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        EventsState(status: .ready, events: [todayEvent, otherDayEvent]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Другой ивент'), findsNothing);

    await tester.tap(dayCell(otherDay));
    await tester.pumpAndSettle();

    expect(find.text('Сегодняшний ивент'), findsNothing);
    expect(find.text('Другой ивент'), findsOneWidget);
  });
}
