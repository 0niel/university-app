import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_button.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_menu.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_options.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  const group = Group(name: 'ИКБО-10-23', uid: 'same-id');
  const teacher = Teacher(name: 'Соколова Мария Викторовна', uid: 'same-id');
  const classroom = Classroom(name: 'А-203', uid: 'room-id');
  const state = ScheduleState(
    selectedSchedule: SelectedGroupSchedule(group: group, schedule: []),
    groupsSchedule: [('same-id', group, [])],
    teachersSchedule: [('same-id', teacher, [])],
    classroomsSchedule: [('room-id', classroom, [])],
  );

  setUpAll(() async {
    await loadGalleryFonts();
    registerFallbackValue(const SelectedScheduleRefreshRequested());
  });

  test(
    'options retain saved types, deduplicate and include an unsaved active',
    () {
      const custom = SelectedCustomSchedule(
        id: 'custom-id',
        name: 'Mine',
        schedule: [],
      );
      final options = schedulePickerOptions(
        state.copyWith(selectedSchedule: custom),
      );
      expect(options.map((option) => option.pickerId), [
        'custom:custom-id',
        'group:same-id',
        'teacher:same-id',
        'classroom:room-id',
      ]);
      expect(schedulePickerOptions(state), hasLength(3));
    },
  );

  late _ScheduleBloc bloc;
  late StreamController<ScheduleState> states;

  setUp(() {
    bloc = _ScheduleBloc();
    states = StreamController<ScheduleState>.broadcast();
    whenListen(bloc, states.stream, initialState: state);
    addTearDown(states.close);
  });

  Future<GoRouter> pumpPicker(
    WidgetTester tester, {
    Locale locale = const Locale('ru'),
    Size size = const Size(390, 844),
    double textScale = 1,
    bool reducedMotion = false,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/schedule',
      routes: [
        GoRoute(
          path: '/schedule',
          builder: (_, _) => BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) => Scaffold(
              body: ScheduleHeader(
                day: DateTime(2026, 10, 19),
                name: state.selectedSchedule?.name,
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/schedule-management',
          builder: (_, _) => const Scaffold(body: Text('management-page')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      BlocProvider<ScheduleBloc>.value(
        value: bloc,
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              disableAnimations: reducedMotion,
            ),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> openPicker(WidgetTester tester) async {
    await tester.tap(find.byType(SchedulePickerButton));
    await tester.pumpAndSettle();
  }

  for (final locale in [const Locale('ru'), const Locale('en')]) {
    testWidgets('selects a saved teacher in place for $locale', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final router = await pumpPicker(tester, locale: locale);
        await openPicker(tester);
        expect(router.routeInformationProvider.value.uri.path, '/schedule');
        expect(find.byType(SchedulePickerMenu), findsOneWidget);
        final selected = find.byKey(
          const ValueKey('schedule-picker-group:same-id'),
        );
        expect(
          tester.getSemantics(selected).flagsCollection.isSelected,
          Tristate.isTrue,
        );
        await tester.tap(find.text(teacher.name));
        await tester.pumpAndSettle();
        verify(
          () => bloc.add(
            const ScheduleSelected(
              selectedSchedule: SelectedTeacherSchedule(
                teacher: teacher,
                schedule: [],
              ),
            ),
          ),
        ).called(1);
        expect(find.byType(AppPopover), findsNothing);
        expect(router.routeInformationProvider.value.uri.path, '/schedule');
        states.add(
          state.copyWith(
            selectedSchedule: const SelectedTeacherSchedule(
              teacher: teacher,
              schedule: [],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(teacher.name), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets('current choice and outside dismissal do not reselect', (
    tester,
  ) async {
    await pumpPicker(tester);
    await openPicker(tester);
    await tester.tap(
      find.byKey(const ValueKey('schedule-picker-group:same-id')),
    );
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(any()));
    await openPicker(tester);
    await tester.tapAt(const Offset(5, 700));
    await tester.pumpAndSettle();
    expect(find.byType(AppPopover), findsNothing);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('classrooms select through the existing schedule event', (
    tester,
  ) async {
    await pumpPicker(tester);
    await openPicker(tester);
    await tester.tap(find.text(classroom.name));
    await tester.pumpAndSettle();
    verify(
      () => bloc.add(
        const ScheduleSelected(
          selectedSchedule: SelectedClassroomSchedule(
            classroom: classroom,
            schedule: [],
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets(
    'management stays reachable with long content at 320px and 200%',
    (
      tester,
    ) async {
      final longState = state.copyWith(
        teachersSchedule: [
          for (var i = 0; i < 20; i++)
            (
              'teacher-$i',
              Teacher(name: 'Соколова Мария Викторовна $i', uid: '$i'),
              <SchedulePart>[],
            ),
        ],
      );
      when(() => bloc.state).thenReturn(longState);
      final router = await pumpPicker(
        tester,
        size: const Size(320, 568),
        textScale: 2,
        reducedMotion: true,
      );
      await openPicker(tester);
      final popover = tester.getRect(find.byType(AppPopover));
      expect(popover.left, greaterThanOrEqualTo(12));
      expect(popover.right, lessThanOrEqualTo(308));
      expect(popover.bottom, lessThanOrEqualTo(556));
      final management = find.byKey(
        const ValueKey('schedule-picker-management'),
      );
      await tester.scrollUntilVisible(
        management,
        300,
        scrollable: find.descendant(
          of: find.byType(AppPopover),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(management);
      await tester.pumpAndSettle();
      expect(find.byType(AppPopover), findsNothing);
      expect(find.text('management-page'), findsOneWidget);
      expect(
        router.state.uri.path,
        '/profile/schedule-management',
      );
      verifyNever(() => bloc.add(any()));
      expect(tester.takeException(), isNull);
    },
  );
}
