import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_lifecycle.dart';

class _Dashboard extends MockBloc<TeacherDashboardEvent, TeacherDashboardState>
    implements TeacherDashboardBloc {
  final activity = <bool>[];

  @override
  void add(TeacherDashboardEvent event) {
    if (event case TeacherDashboardActivityChanged(:final active)) {
      activity.add(active);
    }
  }
}

void main() {
  testWidgets('hidden routes stay inactive when the application resumes', (
    tester,
  ) async {
    final bloc = _Dashboard();
    final visible = ValueNotifier(true);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      BlocProvider<TeacherDashboardBloc>.value(
        value: bloc,
        child: ValueListenableBuilder<bool>(
          valueListenable: visible,
          child: const TeacherDashboardLifecycle(child: SizedBox()),
          builder: (_, value, child) =>
              TickerMode(enabled: value, child: child!),
        ),
      ),
    );
    expect(bloc.activity, [true]);

    visible.value = false;
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(bloc.activity, [true, false]);

    visible.value = true;
    await tester.pump();
    expect(bloc.activity, [true, false, true]);
    await tester.pumpWidget(const SizedBox());
    visible.value = false;
    await tester.pump();
    expect(bloc.activity, [true, false, true]);
    visible.dispose();
    expect(tester.takeException(), isNull);
  });
}
