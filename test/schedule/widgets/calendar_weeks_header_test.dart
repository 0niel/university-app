import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/calendar_weeks_header.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  testWidgets('calendar header is responsive and navigates instantly', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final controller = PageController(initialPage: 2);
    addTearDown(controller.dispose);

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
          body: Column(
            children: [
              CalendarWeeksHeader(
                day: DateTime(2026, 8, 20),
                pageController: controller,
                week: 4,
                format: CalendarFormat.week,
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  children: const [
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.bySemanticsLabel('Previous week')).shortestSide,
      greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
    );
    expect(find.text('Week 4'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Previous week'));
    await tester.pump();
    expect(controller.page, 1);
  });
}
