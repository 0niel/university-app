@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines_view.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/exam_readiness/exam_readiness_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_page.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/exam_topics.dart';
import 'package:rtu_mirea_app/tools/cubit/tools_cubit.dart';
import 'package:rtu_mirea_app/tools/view/tools_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../schedule/view/schedule_page/schedule_test_data.dart';
import 'gallery_fonts.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Readiness extends MockCubit<ExamReadinessState>
    implements ExamReadinessCubit {}

class _Deadlines extends MockCubit<DeadlinesState> implements DeadlinesCubit {}

class _Contributors extends MockBloc<ContributorsEvent, ContributorsState>
    implements ContributorsBloc {}

class _Storage extends Mock implements Storage {}

class _Repository extends Mock implements ScheduleRepository {}

const _config = UniversityConfig(
  organizationId: 'test',
  appName: 'Университет',
  universityName: 'Университет',
  universityShortName: 'Университет',
  websiteUrl: 'https://example.test',
  supportEmail: 'support@example.test',
  deepLinkScheme: 'university',
  webAppHost: 'app.example.test',
  webAppPathPrefix: '/app',
);

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final screen in ['deadlines', 'exams', 'tools']) {
      testWidgets('actual $screen at 390x844 ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final now = screen == 'deadlines'
            ? DateTime(2026, 9, 3, 10, 19)
            : DateTime.now();
        final date = DateTime(now.year, now.month, now.day);
        final examDate = date.add(const Duration(days: 12, hours: 9));
        final storage = _Storage();
        when(() => storage.read(any())).thenReturn(null);
        when(
          () => storage.write(any(), any<dynamic>()),
        ).thenAnswer((_) async {});
        HydratedBloc.storage = storage;
        final schedule = _Schedule();
        const subjects = [
          'Математика',
          'Физика',
          'Базы данных',
          'История',
          'Право',
        ];
        when(() => schedule.state).thenReturn(
          ScheduleState(
            selectedSchedule: SelectedGroupSchedule(
              group: const Group(name: 'ИВБО-01-23'),
              schedule: [
                for (final subject in subjects)
                  scheduleTestLesson(subject: subject, day: date),
                scheduleTestLesson(
                  subject: 'Базы данных',
                  day: examDate,
                  type: LessonType.exam,
                ),
                scheduleTestLesson(
                  day: date.add(const Duration(days: 18)),
                  type: LessonType.credit,
                ),
              ],
            ),
          ),
        );
        final readiness = _Readiness();
        when(() => readiness.state).thenReturn(const ExamReadinessState());
        when(readiness.load).thenAnswer((_) async {});
        final repository = _Repository();
        when(() => repository.hasAuthenticatedUser).thenReturn(false);
        final deadlines = _Deadlines();
        when(() => deadlines.state).thenReturn(
          DeadlinesState(
            status: .ready,
            deadlines: [
              Deadline(
                id: 'lab',
                title: 'Лабораторная № 3',
                subjectName: 'Базы данных',
                dueAt: now.add(const Duration(hours: 3, minutes: 30)),
                source: .me,
                isMine: true,
              ),
              Deadline(
                id: 'math',
                title: 'Домашняя работа № 2',
                subjectName: 'Математика',
                dueAt: date.add(const Duration(days: 2, hours: 18)),
                source: .me,
                isMine: true,
              ),
              Deadline(
                id: 'english',
                title: 'Эссе по английскому',
                subjectName: 'Английский язык',
                dueAt: date.add(const Duration(days: 5, hours: 16)),
                source: .me,
                isMine: true,
                isDone: true,
              ),
              Deadline(
                id: 'project',
                title: 'Курсовой проект',
                subjectName: 'Базы данных',
                dueAt: date.add(const Duration(days: 18, hours: 18)),
                source: .me,
                isMine: true,
              ),
            ],
          ),
        );
        final contributors = _Contributors();
        when(() => contributors.state).thenReturn(
          const ContributorsState(status: .loaded),
        );
        final tools = ToolsCubit();
        addTearDown(tools.close);
        for (final (index, subject) in subjects.indexed) {
          for (
            var step = 0;
            step <
                (index == 2
                    ? 1
                    : index == 1
                    ? 2
                    : 3);
            step++
          ) {
            tools.cycleMark(subject);
          }
          tools.setCredits(subject, index == 2 ? 8 : 6);
        }
        tools
          ..setGrant('base', 3200)
          ..setGrant('study', 6000)
          ..setGrant('science', 2000)
          ..setGrant('social', 0);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: _config),
                RepositoryProvider<ScheduleRepository>.value(value: repository),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<ScheduleBloc>.value(value: schedule),
                  BlocProvider<ExamReadinessCubit>.value(value: readiness),
                  BlocProvider<DeadlinesCubit>.value(value: deadlines),
                  BlocProvider<ContributorsBloc>.value(value: contributors),
                  BlocProvider<ToolsCubit>.value(value: tools),
                ],
                child: Scaffold(
                  body: switch (screen) {
                    'deadlines' => DeadlinesView(now: now),
                    'exams' => const SessionPage(),
                    _ => const ToolsView(),
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (screen == 'exams') {
          final topics = tester.widget<ExamTopics>(find.byType(ExamTopics));
          for (final title in [
            'Реляционная модель и нормализация',
            'SQL: JOIN, подзапросы, оконные функции',
            'Индексы и планы запросов',
            'Транзакции и уровни изоляции',
            'NoSQL и репликация',
          ]) {
            topics.cubit.addTopic(topics.exam.key, title);
          }
          for (final index in [0, 1, 3]) {
            topics.cubit.toggle(topics.exam.key, index);
          }
          await tester.pumpAndSettle();
          expect(
            find.text('Реляционная модель и нормализация'),
            findsOneWidget,
          );
        }
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${screen}_${dark ? 'dark' : 'light'}.png'),
        );
        if (screen == 'tools') {
          for (final (label, name) in [
            ('Стипендия', 'grants'),
            ('Зачётные ед.', 'credits'),
          ]) {
            await tester.tap(find.text(label));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                'goldens/tools_${name}_${dark ? 'dark' : 'light'}.png',
              ),
            );
          }
        }
      });
    }
  }
}
