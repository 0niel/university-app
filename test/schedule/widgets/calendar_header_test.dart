import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/calendar_header.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  testWidgets('month rail is localized adaptive and motion-safe', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var selectedMonth = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
            accessibleNavigation: true,
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: CalendarHeader(
            day: DateTime(2026, 8, 20),
            week: 4,
            format: CalendarFormat.month,
            pageController: null,
            onMonthChanged: (month) => selectedMonth = month,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Авг'), findsNothing);

    final selected = find.bySemanticsLabel(RegExp('August 2024'));
    expect(selected, findsOneWidget);
    expect(
      tester.getSize(selected).shortestSide,
      greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
    );
    expect(
      tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .every((widget) => widget.duration == Duration.zero),
      isTrue,
    );

    final september = find.bySemanticsLabel(RegExp('September 2024'));
    await tester.ensureVisible(september);
    await tester.tap(september);
    await tester.pump();
    expect(selectedMonth, 9);
  });
}
