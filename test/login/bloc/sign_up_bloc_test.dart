import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/login/bloc/sign_up_bloc.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const validEmail = 'student@university.example';
  const invalidEmail = 'not-an-email';
  const validPassword = 'password123';
  const shortPassword = 'short';

  group('SignUpBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      when(
        () => userRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
    });

    SignUpBloc buildBloc() => SignUpBloc(userRepository: userRepository);

    test('initial state is SignUpState()', () {
      expect(buildBloc().state, equals(const SignUpState()));
    });

    group('SignUpEmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'accepts a syntactically valid email when no domain policy is set',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignUpEmailChanged(validEmail)),
        expect: () => <SignUpState>[
          const SignUpState(email: Email.dirty(validEmail)),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits dirty invalid email and isValid false for a bad email',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignUpEmailChanged(invalidEmail)),
        expect: () => <SignUpState>[
          const SignUpState(email: Email.dirty(invalidEmail)),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits isValid true when password and confirmation are already valid',
        build: buildBloc,
        seed: () => const SignUpState(
          password: Password.dirty(validPassword),
          confirmedPassword: ConfirmedPassword.dirty(
            password: validPassword,
            value: validPassword,
          ),
        ),
        act: (bloc) => bloc.add(const SignUpEmailChanged(validEmail)),
        expect: () => <SignUpState>[
          const SignUpState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPassword,
              value: validPassword,
            ),
            isValid: true,
          ),
        ],
      );
    });

    group('SignUpPasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits dirty password and recomputed confirmedPassword',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignUpPasswordChanged(validPassword)),
        expect: () => <SignUpState>[
          const SignUpState(
            password: Password.dirty(validPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPassword,
            ),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits isValid false when password is too short',
        build: buildBloc,
        seed: () => const SignUpState(email: Email.dirty(validEmail)),
        act: (bloc) => bloc.add(const SignUpPasswordChanged(shortPassword)),
        expect: () => <SignUpState>[
          const SignUpState(
            email: Email.dirty(validEmail),
            password: Password.dirty(shortPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: shortPassword,
            ),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits isValid true when email and matching confirmation are present',
        build: buildBloc,
        seed: () => const SignUpState(
          email: Email.dirty(validEmail),
          confirmedPassword: ConfirmedPassword.dirty(
            password: '',
            value: validPassword,
          ),
        ),
        act: (bloc) => bloc.add(const SignUpPasswordChanged(validPassword)),
        expect: () => <SignUpState>[
          const SignUpState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPassword,
              value: validPassword,
            ),
            isValid: true,
          ),
        ],
      );
    });

    group('SignUpConfirmPasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits mismatch confirmation when it does not match the password',
        build: buildBloc,
        seed: () => const SignUpState(
          email: Email.dirty(validEmail),
          password: Password.dirty(validPassword),
        ),
        act: (bloc) =>
            bloc.add(const SignUpConfirmPasswordChanged('different')),
        expect: () => <SignUpState>[
          const SignUpState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPassword,
              value: 'different',
            ),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits isValid true when confirmation matches and inputs are valid',
        build: buildBloc,
        seed: () => const SignUpState(
          email: Email.dirty(validEmail),
          password: Password.dirty(validPassword),
        ),
        act: (bloc) =>
            bloc.add(const SignUpConfirmPasswordChanged(validPassword)),
        expect: () => <SignUpState>[
          const SignUpState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPassword,
              value: validPassword,
            ),
            isValid: true,
          ),
        ],
      );
    });

    group('SignUpSubmitted', () {
      const validState = SignUpState(
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        confirmedPassword: ConfirmedPassword.dirty(
          password: validPassword,
          value: validPassword,
        ),
        isValid: true,
      );

      blocTest<SignUpBloc, SignUpState>(
        'does nothing when state is not valid',
        build: buildBloc,
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => <SignUpState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          );
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [inProgress, success] when signUp succeeds',
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => <SignUpState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.signUp(
              email: validEmail,
              password: validPassword,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [inProgress, failure] when signUp throws',
        setUp: () {
          when(
            () => userRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('sign up failed'));
        },
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => <SignUpState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(status: FormzSubmissionStatus.failure),
        ],
      );
    });
  });
}
