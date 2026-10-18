import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
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
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
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
              compact: size.height < 650,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
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
