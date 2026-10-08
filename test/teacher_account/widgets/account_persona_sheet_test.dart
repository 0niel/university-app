import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/teacher_step.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_persona_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../gallery/gallery_fonts.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

class _Schedules extends Mock implements ScheduleRepository {}

const _teacher = Teacher(uid: 'teacher-a', name: 'Иванов Иван Иванович');
const _bound = AccountPersonaState(
  persona: AccountPersona(
    role: AccountRole.teacher,
    teacherId: 'teacher-a',
    teacherName: 'Иванов Иван Иванович',
    teacherAvailable: true,
  ),
  loaded: true,
);

void main() {
  late _Account account;
  late _Schedules schedules;

  setUpAll(() {
    registerFallbackValue(AccountRole.student);
    registerFallbackValue(_teacher);
  });

  setUp(() {
    account = _Account();
    schedules = _Schedules();
    when(() => account.state).thenReturn(_bound);
    when(() => account.isClosed).thenReturn(false);
    when(
      () => account.configure(
        role: any(named: 'role'),
        teacher: any(named: 'teacher'),
        clearTeacher: any(named: 'clearTeacher'),
      ),
    ).thenAnswer((_) async => true);
    when(() => schedules.searchTeachers(query: any(named: 'query'))).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [_teacher]),
    );
  });

  Future<void> pumpSheet(
    WidgetTester tester, {
    bool dark = false,
    double scale = 1,
    bool onboarding = false,
  }) async {
    await tester.pumpWidget(
      RepositoryProvider<ScheduleRepository>.value(
        value: schedules,
        child: BlocProvider<AccountPersonaCubit>.value(
          value: account,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                disableAnimations: true,
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            ),
            home: Builder(
              builder: (context) => Scaffold(
                backgroundColor: context.colors.canvas,
                body: onboarding
                    ? OnboardingTeacherStep(
                        totalSteps: 4,
                        selected: _teacher,
                        onSelected: (_) {},
                        onBack: () {},
                        onNext: () {},
                        onLater: () {},
                        onStudentMode: () {},
                      )
                    : Center(
                        child: TextButton(
                          onPressed: () => showAccountPersonaSheet(context),
                          child: const Text('open'),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
    if (!onboarding) await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('accountPersona_save')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('accountPersona_save')));
    await tester.pumpAndSettle();
  }

  testWidgets('switching to student preserves the saved teacher binding', (
    tester,
  ) async {
    await pumpSheet(tester);
    expect(
      tester
          .widget<AppButton>(find.byKey(const Key('accountPersona_save')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Студент'));
    await tester.pumpAndSettle();
    await save(tester);
    verify(() => account.configure(role: AccountRole.student)).called(1);
    expect(find.byType(AccountPersonaSheet), findsNothing);
  });

  testWidgets('unlinking uses one atomic request and keeps teacher mode', (
    tester,
  ) async {
    await pumpSheet(tester);
    await tester.ensureVisible(find.text('Отвязать преподавателя'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отвязать преподавателя'));
    await tester.pumpAndSettle();
    await save(tester);
    verify(
      () => account.configure(role: AccountRole.teacher, clearTeacher: true),
    ).called(1);
    expect(find.byType(AccountPersonaSheet), findsNothing);
  });

  testWidgets('a rejected choice stays editable with a localized error', (
    tester,
  ) async {
    when(
      () => account.configure(role: AccountRole.student),
    ).thenAnswer((_) async => false);
    await pumpSheet(tester);
    await tester.tap(find.text('Студент'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.byType(AccountPersonaSheet), findsOneWidget);
    expect(find.byType(AppBanner), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const Key('accountPersona_save')))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('mode choice is usable at 320px with large text', (tester) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpSheet(tester, scale: 1.6);
    await tester.tap(find.text('Студент'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(tester.takeException(), isNull);
    verify(() => account.configure(role: AccountRole.student)).called(1);
  });

  for (final dark in [false, true]) {
    for (final onboarding in [false, true]) {
      final name =
          'teacher_${onboarding ? 'setup' : 'mode'}_${dark ? 'dark' : 'light'}';
      testWidgets(name, (tester) async {
        await loadGalleryFonts();
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await pumpSheet(tester, dark: dark, onboarding: onboarding);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$name.png'),
        );
      }, tags: ['gallery']);
    }
  }
}
