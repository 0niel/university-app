import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_quick_actions.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_actions_sheet.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

import '../../../gallery/schedule_gallery.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('all schedule actions remain reachable from the menu', (
    tester,
  ) async {
    final selected = <ScheduleAction>[];
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleActionsMenu(onSelected: selected.add),
        ),
      ),
      size: const Size(390, 844),
    );
    for (final action in ScheduleAction.values) {
      final row = find.byKey(ValueKey('schedule-action-${action.name}'));
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();
    }
    expect(selected, ScheduleAction.values);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('direct schedule actions work at text scale $scale', (
      tester,
    ) async {
      final calls = <String>[];
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: ScheduleQuickActions(
              hasChanges: true,
              onSearch: () => calls.add('search'),
              onChanges: () => calls.add('changes'),
              onExport: () => calls.add('export'),
            ),
          ),
        ),
        size: const Size(320, 844),
        textScaler: TextScaler.linear(scale),
      );
      for (final action in ['search', 'changes', 'export']) {
        final button = find.byKey(ValueKey('schedule-$action'));
        expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
        await tester.tap(button);
        await tester.pumpAndSettle();
      }
      expect(calls, ['search', 'changes', 'export']);
      expect(find.byKey(const ValueKey('schedule-more')), findsNothing);
      expect(
        tester
            .widget<AppIconButton>(
              find.byKey(const ValueKey('schedule-changes')),
            )
            .dot,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  }

  final locations = {
    ScheduleAction.customSchedules: const CustomScheduleRoute().location,
    ScheduleAction.session: const ScheduleSessionRoute().location,
    ScheduleAction.compare: const ScheduleCompareRoute().location,
    ScheduleAction.analytics: const ScheduleAnalyticsRoute().location,
  };
  for (final entry in locations.entries) {
    testWidgets('schedule menu navigates to ${entry.key.name}', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: AppButton.primary(
                label: 'Open',
                onPressed: () => showScheduleActionsSheet(
                  context,
                  day: DateTime(2026, 9, 2),
                ),
              ),
            ),
          ),
          GoRoute(
            path: entry.value,
            builder: (_, _) => Scaffold(
              body: Text('Destination ${entry.key.name}'),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final row = find.byKey(
        ValueKey('schedule-action-${entry.key.name}'),
      );
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.text('Destination ${entry.key.name}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('schedule tour anchors and floating Today survive redesign', (
    tester,
  ) async {
    await tester.pumpApp(
      scheduleGalleryScene(),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    for (final target in [
      AppTourTarget.scheduleViews,
      AppTourTarget.scheduleWeek,
    ]) {
      expect(AppTourAnchors.contextOf(target), isNotNull);
    }
    final today = find.byKey(const ValueKey('schedule-today-button'));
    expect(today, findsNothing);
    final strip = tester.widget<AppWeekStrip>(find.byType(AppWeekStrip));
    strip.onSelected?.call(2);
    await tester.pumpAndSettle();
    expect(today, findsOneWidget);
    expect(tester.getRect(today).right, closeTo(370, 1));
    await tester.tap(today);
    await tester.pumpAndSettle();
    expect(today, findsNothing);
    expect(
      tester.widget<AppWeekStrip>(find.byType(AppWeekStrip)).selectedIndex,
      scheduleGalleryNow.weekday - 1,
    );
    expect(find.byType(ScheduleBody), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
