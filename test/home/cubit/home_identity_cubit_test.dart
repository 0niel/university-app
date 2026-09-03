import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/home/cubit/home_identity_cubit.dart';

class MockGamificationRepository extends Mock
    implements GamificationRepository {}

void main() {
  const organizationId = 'org-1';

  late MockGamificationRepository repository;

  setUp(() {
    repository = MockGamificationRepository();
  });

  test('initial state is not loaded', () async {
    final cubit = HomeIdentityCubit(repository, organizationId);
    expect(cubit.state.status, HomeIdentityStatus.initial);
    expect(cubit.state.isLoaded, isFalse);
    await cubit.close();
  });

  blocTest<HomeIdentityCubit, HomeIdentityState>(
    'load exposes the academic full name and handle once fetched',
    setUp: () {
      when(() => repository.getProfileOverview(organizationId)).thenAnswer(
        (_) async => const ProfileOverview(
          academic: AcademicProfile(
            fullName: 'Олег Ковалёв',
            handle: 'oleg',
          ),
        ),
      );
    },
    build: () => HomeIdentityCubit(repository, organizationId),
    act: (cubit) => cubit.load(),
    expect: () => [
      predicate<HomeIdentityState>(
        (state) =>
            state.isLoaded &&
            state.fullName == 'Олег Ковалёв' &&
            state.handle == 'oleg',
      ),
    ],
  );

  blocTest<HomeIdentityCubit, HomeIdentityState>(
    'load marks itself as loaded even when the fetch fails',
    setUp: () {
      when(
        () => repository.getProfileOverview(organizationId),
      ).thenThrow(Exception('network'));
    },
    build: () => HomeIdentityCubit(repository, organizationId),
    act: (cubit) => cubit.load(),
    expect: () => [
      predicate<HomeIdentityState>(
        (state) =>
            state.isLoaded && state.fullName == null && state.handle == null,
      ),
    ],
  );
}
