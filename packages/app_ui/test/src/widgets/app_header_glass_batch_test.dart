import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;

import '../kit_harness.dart';

void main() {
  Finder lensIn(Finder parent) => find
      .descendant(of: parent, matching: find.byType(AppGlassRenderer))
      .first;

  BackdropKey? backdrop(WidgetTester tester, Finder lens) {
    final own = find.descendant(
      of: lens,
      matching: find.byType(renderer.LiquidGlassLayer),
    );
    final layer = own.evaluate().isNotEmpty
        ? own.first
        : find
              .ancestor(
                of: lens,
                matching: find.byType(renderer.LiquidGlassLayer),
              )
              .first;
    return tester.widget<renderer.LiquidGlassLayer>(layer).backdropKey;
  }

  Widget nestedGlass(String key) => SizedBox.square(
    dimension: 14,
    child: AppGlassSurface(
      key: ValueKey(key),
      role: AppGlassRole.control,
      child: const SizedBox.expand(),
    ),
  );

  for (final inner in [false, true]) {
    for (final rtl in [false, true]) {
      testWidgets(
        'header isolates custom glass controls at 200 percent '
        'inner=$inner rtl=$rtl',
        (tester) async {
          final taps = [0, 0];
          final actions = [
            AppHeaderAction(
              child: nestedGlass('nested'),
              hasOwnSurface: true,
              semanticsLabel: 'First',
              onTap: () => taps[0]++,
            ),
            if (!inner)
              AppHeaderAction(
                icon: AppLineIcon.bell,
                semanticsLabel: 'Second',
                onTap: () => taps[1]++,
              ),
          ];
          await tester.pumpWidget(
            wrapKit(
              Directionality(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                child: SizedBox(
                  width: 320,
                  child: inner
                      ? AppInnerHeader(
                          title: 'Title',
                          trailingLabel: 'Label',
                          onBack: () => taps[1]++,
                          backSemanticsLabel: 'Second',
                          actions: actions,
                        )
                      : AppScreenHeader(
                          title: 'Title',
                          trailing: nestedGlass('trailing'),
                          actions: actions,
                        ),
                ),
              ),
              textScale: 2,
            ),
          );
          await tester.pumpAndSettle();

          final first = lensIn(find.byType(AppHeaderCircleButton).first);
          final second = inner
              ? find.byType(AppGlassRenderer).first
              : lensIn(find.byType(AppHeaderCircleButton).last);
          final sharedId = backdrop(tester, second);
          expect(sharedId, isNotNull);
          expect(backdrop(tester, first), isNull);
          expect(
            find.descendant(
              of: find.byType(AppHeaderCircleButton).first,
              matching: find.byType(AppGlassRenderer),
            ),
            findsOneWidget,
          );
          expect(
            backdrop(tester, lensIn(find.byKey(const ValueKey('nested')))),
            isNot(sharedId),
          );
          expect(
            LiquidGlassBatch.backdropIdOf(tester.element(find.text('Title'))),
            isNull,
          );
          if (inner) {
            expect(
              LiquidGlassBatch.backdropIdOf(tester.element(find.text('Label'))),
              isNull,
            );
          } else {
            expect(
              backdrop(tester, lensIn(find.byKey(const ValueKey('trailing')))),
              isNot(sharedId),
            );
          }
          for (final lens in [first, second]) {
            final style = tester.widget<AppGlassRenderer>(lens).style;
            expect(style.liteGlass, isFalse);
            expect(style.blur, 6);
            expect(style.refractionIndex, 1.019);
            expect(style.refractionWidth, 12);
            expect(style.specular, AppGlassStyle.floatingRim);
            expect(style.glow, AppGlassStyle.glow);
          }
          final firstTarget = tester.getRect(
            find.byType(AppHeaderCircleButton).first,
          );
          final secondTarget = tester.getRect(
            inner
                ? find.bySemanticsLabel('Second')
                : find.byType(AppHeaderCircleButton).last,
          );
          expect(firstTarget.overlaps(secondTarget), isFalse);
          await tester.tapAt(firstTarget.center);
          await tester.tapAt(secondTarget.center);
          expect(taps, [1, 1]);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
