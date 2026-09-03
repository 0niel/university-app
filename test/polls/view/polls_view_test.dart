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
  setUpAll(() {
    registerFallbackValue(PollFilter.all);
  });

  group('PollsView', () {
    late CampusRepository campusRepository;

    setUp(() {
      campusRepository = MockCampusRepository();
    });

    Widget buildSubject(PollsCubit cubit) {
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
        home: NinjaToastHost(
          child: BlocProvider.value(value: cubit, child: const PollsView()),
        ),
      );
    }

    testWidgets('shows the skeleton on cold load', (tester) async {
      final pending = Completer<List<Poll>>();
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) => pending.future);

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      unawaited(cubit.load());

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('shows a retryable error instead of the empty state', (
      tester,
    ) async {
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenThrow(Exception('network down'));

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pump();

      expect(find.text('Ошибка загрузки'), findsOneWidget);
      expect(find.text('Опросов пока нет'), findsNothing);

      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => []);
      await tester.tap(find.text('Повторить'));
      await tester.pump();

      verify(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).called(2);
    });

    testWidgets('the empty state offers a real create action', (
      tester,
    ) async {
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => []);

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit));
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

    testWidgets('renders a poll card and reloads when the filter changes', (
      tester,
    ) async {
      const poll = Poll(id: 'p-1', title: 'Опрос дня', participantsCount: 3);
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => [poll]);

      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pump();

      expect(find.text('Опрос дня'), findsOneWidget);
      expect(find.text('Пройти'), findsOneWidget);

      await tester.tap(find.text('Мои'));
      await tester.pump();

      verify(
        () => campusRepository.getPolls(filter: PollFilter.mine),
      ).called(1);
    });

    testWidgets(
      'explicit answer editing opens the prefilled runner '
      'while results stay hidden',
      (tester) async {
        const poll = Poll(
          id: 'answered',
          title: 'Ответивший',
          iParticipated: true,
          allowChange: true,
          questions: [
            PollQuestion(
              id: 'q-1',
              text: 'Ваш ответ?',
              kind: PollQuestionKind.quiz,
              myOptionIds: ['o-2'],
              options: [
                PollOption(id: 'o-1', text: 'Первый'),
                PollOption(id: 'o-2', text: 'Второй'),
              ],
            ),
          ],
        );
        when(
          () => campusRepository.getPolls(
            filter: any(named: 'filter'),
            category: any(named: 'category'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => [poll]);
        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        await cubit.load();
        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();
        await tester.ensureVisible(find.text('Изменить ответы'));
        await tester.tap(find.text('Изменить ответы'));
        await tester.pumpAndSettle();

        expect(find.byType(PollRunnerSheet), findsOneWidget);
        expect(find.byType(PollResults), findsNothing);
        expect(
          tester
              .widget<AppRadio<String>>(find.byType(AppRadio<String>).first)
              .groupValue,
          'o-2',
        );
      },
    );

    testWidgets(
      'loading more appends the next page without dropping prior polls',
      (tester) async {
        final first = List.generate(
          20,
          (index) => Poll(id: 'poll-$index', title: 'Опрос $index'),
        );
        when(
          () => campusRepository.getPolls(
            filter: any(named: 'filter'),
            category: any(named: 'category'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => first);
        when(
          () => campusRepository.getPolls(
            filter: any(named: 'filter'),
            category: any(named: 'category'),
            query: any(named: 'query'),
            offset: 20,
          ),
        ).thenAnswer(
          (_) async => const [Poll(id: 'poll-20', title: 'Следующая страница')],
        );
        final cubit = PollsCubit(campusRepository: campusRepository);
        addTearDown(cubit.close);
        await cubit.load();
        await tester.pumpWidget(buildSubject(cubit));
        await tester.pump();
        final l10n = tester.element(find.byType(PollsView)).l10n;
        await tester.scrollUntilVisible(
          find.text(l10n.pollsLoadMore),
          800,
          scrollable: find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.tap(find.text(l10n.pollsLoadMore));
        await tester.pumpAndSettle();

        expect(cubit.state.polls, [
          ...first,
          const Poll(id: 'poll-20', title: 'Следующая страница'),
        ]);
        expect(cubit.hasMore, isFalse);
        expect(find.text(l10n.pollsLoadMore), findsNothing);
        expect(find.text('Следующая страница'), findsOneWidget);
      },
    );

    testWidgets('refresh errors remain visible when cached polls exist', (
      tester,
    ) async {
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => const [Poll(id: 'cached', title: 'Сохранённый опрос')],
      );
      final cubit = PollsCubit(campusRepository: campusRepository);
      addTearDown(cubit.close);
      await cubit.load();
      await tester.pumpWidget(buildSubject(cubit));
      when(
        () => campusRepository.getPolls(
          filter: any(named: 'filter'),
          category: any(named: 'category'),
          query: any(named: 'query'),
        ),
      ).thenThrow(Exception('unavailable'));
      await cubit.load();
      await tester.pump();

      expect(find.text('Сохранённый опрос'), findsOneWidget);
      expect(find.byType(AppBanner), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
    });
  });
}
