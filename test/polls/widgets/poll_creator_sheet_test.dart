import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

class _MockPollsCubit extends Mock implements PollsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const <PollQuestionDraft>[]);
    registerFallbackValue(PollResultsVisibility.always);
  });

  late _MockPollsCubit cubit;

  setUp(() {
    cubit = _MockPollsCubit();
    when(
      () => cubit.createPoll(
        title: any(named: 'title'),
        questions: any(named: 'questions'),
        description: any(named: 'description'),
        category: any(named: 'category'),
        isAnonymous: any(named: 'isAnonymous'),
        resultsVisibility: any(named: 'resultsVisibility'),
        expiresAt: any(named: 'expiresAt'),
        allowChange: any(named: 'allowChange'),
      ),
    ).thenAnswer((_) async => null);
  });

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(900, 1400),
    bool modal = false,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NinjaToastHost(
            child: modal
                ? Builder(
                    builder: (context) => AppButton.primary(
                      label: 'Open creator',
                      onPressed: () =>
                          showPollCreatorSheet(context, cubit: cubit),
                    ),
                  )
                : SingleChildScrollView(child: PollCreatorSheet(cubit: cubit)),
          ),
        ),
      ),
    );
    if (modal) {
      await tester.tap(find.text('Open creator'));
      await tester.pumpAndSettle();
    }
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.pumpAndSettle();
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enterQuestions(
    WidgetTester tester, {
    Size size = const Size(900, 1400),
  }) async {
    await pump(tester, size: size);
    await tester.enterText(find.byType(TextField).first, 'Опрос дня');
    await tap(tester, find.text('Далее'));
  }

  Future<void> submitFromQuestions(WidgetTester tester) async {
    await tap(tester, find.text('Далее'));
    expect(find.text('3 из 4'), findsOneWidget);
    await tap(tester, find.text('Далее'));
    expect(find.text('4 из 4'), findsOneWidget);
    await tap(tester, find.text('Создать'));
  }

  List<dynamic> capturedCreation() => verify(
    () => cubit.createPoll(
      title: any(named: 'title'),
      questions: captureAny(named: 'questions'),
      description: any(named: 'description'),
      category: any(named: 'category'),
      isAnonymous: any(named: 'isAnonymous'),
      resultsVisibility: any(named: 'resultsVisibility'),
      expiresAt: captureAny(named: 'expiresAt'),
      allowChange: any(named: 'allowChange'),
    ),
  ).captured;

  testWidgets(
    'modal keeps navigation visible above the keyboard on a small screen',
    (tester) async {
      await pump(tester, size: const Size(320, 600), modal: true);
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Опрос дня');
      final next = find.text('Далее');
      expect(next.hitTestable(), findsOneWidget);
      expect(tester.getBottomRight(next).dy, lessThanOrEqualTo(360));
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('2 из 4'), findsOneWidget);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'preview edits target question and preserves draft at large text',
    (tester) async {
      await pump(tester, size: const Size(320, 700), modal: true, textScale: 2);
      await tester.enterText(find.byType(TextField).first, 'Опрос дня');
      await tap(tester, find.text('Далее'));
      await tap(tester, find.text('Текст'));
      await tester.enterText(find.byType(TextField), 'Первый вопрос');
      await tap(tester, find.text('Добавить вопрос'));
      await tap(tester, find.text('Текст').last);
      await tester.enterText(find.byType(TextField).last, 'Второй вопрос');
      await tap(tester, find.text('Далее'));
      await tap(tester, find.text('Далее'));
      final l10n = tester.element(find.byType(PollCreatorSheet)).l10n;
      await tap(
        tester,
        find.byTooltip('${l10n.edit}: ${l10n.pollsQuestionNumber(2)}'),
      );
      expect(find.text('Вопрос 2').hitTestable(), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField).last).controller!.text,
        'Второй вопрос',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'Исправленный вопрос',
      );
      await tap(tester, find.text('Далее'));
      await tap(tester, find.text('Далее'));
      expect(find.text('Вопрос 2. Исправленный вопрос'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('validation brings the first invalid question back into view', (
    tester,
  ) async {
    await pump(tester, size: const Size(320, 600), modal: true);
    await tester.enterText(find.byType(TextField).first, 'Опрос дня');
    await tap(tester, find.text('Далее'));
    await tap(tester, find.text('Добавить вопрос'));
    await tap(tester, find.text('Текст').last);
    await tester.enterText(find.byType(TextField).last, 'Второй вопрос');
    await tap(tester, find.text('Далее'));

    expect(find.text('Вопрос 1').hitTestable(), findsOneWidget);
    expect(find.text('Введите текст вопроса'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('blocks leaving the basics step without a title', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('Введите название опроса'), findsOneWidget);
    expect(find.text('Вопрос 1'), findsNothing);
  });

  testWidgets('blocks leaving the questions step until valid', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField).first, 'Опрос дня');
    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('Вопрос 1'), findsOneWidget);

    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('Введите текст вопроса'), findsOneWidget);
    final l10n = tester.element(find.byType(PollCreatorSheet)).l10n;
    expect(find.text(l10n.pollsDistinctOptionsRequired), findsOneWidget);
  });

  testWidgets('submits the built single-question draft', (tester) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField).first, 'Опрос дня');
    await tester.tap(find.text('Далее'));
    await tester.pump();

    final questionFields = find.byType(TextField);
    await tester.enterText(questionFields.at(0), 'Какой стек?');
    await tester.enterText(questionFields.at(1), 'Go');
    await tester.enterText(questionFields.at(2), 'Rust');
    await tester.tap(find.text('Далее'));
    await tester.pump();

    await tester.tap(find.text('Далее'));
    await tester.pump();

    await tester.tap(find.text('Создать'));
    await tester.pump();

    verify(
      () => cubit.createPoll(
        title: 'Опрос дня',
        questions: const [
          PollQuestionDraft(
            text: 'Какой стек?',
            kind: PollQuestionKind.single,
            options: ['Go', 'Rust'],
          ),
        ],
      ),
    ).called(1);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('switching to a text question hides the options editor', (
    tester,
  ) async {
    await pump(tester);

    await tester.enterText(find.byType(TextField).first, 'Опрос дня');
    await tester.tap(find.text('Далее'));
    await tester.pump();

    expect(find.text('Добавить вариант'), findsOneWidget);

    await tester.tap(find.text('Текст'));
    await tester.pump();

    expect(find.text('Добавить вариант'), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets(
    'quiz keeps the correct answer when an earlier option is removed',
    (
      tester,
    ) async {
      await enterQuestions(tester);
      await tap(tester, find.text('Квиз'));
      await tester.enterText(find.byType(TextField).at(0), 'Столица?');
      await tester.enterText(find.byType(TextField).at(1), 'Удалить');
      await tester.enterText(find.byType(TextField).at(2), 'Париж');
      await tap(tester, find.text('Добавить вариант'));
      await tester.enterText(find.byType(TextField).at(3), 'Москва');
      await tap(tester, find.byType(AppRadio<int>).at(2));
      await tap(tester, find.byTooltip('Удалить вариант').first);
      expect(
        tester
            .widget<AppRadio<int>>(find.byType(AppRadio<int>).last)
            .groupValue,
        1,
      );

      await submitFromQuestions(tester);

      final draft =
          (capturedCreation().first as List<PollQuestionDraft>).single;
      expect(draft.kind, PollQuestionKind.quiz);
      expect(draft.options, ['Париж', 'Москва']);
      expect(draft.correctIndex, 1);
    },
  );

  testWidgets('quiz maps the correct index after blank options are omitted', (
    tester,
  ) async {
    await enterQuestions(tester);
    await tap(tester, find.text('Квиз'));
    await tester.enterText(find.byType(TextField).at(0), 'Столица?');
    await tester.enterText(find.byType(TextField).at(2), 'Париж');
    await tap(tester, find.text('Добавить вариант'));
    await tester.enterText(find.byType(TextField).at(3), 'Москва');
    await tap(tester, find.byType(AppRadio<int>).at(2));

    await submitFromQuestions(tester);

    final draft = (capturedCreation().first as List<PollQuestionDraft>).single;
    expect(draft.options, ['Париж', 'Москва']);
    expect(draft.correctIndex, 1);
  });

  testWidgets('quiz cannot advance when the selected correct answer is blank', (
    tester,
  ) async {
    await enterQuestions(tester);
    await tap(tester, find.text('Квиз'));
    await tester.enterText(find.byType(TextField).at(0), 'Столица?');
    await tester.enterText(find.byType(TextField).at(2), 'Париж');
    await tap(tester, find.text('Добавить вариант'));
    await tester.enterText(find.byType(TextField).at(3), 'Москва');
    await tap(tester, find.text('Далее'));

    expect(find.text('2 из 4'), findsOneWidget);
    expect(
      find.text(
        tester
            .element(find.byType(PollCreatorSheet))
            .l10n
            .pollsDistinctOptionsRequired,
      ),
      findsOneWidget,
    );
  });

  testWidgets('question reordering survives preview and back navigation', (
    tester,
  ) async {
    await enterQuestions(tester);
    await tap(tester, find.text('Текст'));
    await tester.enterText(find.byType(TextField), 'Первый вопрос');
    await tap(tester, find.text('Добавить вопрос'));
    await tap(tester, find.text('Текст').last);
    await tester.enterText(find.byType(TextField).last, 'Второй вопрос');
    await tap(tester, find.byTooltip('Переместить вверх'));
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Второй вопрос',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      'Первый вопрос',
    );
    await tap(tester, find.text('Далее'));
    await tap(tester, find.text('Далее'));
    expect(find.text('4 из 4'), findsOneWidget);
    expect(find.text('Вопрос 1. Второй вопрос'), findsOneWidget);
    expect(find.text('Вопрос 2. Первый вопрос'), findsOneWidget);
    await tap(tester, find.text('Назад'));
    await tap(tester, find.text('Назад'));
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Второй вопрос',
    );
    await submitFromQuestions(tester);

    final questions = capturedCreation().first as List<PollQuestionDraft>;
    expect(questions.map((question) => question.text), [
      'Второй вопрос',
      'Первый вопрос',
    ]);
  });

  testWidgets('custom closing date and time reach the create request', (
    tester,
  ) async {
    await enterQuestions(tester);
    await tap(tester, find.text('Текст'));
    await tester.enterText(find.byType(TextField), 'Комментарий');
    await tap(tester, find.text('Далее'));
    await tap(tester, find.text('Выбрать дату'));
    final future = DateTime.now().add(const Duration(days: 19));
    final selected = DateTime(future.year, future.month, future.day);
    tester
        .widget<AppFlatCalendar>(find.byType(AppFlatCalendar))
        .onDateSelected(selected);
    await tester.pump();
    await tap(
      tester,
      find.text(tester.element(find.byType(AppDatePickerSheet)).l10n.done),
    );
    await tap(tester, find.text('23:59'));
    tester.widget<AppTimeWheelGroup>(find.byType(AppTimeWheelGroup)).onChanged((
      hour: 18,
      minute: 37,
    ));
    await tester.pump();
    await tap(
      tester,
      find.text(tester.element(find.byType(AppTimePickerSheet)).l10n.done),
    );
    expect(find.text('18:37'), findsOneWidget);
    await tap(tester, find.text('Далее'));
    await tap(tester, find.text('Создать'));

    expect(
      capturedCreation()[1],
      DateTime(selected.year, selected.month, selected.day, 18, 37),
    );
  });

  testWidgets('closing date picker remains usable in a short viewport', (
    tester,
  ) async {
    await enterQuestions(tester, size: const Size(400, 600));
    await tap(tester, find.text('Текст'));
    await tester.enterText(find.byType(TextField), 'Комментарий');
    await tap(tester, find.text('Далее'));
    await tap(tester, find.text('Выбрать дату'));
    expect(tester.takeException(), isNull);
    final l10n = tester.element(find.byType(AppDatePickerSheet)).l10n;
    final done = find.text(l10n.done);
    await tester.ensureVisible(done);
    await tester.pumpAndSettle();
    expect(done.hitTestable(), findsOneWidget);
    await tap(tester, done);
    expect(find.byType(AppDatePickerSheet), findsNothing);
    expect(find.text('23:59'), findsOneWidget);
  });
}
