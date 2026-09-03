@Tags(['gallery'])
library;

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'gallery_fonts.dart';
import 'schedule_gallery.dart';

class _Repository extends Mock implements ScheduleRepository {}

class _Campus extends Mock implements CampusRepository {}

class _Notifications extends Mock implements LocalNotificationsRepository {}

class _Activities extends MockCubit<UserActivitiesState>
    implements UserActivitiesCubit {}

class _Reminders extends MockCubit<Map<String, int>>
    implements LessonRemindersCubit {}

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    for (final sheet in ['actions', 'add', 'remind', 'teacher']) {
      testWidgets('schedule sheet $sheet ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final repository = _Repository();
        final campus = _Campus();
        final notifications = _Notifications();
        final activities = _Activities();
        final reminders = _Reminders();
        final lesson = scheduleGalleryLessons()[1];
        when(() => activities.state).thenReturn(const UserActivitiesState());
        when(() => reminders.state).thenReturn({});
        when(
          () => reminders.minutesFor(lesson, scheduleGalleryNow),
        ).thenReturn(null);
        when(() => campus.getTeacherProfile(any())).thenAnswer(
          (_) async => const TeacherProfile(
            teacherName: 'Кузнецов А. П.',
            reviewsCount: 128,
            clarity: 4.6,
            loyalty: 4.6,
            usefulness: 4.6,
            subjects: [
              'Программирование на Python',
              'Алгоритмы и структуры данных',
            ],
            reviews: [
              TeacherReview(
                id: '1',
                authorName: 'Аня К.',
                clarity: 5,
                loyalty: 5,
                usefulness: 5,
                body: 'Объясняет понятно, на вопросы отвечает.',
              ),
              TeacherReview(
                id: '2',
                authorName: 'Миша Р.',
                clarity: 4,
                loyalty: 4,
                usefulness: 4,
                body: 'Материалы есть заранее, удобно готовиться.',
              ),
            ],
          ),
        );
        late BuildContext sheetContext;
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<ScheduleRepository>.value(value: repository),
              RepositoryProvider<CampusRepository>.value(value: campus),
              RepositoryProvider<LocalNotificationsRepository>.value(
                value: notifications,
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<UserActivitiesCubit>.value(value: activities),
                BlocProvider<LessonRemindersCubit>.value(value: reminders),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: Builder(
                    builder: (context) {
                      sheetContext = context;
                      return scheduleGalleryScene();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        switch (sheet) {
          case 'actions':
            unawaited(
              showLessonActionsSheet(
                sheetContext,
                lesson: lesson,
                day: scheduleGalleryNow,
              ),
            );
          case 'add':
            unawaited(
              showAddLessonSheet(sheetContext, day: scheduleGalleryNow),
            );
          case 'remind':
            unawaited(
              showLessonRemindSheet(
                sheetContext,
                lesson: lesson,
                day: scheduleGalleryNow,
              ),
            );
          case 'teacher':
            unawaited(
              showTeacherProfileSheet(
                sheetContext,
                teacher: lesson.teachers.single,
              ),
            );
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (sheet == 'actions') {
          expect(
            tester.getSize(find.byKey(const ValueKey('lesson-actions-type'))),
            const Size(44, 44),
          );
        }
        if (sheet == 'teacher') {
          final stats = tester
              .widgetList<AppCard>(find.byType(AppCard))
              .where((card) => '${card.key}'.contains('teacher-stat-'));
          expect(stats, hasLength(3));
          final positions = stats.map(
            (card) => tester.getTopLeft(find.byWidget(card)).dy,
          );
          expect(positions.toSet(), hasLength(1));
        }
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/schedule_sheet_$sheet${dark ? '_dark' : ''}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
