import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/login/bloc/login_with_email_link_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // A non-anonymous user (any non-empty id) so the "already logged in"
  // guard triggers when seeded.
  const loggedInUser = User(id: 'user-123');

  // A valid email link: carries a `code` param and a `continueUrl` whose
  // own query string contains an `email` param.
  final validEmailLink = Uri.parse(
    'https://mirea.ninja/login?code=abc123'
    '&continueUrl=${Uri.encodeQueryComponent(
      'https://mirea.ninja/finish?email=student@mirea.ru',
    )}',
  );

  group('LoginWithEmailLinkBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      // The constructor subscribes to incomingEmailLinks immediately, so it
      // must always be stubbed. Keep it empty so no spurious events fire.
      when(
        () => userRepository.incomingEmailLinks,
      ).thenAnswer((_) => const Stream<Uri>.empty());
      // Default: an anonymous user, so handlers pass the "already logged in"
      // guard and proceed.
      when(
        () => userRepository.user,
      ).thenAnswer((_) => Stream<User>.value(User.anonymous));
      when(
        () => userRepository.logInWithEmailLink(
          email: any(named: 'email'),
          emailLink: any(named: 'emailLink'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => userRepository.logInWithEmailCode(
          email: any(named: 'email'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async {});
    });

    LoginWithEmailLinkBloc buildBloc() =>
        LoginWithEmailLinkBloc(userRepository: userRepository);

    test('initial state is LoginWithEmailLinkState()', () {
      expect(buildBloc().state, equals(const LoginWithEmailLinkState()));
    });

    group('LoginWithEmailLinkSubmitted', () {
      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, success] when logInWithEmailLink succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(LoginWithEmailLinkSubmitted(validEmailLink)),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.logInWithEmailLink(
              email: 'student@mirea.ru',
              emailLink: validEmailLink.toString(),
            ),
          ).called(1);
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when the user is already logged in',
        setUp: () {
          when(
            () => userRepository.user,
          ).thenAnswer((_) => Stream<User>.value(loggedInUser));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(LoginWithEmailLinkSubmitted(validEmailLink)),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
        verify: (_) {
          verifyNever(
            () => userRepository.logInWithEmailLink(
              email: any(named: 'email'),
              emailLink: any(named: 'emailLink'),
            ),
          );
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when the link has no `code` parameter',
        build: buildBloc,
        act: (bloc) => bloc.add(
          LoginWithEmailLinkSubmitted(
            Uri.parse('https://mirea.ninja/login?continueUrl=x'),
          ),
        ),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
        verify: (_) {
          verifyNever(
            () => userRepository.logInWithEmailLink(
              email: any(named: 'email'),
              emailLink: any(named: 'emailLink'),
            ),
          );
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when the continueUrl has no `email` '
        'parameter',
        build: buildBloc,
        act: (bloc) => bloc.add(
          LoginWithEmailLinkSubmitted(
            Uri.parse(
              'https://mirea.ninja/login?code=abc123'
              '&continueUrl=${Uri.encodeQueryComponent(
                'https://mirea.ninja/finish?foo=bar',
              )}',
            ),
          ),
        ),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
        verify: (_) {
          verifyNever(
            () => userRepository.logInWithEmailLink(
              email: any(named: 'email'),
              emailLink: any(named: 'emailLink'),
            ),
          );
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when logInWithEmailLink throws',
        setUp: () {
          when(
            () => userRepository.logInWithEmailLink(
              email: any(named: 'email'),
              emailLink: any(named: 'emailLink'),
            ),
          ).thenThrow(LogInWithEmailLinkFailure(Exception('boom')));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(LoginWithEmailLinkSubmitted(validEmailLink)),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );
    });

    group('LoginWithEmailCodeSubmitted', () {
      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, success] when logInWithEmailCode succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const LoginWithEmailCodeSubmitted(
            email: 'student@mirea.ru',
            code: '000000',
          ),
        ),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.success),
        ],
        verify: (_) {
          verify(
            () => userRepository.logInWithEmailCode(
              email: 'student@mirea.ru',
              code: '000000',
            ),
          ).called(1);
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when the user is already logged in',
        setUp: () {
          when(
            () => userRepository.user,
          ).thenAnswer((_) => Stream<User>.value(loggedInUser));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const LoginWithEmailCodeSubmitted(
            email: 'student@mirea.ru',
            code: '000000',
          ),
        ),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
        verify: (_) {
          verifyNever(
            () => userRepository.logInWithEmailCode(
              email: any(named: 'email'),
              code: any(named: 'code'),
            ),
          );
        },
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] when logInWithEmailCode throws',
        setUp: () {
          when(
            () => userRepository.logInWithEmailCode(
              email: any(named: 'email'),
              code: any(named: 'code'),
            ),
          ).thenThrow(LogInWithEmailLinkFailure(Exception('boom')));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const LoginWithEmailCodeSubmitted(
            email: 'student@mirea.ru',
            code: '000000',
          ),
        ),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );
    });
  });
}
