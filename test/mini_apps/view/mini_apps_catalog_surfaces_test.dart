import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
// The renderer belongs to app_ui; this verifies selective backdrop usage.
// ignore: depend_on_referenced_packages
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_catalog.dart';

void main() {
  for (final textScale in [1.0, 2.0]) {
    testWidgets(
      'only the pinned strip uses glass above catalog content '
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
        var enabled = true;
        late StateSetter rebuild;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, update) {
              rebuild = update;
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
                    () =>
                        state = state.copyWith(isSearching: !state.isSearching),
                  ),
                  onOpen: (_) {},
                  onActions: (_) {},
                  onCreate: () {},
                  onModerate: () {},
                  onResetFilters: () {},
                  onBack: () {},
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(LiquidGlassLens), findsNothing);
        expect(find.byType(LiquidGlassLite), findsNothing);
        expect(find.byType(BackdropFilter), findsNothing);
        expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);

        final sort = find.byKey(const ValueKey('mini-apps-sort-button'));
        final create = find.byKey(const ValueKey('mini-apps-create-button'));
        final recent = find.byKey(const ValueKey('recent-capture-0'));
        for (final control in [sort, create, recent]) {
          expect(
            find.descendant(
              of: control,
              matching: find.byType(LiquidGlassLens),
            ),
            findsNothing,
          );
          expect(
            find.descendant(
              of: control,
              matching: find.byType(LiquidGlassLite),
            ),
            findsNothing,
          );
          expect(
            find.ancestor(of: control, matching: find.byType(AppGlassBatch)),
            findsNothing,
          );
        }
        expect(tester.getRect(sort).overlaps(tester.getRect(recent)), isFalse);
        final icon = find.descendant(
          of: recent,
          matching: find.byType(AppIconTile),
        );
        expect(tester.getSize(icon), const Size.square(52));
        expect(MediaQuery.textScalerOf(tester.element(icon)).scale(26), 26);

        await tester.tap(find.byType(AppHeaderCircleButton));
        await tester.pumpAndSettle();
        final search = find.byType(AppSearchField);
        expect(find.byType(LiquidGlassLens), findsNothing);
        expect(find.byType(BackdropFilter), findsNothing);
        expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
        final field = find.descendant(
          of: search,
          matching: find.byType(TextField),
        );
        await tester.enterText(field, 'draft');
        await tester.pump(const Duration(milliseconds: 300));
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
        expect(find.byType(LiquidGlassLens), findsNothing);
        expect(find.byType(LiquidGlassLite), findsOneWidget);
        expect(
          find.descendant(
            of: pinnedSurface,
            matching: find.byType(LiquidGlassLite),
          ),
          findsOneWidget,
        );
        expect(tester.layers.whereType<BackdropFilterLayer>(), hasLength(1));
        expect(
          find.descendant(of: search, matching: find.byType(BackdropFilter)),
          findsNothing,
        );
        final searchBounds = tester.getRect(search);
        final controller = tester.widget<TextField>(field).controller!;
        for (final next in [false, true]) {
          rebuild(() => enabled = next);
          await tester.pumpAndSettle();
          expect(tester.getRect(search), searchBounds);
          expect(tester.widget<TextField>(field).controller, same(controller));
          expect(controller.text, 'draft');
          expect(
            tester.layers.whereType<BackdropFilterLayer>(),
            next ? hasLength(1) : isEmpty,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'tonal toolbar keeps wrapped targets and actions through glass toggles',
    (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var creates = 0;
      var moderations = 0;
      final sorts = <MiniAppSort>[];
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
                onSortChanged: sorts.add,
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
          expect(
            find.descendant(
              of: controls[index],
              matching: find.byType(LiquidGlassLens),
            ),
            findsNothing,
          );
          expect(
            find.ancestor(
              of: controls[index],
              matching: find.byType(AppGlassBatch),
            ),
            findsNothing,
          );
        }
        await tester.tap(create);
        await tester.tap(moderate);
      }
      expect(creates, 2);
      expect(moderations, 2);
      await tester.tap(controls[0]);
      await tester.pumpAndSettle();
      expect(find.byType(AppPopover), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AppPopover),
          matching: find.text(l10n.miniAppsSortNew),
        ),
      );
      await tester.pumpAndSettle();
      expect(sorts, [MiniAppSort.newest]);
      expect(find.byType(AppPopover), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'ordinary recent tiles keep scroll state and taps '
    'through reveal and toggle',
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
        findsNothing,
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
        expect(
          find.descendant(of: list, matching: find.byType(LiquidGlassLens)),
          findsNothing,
        );
        expect(
          find.descendant(of: list, matching: find.byType(BackdropFilter)),
          findsNothing,
        );
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
