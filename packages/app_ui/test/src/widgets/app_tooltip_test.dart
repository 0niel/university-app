import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppTooltip', () {
    for (final width in [360.0, 430.0]) {
      testWidgets(
        'keeps tooltip direction in canvas units at $width',
        (tester) async {
          tester.view
            ..physicalSize = Size(width, 900) * 3
            ..devicePixelRatio = 3;
          addTearDown(tester.view.reset);
          const message = 'Подсказка';
          final painter = TextPainter(
            text: TextSpan(text: message, style: AppText.subtextStrong),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: 300);
          final threshold = painter.height + AppSpacing.sm * 3 + 7;
          painter.dispose();
          final below = width > AppScale.designWidth;
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              builder: (_, child) => AppScale(child: child!),
              home: Scaffold(
                body: Stack(
                  children: [
                    Positioned(
                      top: threshold + (below ? -1 : 1),
                      left: 100,
                      child: const AppTooltipAnchor(
                        message: message,
                        child: SizedBox(
                          width: 100,
                          height: 44,
                          child: Text('Target'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.longPress(find.text('Target'));
          await tester.pump(const Duration(milliseconds: 200));
          final tooltip = tester.widget<AppTooltip>(find.byType(AppTooltip));
          expect(
            tooltip.arrow,
            below ? AppTooltipArrow.up : AppTooltipArrow.down,
          );
          expect(tester.takeException(), isNull);
        },
        variant: TargetPlatformVariant.only(TargetPlatform.android),
      );
    }

    testWidgets('renders the label with a rotated tail', (tester) async {
      await tester.pumpWidget(wrap(const AppTooltip(label: 'Свайпни')));

      expect(find.text('Свайпни'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppTooltip),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
    });

    testWidgets('the up arrow variant builds', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppTooltip(label: 'Сверху', arrow: AppTooltipArrow.up),
        ),
      );

      expect(find.text('Сверху'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
