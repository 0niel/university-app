import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/best_match_skeleton_card.dart';
import 'package:rtu_mirea_app/search/view/search_page.dart';
import 'package:rtu_mirea_app/search/view/search_results_skeleton.dart';
import 'package:rtu_mirea_app/search/widgets/search_best_match_card.dart';
import 'package:rtu_mirea_app/search/widgets/search_result_item.dart';
import 'package:rtu_mirea_app/search/widgets/search_scope_chip.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

Widget _wrap({
  required SearchBloc searchBloc,
  required ScheduleBloc schedule,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    theme: NinjaTheme.dark(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>.value(value: searchBloc),
          BlocProvider<ScheduleBloc>.value(value: schedule),
        ],
        child: const SearchView(query: 'история'),
      ),
    ),
  );
}

Widget _wrapComponent(
  Widget child, {
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    theme: NinjaTheme.light(),
    builder: (context, appChild) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: appChild!,
    ),
    home: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('SearchView loading skeleton', () {
    late SearchBloc searchBloc;
    late ScheduleBloc scheduleBloc;

    setUp(() {
      searchBloc = MockSearchBloc();
      scheduleBloc = MockScheduleBloc();
      when(() => searchBloc.state).thenReturn(
        const SearchState(status: SearchStatus.loading),
      );
      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
    });

    testWidgets('shows skeleton rows and no spinner on cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(searchBloc: searchBloc, schedule: scheduleBloc),
      );
      await tester.pump();

      expect(find.byType(SearchResultsSkeleton), findsOneWidget);
      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('keeps search controls and skeleton responsive at 200%', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _wrap(
          searchBloc: searchBloc,
          schedule: scheduleBloc,
          textScaler: const TextScaler.linear(2),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(SearchScopeChip).first).height,
        greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
      );
      expect(
        tester.getSize(find.byType(BestMatchSkeletonCard)).height,
        greaterThanOrEqualTo(220),
      );
    });

    testWidgets('empty results offer a pill action that clears the query', (
      tester,
    ) async {
      when(() => searchBloc.state).thenReturn(
        const SearchState(status: SearchStatus.populated),
      );

      await tester.pumpWidget(
        _wrap(searchBloc: searchBloc, schedule: scheduleBloc),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultsSkeleton), findsNothing);
      final emptyState = tester.widget<NinjaEmptyState>(
        find.byType(NinjaEmptyState),
      );
      expect(emptyState.actionLabel, isNotNull);
      expect(emptyState.onAction, isNotNull);

      await tester.tap(find.text(emptyState.actionLabel!));
      await tester.pumpAndSettle();

      expect(find.byType(NinjaEmptyState), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is NinjaStateSwitcher &&
              widget.child.key == const ValueKey('search-zero'),
        ),
        findsOneWidget,
      );
    });
  });

  group('Search composition', () {
    testWidgets('best match stays focused and responsive in light theme', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _wrapComponent(
          SearchBestMatchCard(
            name: 'Большая аудитория для практического занятия',
            query: 'аудитория',
            tagLabel: 'Лучшее совпадение',
            subtitle: 'Главный корпус, четвёртый этаж',
            onPressed: () {},
          ),
          textScaler: const TextScaler.linear(2),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.bySemanticsLabel(
          'Лучшее совпадение, Большая аудитория для практического занятия',
        ),
        findsOneWidget,
      );
      expect(find.byType(Card), findsNothing);
      final decoration =
          tester
                  .widget<DecoratedBox>(find.byType(DecoratedBox).first)
                  .decoration
              as BoxDecoration;
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('result row is dense, semantic, and has a 44dp action', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrapComponent(
          SearchResultItem(
            name: 'Иван Иванов',
            type: ItemType.person,
            subtitle: 'Студент',
            onPressed: () => tapped = true,
          ),
        ),
      );

      final semantics = find.bySemanticsLabel('Иван Иванов, Студент');
      expect(semantics, findsOneWidget);
      expect(find.byType(Card), findsNothing);
      expect(find.byType(Divider), findsNothing);
      expect(tester.getSize(semantics).height, greaterThanOrEqualTo(44));

      await tester.tap(semantics);
      expect(tapped, isTrue);
    });

    testWidgets('scope selection is a borderless brand-filled chip', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapComponent(
          SearchScopeChip(label: 'Расписание', selected: true, onTap: () {}),
        ),
      );

      final colors = NinjaColors.light();
      expect(find.byType(Chip), findsNothing);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(
        tester.getSize(find.byType(SearchScopeChip)).height,
        greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
      );

      final selected =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration!
              as BoxDecoration;
      expect(selected.color, colors.brand);
      expect(selected.border, isNull);
      expect(selected.boxShadow, isNull);
      expect(
        tester.widget<Text>(find.text('Расписание')).style?.color,
        colors.onBrand,
      );
    });

    testWidgets('unselected scope is a neutral chip without an outline', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapComponent(
          SearchScopeChip(label: 'Люди', selected: false, onTap: () {}),
        ),
      );

      final colors = NinjaColors.light();
      final chip =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration!
              as BoxDecoration;
      expect(chip.color, colors.surfaceAlt);
      expect(chip.border, isNull);
      expect(
        tester.widget<Text>(find.text('Люди')).style?.color,
        colors.ink,
      );
    });
  });
}
