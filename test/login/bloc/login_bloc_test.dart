import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/login/bloc/login_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class _MessagelessException implements Exception {
  const _MessagelessException();
}

class _TestAuthenticationFailure extends AuthenticationException {
  const _TestAuthenticationFailure(super.error);
}

void main() {
  const validEmail = 'student@university.example';
  const invalidEmail = 'not-an-email';
  const validPassword = 'password123';
  const shortPassword = 'short';

  group('LoginBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      when(
        () => userRepository.logInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => userRepository.sendLoginEmailLink(email: any(named: 'email')),
      ).thenAnswer((_) async {});
      when(() => userRepository.signInAnonymously()).thenAnswer((_) async {});
    });

    LoginBloc buildBloc() => LoginBloc(userRepository: userRepository);

    LoginBloc buildUniversityBloc() => LoginBloc(
      userRepository: userRepository,
      allowedEmailDomains: const ['university.example'],
    );

    test('initial state is LoginState()', () {
      expect(buildBloc().state, equals(const LoginState()));
    });

    group('LoginEmailChanged', () {
      blocTest<LoginBloc, LoginState>(
        'uses the deployment email-domain policy',
        build: buildUniversityBloc,
        act: (bloc) =>
            bloc.add(const LoginEmailChanged('student@university.example')),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirtyWithDomains(
              'student@university.example',
              allowedDomains: ['university.example'],
            ),
            isEmailValid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'normalizes surrounding whitespace before validation and submission',
        build: buildUniversityBloc,
        act: (bloc) => bloc.add(
          const LoginEmailChanged('  student@university.example  '),
        ),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirtyWithDomains(
              'student@university.example',
              allowedDomains: ['university.example'],
            ),
            isEmailValid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'accepts a syntactically valid email when no domain policy is set',
        build: buildBloc,
        act: (bloc) => bloc.add(const LoginEmailChanged(validEmail)),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirty(validEmail),
            isEmailValid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits dirty email and isEmailValid false for an invalid email',
        build: buildBloc,
        act: (bloc) => bloc.add(const LoginEmailChanged(invalidEmail)),
        expect: () => <LoginState>[
          const LoginState(email: Email.dirty(invalidEmail)),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits isValid true when password is already valid',
        build: buildBloc,
        seed: () => const LoginState(password: Password.dirty(validPassword)),
        act: (bloc) => bloc.add(const LoginEmailChanged(validEmail)),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            isEmailValid: true,
            isValid: true,
          ),
        ],
      );
    });

    group('LoginPasswordChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits dirty password without isValid when email is pure',
        build: buildBloc,
        act: (bloc) => bloc.add(const LoginPasswordChanged(validPassword)),
        expect: () => <LoginState>[
          const LoginState(password: Password.dirty(validPassword)),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits isValid true when email is already valid',
        build: buildBloc,
        seed: () => const LoginState(
          email: Email.dirty(validEmail),
          isEmailValid: true,
        ),
        act: (bloc) => bloc.add(const LoginPasswordChanged(validPassword)),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirty(validEmail),
            password: Password.dirty(validPassword),
            isEmailValid: true,
            isValid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits isValid false when password is too short',
        build: buildBloc,
        seed: () => const LoginState(
          email: Email.dirty(validEmail),
          isEmailValid: true,
        ),
        act: (bloc) => bloc.add(const LoginPasswordChanged(shortPassword)),
        expect: () => <LoginState>[
          const LoginState(
            email: Email.dirty(validEmail),
            password: Password.dirty(shortPassword),
            isEmailValid: true,
          ),
        ],
      );
    });

    group('LoginWithPasswordSubmitted', () {
      const validState = LoginState(
        email: Email.dirty(validEmail),
        password: Password.dirty(validPassword),
        isEmailValid: true,
        isValid: true,
      );

      blocTest<LoginBloc, LoginState>(
        'does nothing when state is not valid',
        build: buildBloc,
        act: (bloc) => bloc.add(LoginWithPasswordSubmitted()),
        expect: () => <LoginState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.logInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          );
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when logInWithPassword succeeds',
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(LoginWithPasswordSubmitted()),
        expect: () => <LoginState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.logInWithPassword(
              email: validEmail,
              password: validPassword,
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'maps the stable auth code to invalid credentials',
        setUp: () {
          when(
            () => userRepository.logInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            const _TestAuthenticationFailure(
              AuthException(
                'Invalid login credentials',
                statusCode: '400',
                code: 'invalid_credentials',
              ),
            ),
          );
        },
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(LoginWithPasswordSubmitted()),
        expect: () => <LoginState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(
            status: FormzSubmissionStatus.failure,
            errorKind: LoginErrorKind.invalidCredentials,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'maps an unclassified failure to the localized generic state',
        setUp: () {
          when(
            () => userRepository.logInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(const _MessagelessException());
        },
        build: buildBloc,
        seed: () => validState,
        act: (bloc) => bloc.add(LoginWithPasswordSubmitted()),
        expect: () => <LoginState>[
          validState.copyWith(status: FormzSubmissionStatus.inProgress),
          validState.copyWith(
            status: FormzSubmissionStatus.failure,
            errorKind: LoginErrorKind.generic,
          ),
        ],
      );
    });

    group('EmailLinkRequested', () {
      const validEmailState = LoginState(
        email: Email.dirty(validEmail),
        isEmailValid: true,
      );

      blocTest<LoginBloc, LoginState>(
        'does nothing when email is not valid',
        build: buildBloc,
        act: (bloc) => bloc.add(EmailLinkRequested()),
        expect: () => <LoginState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.sendLoginEmailLink(email: any(named: 'email')),
          );
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when sendLoginEmailLink succeeds',
        build: buildBloc,
        seed: () => validEmailState,
        act: (bloc) => bloc.add(EmailLinkRequested()),
        expect: () => <LoginState>[
          validEmailState.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
          validEmailState.copyWith(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.sendLoginEmailLink(email: validEmail),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, failure] when sendLoginEmailLink throws',
        setUp: () {
          when(
            () => userRepository.sendLoginEmailLink(email: any(named: 'email')),
          ).thenThrow(Exception('send failed'));
        },
        build: buildBloc,
        seed: () => validEmailState,
        act: (bloc) => bloc.add(EmailLinkRequested()),
        expect: () => <LoginState>[
          validEmailState.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
          validEmailState.copyWith(
            status: FormzSubmissionStatus.failure,
            errorKind: LoginErrorKind.generic,
          ),
        ],
      );
    });

    group('ContinueAsGuestRequested', () {
      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when signInAnonymously succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(ContinueAsGuestRequested()),
        expect: () => <LoginState>[
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(() => userRepository.signInAnonymously()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, failure] with the guest kind when the error '
        'has no message',
        setUp: () {
          when(
            () => userRepository.signInAnonymously(),
          ).thenThrow(const _MessagelessException());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(ContinueAsGuestRequested()),
        expect: () => <LoginState>[
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
            status: FormzSubmissionStatus.failure,
            errorKind: LoginErrorKind.guestUnavailable,
          ),
        ],
      );
    });
  });
}
