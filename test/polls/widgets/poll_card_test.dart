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
        body: PollCard(
          poll: poll,
          onOpen: () {},
          onOwnerActions: onOwnerActions,
          onChangeAnswers: onChangeAnswers,
          onResults: onResults,
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
      final results = tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Результаты'),
      );
      expect(results.onPressed, isNull);
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
}
