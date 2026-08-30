import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/community/view/events_view.dart';
import 'package:rtu_mirea_app/community/widgets/events_skeleton.dart';
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

    testWidgets('renders events and forwards category selection', (
      tester,
    ) async {
      final event = CampusEvent(
        id: 'event-1',
        title: 'День карьеры',
        startsAt: DateTime(2026, 9, 1, 12),
        category: 'career',
        goingCount: 5,
      );
      await tester.pumpWidget(
        buildSubject(
          EventsState(status: .ready, events: [event]),
        ),
      );

      expect(find.text('День карьеры'), findsOneWidget);
      await tester.tap(find.text('Карьера'));
      verify(() => cubit.categoryChanged(.career)).called(1);
    });

    testWidgets('empty board offers a real create action', (tester) async {
      await tester.pumpWidget(
        buildSubject(const EventsState(status: .ready)),
      );
      await tester.pumpAndSettle();

      final emptyState = tester.widget<NinjaEmptyState>(
        find.byType(NinjaEmptyState),
      );
      expect(emptyState.actionLabel, 'Событие');
      expect(emptyState.onAction, isNotNull);
      expect(find.text('Пока ничего нет'), findsOneWidget);
    });

    testWidgets('featured event is the single pastel card of the board', (
      tester,
    ) async {
      final event = CampusEvent(
        id: 'event-1',
        title: 'День карьеры',
        startsAt: DateTime(2026, 9, 1, 12),
        category: 'career',
        goingCount: 5,
      );
      await tester.pumpWidget(
        buildSubject(EventsState(status: .ready, events: [event])),
      );
      await tester.pumpAndSettle();

      final colors = AppTheme.darkTheme.extension<NinjaColors>()!;
      final pastel = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.color == colors.accentSoft)
          .toList();
      expect(pastel, hasLength(1));
      expect(
        pastel.single.borderRadius,
        BorderRadius.circular(NinjaRadius.card),
      );
    });

    testWidgets('fits a 320px viewport at 200 percent text scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 1200);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final event = CampusEvent(
        id: 'event-1',
        title: 'Большая карьерная встреча для студентов',
        startsAt: DateTime(2026, 9, 1, 12),
        category: 'career',
        goingCount: 5,
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
