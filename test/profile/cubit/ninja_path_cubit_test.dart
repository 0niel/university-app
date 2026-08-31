import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';

class NinjaPathCubitTest extends Mock implements GamificationRepository {}

void main() {
  const organizationId = 'org-1';

  const earnedBadge = GamificationBadge(
    id: 'b1',
    category: 'streak',
    name: 'Огонёк',
    description: 'Серия из 7 дней',
    emoji: '🔥',
    rarity: 'rare',
    xpReward: 100,
    shurikenReward: 10,
    isEarned: true,
    progress: 1,
  );
  const lockedBadge = GamificationBadge(
    id: 'b2',
    category: 'social',
    name: 'Друг',
    description: 'Добавь друга',
    emoji: '🤝',
    xpReward: 50,
    shurikenReward: 5,
    progress: 0.5,
  );
  const quest = GamificationQuest(
    id: 'q1',
    period: 'daily',
    emoji: '🎯',
    title: 'Отметься на паре',
    target: 1,
    xpReward: 20,
  );
  const entry = LeaderboardEntry(
    userId: 'u1',
    displayName: 'Иван Иванов',
    xp: 500,
    level: 5,
    streakDays: 7,
    isCurrentUser: true,
  );

  late GamificationRepository gamificationRepository;

  setUp(() {
    gamificationRepository = NinjaPathCubitTest();
    when(
      () => gamificationRepository.getBadges(),
    ).thenAnswer((_) async => [earnedBadge, lockedBadge]);
    when(
      () => gamificationRepository.getQuests(),
    ).thenAnswer((_) async => [quest]);
    when(
      () => gamificationRepository.getLeaderboard(
        any(),
        scope: any(named: 'scope'),
      ),
    ).thenAnswer((_) async => [entry]);
  });

  NinjaPathCubit buildCubit() => .new(
    gamificationRepository: gamificationRepository,
    organizationId: organizationId,
  );

  group('NinjaPathCubit', () {
    test('initial state is NinjaPathState()', () {
      expect(buildCubit().state, equals(const NinjaPathState()));
    });

    group('load', () {
      blocTest<NinjaPathCubit, NinjaPathState>(
        'loads badges, quests and the leaderboard into a loaded state',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          verify(() => gamificationRepository.getBadges()).called(1);
          verify(() => gamificationRepository.getQuests()).called(1);
          verify(
            () => gamificationRepository.getLeaderboard(organizationId),
          ).called(1);

          expect(cubit.state.badgesStatus, NinjaPathLoadStatus.loaded);
          expect(cubit.state.questsStatus, NinjaPathLoadStatus.loaded);
          expect(cubit.state.leaderboardStatus, NinjaPathLoadStatus.loaded);
          expect(cubit.state.badges, [earnedBadge, lockedBadge]);
          expect(cubit.state.quests, [quest]);
          expect(cubit.state.leaderboard, [entry]);
          expect(cubit.state.recentlyUnlocked, earnedBadge);
        },
      );

      blocTest<NinjaPathCubit, NinjaPathState>(
        'marks badges as error when getBadges throws',
        setUp: () => when(
          () => gamificationRepository.getBadges(),
        ).thenThrow(Exception('badges')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.badgesStatus, NinjaPathLoadStatus.error);
          expect(cubit.state.questsStatus, NinjaPathLoadStatus.loaded);
          expect(cubit.state.leaderboardStatus, NinjaPathLoadStatus.loaded);
        },
      );

      blocTest<NinjaPathCubit, NinjaPathState>(
        'marks quests as error when getQuests throws',
        setUp: () => when(
          () => gamificationRepository.getQuests(),
        ).thenThrow(Exception('quests')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.questsStatus, NinjaPathLoadStatus.error);
          expect(cubit.state.badgesStatus, NinjaPathLoadStatus.loaded);
        },
      );

      blocTest<NinjaPathCubit, NinjaPathState>(
        'never asks for the retired squad challenge',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          verifyNever(() => gamificationRepository.getSquadChallenge(any()));
          expect(cubit.state.questsStatus, NinjaPathLoadStatus.loaded);
          expect(cubit.state.quests, [quest]);
        },
      );
    });

    group('loadLeaderboard', () {
      blocTest<NinjaPathCubit, NinjaPathState>(
        'emits [loading, loaded] with the requested scope on success',
        build: buildCubit,
        act: (cubit) => cubit.loadLeaderboard(.all),
        verify: (_) {
          verify(
            () => gamificationRepository.getLeaderboard(
              organizationId,
              scope: 'all',
            ),
          ).called(1);
        },
        expect: () => const <NinjaPathState>[
          NinjaPathState(
            leaderboardStatus: .loading,
            leaderboardScope: .all,
          ),
          NinjaPathState(
            leaderboardStatus: .loaded,
            leaderboardScope: .all,
            leaderboard: [entry],
          ),
        ],
      );

      blocTest<NinjaPathCubit, NinjaPathState>(
        'emits [loading, error] when getLeaderboard throws',
        setUp: () => when(
          () => gamificationRepository.getLeaderboard(
            any(),
            scope: any(named: 'scope'),
          ),
        ).thenThrow(Exception('leaderboard')),
        build: buildCubit,
        act: (cubit) => cubit.loadLeaderboard(.all),
        expect: () => const <NinjaPathState>[
          NinjaPathState(
            leaderboardStatus: .loading,
            leaderboardScope: .all,
          ),
          NinjaPathState(
            leaderboardStatus: .error,
            leaderboardScope: .all,
          ),
        ],
      );

      test('ignores a stale response from the previous scope', () async {
        final groupResponse = Completer<List<LeaderboardEntry>>();
        final allResponse = Completer<List<LeaderboardEntry>>();
        const allEntry = LeaderboardEntry(
          userId: 'u2',
          displayName: 'Мария',
          xp: 900,
          level: 8,
          streakDays: 3,
        );
        when(
          () => gamificationRepository.getLeaderboard(organizationId),
        ).thenAnswer((_) => groupResponse.future);
        when(
          () => gamificationRepository.getLeaderboard(
            organizationId,
            scope: 'all',
          ),
        ).thenAnswer((_) => allResponse.future);
        final cubit = buildCubit();

        final groupLoad = cubit.loadLeaderboard(.group);
        final allLoad = cubit.loadLeaderboard(.all);
        allResponse.complete([allEntry]);
        await allLoad;
        groupResponse.complete([entry]);
        await groupLoad;

        expect(cubit.state.leaderboardScope, LeaderboardScope.all);
        expect(cubit.state.leaderboard, [allEntry]);
        await cubit.close();
      });
    });
  });
}
