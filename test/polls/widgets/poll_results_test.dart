import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

void main() {
  const poll = Poll(
    id: 'results',
    title: 'Результаты',
    questions: [
      PollQuestion(
        id: 'quiz',
        text: 'Квиз',
        kind: PollQuestionKind.quiz,
        myOptionIds: ['right'],
        options: [
          PollOption(id: 'right', text: 'Верный', votes: 3, isCorrect: true),
          PollOption(id: 'wrong', text: 'Неверный', votes: 1),
        ],
      ),
      PollQuestion(
        id: 'text',
        text: 'Комментарии',
        kind: PollQuestionKind.text,
        textAnswers: ['Частный ответ'],
      ),
      PollQuestion(
        id: 'rating',
        text: 'Оценка',
        kind: PollQuestionKind.rating,
        ratingAverage: 4.5,
        ratingCount: 2,
        myRating: 5,
      ),
    ],
  );

  Future<void> pump(WidgetTester tester, Poll value, {double textScale = 1}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Scaffold(
            body: SingleChildScrollView(child: PollResults(poll: value)),
          ),
        ),
      );

  testWidgets('hidden results never render payloads or correct answers', (
    tester,
  ) async {
    await pump(tester, poll);

    expect(find.text('Результаты пока скрыты'), findsOneWidget);
    expect(find.text('Частный ответ'), findsNothing);
    expect(find.text('Верный'), findsNothing);
    expect(find.text('Правильный ответ'), findsNothing);
    expect(find.byType(AppProgressBar), findsNothing);
  });

  testWidgets('owner identity does not bypass server result visibility', (
    tester,
  ) async {
    await pump(tester, poll.copyWith(isMine: true));

    expect(find.text('Результаты пока скрыты'), findsOneWidget);
    expect(find.text('Частный ответ'), findsNothing);
  });

  testWidgets('visible quiz, text and rating results retain their detail', (
    tester,
  ) async {
    await pump(tester, poll.copyWith(canSeeResults: true));

    expect(find.text('75%'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Правильный ответ'), findsOneWidget);
    expect(find.text('Частный ответ'), findsOneWidget);
    expect(find.byType(AppProgressBar), findsNWidgets(3));
    final l10n = tester.element(find.byType(PollResults)).l10n;
    expect(find.text(l10n.pollsRatingAverage('4.5')), findsOneWidget);
    expect(find.text('${l10n.pollsMyChoice}: 5/5'), findsOneWidget);
  });

  testWidgets('result detail handles a narrow viewport and large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pump(tester, poll.copyWith(canSeeResults: true), textScale: 2);

    expect(tester.takeException(), isNull);
    expect(find.text('Правильный ответ'), findsOneWidget);
  });

  testWidgets(
    'empty results do not invent a zero rating and preserve long options',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const longOption =
          'Подробный вариант ответа с пояснением, которое должно быть видно '
          'полностью даже при увеличенном размере текста';
      await pump(
        tester,
        poll.copyWith(
          canSeeResults: true,
          questions: const [
            PollQuestion(
              id: 'rating',
              position: 1,
              text: 'Без оценок',
              kind: PollQuestionKind.rating,
            ),
            PollQuestion(
              id: 'choice',
              text: 'Без голосов',
              kind: PollQuestionKind.single,
              options: [PollOption(id: 'option', text: longOption)],
            ),
          ],
        ),
        textScale: 2,
      );
      expect(find.text('Пока нет ответов'), findsNWidgets(2));
      expect(tester.widget<Text>(find.text(longOption)).maxLines, isNull);
      final l10n = tester.element(find.byType(PollResults)).l10n;
      expect(find.text(l10n.pollsRatingAverage('0.0')), findsNothing);
      expect(
        tester.getTopLeft(find.text('Без голосов')).dy,
        lessThan(tester.getTopLeft(find.text('Без оценок')).dy),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
