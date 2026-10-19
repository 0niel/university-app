import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_catalog.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card.dart';

class _CatalogDriver {
  _CatalogDriver(MiniAppsCatalogState initial, {this.refreshCompletion})
    : state = ValueNotifier(initial);

  final ValueNotifier<MiniAppsCatalogState> state;
  final queries = <String>[];
  final sorts = <MiniAppSort>[];
  final categories = <MiniAppCategory?>[];
  final Completer<void>? refreshCompletion;
  int refreshRequests = 0;
  int resetRequests = 0;

  Future<void> refresh() async {
    refreshRequests++;
    state.value = state.value.copyWith(status: MiniAppsCatalogStatus.loading);
    final completion = refreshCompletion;
    if (completion != null) await completion.future;
  }

  void queryChanged(String query) {
    queries.add(query);
    state.value = state.value.copyWith(query: query);
  }

  void categoryChanged(MiniAppCategory? category) {
    categories.add(category);
    state.value = state.value.copyWith(category: category);
  }

  void sortChanged(MiniAppSort sort) {
    sorts.add(sort);
    state.value = state.value.copyWith(sort: sort);
  }

  void searchToggled() {
    final current = state.value;
    final searching = !current.isSearching;
    state.value = current.copyWith(
      isSearching: searching,
      query: searching ? current.query : '',
    );
  }

  void resetFilters() {
    resetRequests++;
    state.value = state.value.copyWith(query: '', category: null);
  }

  Widget get catalog => ValueListenableBuilder<MiniAppsCatalogState>(
    valueListenable: state,
    builder: (context, value, _) => MiniAppsCatalog(
      state: value,
      onRefresh: refresh,
      onQueryChanged: queryChanged,
      onCategoryChanged: categoryChanged,
      onSortChanged: sortChanged,
      onSearchToggled: searchToggled,
      onResetFilters: resetFilters,
      onOpen: (_) {},
      onActions: (_) {},
      onCreate: () {},
    ),
  );
}

Future<void> _pumpCatalog(
  WidgetTester tester,
  _CatalogDriver driver, {
  double width = 320,
  double textScale = 2,
  bool reduceMotion = true,
}) async {
  tester.view
    ..physicalSize = Size(width, 900)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(driver.state.dispose);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reduceMotion,
          padding: const EdgeInsets.only(top: 24, bottom: 34),
        ),
        child: child!,
      ),
      home: driver.catalog,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const app = MiniApp(
    id: 'campus',
    slug: 'campus',
    name: 'План кампуса',
    description: 'Аудитории и сервисы',
    category: MiniAppCategory.campus,
  );
  const populated = MiniAppsCatalogState(
    status: MiniAppsCatalogStatus.populated,
    apps: [app],
  );

  Finder toggleSearch() => find.descendant(
    of: find.byType(AppInnerHeader),
    matching: find.byType(AppHeaderCircleButton),
  );
  Finder field() => find.descendant(
    of: find.byType(AppSearchField),
    matching: find.byType(TextField),
  );

  testWidgets('sort popover changes once and ignores the active option', (
    tester,
  ) async {
    final driver = _CatalogDriver(populated);
    await _pumpCatalog(tester, driver);
    final l10n = tester.element(find.byType(MiniAppsCatalog)).l10n;
    final sortButton = find.byKey(const ValueKey('mini-apps-sort-button'));
    final createButton = find.byKey(const ValueKey('mini-apps-create-button'));
    expect(
      tester.getRect(sortButton).overlaps(tester.getRect(createButton)),
      isFalse,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(sortButton);
    await tester.pumpAndSettle();
    final popover = find.byType(AppPopover);
    expect(popover, findsOneWidget);
    expect(tester.getSize(popover).width, lessThanOrEqualTo(280));
    await tester.tap(
      find.descendant(of: popover, matching: find.text(l10n.miniAppsSortNew)),
    );
    await tester.pumpAndSettle();
    expect(driver.sorts, [MiniAppSort.newest]);
    expect(driver.state.value.sort, MiniAppSort.newest);
    expect(popover, findsNothing);
    expect(
      find.descendant(
        of: sortButton,
        matching: find.text(l10n.miniAppsSortNew),
      ),
      findsOneWidget,
    );

    await tester.tap(sortButton);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: popover, matching: find.text(l10n.miniAppsSortNew)),
    );
    await tester.pumpAndSettle();
    expect(driver.sorts, [MiniAppSort.newest]);
    expect(popover, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'query debounce cancels on close and rapid reopen retains focus',
    (
      tester,
    ) async {
      final driver = _CatalogDriver(populated);
      await _pumpCatalog(
        tester,
        driver,
        width: 390,
        textScale: 1,
        reduceMotion: false,
      );
      await tester.tap(toggleSearch());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));
      await tester.pump();
      final input = tester.widget<TextField>(field());
      final inputElement = tester.element(field());
      expect(input.focusNode!.hasFocus, isTrue);

      await tester.enterText(field(), 'phys');
      await tester.pump(const Duration(milliseconds: 249));
      expect(driver.queries, isEmpty);
      await tester.enterText(field(), 'physics');
      await tester.pump(const Duration(milliseconds: 249));
      expect(driver.queries, isEmpty);
      await tester.pump(const Duration(milliseconds: 1));
      expect(driver.queries, ['physics']);

      await tester.enterText(field(), 'late query');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(toggleSearch());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(driver.queries, ['physics']);
      expect(driver.state.value.isSearching, isFalse);
      expect(field().hitTestable(), findsNothing);

      await tester.tap(toggleSearch());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      await tester.tap(toggleSearch());
      await tester.pump();
      await tester.tap(toggleSearch());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));
      await tester.pump();
      expect(driver.state.value.isSearching, isTrue);
      expect(tester.element(field()), same(inputElement));
      expect(input.controller!.text, isEmpty);
      expect(input.focusNode!.hasFocus, isTrue);
      expect(driver.queries, ['physics']);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('query echo preserves newer input before the next frame', (
    tester,
  ) async {
    final driver = _CatalogDriver(populated.copyWith(isSearching: true));
    await _pumpCatalog(tester, driver, width: 390, textScale: 1);
    final input = tester.widget<TextField>(field());
    await tester.enterText(field(), 'q1');
    (List<String>, String)? beforeInput;
    final newerInput = Timer(const Duration(milliseconds: 250), () {
      beforeInput = (List.of(driver.queries), driver.state.value.query);
      tester.testTextInput.enterText('q2');
    });
    addTearDown(newerInput.cancel);

    await tester.pump(const Duration(milliseconds: 250));
    expect(beforeInput!.$1, ['q1']);
    expect(beforeInput!.$2, 'q1');
    expect(input.controller!.text, 'q2');
    expect(input.focusNode!.hasFocus, isTrue);
    expect(driver.queries, ['q1']);
    await tester.pump(const Duration(milliseconds: 249));
    expect(driver.queries, ['q1']);
    await tester.pump(const Duration(milliseconds: 1));
    expect(driver.queries, ['q1', 'q2']);
    expect(driver.state.value.query, 'q2');
    expect(input.controller!.text, 'q2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset clears query and category through one callback', (
    tester,
  ) async {
    final driver = _CatalogDriver(
      const MiniAppsCatalogState(
        status: MiniAppsCatalogStatus.populated,
        isSearching: true,
        query: 'physics',
      ),
    );
    await _pumpCatalog(tester, driver);
    final l10n = tester.element(find.byType(MiniAppsCatalog)).l10n;
    final categories = find.byKey(const ValueKey('mini-apps-categories'));
    await tester.tap(
      find.descendant(
        of: categories,
        matching: find.text(l10n.miniAppsCategoryStudy),
      ),
    );
    await tester.pumpAndSettle();
    expect(driver.categories, [MiniAppCategory.study]);
    expect(driver.state.value.category, MiniAppCategory.study);

    await tester.enterText(field(), 'late reset query');
    final reset = find.text(l10n.resetFilter);
    await tester.ensureVisible(reset);
    await tester.pump();
    await tester.tap(reset);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    expect(driver.resetRequests, 1);
    expect(driver.state.value.query, isEmpty);
    expect(driver.state.value.category, isNull);
    expect(tester.widget<TextField>(field()).controller!.text, isEmpty);
    expect(driver.queries, isEmpty);
    expect(driver.categories, [MiniAppCategory.study]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('refresh and failure retain cards with visible inline feedback', (
    tester,
  ) async {
    final driver = _CatalogDriver(
      populated,
      refreshCompletion: Completer<void>(),
    );
    await _pumpCatalog(tester, driver);
    final l10n = tester.element(find.byType(MiniAppsCatalog)).l10n;
    final card = find.descendant(
      of: find.byKey(const ValueKey('catalog-campus')),
      matching: find.byType(MiniAppCard),
    );
    final element = tester.element(card);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(driver.refreshRequests, 1);
    expect(driver.state.value.status, MiniAppsCatalogStatus.loading);
    expect(tester.element(card), same(element));
    expect(find.byType(LinearProgressIndicator).hitTestable(), findsOneWidget);

    driver.state.value = driver.state.value.copyWith(
      status: MiniAppsCatalogStatus.failure,
    );
    driver.refreshCompletion!.complete();
    await tester.pumpAndSettle();
    expect(tester.element(card), same(element));
    expect(card.hitTestable(), findsOneWidget);
    expect(find.text(l10n.loadingError).hitTestable(), findsOneWidget);
    final retry = find.text(l10n.retry).hitTestable();
    expect(retry, findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(retry);
    await tester.pump();
    expect(driver.refreshRequests, 2);
    expect(tester.element(card), same(element));
    driver.state.value = driver.state.value.copyWith(
      status: MiniAppsCatalogStatus.populated,
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.loadingError).hitTestable(), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
