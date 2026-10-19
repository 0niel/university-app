import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

void main() {
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
                    child: AppGlassBatch(
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
