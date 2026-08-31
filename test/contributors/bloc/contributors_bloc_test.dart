import 'package:bloc_test/bloc_test.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  group('ContributorsBloc', () {
    late CommunityRepository communityRepository;

    const response = ContributorsResponse(
      contributors: [
        Contributor(
          login: '0niel',
          avatarUrl: 'https://avatars.githubusercontent.com/u/1',
          htmlUrl: 'https://github.com/0niel',
          contributions: 142,
        ),
      ],
    );

    setUp(() {
      communityRepository = MockCommunityRepository();
    });

    ContributorsBloc buildBloc() =>
        ContributorsBloc(communityRepository: communityRepository);

    test('initial state is ContributorsState()', () {
      final state = buildBloc().state;
      expect(state.status, ContributorsStatus.initial);
      expect(state.contributors.contributors, isEmpty);
    });

    blocTest<ContributorsBloc, ContributorsState>(
      'emits [loading, loaded] with the contributors on success',
      setUp: () => when(
        () => communityRepository.getContributors(),
      ).thenAnswer((_) async => response),
      build: buildBloc,
      act: (bloc) => bloc.add(const ContributorsRequested()),
      verify: (_) {
        verify(() => communityRepository.getContributors()).called(1);
      },
      expect: () => [
        const ContributorsState().copyWith(
          status: ContributorsStatus.loading,
        ),
        const ContributorsState().copyWith(
          status: ContributorsStatus.loaded,
          contributors: response,
        ),
      ],
    );

    blocTest<ContributorsBloc, ContributorsState>(
      'emits [loading, failure] and reports the error on failure',
      setUp: () => when(
        () => communityRepository.getContributors(),
      ).thenThrow(Exception('github down')),
      build: buildBloc,
      act: (bloc) => bloc.add(const ContributorsRequested()),
      expect: () => [
        const ContributorsState().copyWith(
          status: ContributorsStatus.loading,
        ),
        const ContributorsState().copyWith(
          status: ContributorsStatus.failure,
        ),
      ],
      errors: () => [isA<Exception>()],
    );

    blocTest<ContributorsBloc, ContributorsState>(
      'preserves loaded contributors when an offline refresh fails',
      setUp: () => when(
        () => communityRepository.getContributors(),
      ).thenThrow(Exception('offline')),
      seed: () => const ContributorsState(
        status: ContributorsStatus.loaded,
        contributors: response,
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const ContributorsRequested()),
      expect: () => const [
        ContributorsState(
          status: ContributorsStatus.loading,
          contributors: response,
        ),
        ContributorsState(
          status: ContributorsStatus.failure,
          contributors: response,
        ),
      ],
      errors: () => [isA<Exception>()],
    );
  });
}
