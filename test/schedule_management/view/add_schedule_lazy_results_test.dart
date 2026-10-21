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

import '../../helpers/pump_app.dart';

class _Schedules extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Search extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  testWidgets(
    'large results stay lazy and offscreen requests retain feedback',
    (
      tester,
    ) async {
      final schedules = _Schedules();
      final search = _Search();
      final states = StreamController<ScheduleState>.broadcast();
      addTearDown(states.close);
      whenListen(
        schedules,
        states.stream,
        initialState: const ScheduleState(status: ScheduleStatus.loaded),
      );
      final groups = [
        for (var index = 0; index < 500; index++)
          Group(name: 'GROUP-$index', uid: 'g$index'),
      ];
      when(() => search.state).thenReturn(
        SearchState(
          status: SearchStatus.populated,
          groups: SearchGroupsResponse(results: groups),
        ),
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ScheduleBloc>.value(value: schedules),
            BlocProvider<SearchBloc>.value(value: search),
          ],
          child: const Scaffold(body: AddScheduleView()),
        ),
        size: const Size(390, 844),
      );
      await tester.enterText(find.byType(TextField), 'group');
      await tester.pump();
      expect(find.text('GROUP-499'), findsNothing);
      expect(find.byType(AppButton).evaluate().length, lessThan(30));

      final header = tester.widget<AppInnerHeader>(find.byType(AppInnerHeader));
      await tester.enterText(find.byType(TextField), 'groups');
      await tester.pump();
      expect(
        tester.widget<AppInnerHeader>(find.byType(AppInnerHeader)),
        same(header),
      );

      final first = find.byKey(const ValueKey('group:g0'));
      final l10n = tester.element(first).l10n;
      await tester.tap(
        find.descendant(of: first, matching: find.byType(AppButton)),
      );
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, -1800));
      await tester.pump(const Duration(milliseconds: 400));
      states.add(
        ScheduleState(
          status: ScheduleStatus.loaded,
          groupsSchedule: [('g0', groups.first, <SchedulePart>[])],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('GROUP-0 · ${l10n.addScheduleAdded}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
