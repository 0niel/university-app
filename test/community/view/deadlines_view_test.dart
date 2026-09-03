import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadlines_hero.dart';
import 'package:rtu_mirea_app/community/view/deadlines_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_deadlines_cubit.dart';

void main() {
  late DeadlinesCubit cubit;

  setUp(() {
    ToastManager.debugReset();
    cubit = MockDeadlinesCubit();
    when(() => cubit.toggleDone(any())).thenAnswer((_) async => true);
    when(() => cubit.deleteDeadline(any())).thenReturn(null);
    when(
      () => cubit.postponeOverdueToTomorrow(now: any(named: 'now')),
    ).thenAnswer((_) async => true);
  });
  tearDown(ToastManager.debugReset);

  Widget subject(
    DeadlinesState state, {
    double scale = 1,
    bool reduced = false,
    DateTime? now,
  }) {
    when(() => cubit.state).thenReturn(state);
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
          disableAnimations: reduced,
          accessibleNavigation: reduced,
        ),
        child: child!,
      ),
      home: NinjaToastHost(
        child: BlocProvider.value(
          value: cubit,
          child: DeadlinesView(now: now),
        ),
      ),
    );
  }

  Deadline deadline({
    String id = 'one',
    bool done = false,
    bool mine = true,
    DateTime? due,
  }) => Deadline(
    id: id,
    title: 'Работа $id',
    subjectName: 'Математика',
    dueAt: due ?? DateTime(2026, 9, 3, 12).add(const Duration(days: 3)),
    source: .me,
    isMine: mine,
    isDone: done,
  );

  Finder rowFinder(String id) => find.descendant(
    of: find.byKey(ValueKey('deadline-$id')),
    matching: find.byType(AppDeadlineRow),
  );

  testWidgets('shows skeleton without a spinner during cold load', (
    tester,
  ) async {
    await tester.pumpWidget(subject(const DeadlinesState(status: .loading)));
    expect(find.byType(AppSkeletonRow), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(DeadlinesHero), findsNothing);
  });

  testWidgets('shows a retryable load failure', (tester) async {
    when(() => cubit.load()).thenAnswer((_) async => true);
    await tester.pumpWidget(subject(const DeadlinesState(status: .failure)));
    expect(find.byType(AppErrorState), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    verify(() => cubit.load()).called(1);
  });

  testWidgets('groups deadlines with counts and forwards completion', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 3, 12);
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [
            deadline(id: 'today', due: DateTime(2026, 9, 3, 23, 59)),
            deadline(due: DateTime(2026, 9, 6, 12)),
            deadline(id: 'later', due: DateTime(2026, 9, 25, 12)),
          ],
        ),
        now: now,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(AppCalendarMonth), findsNothing);
    expect(find.text('Работа today'), findsOneWidget);
    expect(find.text('НА ЭТОЙ НЕДЕЛЕ · 1'), findsOneWidget);
    expect(find.text('ПОЗЖЕ · 1'), findsOneWidget);
    final row = tester.widget<AppDeadlineRow>(rowFinder('one'));
    row.onToggle!();
    verify(() => cubit.toggleDone('one')).called(1);
  });

  testWidgets('overdue items surface a banner with a postpone action', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 3, 12);
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [
            deadline(id: 'overdue', due: DateTime(2026, 9, 1, 12)),
          ],
        ),
        now: now,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppBanner), findsOneWidget);
    await tester.tap(find.text('Перенести на завтра'));
    await tester.pumpAndSettle();
    verify(
      () => cubit.postponeOverdueToTomorrow(now: any(named: 'now')),
    ).called(1);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('switching to the calendar segment shows the month grid', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 3, 12);
    await tester.pumpWidget(
      subject(
        DeadlinesState(status: .ready, deadlines: [deadline()]),
        now: now,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppCalendarMonth), findsNothing);
    await tester.tap(find.text('Календарь'));
    await tester.pumpAndSettle();
    expect(find.byType(AppCalendarMonth), findsOneWidget);
  });

  testWidgets('the done group is collapsed and expands on tap', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 3, 12);
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [deadline(id: 'done', done: true)],
        ),
        now: now,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Работа done'), findsNothing);
    await tester.tap(find.text('ГОТОВО · 1'));
    verify(() => cubit.toggleDoneGroupExpanded()).called(1);
  });

  testWidgets('completed deadline has an explicit restore control', (
    tester,
  ) async {
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [deadline(done: true)],
          doneGroupExpanded: true,
        ),
      ),
    );
    final row = tester.widget<AppDeadlineRow>(find.byType(AppDeadlineRow));
    expect(row.done, isTrue);
    row.onToggle!();
    verify(() => cubit.toggleDone('one')).called(1);
  });

  testWidgets('long-press opens the deadline actions sheet', (tester) async {
    final now = DateTime(2026, 9, 3, 12);
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [deadline(due: DateTime(2026, 9, 3, 23, 59))],
        ),
        now: now,
      ),
    );
    await tester.pumpAndSettle();
    await tester.longPress(find.byKey(const ValueKey('deadline-one')));
    await tester.pumpAndSettle();
    expect(find.text('Удалить'), findsOneWidget);
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    verify(() => cubit.deleteDeadline('one')).called(1);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('pending and non-owned deadlines cannot be toggled', (
    tester,
  ) async {
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          pendingDeadlineIds: {'one'},
          deadlines: [
            deadline(),
            deadline(id: 'shared', mine: false),
          ],
        ),
      ),
    );
    for (final row in tester.widgetList<AppDeadlineRow>(
      find.byType(AppDeadlineRow),
    )) {
      expect(row.onToggle, isNull);
    }
  });

  testWidgets(
    'semester hero counts completed work rather than partial progress',
    (tester) async {
      await tester.pumpWidget(
        subject(
          DeadlinesState(
            status: .ready,
            deadlines: [
              deadline(),
              deadline(id: 'done', done: true),
            ],
          ),
        ),
      );
      final hero = tester.widget<DeadlinesHero>(find.byType(DeadlinesHero));
      expect(hero.done, 1);
      expect(hero.total, 2);
      expect(find.text('50%'), findsOneWidget);
    },
  );

  testWidgets('header exposes back and an accessible add action', (
    tester,
  ) async {
    await tester.pumpWidget(subject(const DeadlinesState(status: .ready)));
    final header = tester.widget<AppInnerHeader>(find.byType(AppInnerHeader));
    expect(header.onBack, isNotNull);
    expect(header.actions.single.onTap, isNotNull);
    expect(header.actions.single.semanticsLabel, 'Добавить дедлайн');
  });

  testWidgets('empty state offers a real create action', (tester) async {
    await tester.pumpWidget(subject(const DeadlinesState(status: .ready)));
    final empty = tester.widget<AppEmptyState>(find.byType(AppEmptyState));
    expect(empty.onAction, isNotNull);
    expect(empty.actionLabel, 'Добавить');
  });

  testWidgets('fits a narrow screen at 200 percent text scale', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      subject(
        DeadlinesState(status: .ready, deadlines: [deadline()]),
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(DeadlinesHero), findsOneWidget);
  });

  testWidgets('respects reduced motion for completion feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      subject(
        DeadlinesState(status: .ready, deadlines: [deadline()]),
        reduced: true,
      ),
    );
    final rows = find.descendant(
      of: find.byType(AppDeadlineRow),
      matching: find.byType(AnimatedOpacity),
    );
    expect(rows, findsWidgets);
    for (final widget in tester.widgetList<AnimatedOpacity>(rows)) {
      expect(widget.duration, Duration.zero);
    }
  });

  testWidgets('warns when refreshing stale data fails', (tester) async {
    final ready = DeadlinesState(
      status: .ready,
      deadlines: [deadline()],
    );
    when(
      () => cubit.stream,
    ).thenAnswer((_) => Stream.value(ready.copyWith(status: .failure)));
    await tester.pumpWidget(subject(ready));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Не удалось обновить список. Текущие данные могут быть устаревшими.',
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 4));
  });
}
