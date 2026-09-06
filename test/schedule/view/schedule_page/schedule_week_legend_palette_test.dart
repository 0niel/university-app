import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_test_data.dart';

class _Storage extends Mock implements Storage {}

void main() {
  for (final dark in [false, true]) {
    testWidgets('legend follows live lesson colors and reset dark=$dark', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(900, 2200)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final storage = _Storage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      final preferences = UiPreferencesCubit();
      addTearDown(preferences.close);
      final day = DateTime(2026, 9, 7);
      final week = ScheduleWeekView(
        day: day,
        now: day,
        schedule: [
          for (final (index, type) in [
            LessonType.lecture,
            LessonType.practice,
            LessonType.laboratoryWork,
          ].indexed)
            scheduleTestLesson(
              day: day,
              type: type,
              subject: type.name,
              start: 540 + index * 120,
              end: 630 + index * 120,
            ),
        ],
        changes: const [],
        preferences: const SchedulePreferencesState(),
        display: const ScheduleDisplayState(),
        activities: const [],
        onDay: (_) {},
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: preferences,
          child: MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: BlocBuilder<UiPreferencesCubit, UiPreferencesState>(
                  builder: (_, state) => LessonTypePalette(
                    colors: state.lessonTypeColors,
                    child: week,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final colors = dark ? AppColors.dark : AppColors.light;

      Color? legend(String label) =>
          (tester
                      .widget<Container>(
                        find.byKey(ValueKey('schedule-legend-$label')),
                      )
                      .decoration!
                  as BoxDecoration)
              .color;

      void expectColors(List<Color> expected) {
        for (final (index, labels) in [
          ('Лекция', 'ЛЕК'),
          ('Практика', 'ПРАК'),
          ('Лаба', 'ЛАБ'),
        ].indexed) {
          expect(legend(labels.$1), expected[index]);
          final cells = tester.widgetList<AppWeekGridCell>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is AppWeekGridCell && widget.topLabel == labels.$2,
            ),
          );
          expect(cells, isNotEmpty);
          expect(cells.every((cell) => cell.tone == expected[index]), isTrue);
        }
        expect(legend('Отмена'), colors.exam);
      }

      final defaults = [colors.lecture, colors.practice, colors.lab];
      expectColors(defaults);
      const custom = [Color(0xFFAA33DD), Color(0xFFDA5511), Color(0xFF1188BB)];
      for (final (index, name) in [
        'lecture',
        'practice',
        'laboratoryWork',
      ].indexed) {
        preferences.setLessonTypeColor(name, custom[index].toARGB32());
      }
      preferences.setLessonTypeColor('exam', 0xFF33FF99);
      await tester.pumpAndSettle();
      expectColors(custom);
      preferences.resetLessonTypeColors();
      await tester.pumpAndSettle();
      expectColors(defaults);
      expect(tester.takeException(), isNull);
    });
  }
}
