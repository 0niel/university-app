import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_actions_sheet.dart';
import 'package:rtu_mirea_app/schedule_management/schedule_management.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Storage extends Mock implements Storage {}

class _Repository extends Mock implements ScheduleRepository {}

class _Friends extends Mock implements FriendsRepository {}

class _Campus extends Mock implements CampusRepository {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  testWidgets(
    'direct search keeps group teacher room search and subscription',
    (
      tester,
    ) async {
      final storage = _Storage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      final repository = _Repository();
      final friends = _Friends();
      final campus = _Campus();
      final schedule = _Schedule();
      when(() => schedule.state).thenReturn(const ScheduleState());
      const group = Group(name: 'A-01', uid: 'group');
      const teacher = Teacher(name: 'Teacher A', uid: 'teacher');
      const classroom = Classroom(name: 'A-101', uid: 'room');
      when(() => repository.searchGroups(query: 'A')).thenAnswer(
        (_) async => const SearchGroupsResponse(results: [group]),
      );
      when(() => repository.searchTeachers(query: 'A')).thenAnswer(
        (_) async => const SearchTeachersResponse(results: [teacher]),
      );
      when(() => repository.searchClassrooms(query: 'A')).thenAnswer(
        (_) async => const SearchClassroomsResponse(results: [classroom]),
      );
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ScheduleRepository>.value(value: repository),
            RepositoryProvider<FriendsRepository>.value(value: friends),
            RepositoryProvider<CampusRepository>.value(value: campus),
          ],
          child: BlocProvider<ScheduleBloc>.value(
            value: schedule,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Builder(
                  builder: (context) => AppButton.primary(
                    label: 'Open',
                    onPressed: () => openScheduleSearch(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(AddSchedulePage), findsOneWidget);
      final l10n = tester.element(find.byType(AddSchedulePage)).l10n;
      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pumpAndSettle();
      expect(find.text(group.name), findsOneWidget);
      await tester.tap(find.text(l10n.addScheduleAddAction));
      verify(
        () => schedule.add(
          const ScheduleRequested(group: group, makeActive: false),
        ),
      ).called(1);
      await tester.tap(find.text(l10n.addScheduleTabTeacher));
      await tester.pumpAndSettle();
      expect(find.text(teacher.name), findsOneWidget);
      await tester.tap(find.text(l10n.addScheduleAddAction));
      verify(
        () => schedule.add(
          const TeacherScheduleRequested(teacher: teacher, makeActive: false),
        ),
      ).called(1);
      await tester.tap(find.text(l10n.addScheduleTabClassroom));
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 750)),
      );
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pump(const Duration(milliseconds: 650));
      expect(
        tester
            .element(find.byType(AddScheduleView))
            .read<SearchBloc>()
            .state
            .searchMode,
        SearchMode.classrooms,
      );
      verify(() => repository.searchClassrooms(query: 'A')).called(1);
      expect(
        tester
            .element(find.byType(AddScheduleView))
            .read<SearchBloc>()
            .state
            .status,
        SearchStatus.populated,
      );
      await tester.pumpAndSettle();
      expect(find.text(classroom.name), findsOneWidget);
      await tester.tap(find.text(l10n.addScheduleAddAction));
      verify(
        () => schedule.add(
          const ClassroomScheduleRequested(
            classroom: classroom,
            makeActive: false,
          ),
        ),
      ).called(1);
      verifyNever(() => friends.searchUsers(any()));
      verifyNever(() => campus.searchGroupPosts(any()));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('failed schedule search offers retry and keeps the query', (
    tester,
  ) async {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    final repository = _Repository();
    final schedule = _Schedule();
    when(() => schedule.state).thenReturn(const ScheduleState());
    var attempts = 0;
    when(() => repository.searchGroups(query: 'A')).thenAnswer((_) async {
      if (attempts++ == 0) throw Exception('offline');
      return const SearchGroupsResponse(results: [Group(name: 'A-01')]);
    });
    when(() => repository.searchTeachers(query: 'A')).thenAnswer(
      (_) async => const SearchTeachersResponse(results: []),
    );
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ScheduleRepository>.value(value: repository),
          RepositoryProvider<FriendsRepository>.value(value: _Friends()),
          RepositoryProvider<CampusRepository>.value(value: _Campus()),
        ],
        child: BlocProvider<ScheduleBloc>.value(
          value: schedule,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AddSchedulePage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'A');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsOneWidget);
    final l10n = tester.element(find.byType(AddSchedulePage)).l10n;
    await tester.tap(find.text(l10n.retry));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 750)),
    );
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsNothing);
    expect(find.text('A-01'), findsOneWidget);
    expect(attempts, 2);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'A',
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
