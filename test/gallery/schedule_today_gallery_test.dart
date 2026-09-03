@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';

import 'gallery_fonts.dart';
import 'schedule_gallery.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final view in ScheduleView.values) {
      testWidgets(
        'Today returns from ${view.name} in ${dark ? 'dark' : 'light'}',
        (
          tester,
        ) async {
          tester.view
            ..physicalSize = const Size(390, 844)
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: scheduleGalleryScene()),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(
            find.byWidgetPredicate(
              (widget) => widget is AppDayPill && widget.day.label == '2',
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester.element(find.byType(ScheduleBody)).l10n;
          if (view != ScheduleView.day) {
            await tester.tap(
              find.text(view == ScheduleView.week ? l10n.week : l10n.month),
            );
            await tester.pumpAndSettle();
          }
          final today = find.byKey(const ValueKey('schedule-today-button'));
          expect(today, findsOneWidget);
          final bounds = tester.getRect(today);
          expect(bounds.right, closeTo(370, .1));
          expect(
            bounds.height,
            greaterThanOrEqualTo(AppControlSize.touchTarget),
          );
          expect(
            bounds.bottom,
            lessThan(tester.getTopLeft(find.byType(AppBottomBar)).dy),
          );
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              'goldens/schedule_today_${view.name}_${dark ? 'dark' : 'light'}.png',
            ),
          );
          await tester.tap(today);
          await tester.pumpAndSettle();
          expect(today, findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
