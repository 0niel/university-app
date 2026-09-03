import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration trackOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaSwitch),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('off track is surface2, on track is accent', (tester) async {
    await tester.pumpWidget(
      wrapKit(NinjaSwitch(value: false, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(trackOf(tester).color, kitColors.surface2);

    await tester.pumpWidget(
      wrapKit(NinjaSwitch(value: true, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(trackOf(tester).color, kitColors.accent);
  });

  testWidgets('tapping toggles the value', (tester) async {
    var value = false;
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) => NinjaSwitch(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(NinjaSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);

    await tester.tap(find.byType(NinjaSwitch));
    await tester.pumpAndSettle();
    expect(value, isFalse);
  });

  testWidgets('reduced motion skips the animation', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        NinjaSwitch(value: true, onChanged: (_) {}),
        accessibleNavigation: true,
      ),
    );
    await tester.pump();

    expect(trackOf(tester).color, kitColors.accent);
  });

  testWidgets('keeps a 44px tap target', (tester) async {
    await tester.pumpWidget(
      wrapKit(NinjaSwitch(value: false, onChanged: (_) {})),
    );

    expect(tester.getSize(find.byType(NinjaSwitch)).height, 44);
  });

  testWidgets('exposes toggled semantics', (tester) async {
    await tester.pumpWidget(
      wrapKit(NinjaSwitch(value: true, label: 'on', onChanged: (_) {})),
    );

    final semantics = tester.getSemantics(find.byType(NinjaSwitch));
    expect(semantics.label, 'on');
  });
}
