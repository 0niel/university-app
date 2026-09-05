import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

void main() {
  const basePoll = Poll(
    id: 'p-1',
    title: 'Опрос дня',
    participantsCount: 12,
  );

  Future<void> pump(
    WidgetTester tester,
    Poll poll, {
    VoidCallback? onOwnerActions,
    VoidCallback? onChangeAnswers,
    VoidCallback? onResults,
    VoidCallback? onOpen,
    double textScale = 1,
  }) => tester.pumpWidget(
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
        body: SingleChildScrollView(
          child: PollCard(
            poll: poll,
            onOpen: onOpen ?? () {},
            onOwnerActions: onOwnerActions,
            onChangeAnswers: onChangeAnswers,
            onResults: onResults,
          ),
        ),
      ),
    ),
  );

  testWidgets('offers to take an active poll the user has not answered', (
    tester,
  ) async {
    await pump(tester, basePoll);

    expect(find.text('Пройти'), findsOneWidget);
    expect(find.text('Результаты'), findsNothing);
    expect(find.text('12'), findsNothing);
  });

  testWidgets('shows the results action once the user has participated', (
    tester,
  ) async {
    await pump(
      tester,
      basePoll.copyWith(iParticipated: true, canSeeResults: true),
    );

    expect(find.text('Результаты'), findsOneWidget);
    expect(find.text('Пройти'), findsNothing);
    expect(find.text('вы ответили'), findsOneWidget);
  });

  testWidgets('shows the ended tag for a closed poll', (tester) async {
    await pump(tester, basePoll.copyWith(isClosed: true, canSeeResults: true));

    expect(find.text('завершён'), findsOneWidget);
  });

  testWidgets('shows owner actions only when a handler is supplied', (
    tester,
  ) async {
    var tapped = false;
    await pump(tester, basePoll, onOwnerActions: () => tapped = true);

    final button = find.byTooltip('Управление опросом');
    expect(button, findsOneWidget);
    await tester.tap(button);
    expect(tapped, isTrue);
  });

  testWidgets('hides owner actions for polls the user does not own', (
    tester,
  ) async {
    await pump(tester, basePoll);

    expect(find.byTooltip('Управление опросом'), findsNothing);
  });

  testWidgets(
    'change answers is a separate action even when results are hidden',
    (tester) async {
      var changed = false;
      await pump(
        tester,
        basePoll.copyWith(iParticipated: true, allowChange: true),
        onChangeAnswers: () => changed = true,
      );
      expect(find.widgetWithText(AppButton, 'Результаты'), findsNothing);
      expect(find.text('Результаты пока скрыты'), findsOneWidget);
      await tester.tap(find.text('Изменить ответы'));
      expect(changed, isTrue);
    },
  );

  testWidgets('closed polls hide answer editing', (tester) async {
    await pump(
      tester,
      basePoll.copyWith(iParticipated: true, allowChange: true, isClosed: true),
      onChangeAnswers: () {},
    );
    expect(find.text('Изменить ответы'), findsNothing);
  });

  testWidgets('polls that disallow changes hide answer editing', (
    tester,
  ) async {
    await pump(
      tester,
      basePoll.copyWith(iParticipated: true),
      onChangeAnswers: () {},
    );
    expect(find.text('Изменить ответы'), findsNothing);
  });

  testWidgets('card handles a narrow viewport and large text', (tester) async {
    tester.view.physicalSize = const Size(320, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pump(
      tester,
      basePoll.copyWith(
        category: 'academic',
        authorName: 'Длинное имя преподавателя',
        participantsCount: 12345,
        iParticipated: true,
        allowChange: true,
        canSeeResults: true,
      ),
      onOwnerActions: () {},
      onChangeAnswers: () {},
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Изменить ответы'), findsOneWidget);
  });

  testWidgets('public results remain accessible before participating', (
    tester,
  ) async {
    var opened = false;
    await pump(
      tester,
      basePoll.copyWith(canSeeResults: true),
      onResults: () => opened = true,
    );

    expect(find.text('Пройти'), findsOneWidget);
    expect(find.text('Результаты'), findsOneWidget);
    await tester.tap(find.text('Результаты'));
    expect(opened, isTrue);
  });

  testWidgets('title opens the poll and owner action does not open it', (
    tester,
  ) async {
    var opened = 0;
    var managed = 0;
    await pump(
      tester,
      basePoll,
      onOpen: () => opened++,
      onOwnerActions: () => managed++,
    );
    await tester.tap(find.text(basePoll.title));
    expect(opened, 1);
    await tester.tap(find.byTooltip('Управление опросом'));
    expect(managed, 1);
    expect(opened, 1);
  });

  const resultQuestion = PollQuestion(
    id: 'q',
    text: 'Выберите время',
    kind: PollQuestionKind.single,
    myOptionIds: ['b'],
    options: [
      PollOption(id: 'a', text: 'Утро', votes: 3),
      PollOption(id: 'b', text: 'Вечер', votes: 7),
    ],
  );

  testWidgets(
    'answered public poll previews actual results and chosen answer',
    (tester) async {
      await pump(
        tester,
        basePoll.copyWith(
          iParticipated: true,
          canSeeResults: true,
          questions: [resultQuestion],
        ),
      );
      expect(find.text('70%'), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
      expect(find.textContaining('1 вопрос'), findsOneWidget);
      expect(find.byType(AppProgressBar), findsNWidgets(2));
    },
  );

  testWidgets(
    'result preview remains usable with large text on narrow screens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var opened = false;
      await pump(
        tester,
        basePoll.copyWith(
          iParticipated: true,
          canSeeResults: true,
          questions: [
            resultQuestion.copyWith(
              options: const [
                PollOption(
                  id: 'a',
                  text: 'В первой половине дня, сразу после лекций',
                  votes: 3,
                ),
                PollOption(
                  id: 'b',
                  text: 'Поздно вечером после всех занятий',
                  votes: 7,
                ),
              ],
            ),
          ],
        ),
        textScale: 2,
        onOpen: () => opened = true,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('70%'), findsOneWidget);
      await tester.ensureVisible(find.text('Результаты'));
      await tester.tap(find.text('Результаты'));
      expect(opened, isTrue);
    },
  );

  testWidgets('private payload and pre-vote results never enter card preview', (
    tester,
  ) async {
    for (final poll in [
      basePoll.copyWith(
        iParticipated: true,
        isMine: true,
        questions: [resultQuestion],
      ),
      basePoll.copyWith(canSeeResults: true, questions: [resultQuestion]),
    ]) {
      await pump(tester, poll);
      expect(find.byType(AppProgressBar), findsNothing);
      expect(find.text('70%'), findsNothing);
      expect(find.text('Утро'), findsNothing);
    }
  });

  testWidgets('simple poll keeps compact controls and a compact card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pump(tester, basePoll);
    expect(tester.getSize(find.byType(PollCard)).height, lessThan(260));
    expect(tester.getSize(find.byType(AppButton)).width, lessThan(180));
    expect(
      tester.getSize(find.byType(AppButton)).height,
      greaterThanOrEqualTo(44),
    );
  });
}
