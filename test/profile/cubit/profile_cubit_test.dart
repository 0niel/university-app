import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:user_repository/user_repository.dart';

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  const organizationId = 'org-1';
  const currentUser = User(id: 'u1');

  const profile = UserGamificationProfile(
    userId: 'u1',
    xp: 1200,
    level: 5,
    shurikens: 42,
    streakDays: 7,
  );
  const overview = ProfileOverview(
    groupRank: 3,
    groupSize: 30,
    earnedBadges: 4,
    totalBadges: 10,
  );
  const dailyQuest = GamificationQuest(
    id: 'q1',
    period: 'daily',
    emoji: '🎯',
    title: 'Отметься на паре',
    target: 1,
    xpReward: 20,
  );
  const weeklyQuest = GamificationQuest(
    id: 'q2',
    period: 'weekly',
    emoji: '📅',
    title: 'Неделя активности',
    target: 5,
    xpReward: 100,
    progress: 2,
  );
  const entry = LeaderboardEntry(
    userId: 'u1',
    displayName: 'Иван Иванов',
    xp: 500,
    level: 5,
    streakDays: 7,
    isCurrentUser: true,
  );
  const badge = GamificationBadge(
    id: 'b1',
    category: 'Активность',
    name: 'Огонёк',
    description: 'Серия из 7 дней',
    emoji: '🔥',
    rarity: 'rare',
    xpReward: 100,
    shurikenReward: 10,
    isEarned: true,
    progress: 1,
  );
  const settings = UserSettings(notificationsEnabled: false);

  late GamificationRepository gamificationRepository;

  setUpAll(() {
    registerFallbackValue(const UserSettings());
  });

  setUp(() {
    gamificationRepository = MockGamificationRepository();
    when(
      () => gamificationRepository.syncGamification(),
    ).thenAnswer((_) async => const <GamificationBadge>[]);
    when(
      () => gamificationRepository.recordActiveDay(),
    ).thenAnswer((_) async {});
    when(
      () => gamificationRepository.ensureProfile(any()),
    ).thenAnswer((_) async => profile);
    when(
      () => gamificationRepository.getProfileOverview(any()),
    ).thenAnswer((_) async => overview);
    when(
      () => gamificationRepository.getQuests(),
    ).thenAnswer((_) async => [dailyQuest, weeklyQuest]);
    when(
      () => gamificationRepository.getLeaderboard(
        any(),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => [entry]);
    when(
      () => gamificationRepository.getBadges(),
    ).thenAnswer((_) async => [badge]);
    when(
      () => gamificationRepository.getSettings(),
    ).thenAnswer((_) async => settings);
  });

  ProfileCubit buildCubit() => ProfileCubit(
    gamificationRepository: gamificationRepository,
    organizationId: organizationId,
    currentUser: currentUser,
  );

  group('ProfileCubit', () {
    test('initial state seeds the current user', () {
      final cubit = buildCubit();
      expect(cubit.state.status, ProfileStatus.initial);
      expect(cubit.state.user, currentUser);
      expect(cubit.state.gamificationProfile, UserGamificationProfile.empty);
      expect(cubit.state.overview, ProfileOverview.empty);
      expect(cubit.state.failedSections, isEmpty);
      expect(cubit.state.newlyEarnedBadges, isEmpty);
      expect(cubit.state, equals(const ProfileState(user: currentUser)));
    });

    group('state getters', () {
      const completedDaily = GamificationQuest(
        id: 'q3',
        period: 'daily',
        emoji: '✅',
        title: 'Выполнено',
        target: 1,
        xpReward: 30,
        progress: 1,
        isCompleted: true,
      );

      const state = ProfileState(
        quests: [dailyQuest, weeklyQuest, completedDaily],
      );

      test('dailyQuests returns only daily quests', () {
        expect(state.dailyQuests, [dailyQuest, completedDaily]);
      });

      test('dailyDone counts completed daily quests', () {
        expect(state.dailyDone, 1);
      });

      test('dailyXpLeft sums xp of incomplete daily quests', () {
        expect(state.dailyXpLeft, dailyQuest.xpReward);
      });

      test('earnedBadges lists unlocked badges, newest first', () {
        final older = badge.copyWith(id: 'old', earnedAt: DateTime(2026));
        final newer = badge.copyWith(id: 'new', earnedAt: DateTime(2026, 6));
        const locked = GamificationBadge(
          id: 'locked',
          category: 'Учёба',
          name: 'Заметки',
          description: 'Оставь 10 заметок',
          emoji: '📝',
        );
        final state = ProfileState(badges: [older, locked, newer]);

        expect(state.earnedBadges, [newer, older]);
      });

      test('closestBadges keeps the three nearest locked badges', () {
        const template = GamificationBadge(
          id: 'x',
          category: 'Учёба',
          name: 'Заметки',
          description: 'Оставь 10 заметок',
          emoji: '📝',
        );
        final badges = [
          badge,
          template.copyWith(id: 'a', progress: 0.1),
          template.copyWith(id: 'b', progress: 0.9),
          template.copyWith(id: 'c', progress: 0.5),
          template.copyWith(id: 'd', progress: 0.7),
        ];
        final state = ProfileState(badges: badges);

        expect(
          state.closestBadges.map((item) => item.id),
          ['b', 'd', 'c'],
        );
      });

      test('hasStreakHistory requires a full two-week history', () {
        expect(const ProfileState().hasStreakHistory, isFalse);
        expect(
          ProfileState(
            overview: ProfileOverview(
              streakHistory: List.filled(kStreakHistoryDays, true),
            ),
          ).hasStreakHistory,
          isTrue,
        );
      });
    });

    group('load', () {
      blocTest<ProfileCubit, ProfileState>(
        'syncs the server state, then fans the sections out in parallel',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          verifyInOrder([
            () => gamificationRepository.syncGamification(),
            () => gamificationRepository.ensureProfile(organizationId),
          ]);
          verify(() => gamificationRepository.recordActiveDay()).called(1);
          verify(
            () => gamificationRepository.getProfileOverview(organizationId),
          ).called(1);
          verify(() => gamificationRepository.getQuests()).called(1);
          verify(
            () => gamificationRepository.getLeaderboard(
              organizationId,
              limit: 4,
            ),
          ).called(1);
          verify(() => gamificationRepository.getBadges()).called(1);
          verify(() => gamificationRepository.getSettings()).called(1);

          expect(cubit.state.status, ProfileStatus.loaded);
          expect(cubit.state.gamificationProfile, profile);
          expect(cubit.state.overview, overview);
          expect(cubit.state.quests, [dailyQuest, weeklyQuest]);
          expect(cubit.state.leaderboard, [entry]);
          expect(cubit.state.badges, [badge]);
          expect(cubit.state.settings, settings);
          expect(cubit.state.failedSections, isEmpty);
        },
      );

      test('exposes the badges earned by the sync, until celebrated', () async {
        when(
          () => gamificationRepository.syncGamification(),
        ).thenAnswer((_) async => [badge]);
        final cubit = buildCubit();

        await cubit.load();
        expect(cubit.state.newlyEarnedBadges, [badge]);

        cubit.celebrationsShown();
        expect(cubit.state.newlyEarnedBadges, isEmpty);
        await cubit.close();
      });

      blocTest<ProfileCubit, ProfileState>(
        'still loads the sections when the sync fails',
        setUp: () => when(
          () => gamificationRepository.syncGamification(),
        ).thenThrow(Exception('sync')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.status, ProfileStatus.loaded);
          expect(cubit.state.newlyEarnedBadges, isEmpty);
          expect(cubit.state.gamificationProfile, profile);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'flags the sections that failed and keeps the ones that did not',
        setUp: () {
          when(
            () => gamificationRepository.getQuests(),
          ).thenThrow(Exception('quests'));
          when(
            () => gamificationRepository.getBadges(),
          ).thenThrow(Exception('badges'));
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.status, ProfileStatus.loaded);
          expect(cubit.state.failedSections, {
            ProfileSection.quests,
            ProfileSection.badges,
          });
          expect(cubit.state.hasFailed(ProfileSection.quests), isTrue);
          expect(cubit.state.hasFailed(ProfileSection.leaderboard), isFalse);
          expect(cubit.state.quests, isEmpty);
          expect(cubit.state.badges, isEmpty);
          expect(cubit.state.leaderboard, [entry]);
          expect(cubit.state.overview, overview);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'emits error status when the profile is missing entirely',
        setUp: () => when(
          () => gamificationRepository.ensureProfile(any()),
        ).thenThrow(Exception('profile')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.status, ProfileStatus.error);
          expect(cubit.state.hasFailed(ProfileSection.profile), isTrue);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'keeps the cached profile visible when a refresh fails',
        setUp: () => when(
          () => gamificationRepository.ensureProfile(any()),
        ).thenThrow(Exception('profile')),
        build: buildCubit,
        seed: () => const ProfileState(
          user: currentUser,
          gamificationProfile: profile,
        ),
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.status, ProfileStatus.loaded);
          expect(cubit.state.gamificationProfile, profile);
          expect(cubit.state.hasFailed(ProfileSection.profile), isTrue);
        },
      );

      test('does not apply settings loaded before a newer update', () async {
        final staleSettings = Completer<UserSettings>();
        const updatedSettings = UserSettings(themeMode: 'dark');
        when(
          () => gamificationRepository.getSettings(),
        ).thenAnswer((_) => staleSettings.future);
        when(
          () => gamificationRepository.updateSettings(
            updatedSettings,
            previous: any(named: 'previous'),
          ),
        ).thenAnswer((_) async => updatedSettings);
        final cubit = buildCubit();

        final load = cubit.load();
        await untilCalled(() => gamificationRepository.getSettings());
        await cubit.updateSettings(updatedSettings);
        staleSettings.complete(settings);
        await load;

        expect(cubit.state.settings, updatedSettings);
        await cubit.close();
      });

      test('does not emit when closed during the section fan-out', () async {
        final profileResponse = Completer<UserGamificationProfile>();
        when(
          () => gamificationRepository.ensureProfile(organizationId),
        ).thenAnswer((_) => profileResponse.future);
        final cubit = buildCubit();

        final load = cubit.load();
        await untilCalled(
          () => gamificationRepository.ensureProfile(organizationId),
        );
        await cubit.close();
        profileResponse.complete(profile);

        await expectLater(load, completes);
        expect(cubit.state.gamificationProfile, UserGamificationProfile.empty);
      });

      blocTest<ProfileCubit, ProfileState>(
        'is a no-op while a load is already in flight',
        build: buildCubit,
        seed: () => const ProfileState(status: ProfileStatus.loading),
        act: (cubit) => cubit.load(),
        expect: () => const <ProfileState>[],
        verify: (_) {
          verifyNever(() => gamificationRepository.ensureProfile(any()));
        },
      );
    });

    group('reloadSection', () {
      blocTest<ProfileCubit, ProfileState>(
        'clears the failure flag once the section loads',
        build: buildCubit,
        seed: () => const ProfileState(
          user: currentUser,
          status: ProfileStatus.loaded,
          failedSections: {ProfileSection.quests, ProfileSection.badges},
        ),
        act: (cubit) => cubit.reloadSection(ProfileSection.quests),
        verify: (cubit) {
          expect(cubit.state.quests, [dailyQuest, weeklyQuest]);
          expect(cubit.state.failedSections, {ProfileSection.badges});
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'keeps the failure flag when the retry fails again',
        setUp: () => when(
          () => gamificationRepository.getLeaderboard(
            any(),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception('leaderboard')),
        build: buildCubit,
        seed: () => const ProfileState(
          user: currentUser,
          status: ProfileStatus.loaded,
        ),
        act: (cubit) => cubit.reloadSection(ProfileSection.leaderboard),
        verify: (cubit) {
          expect(cubit.state.failedSections, {ProfileSection.leaderboard});
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'refreshes the settings section',
        build: buildCubit,
        seed: () => const ProfileState(
          user: currentUser,
          failedSections: {ProfileSection.settings},
        ),
        act: (cubit) => cubit.reloadSection(ProfileSection.settings),
        verify: (cubit) {
          expect(cubit.state.settings, settings);
          expect(cubit.state.failedSections, isEmpty);
        },
      );
    });

    group('updateSettings', () {
      const next = UserSettings(notificationsEnabled: false, themeMode: 'dark');
      const persisted = UserSettings(
        notificationsEnabled: false,
        themeMode: 'dark',
        accentColor: 'red',
      );

      blocTest<ProfileCubit, ProfileState>(
        'optimistically emits, then emits the persisted settings on success',
        setUp: () => when(
          () => gamificationRepository.updateSettings(
            any(),
            previous: any(named: 'previous'),
          ),
        ).thenAnswer((_) async => persisted),
        build: buildCubit,
        act: (cubit) => cubit.updateSettings(next),
        expect: () => const <ProfileState>[
          ProfileState(user: currentUser, settings: next),
          ProfileState(user: currentUser, settings: persisted),
        ],
        verify: (_) {
          // The last known server state travels along so the RPC only has to
          // write the fields that actually changed.
          verify(
            () => gamificationRepository.updateSettings(
              next,
              previous: const UserSettings(),
            ),
          ).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'sends the freshly loaded settings as the partial-update base',
        setUp: () => when(
          () => gamificationRepository.updateSettings(
            any(),
            previous: any(named: 'previous'),
          ),
        ).thenAnswer((_) async => persisted),
        build: buildCubit,
        act: (cubit) async {
          await cubit.load();
          await cubit.updateSettings(next);
        },
        verify: (_) {
          verify(
            () => gamificationRepository.updateSettings(
              next,
              previous: settings,
            ),
          ).called(1);
        },
      );

      blocTest<ProfileCubit, ProfileState>(
        'rolls back to the persisted settings when updateSettings throws',
        setUp: () => when(
          () => gamificationRepository.updateSettings(
            any(),
            previous: any(named: 'previous'),
          ),
        ).thenThrow(Exception('update')),
        build: buildCubit,
        act: (cubit) => cubit.updateSettings(next),
        expect: () => const <ProfileState>[
          ProfileState(user: currentUser, settings: next),
          ProfileState(user: currentUser),
        ],
      );

      test('persists concurrent updates in user-action order', () async {
        const first = UserSettings(themeMode: 'dark');
        const second = UserSettings(themeMode: 'dark', accentColor: 'red');
        final firstResponse = Completer<UserSettings>();
        final secondResponse = Completer<UserSettings>();
        when(
          () => gamificationRepository.updateSettings(
            first,
            previous: any(named: 'previous'),
          ),
        ).thenAnswer((_) => firstResponse.future);
        when(
          () => gamificationRepository.updateSettings(
            second,
            previous: any(named: 'previous'),
          ),
        ).thenAnswer((_) => secondResponse.future);
        final cubit = buildCubit();

        final firstUpdate = cubit.updateSettings(first);
        final secondUpdate = cubit.updateSettings(second);
        await Future<void>.delayed(Duration.zero);
        verify(
          () => gamificationRepository.updateSettings(
            first,
            previous: const UserSettings(),
          ),
        ).called(1);
        verifyNever(
          () => gamificationRepository.updateSettings(
            second,
            previous: any(named: 'previous'),
          ),
        );

        firstResponse.complete(first);
        await firstUpdate;
        await Future<void>.delayed(Duration.zero);
        verify(
          () => gamificationRepository.updateSettings(
            second,
            previous: first,
          ),
        ).called(1);
        secondResponse.complete(second);
        await secondUpdate;

        expect(cubit.state.settings, second);
        await cubit.close();
      });
    });

    group('updateIdentity', () {
      const updatedOverview = ProfileOverview(groupRank: 1, groupSize: 30);

      blocTest<ProfileCubit, ProfileState>(
        'emits the refreshed overview and returns success',
        setUp: () => when(
          () => gamificationRepository.setUserIdentity(
            organizationId: any(named: 'organizationId'),
            fullName: any(named: 'fullName'),
            handle: any(named: 'handle'),
          ),
        ).thenAnswer((_) async => updatedOverview),
        build: buildCubit,
        act: (cubit) async {
          final result = await cubit.updateIdentity(
            fullName: 'Иван Иванов',
            handle: 'ivan_99',
          );
          expect(result, IdentityUpdateResult.success);
        },
        expect: () => const <ProfileState>[
          ProfileState(user: currentUser, overview: updatedOverview),
        ],
        verify: (_) {
          verify(
            () => gamificationRepository.setUserIdentity(
              organizationId: organizationId,
              fullName: 'Иван Иванов',
              handle: 'ivan_99',
            ),
          ).called(1);
        },
      );

      test('returns handleTaken without changing state', () async {
        when(
          () => gamificationRepository.setUserIdentity(
            organizationId: any(named: 'organizationId'),
            fullName: any(named: 'fullName'),
            handle: any(named: 'handle'),
          ),
        ).thenThrow(const HandleTakenException());
        final cubit = buildCubit();
        final result = await cubit.updateIdentity(
          fullName: 'A',
          handle: 'taken_one',
        );
        expect(result, IdentityUpdateResult.handleTaken);
        expect(cubit.state.overview, ProfileOverview.empty);
      });

      test('returns error on a generic failure', () async {
        when(
          () => gamificationRepository.setUserIdentity(
            organizationId: any(named: 'organizationId'),
            fullName: any(named: 'fullName'),
            handle: any(named: 'handle'),
          ),
        ).thenThrow(Exception('boom'));
        final cubit = buildCubit();
        final result = await cubit.updateIdentity(
          fullName: 'A',
          handle: 'abc',
        );
        expect(result, IdentityUpdateResult.error);
      });
    });
  });
}
