import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/view/add_schedule_page.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _SearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  testWidgets('keeps add geometry and announces confirmed success', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final schedules = _ScheduleBloc();
    final search = _SearchBloc();
    final states = StreamController<ScheduleState>.broadcast();
    addTearDown(states.close);
    whenListen(
      schedules,
      states.stream,
      initialState: const ScheduleState(
        status: ScheduleStatus.loaded,
        teachersSchedule: [
          ('g1', Teacher(name: 'Teacher', uid: 'g1'), <SchedulePart>[]),
        ],
      ),
    );
    const group = Group(name: 'ХЕБО-06-24', uid: 'g1');
    when(() => search.state).thenReturn(
      const SearchState(
        status: SearchStatus.populated,
        groups: SearchGroupsResponse(results: [group]),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NinjaToastHost(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ScheduleBloc>.value(value: schedules),
              BlocProvider<SearchBloc>.value(value: search),
            ],
            child: const Scaffold(body: AddScheduleView()),
          ),
        ),
      ),
    );
    final tabs = find.byType(AppSegmentedControl<ScheduleTarget>);
    expect(tester.getSize(tabs).width, 350);
    final l10n = tester.element(tabs).l10n;
    await tester.enterText(find.byType(TextField), 'хебо0624');
    await tester.pump();
    final add = find.widgetWithText(AppButton, l10n.addScheduleAddAction);
    final before = tester.getSize(add);
    await tester.tap(add);
    await tester.pump();
    expect(tester.widget<AppButton>(add).loading, isTrue);
    expect(find.text('ХЕБО-06-24 · ${l10n.addScheduleAdded}'), findsNothing);
    states.add(
      const ScheduleState(
        status: ScheduleStatus.loaded,
        groupsSchedule: [('g1', group, <SchedulePart>[])],
      ),
    );
    await tester.pumpAndSettle();
    final added = find.widgetWithText(AppButton, l10n.addScheduleAdded);
    expect(tester.getSize(added), before);
    expect(tester.widget<AppButton>(added).onPressed, isNull);
    expect(find.text('ХЕБО-06-24 · ${l10n.addScheduleAdded}'), findsOneWidget);
    verify(
      () => schedules.add(
        const ScheduleRequested(
          group: group,
          makeActive: false,
        ),
      ),
    ).called(1);
    expect(tester.takeException(), isNull);
  });
}
