import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// Verify app_ui capture identities without adding a runtime dependency.
// ignore: depend_on_referenced_packages
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_search_transition.dart';
import 'package:rtu_mirea_app/map/widgets/map_top_bar.dart';

const _campus = CampusModel(
  id: 'campus',
  displayName: 'Кампус на проспекте Вернадского, 78',
  floors: [],
);

Future<void> _pumpBar(
  WidgetTester tester, {
  required TextEditingController controller,
  ValueChanged<String>? onQueryChanged,
  VoidCallback? onFriends,
  VoidCallback? onSearchClosed,
  ValueChanged<CampusModel>? onCampusSelected,
  Locale locale = const Locale('ru'),
  bool hasSelection = true,
  Size size = const Size(320, 420),
  double textScale = 1,
  bool reducedMotion = true,
  bool glassEnabled = true,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.generateTheme(
        AppColors.light,
        Brightness.light,
        glassEnabled: glassEnabled,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reducedMotion,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: MapTopBar(
              controller: controller,
              campuses: const [_campus],
              selectedCampus: hasSelection ? _campus : null,
              onQueryChanged: onQueryChanged ?? (_) {},
              onCampusSelected: onCampusSelected ?? (_) {},
              onFriends: onFriends ?? () {},
              onSearchClosed: onSearchClosed,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final textScale in [1.0, 2.0]) {
    testWidgets(
      'collapsed controls share capture while animated search stays isolated '
      'at scale $textScale',
      (tester) async {
        addTearDown(tester.view.reset);
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        final queries = <String>[];
        var friends = 0;
        CampusModel? selected;
        await _pumpBar(
          tester,
          controller: controller,
          onQueryChanged: queries.add,
          onFriends: () => friends++,
          onCampusSelected: (campus) => selected = campus,
          hasSelection: false,
          reducedMotion: false,
          textScale: textScale,
        );
        final bar = find.byType(MapTopBar);
        final l10n = tester.element(bar).l10n;
        final lenses = find.descendant(
          of: bar,
          matching: find.byType(LiquidGlassLens),
        );
        expect(lenses, findsNWidgets(3));
        final collapsedId = LiquidGlassBatch.backdropIdOf(
          lenses.evaluate().first,
        );
        expect(collapsedId, isNotNull);
        final bounds = [
          for (final element in lenses.evaluate())
            tester.getRect(find.byWidget(element.widget)),
        ];
        for (final element in lenses.evaluate()) {
          expect(LiquidGlassBatch.backdropIdOf(element), collapsedId);
        }
        for (var first = 0; first < bounds.length; first++) {
          for (var second = first + 1; second < bounds.length; second++) {
            expect(bounds[first].overlaps(bounds[second]), isFalse);
          }
        }
        await tester.tap(find.byTooltip(l10n.mapFriendsToggle));
        expect(friends, 1);
        await tester.tap(find.text(l10n.mapCampusFilter));
        await tester.pumpAndSettle();
        expect(find.byType(AppSheet), findsOneWidget);
        expect(
          find.ancestor(
            of: find.byType(AppSheet),
            matching: find.byType(AppGlassBatch),
          ),
          findsNothing,
        );
        await tester.tap(find.text(_campus.displayName));
        await tester.pumpAndSettle();
        expect(selected, _campus);
        expect(find.byType(AppSheet), findsNothing);

        await tester.tap(find.byTooltip(l10n.mapSearchPlaceholder));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 8));
        final transition = tester.widget<MapSearchTransition>(
          find.byType(MapSearchTransition),
        );
        expect(transition.animation.value, greaterThan(0));
        expect(transition.animation.isCompleted, isFalse);
        final search = find.byType(AppSearchField);
        final searchLens = find.descendant(
          of: search,
          matching: find.byType(LiquidGlassLens),
        );
        final searchId = LiquidGlassBatch.backdropIdOf(
          tester.element(searchLens),
        );
        expect(searchId, isNotNull);
        expect(searchId, isNot(collapsedId));
        final campus = find.byType(AppButton);
        expect(tester.getRect(search).overlaps(tester.getRect(campus)), isTrue);
        final remainingControls = lenses.evaluate().where(
          (element) => LiquidGlassBatch.backdropIdOf(element) == collapsedId,
        );
        expect(remainingControls, hasLength(2));
        expect(
          find.byTooltip(l10n.mapFriendsToggle).hitTestable(),
          findsNothing,
        );
        final field = find.byType(TextField);
        final fieldElement = tester.element(field);
        expect(tester.widget<TextField>(field).focusNode!.hasFocus, isFalse);
        await tester.pumpAndSettle();
        expect(tester.element(field), same(fieldElement));
        expect(tester.widget<TextField>(field).focusNode!.hasFocus, isTrue);
        expect(tester.testTextInput.isVisible, isTrue);
        expect(
          LiquidGlassBatch.backdropIdOf(tester.element(searchLens)),
          searchId,
        );
        await tester.enterText(field, 'А-101');
        expect(queries, ['А-101']);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(controller.text, isEmpty);
        expect(queries, ['А-101', '']);
        expect(field, findsNothing);
        expect(tester.testTextInput.isVisible, isFalse);
        expect(lenses, findsNWidgets(3));
        for (final element in lenses.evaluate()) {
          expect(LiquidGlassBatch.backdropIdOf(element), collapsedId);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final glassEnabled in [true, false]) {
    testWidgets(
      'floating search keeps optics and editing with glass $glassEnabled',
      (tester) async {
        addTearDown(tester.view.reset);
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await _pumpBar(
          tester,
          controller: controller,
          glassEnabled: glassEnabled,
          reducedMotion: false,
        );
        final lenses = find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == 'LiquidGlassLens',
        );
        expect(lenses, glassEnabled ? findsWidgets : findsNothing);
        await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
        await tester.pump();
        final fieldElement = tester.element(find.byType(TextField));
        for (var frame = 0; frame < 8; frame++) {
          await tester.pump(const Duration(milliseconds: 40));
          expect(tester.element(find.byType(TextField)), same(fieldElement));
          for (final surface in find.byType(AppGlassSurface).evaluate()) {
            var isolated = false;
            surface.visitAncestorElements((ancestor) {
              if (ancestor.widget is MapTopBar) return false;
              final ancestorWidget = ancestor.widget;
              if ((ancestorWidget is Opacity && ancestorWidget.opacity < 1) ||
                  (ancestorWidget is FadeTransition &&
                      ancestorWidget.opacity.value < 1) ||
                  ancestorWidget is ShaderMask ||
                  ancestorWidget is ColorFiltered) {
                isolated = true;
              }
              return true;
            });
            expect(isolated, isFalse);
          }
          expect(tester.takeException(), isNull);
        }
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'А-101');
        await tester.pumpAndSettle();
        expect(controller.text, 'А-101');
        expect(tester.element(find.byType(TextField)), same(fieldElement));
        expect(
          tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
          isTrue,
        );
        expect(lenses, glassEnabled ? findsOneWidget : findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNothing);
        expect(controller.text, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'expanded search shows one back glyph without a second search icon',
    (tester) async {
      addTearDown(tester.view.reset);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await _pumpBar(tester, controller: controller);
      int visibleGlyphs(AppLineIcon icon) => find
          .byWidgetPredicate(
            (widget) => widget is AppLineIconWidget && widget.icon == icon,
          )
          .evaluate()
          .where((element) {
            var visible = true;
            element.visitAncestorElements((ancestor) {
              final widget = ancestor.widget;
              if ((widget is Opacity && widget.opacity == 0) ||
                  (widget is FadeTransition && widget.opacity.value == 0) ||
                  (widget is Offstage && widget.offstage)) {
                visible = false;
              }
              return true;
            });
            return visible;
          })
          .length;
      expect(visibleGlyphs(AppLineIcon.search), 1);
      await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
      await tester.pumpAndSettle();
      expect(visibleGlyphs(AppLineIcon.search), 0);
      expect(visibleGlyphs(AppLineIcon.chevronL), 1);
      expect(
        find.descendant(
          of: find.byType(AppSearchField),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is AppLineIconWidget &&
                widget.icon == AppLineIcon.search,
          ),
        ),
        findsNothing,
      );
      await tester.enterText(find.byType(TextField), 'А-101');
      await tester.pumpAndSettle();
      expect(controller.text, 'А-101');
      expect(visibleGlyphs(AppLineIcon.search), 0);
      expect(visibleGlyphs(AppLineIcon.chevronL), 1);
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in const [Locale('ru'), Locale('en')]) {
    testWidgets(
      'campus picker follows ${locale.languageCode} and selects campus',
      (
        tester,
      ) async {
        addTearDown(tester.view.reset);
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        CampusModel? chosen;
        await _pumpBar(
          tester,
          controller: controller,
          locale: locale,
          hasSelection: false,
          onCampusSelected: (campus) => chosen = campus,
        );
        final russian = locale.languageCode == 'ru';
        await tester.tap(find.text(russian ? 'Корпус' : 'Campus'));
        await tester.pumpAndSettle();
        expect(find.text(russian ? 'Кампусы' : 'Campuses'), findsOneWidget);
        await tester.tap(find.text(_campus.displayName));
        await tester.pumpAndSettle();
        expect(chosen, _campus);
        expect(find.text(russian ? 'Кампусы' : 'Campuses'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('search begins as an icon and opens a focused field', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var friendsOpened = false;
    await _pumpBar(
      tester,
      controller: controller,
      onFriends: () => friendsOpened = true,
    );
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.byTooltip('Друзья на карте'));
    expect(friendsOpened, isTrue);
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('clear notifies once and back closes search and keyboard', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final queries = <String>[];
    var closed = 0;
    await _pumpBar(
      tester,
      controller: controller,
      onQueryChanged: queries.add,
      onSearchClosed: () => closed++,
    );
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'А-101');
    await tester.pumpAndSettle();
    final localizations = MaterialLocalizations.of(
      tester.element(find.byType(TextField)),
    );
    await tester.tap(find.bySemanticsLabel(localizations.deleteButtonTooltip));
    await tester.pumpAndSettle();
    expect(queries, ['А-101', '']);
    expect(closed, 0);
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Б-202');
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(queries, ['А-101', '', 'Б-202', '']);
    expect(controller.text, isEmpty);
    expect(find.byType(TextField), findsNothing);
    expect(closed, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('escape collapses a search opened by an external query', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController(text: 'А-101');
    addTearDown(controller.dispose);
    final queries = <String>[];
    await _pumpBar(tester, controller: controller, onQueryChanged: queries.add);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(controller.text, isEmpty);
    expect(queries, ['']);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('opening keeps field layout fixed and focuses after expansion', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await _pumpBar(tester, controller: controller, reducedMotion: false);
    final originalBar = tester.getRect(find.byType(MapTopBar));
    final originalButton = tester.getCenter(
      find.byTooltip('Аудитория, кафедра, столовая'),
    );
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pump();
    final field = tester.widget<TextField>(find.byType(TextField));
    final fieldRect = tester.getRect(find.byType(TextField));
    final backTooltip = MaterialLocalizations.of(
      tester.element(find.byType(MapTopBar)),
    ).backButtonTooltip;
    for (var frame = 0; frame < 6; frame++) {
      await tester.pump(const Duration(milliseconds: 40));
      expect(tester.getRect(find.byType(MapTopBar)), originalBar);
      expect(tester.getRect(find.byType(TextField)), fieldRect);
      expect(tester.getCenter(find.byTooltip(backTooltip)), originalButton);
      expect(field.focusNode!.hasFocus, isFalse);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpAndSettle();
    expect(field.focusNode!.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
  });

  testWidgets('closing during expansion cancels pending keyboard focus', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var closed = 0;
    await _pumpBar(
      tester,
      controller: controller,
      reducedMotion: false,
      onSearchClosed: () => closed++,
    );
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final field = tester.widget<TextField>(find.byType(TextField));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(field.focusNode!.hasFocus, isFalse);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.byType(TextField), findsNothing);
    expect(closed, 1);
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(field.focusNode!.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('enabling reduced motion during opening still focuses search', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await _pumpBar(tester, controller: controller, reducedMotion: false);
    await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isFalse);
    await _pumpBar(tester, controller: controller);
    expect(field.focusNode!.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(320, 420), const Size(640, 320)]) {
    testWidgets('search animation fits $size at 200% text', (tester) async {
      addTearDown(tester.view.reset);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await _pumpBar(
        tester,
        controller: controller,
        size: size,
        textScale: 2,
        reducedMotion: false,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Аудитория, кафедра, столовая'));
      await tester.pump();
      for (var frame = 0; frame < 8; frame++) {
        await tester.pump(const Duration(milliseconds: 40));
        expect(tester.takeException(), isNull);
      }
      final field = tester.getRect(find.byType(TextField));
      expect(field.left, greaterThanOrEqualTo(0));
      expect(field.right, lessThanOrEqualTo(size.width));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
