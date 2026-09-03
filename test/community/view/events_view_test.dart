import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/events/events.dart';
import 'package:rtu_mirea_app/community/view/events_view.dart';
import 'package:rtu_mirea_app/community/widgets/events/events_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/mocks/mock_events_cubit.dart';

void main() {
  group('EventsView', () {
    late EventsCubit cubit;

    setUp(() {
      cubit = MockEventsCubit();
    });

    Widget buildSubject(EventsState state, {double textScale = 1}) {
      when(() => cubit.state).thenReturn(state);
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: NinjaToastHost(
          child: BlocProvider<EventsCubit>.value(
            value: cubit,
            child: const EventsView(),
          ),
        ),
      );
    }

    CampusEvent buildEvent({
      String id = 'event-1',
      String title = 'День карьеры',
      DateTime? startsAt,
      String category = 'career',
      int goingCount = 5,
      bool isGoing = false,
      bool isMine = false,
    }) => CampusEvent(
      id: id,
      title: title,
      startsAt: startsAt ?? DateTime.now().add(const Duration(hours: 2)),
      category: category,
      goingCount: goingCount,
      isGoing: isGoing,
      isMine: isMine,
    );

    testWidgets('shows a skeleton without a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const EventsState(status: .loading)),
      );

      expect(find.byType(EventsSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows a retryable error instead of an empty board', (
      tester,
    ) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const EventsState(status: .failure)),
      );

      expect(find.text('Не удалось загрузить события'), findsOneWidget);
      expect(
        find.text('Проверь соединение и попробуй ещё раз'),
        findsOneWidget,
      );

      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('going filter hides events without an RSVP', (tester) async {
      final event = buildEvent();
      await tester.pumpWidget(
        buildSubject(EventsState(status: .ready, events: [event])),
      );

      expect(find.text('День карьеры'), findsOneWidget);
      await tester.tap(find.text('Иду'));
      await tester.pumpAndSettle();
      expect(find.text('День карьеры'), findsNothing);
    });

    testWidgets('past filter hides upcoming events and shows past ones', (
      tester,
    ) async {
      final upcoming = buildEvent(
        id: 'upcoming',
        title: 'Скоро',
        startsAt: DateTime.now().add(const Duration(days: 1)),
      );
      final past = buildEvent(
        id: 'past',
        title: 'Уже прошло',
        startsAt: DateTime.now().subtract(const Duration(days: 3)),
      );
      await tester.pumpWidget(
        buildSubject(EventsState(status: .ready, events: [upcoming, past])),
      );

      expect(find.text('Скоро'), findsOneWidget);
      expect(find.text('Уже прошло'), findsNothing);

      await tester.tap(find.text('Прошедшие'));
      await tester.pumpAndSettle();

      expect(find.text('Скоро'), findsNothing);
      expect(find.text('Уже прошло'), findsOneWidget);
    });

    testWidgets('switching to calendar view renders the month grid', (
      tester,
    ) async {
      final event = buildEvent();
      await tester.pumpWidget(
        buildSubject(EventsState(status: .ready, events: [event])),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Календарь'));
      await tester.pumpAndSettle();

      expect(find.byType(AppCalendarMonth), findsOneWidget);
      expect(find.text('Список'), findsOneWidget);
    });

    testWidgets('empty board offers a real create action', (tester) async {
      await tester.pumpWidget(
        buildSubject(const EventsState(status: .ready)),
      );
      await tester.pumpAndSettle();

      final emptyState = tester.widget<AppEmptyState>(
        find.byType(AppEmptyState),
      );
      expect(emptyState.actionLabel, 'Событие');
      expect(emptyState.onAction, isNotNull);
      expect(find.text('Пока ничего нет'), findsOneWidget);
    });

    testWidgets('event card renders without claiming a free price', (
      tester,
    ) async {
      final event = buildEvent();
      await tester.pumpWidget(
        buildSubject(EventsState(status: .ready, events: [event])),
      );
      await tester.pumpAndSettle();

      expect(find.text('День карьеры'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
      expect(find.text('Бесплатно'), findsNothing);
    });

    testWidgets('fits a 320px viewport at 200 percent text scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 1200);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final event = buildEvent(
        title: 'Большая карьерная встреча для студентов',
      );

      await tester.pumpWidget(
        buildSubject(
          EventsState(status: .ready, events: [event]),
          textScale: 2,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });
  });
}
