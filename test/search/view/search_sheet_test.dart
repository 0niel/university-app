import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_sheet.dart';
import 'package:rtu_mirea_app/search/view/search_sheet_row.dart';

class _SearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

void main() {
  late SearchBloc search;
  late ScheduleBloc schedule;
  late GlobalKey<NavigatorState> navigator;

  setUp(() {
    search = _SearchBloc();
    schedule = _ScheduleBloc();
    navigator = GlobalKey<NavigatorState>();
    when(() => search.state).thenReturn(const SearchState());
    when(() => schedule.state).thenReturn(const ScheduleState());
  });

  Future<void> pump(
    WidgetTester tester, {
    bool modal = false,
    String? query,
    List<String> subjects = const [],
    double scale = 1,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Widget sheet() => SearchSheet(
      bloc: search,
      scheduleBloc: schedule,
      subjects: subjects,
      services: const [],
      initialQuery: query,
    );
    final router = GoRouter(
      navigatorKey: navigator,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: modal
                ? TextButton(
                    onPressed: () => unawaited(
                      showAppSheet<void>(
                        context,
                        heightFraction: .86,
                        scrollable: false,
                        child: sheet(),
                      ),
                    ),
                    child: const Text('Open search'),
                  )
                : sheet(),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('caret and selection changes do not restart a search', (
    tester,
  ) async {
    await pump(tester, query: 'Subject', subjects: ['Subject one']);
    final controller = tester
        .widget<EditableText>(find.byType(EditableText))
        .controller;
    clearInteractions(search);
    controller.selection = const TextSelection.collapsed(offset: 2);
    await tester.pump();
    controller.selection = const TextSelection(baseOffset: 1, extentOffset: 4);
    await tester.pump();
    verifyNever(
      () => search.add(const SearchQueryChanged(searchQuery: 'Subject')),
    );
    expect(find.text('Subject one'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'long search results stay lazy and the last result is reachable',
    (
      tester,
    ) async {
      await pump(
        tester,
        query: 'Subject',
        subjects: [for (var i = 0; i < 200; i++) 'Subject $i'],
        scale: 2,
      );
      expect(find.byType(SearchSheetRow).evaluate().length, lessThan(20));
      expect(find.text('Subject 199'), findsNothing);
      final scroll = Scrollable.of(
        tester.element(find.byType(SearchSheetRow).first),
      );
      scroll.position.jumpTo(scroll.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(find.text('Subject 199'), findsOneWidget);
      expect(find.byType(SearchSheetRow).evaluate().length, lessThan(20));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('keyboard focus waits until the sheet finishes opening', (
    tester,
  ) async {
    await pump(tester, modal: true);
    await tester.tap(find.text('Open search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));
    expect(tester.testTextInput.isVisible, isFalse);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closing during the entrance never requests a keyboard', (
    tester,
  ) async {
    await pump(tester, modal: true);
    await tester.tap(find.text('Open search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(SearchSheet), findsNothing);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(tester.takeException(), isNull);
  });
}
