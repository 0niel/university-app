import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../kit_harness.dart';

void main() {
  Finder lensIn(Finder parent) =>
      find.descendant(of: parent, matching: find.byType(LiquidGlassLens)).first;

  int? backdrop(WidgetTester tester, Finder lens) =>
      LiquidGlassBatch.backdropIdOf(tester.element(lens));

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
        'header batches only peer controls at 200 percent '
        'inner=$inner rtl=$rtl',
        (tester) async {
          final taps = [0, 0];
          final actions = [
            AppHeaderAction(
              child: nestedGlass('nested'),
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
                          controlTone: AppControlSurfaceTone.glass,
                          actions: actions,
                        )
                      : AppScreenHeader(
                          title: 'Title',
                          trailing: nestedGlass('trailing'),
                          controlTone: AppControlSurfaceTone.glass,
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
              ? find.byType(LiquidGlassLens).first
              : lensIn(find.byType(AppHeaderCircleButton).last);
          final sharedId = backdrop(tester, first);
          expect(sharedId, isNotNull);
          expect(backdrop(tester, second), sharedId);
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
            final style = tester.widget<LiquidGlassLens>(lens).style;
            expect(style.liteGlass, isFalse);
            expect(style.blur, 6);
            expect(style.refractionIndex, 1.012);
            expect(style.refractionWidth, 14);
            expect(style.specular, AppGlassStyle.rim);
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
