import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/view/app_schedule_refresh.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  for (final resume in [false, true]) {
    testWidgets(
      'refreshes at startup and on ${resume ? 'resume' : 'timer'}',
      (tester) async {
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        final bloc = _ScheduleBloc();
        when(() => bloc.isClosed).thenReturn(false);
        await tester.pumpWidget(
          BlocProvider<ScheduleBloc>.value(
            value: bloc,
            child: const AppScheduleRefresh(child: SizedBox()),
          ),
        );
        verify(
          () => bloc.add(const SelectedScheduleRefreshRequested()),
        ).called(1);
        if (resume) {
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.paused,
          );
          await tester.pump(const Duration(minutes: 10));
          verifyNever(() => bloc.add(const SelectedScheduleRefreshRequested()));
          tester.binding.handleAppLifecycleStateChanged(
            AppLifecycleState.resumed,
          );
          await tester.pump();
        } else {
          await tester.pump(const Duration(minutes: 5));
        }
        verify(
          () => bloc.add(const SelectedScheduleRefreshRequested()),
        ).called(1);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        verifyNever(() => bloc.add(const SelectedScheduleRefreshRequested()));
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(minutes: 10));
        verifyNever(() => bloc.add(const SelectedScheduleRefreshRequested()));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
