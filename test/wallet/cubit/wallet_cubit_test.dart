import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/wallet/wallet.dart';

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  group('WalletCubit', () {
    late GamificationRepository gamificationRepository;

    const profile = UserGamificationProfile(
      userId: 'user-1',
      xp: 200,
      level: 4,
      shurikens: 88,
      streakDays: 9,
    );
    const overview = ProfileOverview(groupRank: 3, groupSize: 25);
    const earn = ShurikenEntry(title: 'Квест выполнен', amount: 10);
    const spend = ShurikenEntry(title: 'Стикерпак', amount: -5);

    setUp(() {
      gamificationRepository = MockGamificationRepository();
      when(
        () => gamificationRepository.getProfile(),
      ).thenAnswer((_) async => profile);
      when(
        () => gamificationRepository.getProfileOverview(any()),
      ).thenAnswer((_) async => overview);
      when(
        () => gamificationRepository.getShurikenHistory(
          any(),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const [earn, spend]);
    });

    WalletCubit buildCubit() => WalletCubit(
      gamificationRepository: gamificationRepository,
      organizationId: 'mirea',
    );

    test('initial state is WalletState with WalletStatus.initial', () {
      expect(buildCubit().state, equals(const WalletState()));
    });

    group('load', () {
      blocTest<WalletCubit, WalletState>(
        'emits [loading, populated] when every source succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <WalletState>[
          WalletState(status: WalletStatus.loading),
          WalletState(
            status: WalletStatus.populated,
            profile: profile,
            overview: overview,
            history: [earn, spend],
          ),
        ],
        verify: (_) {
          verify(() => gamificationRepository.getProfile()).called(1);
          verify(
            () => gamificationRepository.getProfileOverview(any()),
          ).called(1);
          verify(
            () => gamificationRepository.getShurikenHistory(
              any(),
              limit: any(named: 'limit'),
            ),
          ).called(1);
        },
      );

      blocTest<WalletCubit, WalletState>(
        'still emits populated, falling back to the empty value for the source '
        'that fails',
        // Reject with a correctly-typed Future so the cubit's per-source
        // `.catchError` fallback absorbs it (a synchronous throw would skip
        // the fallback and fail the whole load).
        setUp: () =>
            when(
              () => gamificationRepository.getShurikenHistory(
                any(),
                limit: any(named: 'limit'),
              ),
            ).thenAnswer(
              (_) => Future<List<ShurikenEntry>>.error(Exception('history')),
            ),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <WalletState>[
          WalletState(status: WalletStatus.loading),
          WalletState(
            status: WalletStatus.populated,
            profile: profile,
            overview: overview,
          ),
        ],
      );
    });

    group('tabChanged', () {
      blocTest<WalletCubit, WalletState>(
        'emits the newly selected wallet tab',
        build: buildCubit,
        act: (cubit) => cubit.tabChanged(WalletTab.history),
        expect: () => const <WalletState>[WalletState(tab: WalletTab.history)],
      );
    });
  });
}
