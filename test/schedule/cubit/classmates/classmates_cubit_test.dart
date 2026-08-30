import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';

class MockFriendsRepository extends Mock implements FriendsRepository {}

void main() {
  group('ClassmatesCubit', () {
    late FriendsRepository friendsRepository;

    const sameGroup = Friend(
      friendshipId: 'f-1',
      userId: 'u-1',
      fullName: 'Иван Петров',
      group: 'БСБО-01-22',
    );
    const otherGroup = Friend(
      friendshipId: 'f-2',
      userId: 'u-2',
      fullName: 'Пётр Иванов',
      group: 'БСБО-02-22',
    );

    setUp(() {
      friendsRepository = MockFriendsRepository();
      when(() => friendsRepository.currentUserId).thenReturn('me');
      when(
        () => friendsRepository.getFriends(),
      ).thenAnswer((_) async => [sameGroup, otherGroup]);
    });

    ClassmatesCubit buildCubit() =>
        ClassmatesCubit(friendsRepository: friendsRepository);

    test('initial state is empty ClassmatesState', () {
      expect(buildCubit().state, equals(const ClassmatesState()));
    });

    group('load', () {
      blocTest<ClassmatesCubit, ClassmatesState>(
        'emits [loading, loaded] keeping only friends in the group',
        build: buildCubit,
        act: (cubit) => cubit.load('БСБО-01-22'),
        expect: () => const [
          ClassmatesState(loading: true, group: 'БСБО-01-22'),
          ClassmatesState(classmates: [sameGroup], group: 'БСБО-01-22'),
        ],
      );

      blocTest<ClassmatesCubit, ClassmatesState>(
        'clears state for a blank group without calling the repository',
        build: buildCubit,
        seed: () => const ClassmatesState(
          classmates: [sameGroup],
          group: 'БСБО-01-22',
        ),
        act: (cubit) => cubit.load('  '),
        expect: () => const [ClassmatesState()],
        verify: (_) => verifyNever(() => friendsRepository.getFriends()),
      );

      blocTest<ClassmatesCubit, ClassmatesState>(
        'emits [loading, not-loading] and reports the error on failure',
        setUp: () => when(
          () => friendsRepository.getFriends(),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load('БСБО-01-22'),
        expect: () => const [
          ClassmatesState(loading: true, group: 'БСБО-01-22'),
          ClassmatesState(group: 'БСБО-01-22'),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
