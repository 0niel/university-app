@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/compare/widgets/comparison_day_details.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'gallery_fonts.dart';

final _day = DateTime(2026, 9, 2);

LessonSchedulePart _lesson(String subject, LessonType type, int from, int to) =>
    LessonSchedulePart(
      subject: subject,
      lessonType: type,
      teachers: const [Teacher(name: 'Смирнова Е. В.')],
      classrooms: const [
        Classroom(
          name: 'А-318',
          campus: Campus(name: 'Вернадского, 78', shortName: 'В-78'),
        ),
      ],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: from ~/ 60, minute: from % 60),
        endTime: TimeOfDay(hour: to ~/ 60, minute: to % 60),
      ),
      dates: [_day],
    );

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('comparison detail states ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 1400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: ComparisonDayDetails(
                day: _day,
                myName: 'ИКБО-01-24',
                friendName: 'ИКБО-02-24',
                mine: [
                  _lesson('Математический анализ', .lecture, 540, 630),
                  _lesson('Физика', .laboratoryWork, 660, 750),
                ],
                friends: [
                  _lesson('Математический анализ', .lecture, 540, 630),
                ],
                onDay: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/comparison_details_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
