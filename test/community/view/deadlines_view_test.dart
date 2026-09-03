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
    cubit = MockDeadlinesCubit();
    when(() => cubit.toggleDone(any())).thenAnswer((_) async => true);
  });

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
    dueAt: due ?? DateTime.now().add(const Duration(days: 3)),
    source: .me,
    isMine: mine,
    isDone: done,
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

  testWidgets('groups real deadlines and forwards completion', (tester) async {
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [
            deadline(id: 'today', due: DateTime.now()),
            deadline(),
            deadline(
              id: 'later',
              due: DateTime.now().add(const Duration(days: 20)),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Работа today'), findsOneWidget);
    expect(find.text('НА ЭТОЙ НЕДЕЛЕ'), findsOneWidget);
    final row = tester.widget<AppDeadlineRow>(
      find.byKey(const ValueKey('deadline-one')),
    );
    row.onToggle!();
    verify(() => cubit.toggleDone('one')).called(1);
  });

  testWidgets('completed deadline has an explicit restore control', (
    tester,
  ) async {
    await tester.pumpWidget(
      subject(
        DeadlinesState(status: .ready, deadlines: [deadline(done: true)]),
      ),
    );
    final row = tester.widget<AppDeadlineRow>(find.byType(AppDeadlineRow));
    expect(row.done, isTrue);
    expect(find.byType(Dismissible), findsNothing);
    row.onToggle!();
    verify(() => cubit.toggleDone('one')).called(1);
  });

  testWidgets('uses one supplied time for grouping, labels and urgency', (
    tester,
  ) async {
    final now = DateTime(2034, 12, 31, 23, 40);
    await tester.pumpWidget(
      subject(
        DeadlinesState(
          status: .ready,
          deadlines: [deadline(due: now.add(const Duration(minutes: 90)))],
        ),
        now: now,
      ),
    );
    final row = tester.widget<AppDeadlineRow>(find.byType(AppDeadlineRow));
    expect(find.text('НА ЭТОЙ НЕДЕЛЕ'), findsOneWidget);
    expect(find.text('ПОЗЖЕ'), findsNothing);
    expect(row.meta, 'Математика · завтра 01:10');
    expect(row.left, '1 ч');
    expect(row.urgent, isTrue);
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
      expect(find.byType(SliverPersistentHeader), findsNothing);
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
    tester.view.physicalSize = const Size(320, 700);
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
    final ready = DeadlinesState(status: .ready, deadlines: [deadline()]);
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
