import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/view/analytics/analytics_page.dart';

import '../../../helpers/pump_app.dart';

class _MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  group('AnalyticsPage dataless states', () {
    late ScheduleBloc scheduleBloc;

    setUp(() {
      scheduleBloc = _MockScheduleBloc();
    });

    Future<void> pumpWithState(WidgetTester tester, ScheduleState state) {
      when(() => scheduleBloc.state).thenReturn(state);
      return tester.pumpApp(
        BlocProvider<ScheduleBloc>.value(
          value: scheduleBloc,
          child: const AnalyticsPage(),
        ),
      );
    }

    testWidgets('shows a skeleton while the schedule is loading', (
      tester,
    ) async {
      await pumpWithState(
        tester,
        const ScheduleState(status: ScheduleStatus.loading),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(AppEmptyState), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows a retryable error when the schedule failed', (
      tester,
    ) async {
      await pumpWithState(
        tester,
        const ScheduleState(status: ScheduleStatus.failure),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(AppErrorState), findsOneWidget);

      await tester.tap(find.text('Повторить'));
      await tester.pump();

      verify(
        () => scheduleBloc.add(
          const SelectedScheduleRefreshRequested(manual: true),
        ),
      ).called(1);
    });

    testWidgets('shows the empty state when there is nothing to analyse', (
      tester,
    ) async {
      await pumpWithState(
        tester,
        const ScheduleState(status: ScheduleStatus.loaded),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byType(NinjaSkeleton), findsNothing);
    });
  });
}
