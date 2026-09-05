import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/study_group/view/discover_groups_page.dart';
import 'package:rtu_mirea_app/study_group/view/ninja_discover_study_group_card.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

class MockStudyGroupsRepository extends Mock implements StudyGroupsRepository {}

void main() {
  group('DiscoverGroupsPage', () {
    late StudyGroupsRepository repository;

    setUp(() {
      repository = MockStudyGroupsRepository();
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<StudyGroupsRepository>.value(
          value: repository,
          child: const DiscoverGroupsPage(),
        ),
      );
    }

    testWidgets('swaps states through the shared switcher, starting on a '
        'skeleton', (tester) async {
      final pending = Completer<List<StudyGroupSummary>>();
      when(
        () => repository.searchGroups(any()),
      ).thenAnswer((_) => pending.future);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(NinjaStateSwitcher), findsOneWidget);
      expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
      expect(find.byType(NinjaEmptyState), findsNothing);

      pending.complete(const [
        StudyGroupSummary(id: 'g1', name: 'ИКБО-09-22', memberCount: 3),
      ]);
      await tester.pumpAndSettle();

      expect(find.byType(NinjaSkeletonGroup), findsNothing);
      expect(find.text('ИКБО-09-22'), findsOneWidget);
    });

    testWidgets('search scrolls away and returns with its query intact', (
      tester,
    ) async {
      when(() => repository.searchGroups(any())).thenAnswer(
        (_) async => List.generate(
          24,
          (index) => StudyGroupSummary(
            id: 'g$index',
            name: 'Group $index',
            memberCount: 3,
          ),
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Group');
      tester.testTextInput.hide();
      await tester.pumpAndSettle(const Duration(milliseconds: 400));
      expect(find.byType(AppSearchBar).hitTestable(), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('results')),
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppSearchBar).hitTestable(), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.drag(
        find.byKey(const ValueKey('results')),
        const Offset(0, 1200),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppSearchBar).hitTestable(), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Group',
      );
    });

    testWidgets('group cards stay on plain surfaces with a pill action', (
      tester,
    ) async {
      when(() => repository.searchGroups(any())).thenAnswer(
        (_) async => const [
          StudyGroupSummary(id: 'g1', name: 'ИКБО-09-22', memberCount: 3),
        ],
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final colors = tester.element(find.byType(DiscoverGroupsPage)).colors;
      final card = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(NinjaDiscoverStudyGroupCard),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = card.decoration as BoxDecoration;
      expect(decoration.color, colors.surface);
      expect(decoration.color, isNot(colors.tint2));
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppRadius.card),
      );

      final action = find.descendant(
        of: find.byType(NinjaDiscoverStudyGroupCard),
        matching: find.byType(NinjaButton),
      );
      expect(action, findsOneWidget);
      expect(tester.getSize(action).height, greaterThanOrEqualTo(44));
    });

    testWidgets(
      'shows an error state with retry when the search fails, instead of '
      'the "no groups found" empty state',
      (tester) async {
        when(
          () => repository.searchGroups(any()),
        ).thenThrow(SearchGroupsFailure(Exception('network')));

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(NinjaErrorState), findsOneWidget);
        expect(find.byType(NinjaEmptyState), findsNothing);
      },
    );

    testWidgets('retry re-runs the search', (tester) async {
      when(
        () => repository.searchGroups(any()),
      ).thenThrow(SearchGroupsFailure(Exception('network')));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(NinjaErrorState), findsOneWidget);

      when(() => repository.searchGroups(any())).thenAnswer((_) async => []);

      final error = tester.widget<NinjaErrorState>(
        find.byType(NinjaErrorState),
      );
      await tester.tap(find.text(error.retryLabel!));
      await tester.pumpAndSettle();

      verify(() => repository.searchGroups(any())).called(greaterThan(1));
      expect(find.byType(NinjaErrorState), findsNothing);
      expect(find.byType(NinjaEmptyState), findsOneWidget);
    });

    testWidgets('a stale request cannot replace newer search results', (
      tester,
    ) async {
      final requests = <String, Completer<List<StudyGroupSummary>>>{};
      when(() => repository.searchGroups(any())).thenAnswer((invocation) {
        final query = invocation.positionalArguments.first as String;
        return requests.putIfAbsent(query, Completer.new).future;
      });

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      requests['']!.complete(const []);
      await tester.pump();

      await tester.enterText(find.byType(EditableText), 'old');
      await tester.pump(const Duration(milliseconds: 301));
      await tester.enterText(find.byType(EditableText), 'new');
      await tester.pump(const Duration(milliseconds: 301));

      requests['new']!.complete(const [
        StudyGroupSummary(id: 'new', name: 'Новая группа'),
      ]);
      await tester.pump();
      expect(find.text('Новая группа'), findsOneWidget);

      requests['old']!.complete(const [
        StudyGroupSummary(id: 'old', name: 'Старая группа'),
      ]);
      await tester.pump();

      expect(find.text('Новая группа'), findsOneWidget);
      expect(find.text('Старая группа'), findsNothing);
    });

    testWidgets('current search error clears results from the old query', (
      tester,
    ) async {
      when(
        () => repository.searchGroups(''),
      ).thenAnswer(
        (_) async => const [
          StudyGroupSummary(id: 'old', name: 'Старая группа'),
        ],
      );
      when(
        () => repository.searchGroups('broken'),
      ).thenThrow(SearchGroupsFailure(Exception('network')));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Старая группа'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'broken');
      await tester.pump(const Duration(milliseconds: 301));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      expect(find.text('Старая группа'), findsNothing);
      expect(find.byType(NinjaErrorState), findsOneWidget);
    });
  });
}
