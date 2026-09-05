import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/widgets/firebase_interacted_message_listener.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _App extends Mock implements AppBloc {}

class _Home extends Mock implements HomeCubit {}

class _Lesson extends Fake implements LessonSchedulePart {}

GoRoute? _findRoute(List<RouteBase> routes, String path) {
  for (final route in routes) {
    if (route is GoRoute && route.path == path) return route;
    final nested = _findRoute(route.routes, path);
    if (nested != null) return nested;
  }
  return null;
}

void main() {
  for (final entry in {
    'details': '/schedule',
    'diff': '/schedule/changes',
  }.entries) {
    testWidgets('${entry.key} without payload recovers safely', (tester) async {
      final app = _App();
      final home = _Home();
      when(
        () => app.state,
      ).thenReturn(const AppState(status: AppStatus.authenticated));
      when(() => home.state).thenReturn(
        const HomeState(settings: AppSettings(onboardingShown: true)),
      );
      final production = createRouter(appBloc: app, homeCubit: home);
      final generated = _findRoute(Routes.all, entry.key)!;
      final router = GoRouter(
        initialLocation: '/schedule/${entry.key}',
        redirect: production.configuration.topRedirect,
        routes: [
          GoRoute(
            path: '/schedule',
            builder: (_, _) => const Text('Schedule'),
            routes: [
              GoRoute(
                path: 'changes',
                builder: (_, _) => const Text('Changes'),
              ),
              GoRoute(
                path: entry.key,
                redirect: generated.redirect,
                builder: (_, _) => const Text('Details'),
              ),
            ],
          ),
        ],
      );
      addTearDown(() {
        router.dispose();
        production.dispose();
      });
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(router.routeInformationProvider.value.uri.path, entry.value);
    });
  }

  for (final openPush in [false, true]) {
    testWidgets(
      openPush
          ? 'push opens feed from a lesson without a gray screen'
          : 'notification state preserves '
                'an imperatively pushed lesson payload',
      (
        tester,
      ) async {
        final states = StreamController<AppState>.broadcast(sync: true);
        final app = _App();
        var state = const AppState(status: AppStatus.authenticated);
        when(() => app.state).thenAnswer((_) => state);
        when(() => app.stream).thenAnswer((_) => states.stream);
        when(() => app.consumeNotificationNavigation(any())).thenReturn(true);
        final refresh = GoRouterRefreshStream.auth(app);
        final generated = _findRoute(Routes.all, 'details')!;
        final router = GoRouter(
          initialLocation: '/schedule',
          refreshListenable: refresh,
          routes: [
            GoRoute(path: '/feed', builder: (_, _) => const Text('Feed')),
            GoRoute(
              path: '/schedule',
              builder: (_, _) => const Text('Schedule'),
              routes: [
                GoRoute(
                  path: 'details',
                  redirect: generated.redirect,
                  builder: (_, state) => Text('Details ${state.extra != null}'),
                ),
              ],
            ),
          ],
        );
        addTearDown(() async {
          router.dispose();
          refresh.dispose();
          await states.close();
        });
        await tester.pumpWidget(
          BlocProvider<AppBloc>.value(
            value: app,
            child: MaterialApp.router(
              routerConfig: router,
              builder: (_, child) => openPush
                  ? FirebaseInteractedMessageListener(
                      router: router,
                      child: child!,
                    )
                  : child!,
            ),
          ),
        );
        await tester.pumpAndSettle();
        unawaited(
          router.push<void>(
            '/schedule/details',
            extra: (_Lesson(), DateTime(2026, 9, 5)),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Details true'),
          findsOneWidget,
        );
        state = state.withNotificationDestination(
          route: DeepLinks.normalizeLocation('/'),
        );
        states.add(state);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          find.text(openPush ? 'Feed' : 'Details true'),
          findsOneWidget,
        );
      },
    );
  }

  test('auth refresh still observes sign-out', () async {
    final states = StreamController<AppState>.broadcast(sync: true);
    final app = _App();
    when(
      () => app.state,
    ).thenReturn(const AppState(status: AppStatus.authenticated));
    when(() => app.stream).thenAnswer((_) => states.stream);
    final refresh = GoRouterRefreshStream.auth(app);
    var notifications = 0;
    refresh.addListener(() => notifications++);
    states.add(const AppState(status: AppStatus.authenticated));
    expect(notifications, 0);
    states.add(const AppState());
    expect(notifications, 1);
    refresh.dispose();
    await states.close();
  });
}
