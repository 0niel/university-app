import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

void main() {
  Finder activeLegacyBatches() => find.byWidgetPredicate(
    (widget) => widget is LiquidGlassBatch && widget.enabled,
  );

  Widget surface(String name, {Widget child = const SizedBox(height: 48)}) =>
      SizedBox(
        width: 180,
        child: AppGlassSurface(
          key: ValueKey(name),
          role: AppGlassRole.control,
          child: child,
        ),
      );

  BackdropKey? lensBackdrop(WidgetTester tester, String name) {
    final lens = find
        .descendant(
          of: find.byKey(ValueKey(name)),
          matching: find.byType(AppGlassRenderer),
        )
        .first;
    return tester
        .widget<renderer.LiquidGlassLayer>(
          find.descendant(
            of: lens,
            matching: find.byType(renderer.LiquidGlassLayer),
          ),
        )
        .backdropKey;
  }

  testWidgets(
    'standalone lenses retain independent backdrop reads',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Row(children: [surface('first'), surface('second')]),
        ),
      );
      final first = lensBackdrop(tester, 'first');
      final second = lensBackdrop(tester, 'second');
      expect(first, isNull);
      expect(second, isNull);
      expect(find.byType(renderer.LiquidGlassLayer), findsNWidgets(2));
      expect(activeLegacyBatches(), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('full lenses reuse the enclosing shared backdrop', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: AppGlassBatch(
          child: Row(children: [surface('first'), surface('second')]),
        ),
      ),
    );
    expect(lensBackdrop(tester, 'first'), isNotNull);
    expect(lensBackdrop(tester, 'second'), lensBackdrop(tester, 'first'));
    expect(activeLegacyBatches(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'compact controls share one real layer and isolate nested glass',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: AppGlassBatch.controls(
            child: Row(
              children: [
                surface('first', child: surface('nested')),
                surface('second'),
              ],
            ),
          ),
        ),
      );
      final layers = tester.widgetList<renderer.LiquidGlassLayer>(
        find.byType(renderer.LiquidGlassLayer),
      );
      expect(layers, hasLength(2));
      expect(layers.first.backdropKey, isNotNull);
      expect(layers.last.backdropKey, isNull);
      expect(layers.every((layer) => !layer.fake), isTrue);
      expect(find.byType(AppGlassRenderer), findsNWidgets(3));
      for (final name in ['first', 'second']) {
        final lens = find
            .descendant(
              of: find.byKey(ValueKey(name)),
              matching: find.byType(AppGlassRenderer),
            )
            .first;
        expect(
          AppGlassRendererScope.sharesLayerOf(tester.element(lens)),
          isTrue,
        );
      }
      final nested = find.descendant(
        of: find.byKey(const ValueKey('nested')),
        matching: find.byType(AppGlassRenderer),
      );
      expect(
        AppGlassRendererScope.sharesLayerOf(tester.element(nested)),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('excluded foreground keeps its own backdrop inside a batch', (
    tester,
  ) async {
    int? foregroundId;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: AppGlassBatch(
          child: Column(
            children: [
              surface('peer'),
              AppGlassBatch.exclude(
                child: Builder(
                  builder: (context) {
                    foregroundId = LiquidGlassBatch.backdropIdOf(context);
                    return surface('excluded');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    expect(foregroundId, isNull);
    expect(lensBackdrop(tester, 'peer'), isNotNull);
    expect(lensBackdrop(tester, 'excluded'), isNull);
    expect(
      lensBackdrop(tester, 'excluded'),
      isNot(lensBackdrop(tester, 'peer')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested overlapping lenses do not reuse their parent batch', (
    tester,
  ) async {
    BackdropKey? contentBackdrop;
    int? legacyContentBackdrop;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: AppGlassBatch(
          child: Center(
            child: surface(
              'outer',
              child: Builder(
                builder: (context) {
                  contentBackdrop = AppGlassRendererScope.of(context);
                  legacyContentBackdrop = LiquidGlassBatch.backdropIdOf(
                    context,
                  );
                  return Stack(
                    children: [
                      surface('inner'),
                      Positioned(left: 8, top: 8, child: surface('overlap')),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(contentBackdrop, isNull);
    expect(legacyContentBackdrop, isNull);
    expect(lensBackdrop(tester, 'outer'), isNotNull);
    expect(lensBackdrop(tester, 'inner'), isNull);
    expect(lensBackdrop(tester, 'overlap'), isNull);
    expect(find.byType(renderer.LiquidGlassLayer), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'siblings share one backdrop and separate batches stay isolated',
    (
      tester,
    ) async {
      final ids = <String, int?>{};
      Widget member(String name) => Builder(
        builder: (context) {
          ids[name] = LiquidGlassBatch.backdropIdOf(context);
          return const SizedBox(width: 40, height: 40);
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Column(
            children: [
              AppGlassBatch(
                child: Row(children: [member('first'), member('second')]),
              ),
              AppGlassBatch(child: member('separate')),
              member('outside'),
            ],
          ),
        ),
      );
      expect(ids['first'], isNotNull);
      expect(ids['second'], ids['first']);
      expect(ids['separate'], isNot(ids['first']));
      expect(ids['outside'], isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'glass toggle preserves input, focus, scroll and batch identity',
    (
      tester,
    ) async {
      var enabled = true;
      int? backdropId;
      late StateSetter update;
      final controller = TextEditingController();
      final focus = FocusNode();
      final scroll = ScrollController();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      addTearDown(scroll.dispose);
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
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 280,
                    child: AppGlassBatch.controls(
                      child: Builder(
                        builder: (context) {
                          backdropId = LiquidGlassBatch.backdropIdOf(context);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: controller,
                                focusNode: focus,
                              ),
                              SizedBox(
                                height: 48,
                                child: ListView.builder(
                                  controller: scroll,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 20,
                                  itemBuilder: (_, index) => SizedBox(
                                    width: 80,
                                    child: Center(child: Text('Item $index')),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
      final field = find.byType(TextField);
      final element = tester.element(field);
      final initialBounds = tester.getRect(field);
      final initialId = backdropId;
      expect(initialId, isNotNull);
      await tester.enterText(field, 'Unfinished message');
      scroll.jumpTo(120);
      await tester.pump();
      for (final next in [false, true, false]) {
        update(() => enabled = next);
        await tester.pumpAndSettle();
        expect(backdropId, next ? initialId : isNull);
        expect(tester.element(field), same(element));
        expect(tester.getRect(field), initialBounds);
        expect(controller.text, 'Unfinished message');
        expect(focus.hasFocus, isTrue);
        expect(scroll.offset, 120);
      }
      expect(tester.takeException(), isNull);
    },
  );
}
