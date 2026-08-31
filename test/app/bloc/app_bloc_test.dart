import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockStorage extends Mock implements Storage {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  const user = User(
    id: '1',
    email: 'student@mirea.ru',
    name: 'Student',
    isNewUser: false,
  );
  const newUser = User(id: '2', email: 'new@mirea.ru');

  late Storage storage;
  late UserRepository userRepository;
  late StreamController<User> userController;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    userRepository = MockUserRepository();
    userController = StreamController<User>.broadcast();
    when(() => userRepository.user).thenAnswer((_) => userController.stream);
    when(() => userRepository.logOut()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await userController.close();
  });

  AppBloc buildBloc({User initialUser = User.anonymous}) => AppBloc(
    firebaseMessaging: null,
    userRepository: userRepository,
    user: initialUser,
  );

  group('AppBloc', () {
    group('constructor', () {
      test('initial status is unauthenticated for anonymous user', () async {
        final bloc = buildBloc();
        expect(bloc.state.status, AppStatus.unauthenticated);
        await bloc.close();
      });

      test('initial status is authenticated for a real user', () async {
        final bloc = buildBloc(initialUser: user);
        expect(bloc.state.status, AppStatus.authenticated);
        expect(bloc.state.user, user);
        await bloc.close();
      });

      test('subscribes to the user repository user stream', () async {
        final bloc = buildBloc();
        verify(() => userRepository.user).called(1);
        await bloc.close();
      });
    });

    group('AppUserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when a real user is added',
        build: buildBloc,
        act: (bloc) => bloc.add(const AppUserChanged(user)),
        expect: () => const <AppState>[
          AppState(status: AppStatus.authenticated, user: user),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits onboardingRequired when a new user is added',
        build: buildBloc,
        act: (bloc) => bloc.add(const AppUserChanged(newUser)),
        expect: () => const <AppState>[
          AppState(status: AppStatus.onboardingRequired, user: newUser),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when the anonymous user is added',
        build: () => buildBloc(initialUser: user),
        act: (bloc) => bloc.add(const AppUserChanged(User.anonymous)),
        expect: () => const <AppState>[AppState()],
      );

      blocTest<AppBloc, AppState>(
        'reacts to the user repository user stream',
        build: buildBloc,
        act: (bloc) => userController.add(user),
        expect: () => const <AppState>[
          AppState(status: AppStatus.authenticated, user: user),
        ],
      );

      blocTest<AppBloc, AppState>(
        'preserves the AMOLED preference across auth changes',
        build: buildBloc,
        seed: () => const AppState(
          isAmoled: true,
        ),
        act: (bloc) => bloc.add(const AppUserChanged(user)),
        expect: () => const [
          AppState(
            status: AppStatus.authenticated,
            user: user,
            isAmoled: true,
          ),
        ],
      );
    });

    test(
      'does not subscribe to notification taps after close begins',
      () async {
        final messaging = MockFirebaseMessaging();
        final initialMessage = Completer<RemoteMessage?>();
        when(
          messaging.getInitialMessage,
        ).thenAnswer((_) => initialMessage.future);
        final bloc = AppBloc(
          firebaseMessaging: messaging,
          userRepository: userRepository,
          user: User.anonymous,
        );

        final setup = bloc.setupInteractedMessage();
        final close = bloc.close();
        initialMessage.complete(
          const RemoteMessage(data: {'route': '/profile'}),
        );

        await Future.wait([setup, close]);
        expect(bloc.isClosed, isTrue);
      },
    );

    group('AppLogoutRequested', () {
      final calls = <String>[];
      blocTest<AppBloc, AppState>(
        'runs device cleanup before signing out',
        setUp: () {
          calls.clear();
          when(() => userRepository.logOut()).thenAnswer((_) async {
            calls.add('logout');
          });
        },
        build: () => AppBloc(
          firebaseMessaging: null,
          userRepository: userRepository,
          user: user,
          onBeforeLogout: () async => calls.add('cleanup'),
        ),
        act: (bloc) => bloc.add(const AppLogoutRequested()),
        expect: () => const <AppState>[],
        verify: (_) => expect(calls, ['cleanup', 'logout']),
      );

      blocTest<AppBloc, AppState>(
        'calls logOut on the user repository',
        build: buildBloc,
        act: (bloc) => bloc.add(const AppLogoutRequested()),
        verify: (_) => verify(() => userRepository.logOut()).called(1),
      );

      blocTest<AppBloc, AppState>(
        'awaits logOut without emitting state',
        setUp: () => when(
          () => userRepository.logOut(),
        ).thenAnswer((_) async => Future<void>.delayed(Duration.zero)),
        build: buildBloc,
        act: (bloc) => bloc.add(const AppLogoutRequested()),
        expect: () => const <AppState>[],
        verify: (_) => verify(() => userRepository.logOut()).called(1),
      );

      blocTest<AppBloc, AppState>(
        'reports logOut failures',
        setUp: () => when(
          () => userRepository.logOut(),
        ).thenAnswer((_) async => throw Exception('logout failed')),
        build: buildBloc,
        act: (bloc) => bloc.add(const AppLogoutRequested()),
        expect: () => const <AppState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group('InteractedMessageReceived', () {
      blocTest<AppBloc, AppState>(
        'emits every identical notification tap',
        build: buildBloc,
        act: (bloc) {
          const message = RemoteMessage(data: {'route': '/profile'});
          bloc
            ..add(const InteractedMessageReceived(message))
            ..add(const InteractedMessageReceived(message));
        },
        expect: () => [
          isA<AppState>()
              .having((state) => state.routeToOpen, 'route', '/profile')
              .having(
                (state) => state.notificationNavigationId,
                'navigation id',
                1,
              ),
          isA<AppState>()
              .having((state) => state.routeToOpen, 'route', '/profile')
              .having(
                (state) => state.notificationNavigationId,
                'navigation id',
                2,
              ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'clears a previous post destination when a route arrives',
        build: buildBloc,
        act: (bloc) {
          bloc
            ..add(
              const InteractedMessageReceived(
                RemoteMessage(data: {'discourse_post_id': '42'}),
              ),
            )
            ..add(
              const InteractedMessageReceived(
                RemoteMessage(data: {'route': '/profile'}),
              ),
            );
        },
        expect: () => [
          isA<AppState>().having(
            (state) => state.discoursePostIdToOpen,
            'post id',
            42,
          ),
          isA<AppState>()
              .having(
                (state) => state.discoursePostIdToOpen,
                'post id',
                isNull,
              )
              .having((state) => state.routeToOpen, 'route', '/profile'),
        ],
      );
    });

    group('ThemeChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new isAmoled flag',
        build: buildBloc,
        act: (bloc) => bloc.add(const ThemeChanged(isAmoled: true)),
        expect: () => [
          isA<AppState>().having((s) => s.isAmoled, 'isAmoled', true),
        ],
      );
    });

    group('hydration', () {
      test('fromJson restores only theme and preserves live auth', () async {
        final bloc = buildBloc(initialUser: user);
        final restored = bloc.fromJson({
          'isAmoled': true,
          'status': AppStatus.authenticated.name,
        });
        expect(restored?.isAmoled, true);
        expect(restored?.status, AppStatus.authenticated);
        expect(restored?.user, user);
        await bloc.close();
      });

      test('toJson never persists authentication state', () async {
        final bloc = buildBloc(initialUser: user);
        final json = bloc.toJson(bloc.state);
        expect(json, isNot(contains('status')));
        expect(json['isAmoled'], false);
        await bloc.close();
      });

      test('fromJson returns null on corrupt data', () async {
        final bloc = buildBloc();
        expect(bloc.fromJson({'isAmoled': 'oops'}), isNull);
        await bloc.close();
      });

      test('fromJson ignores persisted authentication status', () async {
        final bloc = buildBloc();
        final restored = bloc.fromJson({
          'isAmoled': true,
          'status': AppStatus.authenticated.index,
        });
        expect(restored?.status, AppStatus.unauthenticated);
        expect(restored?.user, User.anonymous);
        await bloc.close();
      });
    });
  });
}
