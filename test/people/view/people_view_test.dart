import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/people/people.dart';

import '../../helpers/mocks/mock_people_cubit.dart';

void main() {
  group('PeopleView', () {
    late PeopleCubit cubit;

    setUp(() {
      cubit = MockPeopleCubit();
      when(() => cubit.load()).thenAnswer((_) async => true);
    });

    Widget buildSubject(
      PeopleState state, {
      double textScale = 1,
      Stream<PeopleState> states = const Stream.empty(),
    }) {
      whenListen(
        cubit,
        states,
        initialState: state,
      );
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: NinjaToastHost(child: child!),
        ),
        home: BlocProvider<PeopleCubit>.value(
          value: cubit,
          child: PeopleView(
            onRefresh: cubit.load,
            onAdd: _done,
            onCreateGroup: _done,
            onJoinByCode: _done,
            onDiscoverGroups: _done,
            onManageGroup: _done,
            onAddToFriends: (_) => _done(),
            onRespondFriendRequest:
                ({
                  required friendshipId,
                  required accept,
                }) => _done(),
            onRespondGroupInvite: (_, {required accept}) => _done(),
          ),
        ),
      );
    }

    testWidgets('shows a skeleton without a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const PeopleState(status: .loading)),
      );

      expect(find.byType(NinjaPeopleLoadingSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('cold-load composition fits 320px at 200% text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildSubject(
          const PeopleState(status: .loading),
          textScale: 2,
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows a retryable cold-load failure', (tester) async {
      await tester.pumpWidget(
        buildSubject(const PeopleState(status: .failure)),
      );

      expect(find.byType(PeopleColdError), findsOneWidget);
      expect(find.text('Не удалось загрузить людей'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      await tester.pump();

      verify(() => cubit.load()).called(1);
    });

    testWidgets('reports a partial cold-load failure', (tester) async {
      final states = StreamController<PeopleState>();
      addTearDown(states.close);
      await tester.pumpWidget(
        buildSubject(
          const PeopleState(status: .ready),
          states: states.stream,
        ),
      );

      states.add(
        const PeopleState(
          status: .ready,
          failedSources: {.requests, .studyGroup},
        ),
      );
      await tester.pump();

      expect(
        find.text(
          'Часть данных не обновилась. Показываем последние доступные данные.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('group source failure hides the create group actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const PeopleState(
            status: .ready,
            tab: .group,
            failedSources: {.studyGroup},
          ),
        ),
      );

      expect(find.text('Не удалось проверить вашу группу'), findsOneWidget);
      expect(find.text('Создать группу'), findsNothing);
      expect(find.text('Вступить по коду'), findsNothing);
      await tester.tap(find.text('Повторить'));
      await tester.pump();

      verify(() => cubit.load()).called(1);
    });

    testWidgets('fits the group empty state at 320px and 200% text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildSubject(
          const PeopleState(status: .ready, tab: .group),
          textScale: 2,
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaNoStudyGroupTab), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the group empty state leads with one CTA and pills', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const PeopleState(status: .ready, tab: .group)),
      );
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Создать группу'),
        ),
        findsOneWidget,
      );
      final pills = tester.widgetList<NinjaChip>(find.byType(NinjaChip));
      expect(
        pills.map((chip) => chip.label),
        ['Вступить по коду', 'Найти группу'],
      );
      expect(
        tester.getSize(find.byType(NinjaChip).first).height,
        greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
      );
    });

    testWidgets('the friends empty state carries its own CTA', (tester) async {
      await tester.pumpWidget(
        buildSubject(const PeopleState(status: .ready)),
      );
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Найти друзей'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.byType(AppPressable),
        ),
        findsOneWidget,
      );
    });
  });
}

Future<void> _done() {
  final completer = Completer<void>()..complete();
  return completer.future;
}
