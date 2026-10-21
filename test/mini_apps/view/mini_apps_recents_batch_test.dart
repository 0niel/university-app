import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_catalog.dart';

void main() {
  testWidgets(
    'toolbar batches wrapped controls without changing their actions',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var creates = 0;
      var moderations = 0;
      var enabled = true;
      late StateSetter update;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MaterialApp(
              theme: AppTheme.generateTheme(
                AppColors.dark,
                Brightness.dark,
                glassEnabled: enabled,
              ),
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2),
                  disableAnimations: true,
                ),
                child: child!,
              ),
              home: MiniAppsCatalog(
                state: const MiniAppsCatalogState(
                  status: MiniAppsCatalogStatus.populated,
                  isModerator: true,
                ),
                onRefresh: () async {},
                onQueryChanged: (_) {},
                onCategoryChanged: (_) {},
                onSortChanged: (_) {},
                onSearchToggled: () {},
                onOpen: (_) {},
                onActions: (_) {},
                onCreate: () => creates++,
                onModerate: () => moderations++,
                onResetFilters: () {},
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(MiniAppsCatalog)).l10n;
      final controls = [
        find.byKey(const ValueKey('mini-apps-sort-button')),
        find.byKey(const ValueKey('mini-apps-create-button')),
        find.byTooltip(l10n.miniAppsModeration),
      ];
      final batches = [
        for (final control in controls)
          tester.element(
            find.ancestor(of: control, matching: find.byType(AppGlassBatch)),
          ),
      ];
      expect(batches[1], same(batches[0]));
      expect(batches[2], same(batches[0]));
      final bounds = controls.map(tester.getRect).toList();
      for (var i = 0; i < bounds.length; i++) {
        for (var j = i + 1; j < bounds.length; j++) {
          expect(bounds[i].overlaps(bounds[j]), isFalse);
        }
      }
      expect(bounds[1].top, greaterThan(bounds[0].top));
      final create = controls[1];
      final moderate = controls[2];
      for (final next in [false, true]) {
        update(() => enabled = next);
        await tester.pumpAndSettle();
        for (var index = 0; index < controls.length; index++) {
          expect(tester.getRect(controls[index]), bounds[index]);
        }
        await tester.tap(create);
        await tester.tap(moderate);
      }
      expect(creates, 2);
      expect(moderations, 2);
      await tester.tap(controls[0]);
      await tester.pumpAndSettle();
      expect(find.byType(AppPopover), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'recent glass stays scrollable and tappable through reveal and toggle',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final recents = List.generate(
        8,
        (index) => MiniApp(
          id: 'recent-$index',
          slug: 'recent-$index',
          name: 'Recent application $index',
        ),
      );
      final state = MiniAppsCatalogState(
        status: MiniAppsCatalogStatus.populated,
        apps: [recents.first],
        recents: recents,
      );
      final opened = <String>[];
      var enabled = true;
      late StateSetter update;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MaterialApp(
              theme: AppTheme.generateTheme(
                AppColors.dark,
                Brightness.dark,
                glassEnabled: enabled,
              ),
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: MiniAppsCatalog(
                state: state,
                onRefresh: () async {},
                onQueryChanged: (_) {},
                onCategoryChanged: (_) {},
                onSortChanged: (_) {},
                onSearchToggled: () {},
                onOpen: (app) => opened.add(app.id),
                onActions: (_) {},
                onCreate: () {},
                onResetFilters: () {},
              ),
            );
          },
        ),
      );
      await tester.pump(const Duration(milliseconds: 90));
      final list = find.byKey(const ValueKey('mini-apps-recents'));
      expect(
        find.ancestor(of: list, matching: find.byType(AppGlassBatch)),
        findsOneWidget,
      );
      await tester.drag(list, const Offset(-170, 0));
      await tester.pumpAndSettle();
      final scrollable = find.descendant(
        of: list,
        matching: find.byType(Scrollable),
      );
      final scrollableState = tester.state<ScrollableState>(scrollable);
      final position = scrollableState.position;
      expect(position.pixels, greaterThan(0));
      final offset = position.pixels;
      final bounds = tester.getRect(list);
      for (final next in [false, true]) {
        update(() => enabled = next);
        await tester.pumpAndSettle();
        expect(tester.getRect(list), bounds);
        expect(
          tester.state<ScrollableState>(scrollable),
          same(scrollableState),
        );
        expect(scrollableState.position.pixels, offset);
        final recent = find.byKey(const ValueKey('recent-recent-2'));
        expect(recent.hitTestable(), findsOneWidget);
        await tester.tap(recent);
        await tester.pumpAndSettle();
      }
      expect(opened, ['recent-2', 'recent-2']);
      expect(tester.takeException(), isNull);
    },
  );
}
