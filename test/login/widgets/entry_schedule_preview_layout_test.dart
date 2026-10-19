import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/entry_feature_preview.dart';
import 'package:rtu_mirea_app/onboarding/widgets/welcome_step.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';

void main() {
  for (final (size, textScale, reduceMotion) in [
    (const Size(320, 568), 2.0, true),
    (const Size(390, 844), 1.0, false),
    (const Size(844, 390), 2.0, false),
  ]) {
    for (final feature in [
      EntryFeature.schedule,
      EntryFeature.teacherSchedule,
    ]) {
      testWidgets(
        'entry schedule stays one row $feature at $size/$textScale '
        'reduceMotion=$reduceMotion',
        (tester) async {
          tester.view
            ..physicalSize = size
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                  disableAnimations: reduceMotion,
                ),
                child: child!,
              ),
              home: Scaffold(
                body: feature == EntryFeature.schedule
                    ? OnboardingWelcomeStep(
                        totalSteps: 4,
                        onStart: () {},
                        onHaveAccount: () {},
                      )
                    : EntryFeaturePreview(feature: feature),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final preview = find.byType(AppPreviewScope);
          final strip = find.byType(ScheduleDayStrip);
          final pager = find.descendant(
            of: strip,
            matching: find.byType(AppWeekPager),
          );
          final week = find.descendant(
            of: strip,
            matching: find.byKey(ValueKey(DateTime(2026, 8, 31))),
          );
          final days = find.descendant(
            of: week,
            matching: find.byType(AppDayPill),
          );
          expect(days, findsNWidgets(7));
          expect(tester.getSize(pager).height, lessThan(90));
          final previewBounds = tester.getRect(preview);
          final stripBounds = tester.getRect(strip);
          expect(stripBounds.left, closeTo(previewBounds.left, .1));
          expect(stripBounds.right, closeTo(previewBounds.right, .1));
          final first = tester.getRect(days.first);
          for (final element in days.evaluate()) {
            final bounds = tester.getRect(
              find.byElementPredicate(
                (candidate) => identical(candidate, element),
              ),
            );
            expect(bounds.top, closeTo(first.top, .1));
            expect(bounds.bottom, closeTo(first.bottom, .1));
          }
          final selected = find.descendant(
            of: week,
            matching: find.byWidgetPredicate(
              (widget) => widget is AppDayPill && widget.selected,
            ),
          );
          expect(selected, findsOneWidget);
          final selectedBounds = tester.getRect(selected);
          expect(selectedBounds.left, greaterThanOrEqualTo(stripBounds.left));
          expect(selectedBounds.right, lessThanOrEqualTo(stripBounds.right));
          expect(tester.widget<AppWeekPager>(pager).selectedIndex, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
