import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/profile/cubit/startup_screen_cubit.dart';

class _App extends Mock implements AppBloc {}

class _Home extends Mock implements HomeCubit {}

void main() {
  testWidgets('each saved startup screen becomes the default route', (
    tester,
  ) async {
    for (final screen in StartupScreen.values) {
      final router = createRouter(startupScreen: screen);
      expect(router.routeInformationProvider.value.uri.path, screen.location);
      router.dispose();
    }
  });

  testWidgets(
    'an explicit platform link takes priority over the startup screen',
    (
      tester,
    ) async {
      tester.platformDispatcher.defaultRouteNameTestValue =
          '/feed/news?source=link';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
      final router = createRouter(startupScreen: StartupScreen.schedule);
      addTearDown(router.dispose);
      expect(
        router.routeInformationProvider.value.uri.toString(),
        '/feed/news?source=link',
      );
    },
  );

  for (final entry in [
    (AppStatus.unauthenticated, true, '/auth'),
    (AppStatus.authenticated, false, '/onboarding'),
    (AppStatus.authenticated, true, '/services/map'),
  ]) {
    testWidgets(
      'startup preference respects ${entry.$3} navigation',
      (
        tester,
      ) async {
        final app = _App();
        final home = _Home();
        when(() => app.state).thenReturn(AppState(status: entry.$1));
        when(() => home.state).thenReturn(
          HomeState(settings: AppSettings(onboardingShown: entry.$2)),
        );
        final production = createRouter(
          appBloc: app,
          homeCubit: home,
          startupScreen: StartupScreen.map,
        );
        final router = GoRouter(
          initialLocation: production.routeInformationProvider.value.uri
              .toString(),
          redirect: production.configuration.topRedirect,
          routes: [
            for (final path in [
              '/auth',
              '/onboarding',
              '/services/map',
              '/feed/news',
            ])
              GoRoute(path: path, builder: (_, _) => Text(path)),
          ],
        );
        addTearDown(() {
          router.dispose();
          production.dispose();
        });
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, entry.$3);
        if (entry.$1 == AppStatus.authenticated && entry.$2) {
          router.go('/auth');
          await tester.pumpAndSettle();
          expect(
            router.routeInformationProvider.value.uri.path,
            '/services/map',
          );
          router.go('/feed/news');
          await tester.pumpAndSettle();
          expect(router.routeInformationProvider.value.uri.path, '/feed/news');
        }
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }
}
