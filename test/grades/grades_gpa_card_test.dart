import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_state.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';
import 'package:rtu_mirea_app/grades/widgets/grades_gpa_card.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('personal GPA preserves precision and fits $scale text', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 568)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final now = DateTime(2026, 9, 2);
      final state = GradesState(
        termId: 'current',
        book: GradesBook(
          terms: {
            'current': [
              SubjectGrades(
                subject: 'Физика',
                marks: [
                  for (var i = 0; i < 25; i++)
                    GradeMark(value: i < 13 ? 5 : 4, date: now),
                ],
              ),
            ],
          },
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GradesGpaCard(state: state),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('4,52'), findsOneWidget);
      expect(find.text('Личный GPA'), findsOneWidget);
    });
  }
}
