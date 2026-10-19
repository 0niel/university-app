import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final (size, inset) in [
    (const Size(390, 844), 43.0),
    (const Size(844, 390), 0.0),
    (const Size(844, 390), 24.0),
  ]) {
    for (final extendTopSafeArea in [false, true]) {
      testWidgets(
        'pinned header covers inset $inset at $size '
        'when extended=$extendTopSafeArea',
        (tester) async {
          tester.view
            ..physicalSize = size
            ..devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final scroll = ScrollController();
          final focus = FocusNode();
          final text = TextEditingController();
          addTearDown(scroll.dispose);
          addTearDown(focus.dispose);
          addTearDown(text.dispose);
          const fieldKey = ValueKey('header-field');
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: MediaQuery(
                  data: MediaQueryData(
                    size: size,
                    padding: EdgeInsets.only(top: inset),
                  ),
                  child: CustomScrollView(
                    controller: scroll,
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 180)),
                      AppPinnedHeader(
                        extendTopSafeArea: extendTopSafeArea,
                        child: SizedBox(
                          height: 56,
                          child: TextField(
                            key: fieldKey,
                            controller: text,
                            focusNode: focus,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 2000)),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final surface = find.byType(AppPinnedSurface);
          final field = find.byKey(fieldKey);
          final fieldElement = tester.element(field);
          expect(tester.widget<AppPinnedSurface>(surface).elevated, isFalse);
          expect(tester.getTopLeft(field).dy, 180);
          await tester.enterText(field, 'Search');
          await tester.pumpAndSettle();

          for (final offset in [300.0, 650.0]) {
            scroll.jumpTo(offset);
            await tester.pumpAndSettle();
            expect(tester.widget<AppPinnedSurface>(surface).elevated, isTrue);
            expect(tester.getTopLeft(surface).dy, 0);
            expect(
              tester.getTopLeft(field).dy,
              extendTopSafeArea ? inset : 0,
            );
            expect(tester.getSize(surface).width, size.width);
            expect(tester.element(field), same(fieldElement));
            expect(focus.hasFocus, isTrue);
            expect(text.text, 'Search');
            expect(find.byType(AppGlassSurface), findsOneWidget);
          }
          scroll.jumpTo(0);
          await tester.pumpAndSettle();
          expect(tester.widget<AppPinnedSurface>(surface).elevated, isFalse);
          expect(tester.getTopLeft(field).dy, 180);
          expect(tester.element(field), same(fieldElement));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
