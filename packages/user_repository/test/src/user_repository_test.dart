import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockPackageInfoClient extends Mock implements PackageInfoClient {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockUserStorage extends Mock implements UserStorage {}

class FakeLogOutFailure extends Fake implements LogOutFailure {}

class FakeDeleteAccountFailure extends Fake implements DeleteAccountFailure {}

class FakeSendLoginEmailLinkFailure extends Fake
    implements SendLoginEmailLinkFailure {}

class FakeLogInWithEmailLinkFailure extends Fake
    implements LogInWithEmailLinkFailure {}

class FakeLogInWithPasswordFailure extends Fake
    implements LogInWithPasswordFailure {}

class FakeSignUpFailure extends Fake implements SignUpFailure {}

class FakeSignInAnonymouslyFailure extends Fake
    implements SignInAnonymouslyFailure {}

class FakeSendPasswordResetEmailFailure extends Fake
    implements SendPasswordResetEmailFailure {}

class FakeResetPasswordFailure extends Fake implements ResetPasswordFailure {}

void main() {
  group('UserRepository', () {
    late AuthenticationClient authenticationClient;
    late PackageInfoClient packageInfoClient;
    late DeepLinkService deepLinkService;
    late UserStorage storage;
    late StreamController<Uri> deepLinkClientController;
    late UserRepository userRepository;

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      packageInfoClient = MockPackageInfoClient();
      deepLinkService = MockDeepLinkService();
      storage = MockUserStorage();
      deepLinkClientController = StreamController<Uri>.broadcast();

      when(
        () => deepLinkService.deepLinkStream,
      ).thenAnswer((_) => deepLinkClientController.stream);

      userRepository = UserRepository(
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkService: deepLinkService,
        storage: storage,
      );
    });

    group('user', () {
      UserRepository initializingRepository(
        Future<void> Function(String) initialize, {
        Duration timeout = const Duration(seconds: 8),
        void Function(Object, StackTrace)? onError,
      }) => UserRepository(
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkService: deepLinkService,
        storage: storage,
        initializeUser: initialize,
        initializationTimeout: timeout,
        onInitializationError: onError,
      );

      for (final email in <String?>[null, 'student@example.org']) {
        test(
          'waits for profile initialization before emitting email=$email',
          () async {
            final pending = Completer<void>();
            final initialized = <String>[];
            final emitted = <User>[];
            when(() => authenticationClient.user).thenAnswer(
              (_) => Stream.value(
                AuthenticationUser(id: 'current', email: email),
              ),
            );
            final repository = initializingRepository((id) {
              initialized.add(id);
              return pending.future;
            });
            final subscription = repository.user.listen(emitted.add);
            await Future<void>.delayed(Duration.zero);
            expect(initialized, ['current']);
            expect(emitted, isEmpty);
            pending.complete();
            await Future<void>.delayed(Duration.zero);
            expect(emitted.single, User(id: 'current', email: email));
            await subscription.cancel();
          },
        );
      }

      for (final replacement in [
        AuthenticationUser.anonymous,
        const AuthenticationUser(id: 'replacement'),
        const AuthenticationUser(id: 'old', email: 'linked@example.org'),
      ]) {
        test(
          'ignores obsolete bootstrap after auth changes to $replacement',
          () async {
            final authentication = StreamController<AuthenticationUser>(
              sync: true,
            );
            final pending = Completer<void>();
            final emitted = <User>[];
            final initialized = <String>[];
            when(
              () => authenticationClient.user,
            ).thenAnswer((_) => authentication.stream);
            final repository = initializingRepository((id) {
              initialized.add(id);
              return initialized.length == 1 ? pending.future : Future.value();
            });
            final subscription = repository.user.listen(emitted.add);
            authentication.add(
              const AuthenticationUser(id: 'old'),
            );
            await Future<void>.delayed(Duration.zero);
            authentication.add(replacement);
            await Future<void>.delayed(Duration.zero);
            final expected = replacement.isAnonymous
                ? User.anonymous
                : User.fromAuthenticationUser(authenticationUser: replacement);
            expect(emitted, [expected]);
            if (replacement.isAnonymous) {
              pending.completeError(StateError('late initialization failure'));
            } else {
              pending.complete();
            }
            await Future<void>.delayed(Duration.zero);
            expect(emitted, [expected]);
            expect(
              initialized,
              replacement.isAnonymous ? ['old'] : ['old', replacement.id],
            );
            await subscription.cancel();
            await authentication.close();
          },
        );
      }

      test('profile initialization failures preserve authentication', () async {
        final errors = <Object>[];
        final failure = StateError('offline');
        when(() => authenticationClient.user).thenAnswer(
          (_) => Stream.value(
            const AuthenticationUser(id: 'guest'),
          ),
        );
        final repository = initializingRepository(
          (_) => Future.error(failure),
          onError: (error, _) => errors.add(error),
        );
        expect(
          await repository.user.first,
          const User(id: 'guest'),
        );
        expect(errors, [failure]);
      });

      test(
        'stalled initialization has a bounded authenticated fallback',
        () async {
          final pending = Completer<void>();
          final errors = <Object>[];
          when(() => authenticationClient.user).thenAnswer(
            (_) => Stream.value(const AuthenticationUser(id: 'normal')),
          );
          final repository = initializingRepository(
            (_) => pending.future,
            timeout: const Duration(milliseconds: 1),
            onError: (error, _) => errors.add(error),
          );
          expect(await repository.user.first, const User(id: 'normal'));
          expect(errors.single, isA<TimeoutException>());
          pending.complete();
        },
      );

      test('signed out users do not initialize a profile', () async {
        final initialized = <String>[];
        when(
          () => authenticationClient.user,
        ).thenAnswer((_) => Stream.value(AuthenticationUser.anonymous));
        final repository = initializingRepository((id) async {
          initialized.add(id);
        });
        expect(await repository.user.first, User.anonymous);
        expect(initialized, isEmpty);
      });

      test('cancelled subscription ignores late initializer failure', () async {
        final pending = Completer<void>();
        final emitted = <User>[];
        final errors = <Object>[];
        when(() => authenticationClient.user).thenAnswer(
          (_) => Stream.value(const AuthenticationUser(id: 'current')),
        );
        final repository = initializingRepository((_) => pending.future);
        final subscription = repository.user.listen(
          emitted.add,
          onError: errors.add,
        );
        await Future<void>.delayed(Duration.zero);
        await subscription.cancel();
        pending.completeError(StateError('late initialization failure'));
        await Future<void>.delayed(Duration.zero);
        expect(emitted, isEmpty);
        expect(errors, isEmpty);
      });

      test(
        'without initializer preserves authenticated user metadata',
        () async {
          const authenticationUser = AuthenticationUser(
            id: 'current',
            email: 'student@example.org',
            name: 'Student',
            photo: 'https://example.org/photo.png',
            isNewUser: false,
          );
          when(() => authenticationClient.user).thenAnswer(
            (_) => Stream.value(authenticationUser),
          );
          expect(
            await userRepository.user.first,
            User.fromAuthenticationUser(authenticationUser: authenticationUser),
          );
        },
      );

      test('calls user on AuthenticationClient', () async {
        when(
          () => authenticationClient.user,
        ).thenAnswer((_) => const Stream.empty());
        await expectLater(userRepository.user, emitsDone);
        verify(() => authenticationClient.user).called(1);
      });

      test(
        'emits User.anonymous '
        'when authenticationClient.user is anonymous',
        () async {
          when(() => authenticationClient.user).thenAnswer(
            (_) => Stream.value(AuthenticationUser.anonymous),
          );
          final user = await userRepository.user.first;
          expect(user, equals(User.anonymous));
        },
      );
    });

    group('incomingEmailLinks', () {
      final validEmailLink = Uri.https('valid.email.link');
      final validEmailLink2 = Uri.https('valid.email.link');
      final invalidEmailLink = Uri.https('invalid.email.link');

      test(
        'emits a new email link '
        'for every valid email link from DeepLinkClient.deepLinkStream',
        () async {
          when(
            () => authenticationClient.isLogInWithEmailLink(
              emailLink: validEmailLink.toString(),
            ),
          ).thenReturn(true);

          when(
            () => authenticationClient.isLogInWithEmailLink(
              emailLink: validEmailLink2.toString(),
            ),
          ).thenReturn(true);

          when(
            () => authenticationClient.isLogInWithEmailLink(
              emailLink: invalidEmailLink.toString(),
            ),
          ).thenReturn(false);

          final expectation = expectLater(
            userRepository.incomingEmailLinks,
            emitsInOrder(<Uri>[validEmailLink, validEmailLink2]),
          );

          deepLinkClientController
            ..add(validEmailLink)
            ..add(invalidEmailLink)
            ..add(validEmailLink2);

          await expectation;
        },
      );
    });

    group('sendLoginEmailLink', () {
      const packageName = 'appPackageName';

      setUp(() {
        when(() => packageInfoClient.packageName).thenReturn(packageName);
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenAnswer((_) async {});
      });

      test('calls sendLoginEmailLink on AuthenticationClient '
          'with email and app package name from PackageInfoClient', () async {
        await userRepository.sendLoginEmailLink(
          email: 'ben_franklin@upenn.edu',
        );

        verify(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: packageName,
          ),
        ).called(1);
      });

      test('rethrows SendLoginEmailLinkFailure', () async {
        final exception = FakeSendLoginEmailLinkFailure();
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.sendLoginEmailLink(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(exception),
        );
      });

      test('throws SendLoginEmailLinkFailure '
          'on generic exception', () async {
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.sendLoginEmailLink(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(isA<SendLoginEmailLinkFailure>()),
        );
      });
    });

    group('logInWithEmailLink', () {
      const email = 'email@example.com';
      const emailLink = 'email.link';

      test('calls logInWithEmailLink on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.logInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        verify(
          () => authenticationClient.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
        ).called(1);
      });

      test('rethrows LogInWithEmailLinkFailure', () async {
        final exception = FakeLogInWithEmailLinkFailure();
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          throwsA(exception),
        );
      });

      test('throws LogInWithEmailLinkFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          throwsA(isA<LogInWithEmailLinkFailure>()),
        );
      });
    });

    group('logInWithEmailCode', () {
      const email = 'email@example.com';
      const code = '123456';

      test('calls logInWithEmailCode on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithEmailCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.logInWithEmailCode(email: email, code: code);

        verify(
          () => authenticationClient.logInWithEmailCode(
            email: email,
            code: code,
          ),
        ).called(1);
      });

      test('throws LogInWithEmailLinkFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithEmailCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithEmailCode(email: email, code: code),
          throwsA(isA<LogInWithEmailLinkFailure>()),
        );
      });
    });

    group('logInWithPassword', () {
      const email = 'email@example.com';
      const password = 'password';

      test('calls logInWithPassword on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.logInWithPassword(
          email: email,
          password: password,
        );

        verify(
          () => authenticationClient.logInWithPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('rethrows LogInWithPasswordFailure', () async {
        final exception = FakeLogInWithPasswordFailure();
        when(
          () => authenticationClient.logInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.logInWithPassword(
            email: email,
            password: password,
          ),
          throwsA(exception),
        );
      });

      test('throws LogInWithPasswordFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<LogInWithPasswordFailure>()),
        );
      });
    });

    group('signUp', () {
      const email = 'email@example.com';
      const password = 'password';

      test('calls signUp on AuthenticationClient', () async {
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.signUp(email: email, password: password);

        verify(
          () => authenticationClient.signUp(email: email, password: password),
        ).called(1);
      });

      test('rethrows SignUpFailure', () async {
        final exception = FakeSignUpFailure();
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.signUp(email: email, password: password),
          throwsA(exception),
        );
      });

      test('throws SignUpFailure on generic exception', () async {
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signUp(email: email, password: password),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });

    group('signInAnonymously', () {
      test('calls signInAnonymously on AuthenticationClient', () async {
        when(
          () => authenticationClient.signInAnonymously(),
        ).thenAnswer((_) async {});

        await userRepository.signInAnonymously();

        verify(() => authenticationClient.signInAnonymously()).called(1);
      });

      test('rethrows SignInAnonymouslyFailure', () async {
        final exception = FakeSignInAnonymouslyFailure();
        when(
          () => authenticationClient.signInAnonymously(),
        ).thenThrow(exception);
        expect(() => userRepository.signInAnonymously(), throwsA(exception));
      });

      test('throws SignInAnonymouslyFailure on generic exception', () async {
        when(
          () => authenticationClient.signInAnonymously(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signInAnonymously(),
          throwsA(isA<SignInAnonymouslyFailure>()),
        );
      });
    });

    group('sendPasswordResetEmail', () {
      const email = 'email@example.com';

      test('calls sendPasswordResetEmail on AuthenticationClient', () async {
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.sendPasswordResetEmail(email: email);

        verify(
          () => authenticationClient.sendPasswordResetEmail(email: email),
        ).called(1);
      });

      test('rethrows SendPasswordResetEmailFailure', () async {
        final exception = FakeSendPasswordResetEmailFailure();
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.sendPasswordResetEmail(email: email),
          throwsA(exception),
        );
      });

      test('throws SendPasswordResetEmailFailure '
          'on generic exception', () async {
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.sendPasswordResetEmail(email: email),
          throwsA(isA<SendPasswordResetEmailFailure>()),
        );
      });
    });

    group('resetPassword', () {
      const email = 'email@example.com';
      const code = '123456';
      const newPassword = 'newPassword';

      test('calls resetPassword on AuthenticationClient', () async {
        when(
          () => authenticationClient.resetPassword(
            email: any(named: 'email'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.resetPassword(
          email: email,
          code: code,
          newPassword: newPassword,
        );

        verify(
          () => authenticationClient.resetPassword(
            email: email,
            code: code,
            newPassword: newPassword,
          ),
        ).called(1);
      });

      test('rethrows ResetPasswordFailure', () async {
        final exception = FakeResetPasswordFailure();
        when(
          () => authenticationClient.resetPassword(
            email: any(named: 'email'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.resetPassword(
            email: email,
            code: code,
            newPassword: newPassword,
          ),
          throwsA(exception),
        );
      });

      test('throws ResetPasswordFailure on generic exception', () async {
        when(
          () => authenticationClient.resetPassword(
            email: any(named: 'email'),
            code: any(named: 'code'),
            newPassword: any(named: 'newPassword'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.resetPassword(
            email: email,
            code: code,
            newPassword: newPassword,
          ),
          throwsA(isA<ResetPasswordFailure>()),
        );
      });
    });

    group('logOut', () {
      test('calls logOut on AuthenticationClient', () async {
        when(() => authenticationClient.logOut()).thenAnswer((_) async {});
        await userRepository.logOut();
        verify(() => authenticationClient.logOut()).called(1);
      });

      test('rethrows LogOutFailure', () async {
        final exception = FakeLogOutFailure();
        when(() => authenticationClient.logOut()).thenThrow(exception);
        expect(() => userRepository.logOut(), throwsA(exception));
      });

      test('throws LogOutFailure on generic exception', () async {
        when(() => authenticationClient.logOut()).thenThrow(Exception());
        expect(() => userRepository.logOut(), throwsA(isA<LogOutFailure>()));
      });
    });

    group('deleteAccount', () {
      test('calls deleteAccount on AuthenticationClient', () async {
        when(
          () => authenticationClient.deleteAccount(),
        ).thenAnswer((_) async {});
        await userRepository.deleteAccount();
        verify(() => authenticationClient.deleteAccount()).called(1);
      });

      test('rethrows DeleteAccountFailure', () async {
        final exception = FakeDeleteAccountFailure();
        when(() => authenticationClient.deleteAccount()).thenThrow(exception);
        expect(() => userRepository.deleteAccount(), throwsA(exception));
      });

      test('throws DeleteAccountFailure on generic exception', () async {
        when(() => authenticationClient.deleteAccount()).thenThrow(Exception());
        expect(
          () => userRepository.deleteAccount(),
          throwsA(isA<DeleteAccountFailure>()),
        );
      });
    });

    group('UserFailure', () {
      final error = Exception('errorMessage');

      group('FetchAppOpenedCountFailure', () {
        test('has correct props', () {
          expect(FetchAppOpenedCountFailure(error).props, [error]);
        });
      });

      group('IncrementAppOpenedCountFailure', () {
        test('has correct props', () {
          expect(IncrementAppOpenedCountFailure(error).props, [error]);
        });
      });
    });

    group('fetchAppOpenedCount', () {
      test('returns the app opened count from UserStorage ', () async {
        when(storage.fetchAppOpenedCount).thenAnswer((_) async => 1);

        final result = await userRepository.fetchAppOpenedCount();
        expect(result, 1);
      });

      test('throws a FetchAppOpenedCountFailure '
          'when fetching app opened count fails', () async {
        when(() => storage.fetchAppOpenedCount()).thenThrow(Exception());

        expect(
          userRepository.fetchAppOpenedCount(),
          throwsA(isA<FetchAppOpenedCountFailure>()),
        );
      });
    });

    group('incrementAppOpenedCount', () {
      test('increments app opened count by 1 in UserStorage', () async {
        when(() => storage.fetchAppOpenedCount()).thenAnswer((_) async => 3);

        when(
          () => storage.setAppOpenedCount(count: 4),
        ).thenAnswer((_) async {});

        await expectLater(userRepository.incrementAppOpenedCount(), completes);
      });

      test('throws a IncrementAppOpenedCountFailure '
          'when setting app opened count fails', () async {
        when(() => storage.fetchAppOpenedCount()).thenAnswer((_) async => 3);
        when(
          () => storage.setAppOpenedCount(count: any(named: 'count')),
        ).thenThrow(Exception());

        expect(
          userRepository.incrementAppOpenedCount(),
          throwsA(isA<IncrementAppOpenedCountFailure>()),
        );
      });
    });
  });
}
