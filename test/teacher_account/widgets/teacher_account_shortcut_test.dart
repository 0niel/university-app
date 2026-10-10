import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_account_shortcut.dart';

import '../../gallery/gallery_fonts.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

void main() {
  const ready = AccountPersonaState(
    persona: AccountPersona(
      role: AccountRole.teacher,
      teacherId: 'teacher-id',
      teacherName: 'Иванов Иван Иванович',
      teacherAvailable: true,
    ),
    loaded: true,
  );
  const unselected = AccountPersonaState(
    persona: AccountPersona(role: AccountRole.teacher),
    loaded: true,
  );
  final unavailable = ready.copyWith(
    persona: ready.persona.copyWith(teacherAvailable: false),
  );
  final restoring = unselected.copyWith(
    loaded: false,
    operation: AccountPersonaOperation.restoring,
  );
  late _Account account;
  late StreamController<AccountPersonaState> states;
  late GoRouter router;

  Future<void> pump(
    WidgetTester tester,
    AccountPersonaState state, {
    double scale = 1,
    bool dark = false,
  }) async {
    account = _Account();
    states = StreamController<AccountPersonaState>.broadcast();
    whenListen(account, states.stream, initialState: state);
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.screen),
              child: TeacherAccountShortcut(),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/teacher',
          builder: (_, _) => const Scaffold(body: Text('cabinet opened')),
        ),
      ],
    );
    tester.view
      ..physicalSize = const Size(320, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await states.close();
      router.dispose();
    });
    await tester.pumpWidget(
      BlocProvider<AccountPersonaCubit>.value(
        value: account,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
            ),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final entry in [
    ('ready', ready, 'Иванов Иван Иванович'),
    ('unselected', unselected, 'Выберите преподавателя'),
    ('unavailable', unavailable, 'Преподаватель недоступен'),
  ]) {
    testWidgets('${entry.$1} entry explains its purpose and opens cabinet', (
      tester,
    ) async {
      await pump(tester, entry.$2, scale: 2);
      final card = find.byKey(const ValueKey('teacher-account-shortcut'));
      final copy = tester.widget<AppCard>(card).semanticsLabel!;
      expect(copy, contains('Ваш кабинет'));
      expect(copy, contains(entry.$3));
      expect(
        copy,
        contains(
          entry.$1 == 'ready'
              ? 'Своё расписание, группы и рейтинг'
              : entry.$1 == 'unselected'
              ? 'свои занятия и рейтинг'
              : 'Выберите преподавателя заново',
        ),
      );
      expect(tester.getSize(card).height, greaterThanOrEqualTo(44));
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('cabinet opened'), findsOneWidget);
      expect(
        GoRouterState.of(tester.element(find.text('cabinet opened'))).uri.path,
        '/profile/teacher',
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('restoring is honest and becomes an actionable ready entry', (
    tester,
  ) async {
    await pump(tester, restoring);
    final card = find.byKey(const ValueKey('teacher-account-shortcut'));
    expect(tester.widget<AppCard>(card).onTap, isNull);
    expect(find.text('Загружаем ваш кабинет'), findsOneWidget);
    expect(find.text('Выберите преподавателя'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.tap(card);
    await tester.pump();
    expect(router.routeInformationProvider.value.uri.path, '/');
    states.add(ready);
    await tester.pumpAndSettle();
    expect(tester.widget<AppCard>(card).onTap, isNotNull);
    expect(find.text('Иванов Иван Иванович'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('cabinet opened'), findsOneWidget);
  });

  testWidgets('student entry is hidden and cached teacher remains available', (
    tester,
  ) async {
    await pump(tester, const AccountPersonaState(loaded: true));
    expect(find.byType(AppCard), findsNothing);
    states.add(
      ready.copyWith(
        loaded: false,
        operation: AccountPersonaOperation.restoring,
      ),
    );
    await tester.pumpAndSettle();
    final card = find.byKey(const ValueKey('teacher-account-shortcut'));
    expect(tester.widget<AppCard>(card).onTap, isNotNull);
    expect(find.text('Иванов Иван Иванович'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'entry states ${dark ? 'dark' : 'light'} gallery',
      (tester) async {
        await loadGalleryFonts();
        await pump(tester, ready, dark: dark, scale: 1.6);
        final material = find.byType(MaterialApp);
        final labels = ['ready', 'unselected', 'unavailable', 'restoring'];
        final values = [ready, unselected, unavailable, restoring];
        for (var index = 0; index < values.length; index++) {
          states.add(values[index]);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull);
          await expectLater(
            material,
            matchesGoldenFile(
              'goldens/teacher_entry_${labels[index]}_'
              '${dark ? 'dark' : 'light'}.png',
            ),
          );
        }
      },
      tags: const ['gallery'],
    );
  }
}
