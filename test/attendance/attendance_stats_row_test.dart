import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_stats_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final dark in [false, true]) {
      testWidgets('statistics fit an unbounded scroll at $scale in $dark', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(320, 568)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: AttendanceStatsRow(
                      totalPercent: 94,
                      missed: 6,
                      riskCount: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('94%'), findsOneWidget);
        expect(
          tester.getSize(find.byType(AttendanceStatsRow)).height.isFinite,
          isTrue,
        );
      });
    }
  }
}
