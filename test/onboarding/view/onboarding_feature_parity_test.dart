import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:rtu_mirea_app/onboarding/widgets/group_results.dart';
import 'package:rtu_mirea_app/onboarding/widgets/group_step.dart';
import 'package:rtu_mirea_app/onboarding/widgets/welcome_step.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mocks/mock_schedule_repository.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Home extends MockCubit<HomeState> implements HomeCubit {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Router extends Mock implements GoRouter {}

class _Gamification extends Mock implements GamificationRepository {}

class _Storage extends Mock implements Storage {}

void main() {
  late _App app;
  late _Home home;
  late _Schedule schedule;
  late _Router router;
  late _Gamification gamification;
  late MockScheduleRepository repository;

  setUpAll(() => registerFallbackValue(const AppLogoutRequested()));
  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    app = _App();
    home = _Home();
    schedule = _Schedule();
    router = _Router();
    gamification = _Gamification();
    when(
      () => gamification.ensureAcademicProfile(
        any(),
        academicGroup: any(named: 'academicGroup'),
      ),
    ).thenAnswer((_) async {});
    repository = MockScheduleRepository();
    when(() => app.state).thenReturn(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'current'),
      ),
    );
    when(() => app.isClosed).thenReturn(false);
    when(() => home.state).thenReturn(const HomeState());
    when(() => schedule.state).thenReturn(const ScheduleState());
    when(
      () => gamification.getProfileOverview(any()),
    ).thenAnswer((_) async => ProfileOverview.empty);
  });
  tearDown(() {
    AppTourController.instance.stop();
    ToastManager.debugReset();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UniversityConfig>.value(
            value: UniversityConfig.current,
          ),
          RepositoryProvider<GamificationRepository>.value(value: gamification),
          RepositoryProvider<ScheduleRepository>.value(value: repository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>.value(value: app),
            BlocProvider<HomeCubit>.value(value: home),
            BlocProvider<ScheduleBloc>.value(value: schedule),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: InheritedGoRouter(
              goRouter: router,
              child: const OnBoardingPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openGroup(WidgetTester tester) async {
    await pumpPage(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_start')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_start')));
    await tester.pumpAndSettle();
  }

  testWidgets('anonymous onboarding does not require an identity step', (
    tester,
  ) async {
    when(() => app.state).thenReturn(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'guest', isGuest: true),
      ),
    );
    await pumpPage(tester);
    expect(
      tester
          .widget<OnboardingWelcomeStep>(find.byType(OnboardingWelcomeStep))
          .totalSteps,
      3,
    );
  });

  testWidgets(
    'setup can be skipped after creating a minimal profile without identity',
    (
      tester,
    ) async {
      await openGroup(tester);
      await tester.scrollUntilVisible(
        find.byKey(const Key('onboarding_skip')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('onboarding_skip')));
      AppTourController.instance.stop();
      await tester.pump(const Duration(milliseconds: 50));
      verify(home.closeOnboarding).called(1);
      verify(() => router.go('/feed')).called(1);
      verifyNever(() => app.add(any()));
    },
  );

  testWidgets('manual schedule escape completes setup before navigating', (
    tester,
  ) async {
    await openGroup(tester);
    tester.widget<GroupResults>(find.byType(GroupResults)).onCreateSchedule();
    await tester.pumpAndSettle();
    verifyInOrder([home.closeOnboarding, () => router.go('/schedule/create')]);
    verifyNever(() => app.add(any()));
  });

  for (final guest in [false, true]) {
    testWidgets(
      'fresh setup synchronizes its chosen group before finishing guest=$guest',
      (tester) async {
        when(() => app.state).thenReturn(
          AppState(
            status: AppStatus.authenticated,
            user: User(id: 'fresh', isGuest: guest),
          ),
        );
        await openGroup(tester);
        final pending = Completer<void>();
        when(
          () => gamification.ensureAcademicProfile(
            any(),
            academicGroup: 'GROUP-01',
          ),
        ).thenAnswer((_) => pending.future);
        final step = tester.widget<OnboardingGroupStep>(
          find.byType(OnboardingGroupStep),
        );
        step.onSelected(const Group(name: 'GROUP-01'));
        step.onSkip!();
        step.onSkip!();
        await tester.pump();
        verifyNever(home.closeOnboarding);
        verifyNever(() => router.go('/feed'));
        verify(
          () => gamification.ensureAcademicProfile(
            UniversityConfig.current.organizationId,
            academicGroup: 'GROUP-01',
          ),
        ).called(1);
        pending.complete();
        await tester.pump(const Duration(milliseconds: 50));
        AppTourController.instance.stop();
        verifyInOrder([home.closeOnboarding, () => router.go('/feed')]);
        ToastManager.debugReset();
        await tester.pump(const Duration(milliseconds: 100));
      },
    );
  }

  testWidgets(
    'a failed bootstrap keeps onboarding recoverable until retry succeeds',
    (tester) async {
      await openGroup(tester);
      when(
        () => gamification.ensureAcademicProfile(
          any(),
          academicGroup: any(named: 'academicGroup'),
        ),
      ).thenThrow(Exception('offline'));
      tester
          .widget<OnboardingGroupStep>(find.byType(OnboardingGroupStep))
          .onSkip!();
      await tester.pumpAndSettle();
      verifyNever(home.closeOnboarding);
      verifyNever(() => router.go('/feed'));
      expect(find.byType(OnboardingGroupStep), findsOneWidget);
      when(
        () => gamification.ensureAcademicProfile(
          any(),
          academicGroup: any(named: 'academicGroup'),
        ),
      ).thenAnswer((_) async {});
      tester
          .widget<OnboardingGroupStep>(find.byType(OnboardingGroupStep))
          .onSkip!();
      await tester.pump(const Duration(milliseconds: 50));
      AppTourController.instance.stop();
      verify(home.closeOnboarding).called(1);
      ToastManager.debugReset();
      await tester.pump(const Duration(milliseconds: 100));
    },
  );

  testWidgets(
    'late onboarding completion cannot navigate a replacement account',
    (tester) async {
      await openGroup(tester);
      final pending = Completer<void>();
      when(
        () => gamification.ensureAcademicProfile(
          any(),
          academicGroup: any(named: 'academicGroup'),
        ),
      ).thenAnswer((_) => pending.future);
      tester
          .widget<OnboardingGroupStep>(find.byType(OnboardingGroupStep))
          .onSkip!();
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'replacement'),
        ),
      );
      pending.complete();
      await tester.pumpAndSettle();
      verifyNever(home.closeOnboarding);
      verifyNever(() => router.go('/feed'));
    },
  );

  testWidgets(
    'existing-account action confirms before changing authentication',
    (tester) async {
      await pumpPage(tester);
      await tester.scrollUntilVisible(
        find.byKey(const Key('onboarding_haveAccount')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('onboarding_haveAccount')));
      await tester.pumpAndSettle();
      verifyNever(() => app.add(any()));
      final l10n = tester.element(find.byType(OnBoardingPage)).l10n;
      expect(find.text(l10n.profileSignOutConfirm), findsOneWidget);
      await tester.tap(find.text(l10n.cancel));
      await tester.pumpAndSettle();
      verifyNever(() => app.add(any()));
      await tester.tap(find.byKey(const Key('onboarding_haveAccount')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is NinjaPillButton && widget.label == l10n.profileSignOut,
        ),
      );
      await tester.pumpAndSettle();
      verify(() => app.add(const AppLogoutRequested())).called(1);
      verifyNever(home.closeOnboarding);
    },
  );

  testWidgets('account confirmation cannot sign out a replacement session', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_haveAccount')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_haveAccount')));
    await tester.pumpAndSettle();
    when(() => app.state).thenReturn(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'replacement'),
      ),
    );
    final l10n = tester.element(find.byType(OnBoardingPage)).l10n;
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is NinjaPillButton && widget.label == l10n.profileSignOut,
      ),
    );
    await tester.pumpAndSettle();
    verifyNever(() => app.add(any()));
  });
}
