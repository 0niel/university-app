import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class _MockPollsCubit extends Mock implements PollsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Poll(id: 'p-1', title: 'Стек'));
    registerFallbackValue(const <PollAnswer>[]);
  });

  const poll = Poll(
    id: 'p-1',
    title: 'Опрос дня',
    questions: [
      PollQuestion(
        id: 'q-1',
        text: 'Какой стек?',
        kind: PollQuestionKind.single,
        options: [
          PollOption(id: 'o-1', text: 'Go'),
          PollOption(id: 'o-2', text: 'Rust'),
        ],
      ),
      PollQuestion(id: 'q-2', text: 'Комментарий', kind: PollQuestionKind.text),
    ],
  );

  late _MockPollsCubit cubit;

  setUp(() {
    cubit = _MockPollsCubit();
    when(
      () => cubit.submitAnswers(
        poll: any(named: 'poll'),
        answers: any(named: 'answers'),
      ),
    ).thenAnswer((_) async => null);
  });

  Future<void> pump(WidgetTester tester, {Poll value = poll}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: NinjaToastHost(
              child: SingleChildScrollView(
                child: PollRunnerSheet(poll: value, cubit: cubit),
              ),
            ),
          ),
        ),
      );

  testWidgets('blocks advancing past a required question with no answer', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('1 из 2'), findsOneWidget);
    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('Это обязательный вопрос'), findsOneWidget);
    expect(find.text('1 из 2'), findsOneWidget);
  });

  testWidgets('advances to the next question after answering', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('2 из 2'), findsOneWidget);
    expect(find.text('Отправить'), findsOneWidget);
  });

  testWidgets('goes back to the previous question', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();
    expect(find.text('2 из 2'), findsOneWidget);

    await tester.tap(find.text('Назад'));
    await tester.pump();

    expect(find.text('1 из 2'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
  });

  testWidgets('submits every answered question on the last step', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Всё отлично');
    await tester.tap(find.text('Отправить'));
    await tester.pump();

    verify(
      () => cubit.submitAnswers(
        poll: poll,
        answers: const [
          PollAnswer(questionId: 'q-1', optionIds: ['o-1']),
          PollAnswer(questionId: 'q-2', text: 'Всё отлично'),
        ],
      ),
    ).called(1);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('empty polls render an empty state without indexing a question', (
    tester,
  ) async {
    await pump(
      tester,
      value: const Poll(id: 'empty', title: 'Пустой'),
    );

    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(find.text('В этом опросе нет вопросов'), findsOneWidget);
    expect(find.text('Отправить'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quiz uses one selected option and validates every required step',
    (
      tester,
    ) async {
      final mixed = poll.copyWith(
        questions: [
          poll.questions.first.copyWith(kind: PollQuestionKind.quiz),
          const PollQuestion(
            id: 'q-multi',
            position: 1,
            text: 'Технологии',
            kind: PollQuestionKind.multiple,
            options: [
              PollOption(id: 'dart', text: 'Dart'),
              PollOption(id: 'sql', text: 'SQL'),
            ],
          ),
          const PollQuestion(
            id: 'q-rating',
            position: 2,
            text: 'Оценка',
            kind: PollQuestionKind.rating,
          ),
        ],
      );
      await pump(tester, value: mixed);
      await tester.tap(find.text('Go'));
      await tester.pump();
      await tester.tap(find.text('Rust'));
      await tester.pump();
      expect(
        tester
            .widget<AppRadio<String>>(find.byType(AppRadio<String>).first)
            .groupValue,
        'o-2',
      );
      await tester.tap(find.text('Далее'));
      await tester.pump();
      await tester.tap(find.text('Далее'));
      await tester.pump();
      expect(find.text('2 из 3'), findsOneWidget);
      expect(find.text('Это обязательный вопрос'), findsOneWidget);
      await tester.tap(find.text('Dart'));
      await tester.pump();
      await tester.tap(find.text('SQL'));
      await tester.pump();
      await tester.tap(find.text('Далее'));
      await tester.pump();
      await tester.tap(find.text('Отправить'));
      await tester.pump();
      expect(find.text('Это обязательный вопрос'), findsOneWidget);
      verifyNever(
        () => cubit.submitAnswers(
          poll: any(named: 'poll'),
          answers: any(named: 'answers'),
        ),
      );
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('Отправить'));
      await tester.pump();

      verify(
        () => cubit.submitAnswers(
          poll: mixed,
          answers: const [
            PollAnswer(questionId: 'q-1', optionIds: ['o-2']),
            PollAnswer(questionId: 'q-multi', optionIds: ['dart', 'sql']),
            PollAnswer(questionId: 'q-rating', rating: 4),
          ],
        ),
      ).called(1);
    },
  );

  testWidgets(
    'pending submission prevents repeat submission and input changes',
    (
      tester,
    ) async {
      final pending = Completer<Poll?>();
      final single = poll.copyWith(questions: [poll.questions.first]);
      when(
        () => cubit.submitAnswers(
          poll: any(named: 'poll'),
          answers: any(named: 'answers'),
        ),
      ).thenAnswer((_) => pending.future);
      await pump(tester, value: single);
      await tester.tap(find.text('Go'));
      await tester.pump();
      await tester.tap(find.text('Отправить'));
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
      expect(
        tester
            .widget<AbsorbPointer>(
              find
                  .ancestor(
                    of: find.byType(AppRadio<String>).first,
                    matching: find.byType(AbsorbPointer),
                  )
                  .first,
            )
            .absorbing,
        isTrue,
      );
      pending.complete(null);
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNotNull,
      );
      expect(
        tester
            .widget<AppRadio<String>>(find.byType(AppRadio<String>).first)
            .groupValue,
        'o-1',
      );
      verify(
        () => cubit.submitAnswers(
          poll: single,
          answers: const [
            PollAnswer(questionId: 'q-1', optionIds: ['o-1']),
          ],
        ),
      ).called(1);
    },
  );

  testWidgets('failed submission keeps text and selections for retry', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Сохранить черновик');
    await tester.tap(find.text('Отправить'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Сохранить черновик',
    );
    await tester.tap(find.text('Назад'));
    await tester.pump();
    expect(
      tester
          .widget<AppRadio<String>>(find.byType(AppRadio<String>).first)
          .groupValue,
      'o-1',
    );
    await tester.tap(find.text('Далее'));
    await tester.pump();
    await tester.tap(find.text('Отправить'));
    await tester.pump();

    verify(
      () => cubit.submitAnswers(
        poll: poll,
        answers: const [
          PollAnswer(questionId: 'q-1', optionIds: ['o-1']),
          PollAnswer(questionId: 'q-2', text: 'Сохранить черновик'),
        ],
      ),
    ).called(2);
  });

  testWidgets('counter refresh does not reset the current draft or step', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Rust'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Локальный текст');
    final refreshed = poll.copyWith(
      participantsCount: 99,
      questions: [
        for (final question in poll.questions)
          question.copyWith(
            options: [
              for (final option in question.options) option.copyWith(votes: 12),
            ],
          ),
      ],
    );
    await pump(tester, value: refreshed);
    expect(find.text('2 из 2'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Локальный текст',
    );
    await tester.tap(find.text('Отправить'));
    await tester.pump();

    verify(
      () => cubit.submitAnswers(
        poll: refreshed,
        answers: const [
          PollAnswer(questionId: 'q-1', optionIds: ['o-2']),
          PollAnswer(questionId: 'q-2', text: 'Локальный текст'),
        ],
      ),
    ).called(1);
  });

  testWidgets(
    'editing starts from saved answers and closed polls cannot submit',
    (
      tester,
    ) async {
      final answered = poll.copyWith(
        iParticipated: true,
        allowChange: true,
        questions: [
          poll.questions.first.copyWith(myOptionIds: ['o-2']),
        ],
      );
      await pump(tester, value: answered);
      expect(
        tester
            .widget<AppRadio<String>>(find.byType(AppRadio<String>).first)
            .groupValue,
        'o-2',
      );
      await pump(tester, value: answered.copyWith(isClosed: true));
      await tester.tap(find.text('Отправить'));
      await tester.pump();
      verifyNever(
        () => cubit.submitAnswers(
          poll: any(named: 'poll'),
          answers: any(named: 'answers'),
        ),
      );
    },
  );

  testWidgets('structural refresh discards answers for removed questions', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.tap(find.text('Далее'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Старый черновик');
    final updated = poll.copyWith(
      questions: const [
        PollQuestion(
          id: 'new',
          text: 'Новый вопрос',
          kind: PollQuestionKind.text,
        ),
      ],
    );
    await pump(tester, value: updated);

    expect(find.text('1 из 1'), findsOneWidget);
    expect(find.text('Новый вопрос'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'Новый ответ');
    await tester.tap(find.text('Отправить'));
    await tester.pump();
    verify(
      () => cubit.submitAnswers(
        poll: updated,
        answers: const [PollAnswer(questionId: 'new', text: 'Новый ответ')],
      ),
    ).called(1);
  });

  testWidgets('server acknowledged own answers replace the local draft', (
    tester,
  ) async {
    final initial = poll.copyWith(
      allowChange: true,
      questions: [poll.questions.last],
    );
    await pump(tester, value: initial);
    await tester.enterText(find.byType(TextField), 'Локальный ответ');
    final acknowledged = initial.copyWith(
      iParticipated: true,
      questions: [
        poll.questions.last.copyWith(myTextAnswer: 'Подтверждённый ответ'),
      ],
    );
    await pump(tester, value: acknowledged);

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Подтверждённый ответ',
    );
    expect(tester.takeException(), isNull);
  });
}
