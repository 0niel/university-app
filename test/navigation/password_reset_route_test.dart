import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:user_repository/user_repository.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Home extends MockCubit<HomeState> implements HomeCubit {}

class _Repository extends Mock implements UserRepository {}

Finder _input(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

void main() {
  for (final onboardingShown in [true, false]) {
    testWidgets(
      'recovery authentication keeps password entry open '
      'when onboardingShown is $onboardingShown',
      (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.defaultRouteNameTestValue = '/password-reset';
        addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

        final app = _App();
        final home = _Home();
        final repository = _Repository();
        final states = StreamController<AppState>.broadcast();
        final verification = Completer<String>();
        whenListen(app, states.stream, initialState: const AppState());
        whenListen(
          home,
          const Stream<HomeState>.empty(),
          initialState: HomeState(
            settings: AppSettings(onboardingShown: onboardingShown),
          ),
        );
        when(
          () => repository.user,
        ).thenAnswer((_) => const Stream<User>.empty());
        when(
          () => repository.verifyPasswordResetCode(
            email: 'student@example.edu',
            code: '123456',
          ),
        ).thenAnswer((_) => verification.future);
        final refresh = GoRouterRefreshStream.auth(app);
        final router = createRouter(
          appBloc: app,
          homeCubit: home,
          refreshListenable: refresh,
        );
        addTearDown(() async {
          if (!verification.isCompleted) {
            verification.complete('recovery-owner');
          }
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
          router.dispose();
          refresh.dispose();
          await states.close();
          await app.close();
          await home.close();
        });

        await tester.pumpWidget(
          RepositoryProvider<UserRepository>.value(
            value: repository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AppBloc>.value(value: app),
                BlocProvider<HomeCubit>.value(value: home),
              ],
              child: MaterialApp.router(
                routerConfig: router,
                theme: AppTheme.darkTheme,
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: child!,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          '/password-reset',
        );
        expect(find.byType(PasswordResetPage), findsOneWidget);

        await tester.enterText(
          _input('passwordResetPage_emailInput'),
          'student@example.edu',
        );
        await tester.pump();
        await tester.ensureVisible(
          find.byKey(const Key('passwordResetPage_haveCodeButton')),
        );
        await tester.tap(
          find.byKey(const Key('passwordResetPage_haveCodeButton')),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          _input('passwordResetPage_codeInput'),
          '123456',
        );
        await tester.pump();
        await tester.pump();

        states.add(
          const AppState(
            status: AppStatus.authenticated,
            user: User(
              id: 'recovery-owner',
              email: 'student@example.edu',
              isNewUser: false,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          router.routeInformationProvider.value.uri.path,
          '/password-reset',
        );
        expect(find.byType(PasswordResetPage), findsOneWidget);

        verification.complete('recovery-owner');
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          '/password-reset',
        );
        expect(_input('passwordResetPage_passwordInput'), findsOneWidget);
        expect(
          _input('passwordResetPage_confirmPasswordInput'),
          findsOneWidget,
        );
        verify(
          () => repository.verifyPasswordResetCode(
            email: 'student@example.edu',
            code: '123456',
          ),
        ).called(1);
        verifyNever(
          () => repository.sendPasswordResetEmail(email: any(named: 'email')),
        );
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }
}
