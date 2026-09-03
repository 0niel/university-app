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
  setUpAll(() => registerFallbackValue(PollType.single));

  testWidgets('failed creation preserves input and exposes a retryable error', (
    tester,
  ) async {
    final cubit = _MockPollsCubit();
    final result = Completer<bool>();
    when(
      () => cubit.createPoll(
        question: any(named: 'question'),
        options: any(named: 'options'),
        type: any(named: 'type'),
        isAnonymous: any(named: 'isAnonymous'),
        showResults: any(named: 'showResults'),
        expiresAt: any(named: 'expiresAt'),
        correctIndex: any(named: 'correctIndex'),
      ),
    ).thenAnswer((_) => result.future);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(child: PollCreatorSheet(cubit: cubit)),
        ),
      ),
    );
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Когда встречаемся?');
    await tester.enterText(fields.at(1), 'В понедельник');
    await tester.enterText(fields.at(2), 'Во вторник');
    await tester.ensureVisible(find.text('Создать'));
    await tester.tap(find.text('Создать'));
    await tester.pump();
    expect(
      tester.widget<NinjaButton>(find.byType(NinjaButton)).loading,
      isTrue,
    );
    expect(
      tester.widget<NinjaButton>(find.byType(NinjaButton)).onPressed,
      isNull,
    );
    result.complete(false);
    await tester.pump();
    expect(find.byType(AppBanner), findsOneWidget);
    expect(
      find.text('Не удалось создать опрос. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(fields.first).controller!.text,
      'Когда встречаемся?',
    );
    expect(
      tester.widget<NinjaButton>(find.byType(NinjaButton)).onPressed,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing an earlier option preserves the correct quiz answer', (
    tester,
  ) async {
    final cubit = _MockPollsCubit();
    when(
      () => cubit.createPoll(
        question: any(named: 'question'),
        options: any(named: 'options'),
        type: any(named: 'type'),
        isAnonymous: any(named: 'isAnonymous'),
        showResults: any(named: 'showResults'),
        expiresAt: any(named: 'expiresAt'),
        correctIndex: any(named: 'correctIndex'),
      ),
    ).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(child: PollCreatorSheet(cubit: cubit)),
        ),
      ),
    );

    await tester.tap(find.text('Квиз'));
    await tester.tap(find.text('Добавить вариант'));
    await tester.pump();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Вопрос');
    await tester.enterText(fields.at(1), 'А');
    await tester.enterText(fields.at(2), 'Б');
    await tester.enterText(fields.at(3), 'В');
    await tester.tap(find.bySemanticsLabel('Вариант 3, Квиз'));
    await tester.tap(find.byTooltip('Удалить вариант').first);
    await tester.pump();
    await tester.ensureVisible(find.text('Создать'));
    await tester.tap(find.text('Создать'));
    await tester.pump();

    verify(
      () => cubit.createPoll(
        question: 'Вопрос',
        options: ['Б', 'В'],
        type: PollType.quiz,
        correctIndex: 1,
      ),
    ).called(1);
  });

  testWidgets('blank options before the answer do not shift quiz index', (
    tester,
  ) async {
    final cubit = _MockPollsCubit();
    when(
      () => cubit.createPoll(
        question: any(named: 'question'),
        options: any(named: 'options'),
        type: any(named: 'type'),
        isAnonymous: any(named: 'isAnonymous'),
        showResults: any(named: 'showResults'),
        expiresAt: any(named: 'expiresAt'),
        correctIndex: any(named: 'correctIndex'),
      ),
    ).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(child: PollCreatorSheet(cubit: cubit)),
        ),
      ),
    );

    await tester.tap(find.text('Квиз'));
    await tester.tap(find.text('Добавить вариант'));
    await tester.pump();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Вопрос');
    await tester.enterText(fields.at(2), 'Б');
    await tester.enterText(fields.at(3), 'В');
    await tester.tap(find.bySemanticsLabel('Вариант 3, Квиз'));
    await tester.ensureVisible(find.text('Создать'));
    await tester.tap(find.text('Создать'));
    await tester.pump();

    verify(
      () => cubit.createPoll(
        question: 'Вопрос',
        options: ['Б', 'В'],
        type: PollType.quiz,
        correctIndex: 1,
      ),
    ).called(1);
  });
}
