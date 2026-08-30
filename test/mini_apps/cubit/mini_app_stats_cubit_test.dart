import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_stats_cubit.dart';

class MockMiniAppsRepository extends Mock implements MiniAppsRepository {}

void main() {
  final stats = [
    MiniAppDailyStat(day: DateTime(2026, 6), launches: 5, uniqueUsers: 3),
    MiniAppDailyStat(day: DateTime(2026, 6, 2), launches: 8, uniqueUsers: 4),
  ];

  group('MiniAppStatsCubit', () {
    late MiniAppsRepository repository;

    setUp(() {
      repository = MockMiniAppsRepository();
      when(
        () => repository.getStats(any(), days: any(named: 'days')),
      ).thenAnswer((_) async => stats);
    });

    MiniAppStatsCubit buildCubit() =>
        MiniAppStatsCubit(miniAppsRepository: repository, appId: 'app-1');

    test('initial state is initial with the 30-day range', () {
      expect(buildCubit().state, const MiniAppStatsState());
    });

    group('load', () {
      blocTest<MiniAppStatsCubit, MiniAppStatsState>(
        'emits [loading, populated] for the default range when getStats '
        'succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => <MiniAppStatsState>[
          const MiniAppStatsState(status: MiniAppStatsStatus.loading),
          MiniAppStatsState(
            status: MiniAppStatsStatus.populated,
            stats: stats,
          ),
        ],
        verify: (_) => verify(() => repository.getStats('app-1')).called(1),
      );

      blocTest<MiniAppStatsCubit, MiniAppStatsState>(
        'emits [loading, failure] and reports the error when getStats fails',
        setUp: () => when(
          () => repository.getStats(any(), days: any(named: 'days')),
        ).thenThrow(const GetMiniAppStatsFailure('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <MiniAppStatsState>[
          MiniAppStatsState(status: MiniAppStatsStatus.loading),
          MiniAppStatsState(status: MiniAppStatsStatus.failure),
        ],
        errors: () => [isA<GetMiniAppStatsFailure>()],
      );
    });

    group('rangeChanged', () {
      blocTest<MiniAppStatsCubit, MiniAppStatsState>(
        'refetches with the new range days',
        build: buildCubit,
        act: (cubit) => cubit.rangeChanged(MiniAppStatsRange.week),
        expect: () => <MiniAppStatsState>[
          const MiniAppStatsState(
            status: MiniAppStatsStatus.loading,
            range: MiniAppStatsRange.week,
          ),
          MiniAppStatsState(
            status: MiniAppStatsStatus.populated,
            range: MiniAppStatsRange.week,
            stats: stats,
          ),
        ],
        verify: (_) =>
            verify(() => repository.getStats('app-1', days: 7)).called(1),
      );

      blocTest<MiniAppStatsCubit, MiniAppStatsState>(
        'is a no-op when the range is already selected and populated',
        build: buildCubit,
        seed: () => MiniAppStatsState(
          status: MiniAppStatsStatus.populated,
          stats: stats,
        ),
        act: (cubit) => cubit.rangeChanged(MiniAppStatsRange.month),
        expect: () => const <MiniAppStatsState>[],
        verify: (_) => verifyNever(
          () => repository.getStats(any(), days: any(named: 'days')),
        ),
      );
    });
  });
}
