import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/mocks/mock_team_finder_cubit.dart';

void main() {
  group('TeamFinderView', () {
    late TeamFinderCubit cubit;

    setUp(() => cubit = MockTeamFinderCubit());

    Widget buildSubject(TeamFinderState state) {
      when(() => cubit.state).thenReturn(state);
      return _app(
        BlocProvider<TeamFinderCubit>.value(
          value: cubit,
          child: const TeamFinderView(),
        ),
      );
    }

    testWidgets('uses a skeleton instead of a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const TeamFinderState(status: .loading)),
      );

      expect(find.byType(TeamListSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('keeps a cold-load error retryable', (tester) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const TeamFinderState(status: .failure)),
      );

      expect(find.text('Не удалось загрузить команды'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('confirms withdrawal before changing lifecycle state', (
      tester,
    ) async {
      const team = Team(
        id: 'team-1',
        title: 'Campus Crew',
        hasApplied: true,
        myApplicationId: 'application-1',
      );
      when(() => cubit.withdraw(team)).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const TeamFinderState(status: .ready, teams: [team])),
      );

      await tester.tap(find.text('Отозвать отклик'));
      await tester.pumpAndSettle();

      expect(find.text('Отозвать отклик?'), findsOneWidget);
      verifyNever(() => cubit.withdraw(team));

      await tester.tap(
        find.descendant(
          of: find.byType(NinjaDialog),
          matching: find.text('Отозвать отклик'),
        ),
      );
      await tester.pumpAndSettle();

      verify(() => cubit.withdraw(team)).called(1);
    });
  });

  testWidgets('team application exposes lifecycle actions separately', (
    tester,
  ) async {
    var accepted = false;
    var rejected = false;
    var telegram = false;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: TeamApplicationCard(
            application: const TeamApplication(
              id: 'application-1',
              teamId: 'team-1',
              applicantId: 'user-1',
              applicantName: 'Анна',
              applicantHandle: 'anna_dev',
              attachProfile: true,
            ),
            onAccept: () => accepted = true,
            onReject: () => rejected = true,
            onTelegram: () => telegram = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Принять'));
    await tester.tap(find.text('Отклонить'));
    await tester.tap(find.text('Написать в Telegram'));

    expect((accepted, rejected, telegram), (true, true, true));
  });

  testWidgets('hidden contact hides the dead Telegram button entirely', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: TeamApplicationCard(
            application: const TeamApplication(
              id: 'application-1',
              teamId: 'team-1',
              applicantId: 'user-1',
              applicantName: 'Анна',
            ),
            onAccept: () => fail('Disabled accept action was invoked'),
            onReject: () => fail('Disabled reject action was invoked'),
          ),
        ),
      ),
    );

    expect(find.text('Контакт Telegram недоступен'), findsNothing);
    expect(find.text('Контакт скрыт'), findsOneWidget);
  });

  testWidgets('create and apply forms support 320px at 200% text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final cubit = MockTeamFinderCubit();
    when(() => cubit.state).thenReturn(const TeamFinderState());
    const team = Team(
      id: 'team-1',
      title: 'Campus Crew',
      neededRoles: ['backend', 'design'],
    );

    for (final form in <Widget>[
      const CreateTeamSheet(),
      const ApplyToTeamSheet(team: team),
    ]) {
      await tester.pumpWidget(
        _app(
          MediaQuery.withClampedTextScaling(
            minScaleFactor: 2,
            maxScaleFactor: 2,
            child: BlocProvider<TeamFinderCubit>.value(
              value: cubit,
              child: Scaffold(
                body: Padding(padding: const .all(16), child: form),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    }
  });
}

Widget _app(Widget home) => MaterialApp(
  theme: AppTheme.darkTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('ru'),
  home: home,
);
