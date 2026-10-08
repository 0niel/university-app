import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_greeting.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_hero.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_account_shortcut.dart';

import '../../gallery/home_dashboard_fixture.dart';
import '../../helpers/pump_app.dart';

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

void main() {
  testWidgets('teacher home keeps common content and offers its cabinet', (
    tester,
  ) async {
    final account = _Account();
    when(() => account.state).thenReturn(
      const AccountPersonaState(
        persona: AccountPersona(
          role: AccountRole.teacher,
          teacherId: 'teacher-id',
          teacherName: 'Иванов Иван Иванович',
          teacherAvailable: true,
        ),
        loaded: true,
      ),
    );
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      BlocProvider<AccountPersonaCubit>.value(
        value: account,
        child: Scaffold(body: homeDashboardFixture(controller: controller)),
      ),
      size: const Size(390, 844),
    );
    await tester.pump();
    expect(
      tester.widget<HomeGreeting>(find.byType(HomeGreeting)).name,
      'Преподаватель',
    );
    expect(find.byType(TeacherAccountShortcut), findsOneWidget);
    expect(find.text('Иванов Иван Иванович'), findsOneWidget);
    expect(find.text('Кабинет преподавателя'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('full dashboard remains scrollable at 320px and 200% text', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      Scaffold(body: homeDashboardFixture(controller: controller)),
      size: const Size(320, 844),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final loading in [true, false]) {
    testWidgets(
      '${loading ? 'loading' : 'no schedule'} never claims a free day',
      (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);
        await tester.pumpApp(
          Scaffold(
            body: homeDashboardFixture(
              controller: controller,
              loading: loading,
              noSchedule: !loading,
            ),
          ),
          size: const Size(390, 844),
        );
        await tester.pump();
        expect(find.byType(HomeHero), findsNothing);
        expect(find.text('Сегодня пар нет'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
