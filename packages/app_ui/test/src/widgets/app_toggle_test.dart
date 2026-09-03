import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration trackOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppSwitch),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('track is 48x28 and toggles the accent fill', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppSwitch(value: false, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();

    expect(trackOf(tester).color, kitColors.surface2);

    await tester.pumpWidget(
      wrapKit(AppSwitch(value: true, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();

    expect(trackOf(tester).color, kitColors.accent);
    final constraints = tester
        .widget<Container>(
          find
              .descendant(
                of: find.byType(AppSwitch),
                matching: find.byType(Container),
              )
              .first,
        )
        .constraints;
    expect(constraints?.maxWidth, 48);
    expect(constraints?.maxHeight, 28);
  });

  testWidgets('tapping reports the flipped value', (tester) async {
    bool? received;
    await tester.pumpWidget(
      wrapKit(AppSwitch(value: false, onChanged: (value) => received = value)),
    );

    await tester.tap(find.byType(AppSwitch));
    expect(received, isTrue);
  });

  testWidgets('disabled dims to 45%', (tester) async {
    await tester.pumpWidget(wrapKit(const AppSwitch(value: true)));

    final opacity = tester.widget<Opacity>(
      find.descendant(
        of: find.byType(AppSwitch),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.45);
  });

  testWidgets('optional label renders in muted 12', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppSwitch(value: true, label: 'on', onChanged: (_) {})),
    );

    expect(find.text('on'), findsOneWidget);
    expect(kitStyleOf(tester, 'on')?.color, kitColors.muted);
    expect(kitStyleOf(tester, 'on')?.fontSize, 12);
  });

  testWidgets('AppToggle and NinjaSwitch delegate to AppSwitch', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        Column(
          children: [
            AppToggle(value: true, onChanged: (_) {}),
            NinjaSwitch(value: false, onChanged: (_) {}),
          ],
        ),
      ),
    );

    expect(find.byType(AppSwitch), findsNWidgets(2));
  });

  testWidgets('AppLangToggle renders a segmented control', (tester) async {
    var picked = '';
    await tester.pumpWidget(
      wrapKit(
        AppLangToggle(
          value: 'RU',
          options: const ['RU', 'EN'],
          onChanged: (value) => picked = value,
        ),
      ),
    );

    expect(find.byType(AppSegmentedControl<String>), findsOneWidget);
    await tester.tap(find.text('EN'));
    expect(picked, 'EN');
  });
}
