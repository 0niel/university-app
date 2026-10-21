import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
  Widget host({
    required Future<void> Function(BuildContext) onTap,
    bool disableAnimations = false,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: disableAnimations,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> open(
    WidgetTester tester, {
    String? title,
    String? subtitle,
    bool showClose = true,
    bool showGrabber = true,
    String? primaryAction,
    VoidCallback? onPrimaryAction,
    Color? backgroundColor,
    Widget child = const Text('sheet body'),
  }) async {
    await tester.pumpWidget(
      host(
        onTap: (context) => showAppSheet<void>(
          context,
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          showGrabber: showGrabber,
          primaryAction: primaryAction,
          onPrimaryAction: onPrimaryAction,
          backgroundColor: backgroundColor,
          child: child,
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Finder surfaceMaterial() => find
      .descendant(of: find.byType(AppSheet), matching: find.byType(Material))
      .first;

  void usePhoneViewport(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.viewPadding = const FakeViewPadding(top: 47, bottom: 34);
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    addTearDown(tester.view.reset);
  }

  group('showAppSheet', () {
    testWidgets('shows grabber, title, subtitle, close and content', (
      tester,
    ) async {
      await open(tester, title: 'Экспорт', subtitle: 'Куда угодно');

      expect(find.text('Экспорт'), findsOneWidget);
      expect(find.text('Куда угодно'), findsOneWidget);
      expect(find.text('sheet body'), findsOneWidget);
      expect(find.byType(AppSheetCloseButton), findsOneWidget);
      expect(
        tester.getSize(find.byType(AppSheetCloseButton)),
        const Size(44, 44),
      );
    });

    testWidgets('uses the design top radius of 32', (tester) async {
      await open(tester, title: 'Радиус');

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppSheet),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(
        material.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(32)),
      );
    });

    testWidgets('one continuous glass surface covers header, body and footer', (
      tester,
    ) async {
      usePhoneViewport(tester);
      var actions = 0;
      await open(
        tester,
        title: 'Напомнить',
        subtitle: 'Предмет и время занятия',
        primaryAction: 'Готово',
        onPrimaryAction: () => actions++,
        child: const SizedBox(height: 180, child: Text('options')),
      );

      expect(find.byType(AppGlassSurface), findsOneWidget);
      final surface = tester.getRect(surfaceMaterial());
      final glass = tester.getRect(find.byType(AppGlassSurface));
      expect(glass.top, surface.top);
      expect(glass.width, surface.width);
      expect(glass.bottom, surface.bottom + AppRadius.sheet);
      expect(surface.width, 390);
      expect(surface.bottom, 844);
      for (final content in [
        find.byType(AppSheetGrabber),
        find.byType(AppSheetTitle),
        find.text('options'),
        find.byType(AppSheetAction),
      ]) {
        final bounds = tester.getRect(content);
        expect(bounds.top, greaterThanOrEqualTo(surface.top));
        expect(bounds.bottom, lessThanOrEqualTo(surface.bottom));
      }
      expect(
        find.ancestor(
          of: find.byType(AppSheetTitle),
          matching: find.byType(AppGlassSurface),
        ),
        findsNothing,
      );
      expect(
        surface.bottom - tester.getRect(find.byType(AppSheetAction)).bottom,
        AppSpacing.sheetBottom + 34,
      );
      await tester.tap(find.byType(AppSheetAction));
      expect(actions, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrolling long content keeps the header and action together', (
      tester,
    ) async {
      usePhoneViewport(tester);
      await open(
        tester,
        title: 'Параметры',
        primaryAction: 'Сохранить',
        onPrimaryAction: () {},
        child: Column(
          children: [
            for (var index = 0; index < 30; index++)
              SizedBox(height: 48, child: Text('row $index')),
          ],
        ),
      );
      final header = tester.getRect(find.byType(AppSheetTitle));
      final action = tester.getRect(find.byType(AppSheetAction));
      final surface = tester.getRect(surfaceMaterial());
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1600),
      );
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byType(AppSheetTitle)), header);
      expect(tester.getRect(find.byType(AppSheetAction)), action);
      expect(tester.getRect(surfaceMaterial()), surface);
      expect(find.text('row 29').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keyboard keeps form state and the footer above its inset', (
      tester,
    ) async {
      usePhoneViewport(tester);
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      var actions = 0;
      await tester.pumpWidget(
        host(
          disableAnimations: true,
          onTap: (context) => showAppSheet<void>(
            context,
            title: 'Редактор заметки',
            subtitle: 'Введите текст',
            primaryAction: 'Сохранить',
            onPrimaryAction: () => actions++,
            child: Column(
              children: [
                TextField(controller: controller, focusNode: focus),
                const SizedBox(height: 800),
                const Text('end'),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'draft');
      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      tester.view.padding = const FakeViewPadding(top: 47);
      await tester.pumpAndSettle();

      expect(controller.text, 'draft');
      expect(focus.hasFocus, isTrue);
      expect(tester.getRect(surfaceMaterial()).top, greaterThanOrEqualTo(47));
      expect(
        tester.getRect(find.byType(AppSheetAction)).bottom,
        lessThanOrEqualTo(844 - 320 - AppSpacing.sheetBottom),
      );
      await tester.tap(find.byType(AppSheetAction));
      expect(actions, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps an explicit background color on the shared surface', (
      tester,
    ) async {
      const background = Color(0xFF263142);
      await open(tester, title: 'Цвет', backgroundColor: background);

      expect(tester.widget<Material>(surfaceMaterial()).color, background);
      expect(find.byType(AppGlassSurface), findsOneWidget);
    });

    testWidgets('opaque sheet retains its rim without filtering its own fill', (
      tester,
    ) async {
      usePhoneViewport(tester);
      await open(tester, title: 'Search');

      expect(find.byType(LiquidGlassLens), findsNothing);
      expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
      final glass = tester.widget<LiquidGlassLite>(
        find.byType(LiquidGlassLite),
      );
      expect(glass.specular, AppGlassStyle.rim);
      expect(glass.glow, AppGlassStyle.glow);
      expect(tester.takeException(), isNull);
    });

    testWidgets('translucent sheet keeps its live backdrop', (tester) async {
      usePhoneViewport(tester);
      await open(
        tester,
        title: 'Search',
        backgroundColor: const Color(0x40263142),
      );

      expect(find.byType(LiquidGlassLens), findsOneWidget);
      expect(tester.layers.whereType<BackdropFilterLayer>(), isNotEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keyboard inset progress keeps the footer visible each frame', (
      tester,
    ) async {
      usePhoneViewport(tester);
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        host(
          onTap: (context) => showAppSheet<void>(
            context,
            title: 'Search',
            primaryAction: 'Done',
            onPrimaryAction: () {},
            child: Column(
              children: [
                TextField(controller: controller, focusNode: focus),
                const SizedBox(height: 800),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'draft');
      final field = tester.element(find.byType(TextField));

      for (final inset in [
        80.0,
        160.0,
        240.0,
        320.0,
        240.0,
        160.0,
        80.0,
        0.0,
      ]) {
        tester.view.viewInsets = FakeViewPadding(bottom: inset);
        tester.view.padding = const FakeViewPadding(top: 47);
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump();

        expect(
          tester.getRect(find.byType(AppSheetAction)).bottom,
          lessThanOrEqualTo(844 - inset - AppSpacing.sheetBottom + .01),
          reason: 'The footer must follow the current keyboard inset $inset',
        );
        expect(tester.element(find.byType(TextField)), same(field));
        expect(controller.text, 'draft');
        expect(focus.hasFocus, isTrue);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('the grabber is a line-colored pill', (tester) async {
      await open(tester, title: 'Граббер');

      final colors = AppTheme.darkTheme.extension<AppColors>()!;
      final grabber = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AppSheet),
              matching: find.byType(Container),
            ),
          )
          .firstWhere(
            (container) => container.constraints?.maxWidth == 40,
          );
      final decoration = grabber.decoration! as BoxDecoration;
      expect(decoration.color, colors.muted2);
      expect(decoration.borderRadius, BorderRadius.circular(2));
    });

    testWidgets('close button pops the sheet', (tester) async {
      await open(tester, title: 'Закрыть');
      expect(find.text('sheet body'), findsOneWidget);

      await tester.tap(find.byType(AppSheetCloseButton));
      await tester.pumpAndSettle();

      expect(find.text('sheet body'), findsNothing);
    });

    testWidgets('renders a bare sheet without header when title is null', (
      tester,
    ) async {
      await open(tester, showGrabber: false);

      expect(find.text('sheet body'), findsOneWidget);
      expect(find.byType(AppSheetTitle), findsNothing);
      expect(find.byType(AppSheetCloseButton), findsNothing);
    });

    testWidgets('returns the value passed to Navigator.pop', (tester) async {
      Object? result;
      await tester.pumpWidget(
        host(
          onTap: (context) async {
            result = await showAppSheet<String>(
              context,
              title: 'Выбор',
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).pop('picked'),
                  child: const Text('pick'),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();

      expect(result, 'picked');
    });
  });
}
