import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines_view.dart';
import 'package:rtu_mirea_app/community/widgets/deadline_widgets.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_row.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_deadlines_cubit.dart';

void main() {
  group('DeadlinesView', () {
    late DeadlinesCubit cubit;

    setUp(() {
      cubit = MockDeadlinesCubit();
    });

    Widget buildSubject(
      DeadlinesState state, {
      ThemeData? theme,
      double textScale = 1,
      bool reduceMotion = false,
    }) {
      when(() => cubit.state).thenReturn(state);
      return MaterialApp(
        theme: theme ?? AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reduceMotion,
            accessibleNavigation: reduceMotion,
          ),
          child: child!,
        ),
        home: NinjaToastHost(
          child: BlocProvider<DeadlinesCubit>.value(
            value: cubit,
            child: const DeadlinesView(),
          ),
        ),
      );
    }

    testWidgets('shows skeleton without a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const DeadlinesState(status: .loading)),
      );

      expect(find.byType(DeadlinesSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(DeadlineOverview), findsNothing);
      expect(
        find.descendant(
          of: find.byType(DeadlinesSkeleton),
          matching: find.byType(NinjaSkeleton),
        ),
        findsWidgets,
      );
      final skeletonBorders = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(DeadlinesSkeleton),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.border != null);
      expect(skeletonBorders, isEmpty);
    });

    testWidgets('shows a retryable load failure', (tester) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const DeadlinesState(status: .failure)),
      );

      expect(find.text('Не удалось загрузить дедлайны'), findsOneWidget);
      expect(find.text('Проверь соединение и попробуй снова'), findsOneWidget);
      expect(find.byType(DeadlineOverview), findsNothing);
      expect(find.byType(DeadlineFilterRow), findsNothing);
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('renders a deadline and forwards typed filter selection', (
      tester,
    ) async {
      final deadline = Deadline(
        id: 'deadline-1',
        title: 'Экзамен по математике',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
      );
      await tester.pumpWidget(
        buildSubject(DeadlinesState(status: .ready, deadlines: [deadline])),
      );
      await tester.pumpAndSettle();

      expect(find.text('Экзамен по математике'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Отметить выполненным',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Личные'));
      verify(() => cubit.filterChanged(.mine)).called(1);
    });

    testWidgets('completed deadline restores only through its clear action', (
      tester,
    ) async {
      final deadline = Deadline(
        id: 'done',
        title: 'Сданная работа',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
        isDone: true,
      );
      await tester.pumpWidget(
        buildSubject(DeadlinesState(status: .ready, deadlines: [deadline])),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dismissible), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Вернуть в активные',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows useful progress without divider-board styling', (
      tester,
    ) async {
      final deadlines = [
        Deadline(
          id: 'active',
          title: 'Курсовая',
          subjectName: 'Проектирование',
          dueAt: DateTime(2099, 9),
          source: .me,
          isMine: true,
          progress: 50,
        ),
        Deadline(
          id: 'done',
          title: 'Практика',
          dueAt: DateTime(2099, 8),
          source: .me,
          isMine: true,
          isDone: true,
        ),
      ];
      await tester.pumpWidget(
        buildSubject(DeadlinesState(status: .ready, deadlines: deadlines)),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 активный'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('Дедлайн'), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
      expect(find.byType(SliverPersistentHeader), findsNothing);
      final borderedCards = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(DeadlineRow),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.border != null);
      expect(borderedCards, isEmpty);
    });

    testWidgets('overview is the single pastel feature card of the screen', (
      tester,
    ) async {
      final deadline = Deadline(
        id: 'active',
        title: 'Курсовая',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
      );
      await tester.pumpWidget(
        buildSubject(
          DeadlinesState(status: .ready, deadlines: [deadline]),
          theme: NinjaTheme.light(),
        ),
      );
      await tester.pumpAndSettle();

      final colors = NinjaColors.light();
      final fills = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.color == colors.accentSoft)
          .toList();
      expect(fills, hasLength(1));
      expect(
        fills.single.borderRadius,
        BorderRadius.circular(NinjaRadius.card),
      );
      expect(
        find.descendant(
          of: find.byType(DeadlineOverview),
          matching: find.text('1 активный'),
        ),
        findsOneWidget,
      );
      final addButton = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(DeadlineAddButton),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .first;
      final decoration = addButton.decoration! as BoxDecoration;
      expect(decoration.color, colors.onAccentSoft);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(NinjaRadius.pill),
      );
    });

    testWidgets('header back control is a 44dp circular button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const DeadlinesState(status: .ready)),
      );
      await tester.pumpAndSettle();

      final backButton = find.descendant(
        of: find.byType(CommunityPageHeader),
        matching: find.byType(NinjaIconButton),
      );
      expect(backButton, findsOneWidget);
      expect(tester.getSize(backButton), const Size(44, 44));
    });

    testWidgets('empty state offers a real create action', (tester) async {
      await tester.pumpWidget(
        buildSubject(const DeadlinesState(status: .ready)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Дедлайнов нет'), findsOneWidget);
      expect(find.byType(DeadlineOverview), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Дедлайн'),
        ),
        findsOneWidget,
      );
      final emptyState = tester.widget<NinjaEmptyState>(
        find.byType(NinjaEmptyState),
      );
      expect(emptyState.actionLabel, 'Дедлайн');
      expect(emptyState.onAction, isNotNull);
    });

    testWidgets('fits a narrow AMOLED screen at 200% text scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final amoled = AppTheme.generateTheme(
        AppColors.dark.copyWith(
          background01: Colors.black,
          surface: const Color(0xFF101010),
          surfaceHigh: const Color(0xFF1A1A1A),
        ),
        Brightness.dark,
      );
      final deadline = Deadline(
        id: 'deadline-1',
        title: 'Подготовить очень длинную презентацию для защиты проекта',
        subjectName: 'Проектирование информационных систем',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
        progress: 35,
      );
      await tester.pumpWidget(
        buildSubject(
          DeadlinesState(status: .ready, deadlines: [deadline]),
          theme: amoled,
          textScale: 2,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(DeadlineOverview), findsOneWidget);
      expect(find.text('Дедлайны'), findsOneWidget);
    });

    testWidgets('removes deadline motion when accessibility requests it', (
      tester,
    ) async {
      final deadline = Deadline(
        id: 'deadline-1',
        title: 'Экзамен',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
      );
      await tester.pumpWidget(
        buildSubject(
          DeadlinesState(status: .ready, deadlines: [deadline]),
          reduceMotion: true,
        ),
      );

      expect(
        tester
            .widgetList<AnimatedOpacity>(
              find.descendant(
                of: find.byType(DeadlineRow),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .every((widget) => widget.duration == Duration.zero),
        isTrue,
      );
      expect(
        tester
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(DeadlineOverview),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .every((widget) => widget.duration == Duration.zero),
        isTrue,
      );
    });

    testWidgets('warns when refreshing stale data fails', (tester) async {
      final deadline = Deadline(
        id: 'deadline-1',
        title: 'Экзамен',
        dueAt: DateTime(2099, 9),
        source: .me,
        isMine: true,
      );
      final ready = DeadlinesState(status: .ready, deadlines: [deadline]);
      final failure = ready.copyWith(status: .failure);
      when(() => cubit.stream).thenAnswer((_) => Stream.value(failure));

      await tester.pumpWidget(buildSubject(ready));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(
        find.text(
          'Не удалось обновить список. Текущие данные могут быть устаревшими.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
