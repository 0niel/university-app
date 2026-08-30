import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_comparison/schedule_comparison_cubit.dart';

void main() {
  group('ScheduleComparisonCubit', () {
    test('initial state is empty and disabled', () {
      final cubit = ScheduleComparisonCubit();
      expect(cubit.state, const ScheduleComparisonState());
      expect(cubit.state.schedules, isEmpty);
      expect(cubit.state.isEnabled, isFalse);
    });

    test('limits comparisons to three schedules', () {
      expect(ScheduleComparisonCubit.maxSchedules, 3);
    });
  });
}
