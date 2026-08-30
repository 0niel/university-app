import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const validEmail = 'student@university.example';
  const invalidEmail = 'not-an-email';

  group('PasswordResetBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      when(
        () => userRepository.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenAnswer((_) async {});
    });

    PasswordResetBloc buildBloc() =>
        PasswordResetBloc(userRepository: userRepository);

    test('initial state is PasswordResetState()', () {
      expect(buildBloc().state, equals(const PasswordResetState()));
    });

    group('PasswordResetEmailChanged', () {
      blocTest<PasswordResetBloc, PasswordResetState>(
        'accepts a syntactically valid email when no domain policy is set',
        build: buildBloc,
        act: (bloc) => bloc.add(const PasswordResetEmailChanged(validEmail)),
        expect: () => <PasswordResetState>[
          const PasswordResetState(
            email: Email.dirty(validEmail),
            isValid: true,
          ),
        ],
      );

      blocTest<PasswordResetBloc, PasswordResetState>(
        'emits dirty email and isValid false for an invalid email',
        build: buildBloc,
        act: (bloc) => bloc.add(const PasswordResetEmailChanged(invalidEmail)),
        expect: () => <PasswordResetState>[
          const PasswordResetState(
            email: Email.dirty(invalidEmail),
          ),
        ],
      );
    });

    group('PasswordResetRequested', () {
      const validState = PasswordResetState(
        email: Email.dirty(validEmail),
        isValid: true,
      );

      blocTest<PasswordResetBloc, PasswordResetState>(
        'does nothing when state is not valid',
        build: buildBloc,
        act: (bloc) => bloc.add(PasswordResetRequested()),
        expect: () => <PasswordResetState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            ),
          );
        },
      );

      blocTest<PasswordResetBloc, PasswordResetState>(
        'emits [inProgress, success] when sendPasswordResetEmail succeeds',
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(PasswordResetRequested()),
        expect: () => <PasswordResetState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.sendPasswordResetEmail(email: validEmail),
          ).called(1);
        },
      );

      blocTest<PasswordResetBloc, PasswordResetState>(
        'emits [inProgress, failure] when sendPasswordResetEmail throws',
        setUp: () {
          when(
            () => userRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            ),
          ).thenThrow(Exception('reset failed'));
        },
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(PasswordResetRequested()),
        expect: () => <PasswordResetState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(status: FormzSubmissionStatus.failure),
        ],
        verify: (_) {
          verify(
            () => userRepository.sendPasswordResetEmail(email: validEmail),
          ).called(1);
        },
      );
    });
  });
}
