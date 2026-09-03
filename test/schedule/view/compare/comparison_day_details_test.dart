import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/schedule/view/compare/widgets/comparison_day_details.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';

final _day = DateTime(2026, 9, 2);

LessonSchedulePart _lesson(String subject, int from, int until) =>
    LessonSchedulePart(
      subject: subject,
      lessonType: LessonType.practice,
      teachers: const [Teacher(name: 'Иванов Иван Иванович')],
      classrooms: const [
        Classroom(
          name: 'А-101',
          campus: Campus(name: 'Главный', shortName: 'Г'),
        ),
      ],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: from ~/ 60, minute: from % 60),
        endTime: TimeOfDay(hour: until ~/ 60, minute: until % 60),
      ),
      dates: [_day],
    );

Widget _scene({
  required List<LessonSchedulePart> mine,
  required List<LessonSchedulePart> friends,
  required ValueChanged<DateTime> onDay,
  List<int> friendUncertainFrom = const [],
  bool dark = false,
}) => Theme(
  data: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
  child: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: ComparisonDayDetails(
          day: _day,
          mine: mine,
          friends: friends,
          myName: 'ИКБО-01-24',
          friendName: 'ИКБО-02-24',
          friendUncertainFrom: friendUncertainFrom,
          onDay: onDay,
        ),
      ),
    ),
  ),
);

void main() {
  setUpAll(loadGalleryFonts);
  final l10n = AppLocalizationsRu();

  testWidgets(
    'shows both subjects and metadata alongside real common windows',
    (
      tester,
    ) async {
      await tester.pumpApp(
        _scene(
          mine: [_lesson('Математический анализ', 545, 615)],
          friends: [
            _lesson('Программирование', 545, 615),
            _lesson('Физика', 645, 705),
          ],
          onDay: (_) {},
        ),
        size: const Size(390, 1200),
      );
      expect(find.text('Математический анализ'), findsOneWidget);
      expect(find.text('Программирование'), findsOneWidget);
      expect(find.text('Физика'), findsOneWidget);
      expect(find.text('А-101'), findsNWidgets(3));
      expect(find.text('Иванов Иван Иванович'), findsNWidgets(3));
      expect(find.text('09:05–10:15'), findsNWidgets(3));
      expect(
        find.text(l10n.compareCommonWindow('10:15', '10:45')),
        findsOneWidget,
      );
      expect(find.text(l10n.compareFreeCell), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('shared subjects stay together and days remain navigable', (
    tester,
  ) async {
    final days = <DateTime>[];
    final shared = _lesson('Общая лекция', 540, 630);
    await tester.pumpApp(
      _scene(mine: [shared], friends: [shared], onDay: days.add),
      size: const Size(390, 844),
    );
    expect(find.text('Общая лекция'), findsNWidgets(2));
    expect(find.text(l10n.compareTogether), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('comparison-previous-day')));
    await tester.tap(find.byKey(const ValueKey('comparison-next-day')));
    expect(days, [
      _day.subtract(const Duration(days: 1)),
      _day.add(const Duration(days: 1)),
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty comparison keeps its day controls and new empty state', (
    tester,
  ) async {
    await tester.pumpApp(
      _scene(mine: const [], friends: const [], onDay: (_) {}),
      size: const Size(390, 844),
    );
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text(l10n.compareNoLessonsBoth), findsOneWidget);
    expect(find.byKey(const ValueKey('comparison-next-day')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'unknown event time does not become an empty day or midnight row',
    (
      tester,
    ) async {
      await tester.pumpApp(
        _scene(
          mine: const [],
          friends: const [],
          friendUncertainFrom: const [0],
          onDay: (_) {},
        ),
      );
      expect(find.byType(AppBanner), findsOneWidget);
      expect(find.text(l10n.compareNoLessonsBoth), findsNothing);
      expect(find.text('00:00'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an uncertain start inside a lesson never labels its friend free',
    (
      tester,
    ) async {
      await tester.pumpApp(
        _scene(
          mine: [_lesson('Lesson', 540, 600)],
          friends: const [],
          friendUncertainFrom: const [570],
          onDay: (_) {},
        ),
        size: const Size(390, 1200),
      );
      expect(find.text(l10n.compareFreeCell), findsNothing);
      expect(find.text(l10n.legendEvent), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final dark in [false, true]) {
    testWidgets('long titles fit narrow text-scaled comparison dark=$dark', (
      tester,
    ) async {
      const longSubject =
          'Проектирование распределённых информационных систем университета';
      await tester.pumpApp(
        _scene(
          mine: [_lesson(longSubject, 540, 630)],
          friends: [_lesson('Алгоритмы и структуры данных', 540, 630)],
          onDay: (_) {},
          dark: dark,
        ),
        size: const Size(320, 844),
        textScaler: const TextScaler.linear(2),
      );
      expect(find.text(longSubject), findsOneWidget);
      expect(tester.widget<Text>(find.text(longSubject)).maxLines, isNull);
      await tester.ensureVisible(find.text('Алгоритмы и структуры данных'));
      expect(tester.takeException(), isNull);
    });
  }
}
