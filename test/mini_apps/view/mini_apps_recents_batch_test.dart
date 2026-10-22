import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// The renderer belongs to app_ui; this verifies its shared capture contract.
// ignore: depend_on_referenced_packages
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_catalog.dart';

void main() {
  for (final textScale in [1.0, 2.0]) {
    testWidgets(
      'catalog peers share capture and pinned search stays isolated '
      'at scale $textScale',
      (tester) async {
        tester.view
          ..physicalSize = const Size(390, 1100)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final apps = List.generate(
          20,
          (index) => MiniApp(
            id: 'capture-$index',
            slug: 'capture-$index',
            name: 'Application $index',
          ),
        );
        var state = MiniAppsCatalogState(
          status: MiniAppsCatalogStatus.populated,
          apps: apps,
          recents: apps.take(6).toList(),
          isModerator: true,
        );
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, update) => MaterialApp(
              theme: AppTheme.darkTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(textScale),
                  disableAnimations: true,
                  padding: const EdgeInsets.only(top: 24),
                ),
                child: child!,
              ),
              home: MiniAppsCatalog(
                state: state,
                onRefresh: () async {},
                onQueryChanged: (_) {},
                onCategoryChanged: (_) {},
                onSortChanged: (_) {},
                onSearchToggled: () => update(
                  () => state = state.copyWith(isSearching: !state.isSearching),
                ),
                onOpen: (_) {},
                onActions: (_) {},
                onCreate: () {},
                onModerate: () {},
                onResetFilters: () {},
                onBack: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        Finder lensIn(Finder parent) => find
            .descendant(of: parent, matching: find.byType(LiquidGlassLens))
            .first;
        int? backdropOf(Finder lens) =>
            LiquidGlassBatch.backdropIdOf(tester.element(lens));

        final sort = find.byKey(const ValueKey('mini-apps-sort-button'));
        final create = find.byKey(const ValueKey('mini-apps-create-button'));
        final recent = find.byKey(const ValueKey('recent-capture-0'));
        final sortLens = lensIn(sort);
        final sharedId = backdropOf(sortLens);
        expect(sharedId, isNotNull);
        expect(backdropOf(lensIn(create)), sharedId);
        expect(backdropOf(lensIn(recent)), sharedId);
        expect(tester.getRect(sort).overlaps(tester.getRect(recent)), isFalse);
        final header = find.byType(AppInnerHeader);
        final headerId = backdropOf(lensIn(header));
        expect(headerId, isNotNull);
        expect(headerId, isNot(sharedId));
        for (final lens
            in find
                .descendant(
                  of: header,
                  matching: find.byType(LiquidGlassLens),
                )
                .evaluate()) {
          expect(LiquidGlassBatch.backdropIdOf(lens), headerId);
        }
        for (final lens in [sortLens, lensIn(create), lensIn(recent)]) {
          final style = tester.widget<LiquidGlassLens>(lens).style;
          expect(style.liteGlass, isFalse);
          expect(style.blur, 6);
          expect(style.refractionIndex, 1.012);
          expect(style.refractionWidth, 14);
        }

        await tester.tap(find.byType(AppHeaderCircleButton));
        await tester.pumpAndSettle();
        final search = find.byType(AppSearchField);
        final searchId = backdropOf(lensIn(search));
        expect(searchId, isNotNull);
        expect(searchId, isNot(sharedId));
        expect(searchId, isNot(headerId));
        await tester.drag(
          find.byKey(const PageStorageKey('mini-apps-catalog')),
          const Offset(0, -360),
        );
        await tester.pumpAndSettle();
        final pinnedSurface = find.ancestor(
          of: search,
          matching: find.byType(AppPinnedSurface),
        );
        expect(tester.widget<AppPinnedSurface>(pinnedSurface).elevated, isTrue);
        expect(backdropOf(lensIn(search)), searchId);
        expect(backdropOf(lensIn(recent)), sharedId);
        expect(tester.takeException(), isNull);
      },
    );
  }

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
