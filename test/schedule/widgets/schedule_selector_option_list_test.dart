import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector/schedule_selector_widgets.dart';

import '../../helpers/pump_app.dart';

class _MockCustomScheduleCubit extends MockCubit<CustomScheduleState>
    implements CustomScheduleCubit {}

void main() {
  group('ScheduleSelectorOptionList', () {
    late CustomScheduleCubit cubit;

    setUp(() => cubit = _MockCustomScheduleCubit());

    Future<void> pumpList(
      WidgetTester tester, {
      required CustomScheduleState state,
      String? selectedId,
      VoidCallback? onCreateRequested,
    }) {
      when(() => cubit.state).thenReturn(state);
      return tester.pumpApp(
        BlocProvider<CustomScheduleCubit>.value(
          value: cubit,
          child: Scaffold(
            body: SingleChildScrollView(
              child: ScheduleSelectorOptionList(
                selectedId: selectedId,
                onSelected: (_) {},
                onSubmit: () {},
                onCreateRequested: onCreateRequested ?? () {},
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('offers to create one when there are no schedules', (
      tester,
    ) async {
      var created = false;
      await pumpList(
        tester,
        state: const CustomScheduleState(),
        onCreateRequested: () => created = true,
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Создать расписание'), findsOneWidget);
      await tester.tap(find.text('Создать расписание'));
      expect(created, isTrue);
    });

    testWidgets('lists the saved schedules and reveals the submit action', (
      tester,
    ) async {
      const schedule = CustomSchedule(
        id: 'one',
        name: 'Моё расписание',
        lessons: [],
      );
      await pumpList(
        tester,
        state: const CustomScheduleState(customSchedules: [schedule]),
        selectedId: 'one',
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Моё расписание'), findsOneWidget);
      expect(find.text('Добавить в выбранное расписание'), findsOneWidget);
    });
  });
}
