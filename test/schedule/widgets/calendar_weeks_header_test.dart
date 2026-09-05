import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/calendar_weeks_header.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  Future<void> pumpHeader(
    WidgetTester tester,
    PageController controller, {
    bool attach = true,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: NinjaTheme.light(),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Column(
          children: [
            CalendarWeeksHeader(
              day: DateTime(2026, 1, 31),
              pageController: controller,
              week: 4,
              format: CalendarFormat.week,
            ),
            if (attach)
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: 6,
                  itemBuilder: (_, index) => Center(child: Text('page $index')),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  testWidgets('rapid header taps animate and accumulate the requested pages', (
    tester,
  ) async {
    final controller = PageController(initialPage: 2);
    addTearDown(controller.dispose);
    await pumpHeader(tester, controller);
    await tester.tap(find.bySemanticsLabel('Next week'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    expect(controller.page, greaterThan(2));
    expect(controller.page, lessThan(3));
    await tester.tap(find.bySemanticsLabel('Next week'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(controller.page, 4);
    await tester.tap(find.bySemanticsLabel('Previous week'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.tap(find.bySemanticsLabel('Next week'));
    await tester.pumpAndSettle();
    expect(controller.page, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'header tolerates detached controllers and clamps both boundaries',
    (tester) async {
      final controller = PageController();
      addTearDown(controller.dispose);
      await pumpHeader(tester, controller, attach: false);
      await tester.tap(find.bySemanticsLabel('Next week'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await pumpHeader(tester, controller);
      await tester.tap(find.bySemanticsLabel('Previous week'));
      await tester.pumpAndSettle();
      expect(controller.page, 0);
      controller.jumpToPage(5);
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Next week'));
      await tester.pumpAndSettle();
      expect(controller.page, 5);
      expect(tester.takeException(), isNull);
    },
  );

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
