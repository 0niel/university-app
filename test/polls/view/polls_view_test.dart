import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  group('PollsView', () {
    late CampusRepository campusRepository;

    setUp(() {
      campusRepository = MockCampusRepository();
    });

    Widget buildSubject(
      PollsCubit cubit, {
      double textScale = 1,
      bool reduceMotion = false,
    }) {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reduceMotion,
            accessibleNavigation: reduceMotion,
          ),
          child: child!,
        ),
        home: NinjaToastHost(
          child: BlocProvider.value(
            value: cubit,
            child: const PollsView(),
          ),
        ),
      );
    }

    testWidgets(
      'shows the skeleton on cold load and hides the spinner',
      (tester) async {
        // getPolls never completes, so the cubit stays in loading
        // with no cached polls — the cold-load branch.
        final pending = Completer<List<Poll>>();
        when(
          () => campusRepository.getPolls(),
        ).thenAnswer((_) => pending.future);

        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        unawaited(cubit.load());

        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();

        expect(find.byType(NinjaSkeleton), findsWidgets);
        expect(find.bySemanticsLabel('Загрузка'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && (widget.properties.liveRegion ?? false),
          ),
          findsOneWidget,
        );
        expect(tester.binding.transientCallbackCount, 1);
        expect(find.text('0'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'shows a retryable error instead of "no polls yet" on failure',
      (tester) async {
        when(
          () => campusRepository.getPolls(),
        ).thenThrow(Exception('network down'));

        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        await cubit.load();

        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();

        expect(find.text('Ошибка загрузки'), findsOneWidget);
        expect(find.text('Опросов пока нет'), findsNothing);
        expect(find.text('0'), findsNothing);

        when(() => campusRepository.getPolls()).thenAnswer((_) async => []);
        await tester.tap(find.text('Повторить'));
        await tester.pump();

        verify(() => campusRepository.getPolls()).called(2);
      },
    );

    testWidgets(
      'shows an error toast and does not crash when a vote fails',
      (tester) async {
        const option1 = PollOption(id: 'o-1', text: 'Go', votes: 3);
        const option2 = PollOption(id: 'o-2', text: 'Rust', votes: 1);
        const poll = Poll(
          id: 'p-1',
          question: 'Какой стек учить летом?',
          pollType: PollType.single,
          options: [option1, option2],
          totalVotes: 4,
        );
        when(
          () => campusRepository.getPolls(),
        ).thenAnswer((_) async => [poll]);
        when(
          () => campusRepository.votePoll(
            pollId: any(named: 'pollId'),
            optionIds: any(named: 'optionIds'),
          ),
        ).thenThrow(Exception('rls'));

        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        await cubit.load();

        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();

        await tester.tap(find.text('Go'));
        await tester.pump();

        expect(find.text('Ошибка'), findsWidgets);
        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets(
      'disables the tapped option while the vote is pending',
      (tester) async {
        const option1 = PollOption(id: 'o-1', text: 'Go', votes: 3);
        const option2 = PollOption(id: 'o-2', text: 'Rust', votes: 1);
        const poll = Poll(
          id: 'p-1',
          question: 'Какой стек учить летом?',
          pollType: PollType.single,
          options: [option1, option2],
          totalVotes: 4,
        );
        when(
          () => campusRepository.getPolls(),
        ).thenAnswer((_) async => [poll]);
        final voteCompleter = Completer<void>();
        when(
          () => campusRepository.votePoll(
            pollId: any(named: 'pollId'),
            optionIds: any(named: 'optionIds'),
          ),
        ).thenAnswer((_) => voteCompleter.future);

        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        await cubit.load();

        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();

        await tester.tap(find.text('Go'));
        await tester.pump();

        expect(cubit.state.pendingPollIds, contains('p-1'));
        expect(find.byType(NinjaSpinner), findsOneWidget);

        // Tapping again while pending must not submit a second vote.
        await tester.tap(find.text('Go'));
        await tester.pump();
        verify(
          () => campusRepository.votePoll(
            pollId: any(named: 'pollId'),
            optionIds: any(named: 'optionIds'),
          ),
        ).called(1);

        voteCompleter.complete();
        await tester.pumpAndSettle();
      },
    );

    testWidgets('the empty state offers a real create action', (tester) async {
      when(() => campusRepository.getPolls()).thenAnswer((_) async => []);

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit, reduceMotion: true));
      await tester.pump();

      expect(find.byType(NinjaEmptyState), findsOneWidget);
      expect(find.text('Опросов пока нет'), findsOneWidget);

      final cta = find.descendant(
        of: find.byType(NinjaEmptyState),
        matching: find.text('Создать'),
      );
      expect(cta, findsOneWidget);
      await tester.tap(cta);
      await tester.pumpAndSettle();

      expect(find.text('Новый опрос'), findsOneWidget);
    });

    testWidgets('results render a full-row option bar with a tabular percent', (
      tester,
    ) async {
      const poll = Poll(
        id: 'p-1',
        question: 'Какой стек учить летом?',
        pollType: PollType.single,
        options: [
          PollOption(id: 'o-1', text: 'Go', votes: 3, votedByMe: true),
          PollOption(id: 'o-2', text: 'Rust', votes: 1),
        ],
        totalVotes: 4,
      );
      when(
        () => campusRepository.getPolls(),
      ).thenAnswer((_) async => [poll]);

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit, reduceMotion: true));
      await tester.pumpAndSettle();

      final bars = find.byType(PollOptionBar);
      expect(bars, findsNWidgets(2));
      for (final bar in bars.evaluate()) {
        expect(
          tester.getSize(find.byWidget(bar.widget)).height,
          greaterThanOrEqualTo(44),
        );
      }

      final percent = tester.widget<Text>(find.text('75%'));
      expect(
        percent.style?.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
      expect(find.text('25%'), findsOneWidget);
      for (final (index, label) in ['Go', 'Rust'].indexed) {
        expect(
          tester.getCenter(find.text(label)).dy,
          closeTo(tester.getCenter(bars.at(index)).dy, .1),
        );
      }
    });

    testWidgets('fits 320px at 200 percent with reduced motion', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final poll = Poll(
        id: 'p-adaptive',
        question: 'Какой формат занятий удобнее для длинной учебной недели?',
        pollType: PollType.single,
        options: const [
          PollOption(id: 'o-1', text: 'Очно', votes: 10),
          PollOption(id: 'o-2', text: 'Онлайн', votes: 7),
        ],
        totalVotes: 17,
        isMine: true,
        createdAt: DateTime(2026, 8, 20, 12),
      );
      when(() => campusRepository.getPolls()).thenAnswer((_) async => [poll]);
      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(
        buildSubject(cubit, textScale: 2, reduceMotion: true),
      );
      await tester.pump();

      expect(find.text('Очно'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
