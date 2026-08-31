import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  group('UserActivitiesCubit', () {
    late ScheduleRepository scheduleRepository;

    final activity = UserActivity(
      id: 'a-1',
      type: UserActivityType.consult,
      title: 'Консультация по курсовой',
      startsAt: DateTime(2026, 5, 22, 12, 20),
    );

    setUp(() {
      scheduleRepository = MockScheduleRepository();
      when(() => scheduleRepository.hasAuthenticatedUser).thenReturn(true);
      when(
        () => scheduleRepository.getUserActivities(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) async => [activity]);
    });

    UserActivitiesCubit buildCubit() =>
        UserActivitiesCubit(scheduleRepository: scheduleRepository);

    test('initial state is empty UserActivitiesState', () {
      expect(buildCubit().state, equals(const UserActivitiesState()));
    });

    group('load', () {
      blocTest<UserActivitiesCubit, UserActivitiesState>(
        'emits [loading, populated] when getUserActivities succeeds',
        build: buildCubit,
        act: (cubit) =>
            cubit.load(from: DateTime(2026, 5), to: DateTime(2026, 5, 31)),
        expect: () => [
          const UserActivitiesState(status: UserActivitiesStatus.loading),
          UserActivitiesState(
            activities: [activity],
            status: UserActivitiesStatus.populated,
          ),
        ],
      );

      blocTest<UserActivitiesCubit, UserActivitiesState>(
        'does nothing when there is no authenticated user',
        setUp: () => when(
          () => scheduleRepository.hasAuthenticatedUser,
        ).thenReturn(false),
        build: buildCubit,
        act: (cubit) =>
            cubit.load(from: DateTime(2026, 5), to: DateTime(2026, 5, 31)),
        expect: () => const <UserActivitiesState>[],
        verify: (_) => verifyNever(
          () => scheduleRepository.getUserActivities(
            from: any(named: 'from'),
            to: any(named: 'to'),
          ),
        ),
      );

      blocTest<UserActivitiesCubit, UserActivitiesState>(
        'emits [loading, failure] and reports the error on failure',
        setUp: () => when(
          () => scheduleRepository.getUserActivities(
            from: any(named: 'from'),
            to: any(named: 'to'),
          ),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) =>
            cubit.load(from: DateTime(2026, 5), to: DateTime(2026, 5, 31)),
        expect: () => const [
          UserActivitiesState(status: UserActivitiesStatus.loading),
          UserActivitiesState(status: UserActivitiesStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('state queries', () {
      test('forDay keeps only activities on the given day', () {
        final state = UserActivitiesState(activities: [activity]);
        expect(state.forDay(DateTime(2026, 5, 22)), [activity]);
        expect(state.forDay(DateTime(2026, 5, 23)), isEmpty);
      });
    });

    test('keeps the newest range when requests finish out of order', () async {
      final first = Completer<List<UserActivity>>();
      final second = Completer<List<UserActivity>>();
      var request = 0;
      when(
        () => scheduleRepository.getUserActivities(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) => request++ == 0 ? first.future : second.future);
      final newerActivity = activity.copyWith(id: 'newer');
      final cubit = buildCubit();
      addTearDown(cubit.close);

      final firstLoad = cubit.load(
        from: DateTime(2026, 5),
        to: DateTime(2026, 5, 31),
      );
      final secondLoad = cubit.load(
        from: DateTime(2026, 6),
        to: DateTime(2026, 6, 30),
      );
      second.complete([newerActivity]);
      await secondLoad;
      first.complete([activity]);
      await firstLoad;

      expect(cubit.state.activities, [newerActivity]);
      expect(cubit.state.status, UserActivitiesStatus.populated);
    });
  });
}
