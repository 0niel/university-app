import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester) =>
      kitDecorationOf(tester, AppIconButton);

  Finder dot() => find.descendant(
        of: find.byType(AppIconButton),
        matching: find.byType(IgnorePointer),
      );

  testWidgets('fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.bell),
          onPressed: () => taps++,
        ),
      ),
    );

    await tester.tap(find.byType(AppIconButton));
    expect(taps, 1);
  });

  testWidgets('tones resolve to the kit fills', (tester) async {
    const cases = {
      AppIconButtonTone.secondary: 'surface2',
      AppIconButtonTone.primary: 'accent',
      AppIconButtonTone.surface: 'surface',
      AppIconButtonTone.tonal: 'tint',
    };
    final colors = {
      'surface2': kitColors.surface2,
      'accent': kitColors.accent,
      'surface': kitColors.surface,
      'tint': kitColors.tint,
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        wrapKit(
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.bell),
            tone: entry.key,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester).color, colors[entry.value]);
    }
  });

  testWidgets('disabled uses canvas', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppIconButton(icon: AppLineIconWidget(AppLineIcon.bell))),
    );

    expect(decorationOf(tester).color, kitColors.canvas);
  });

  testWidgets('visual sizes retain at least 44px targets', (tester) async {
    const expected = {
      AppIconButtonSize.regular: 44.0,
      AppIconButtonSize.compact: 42.0,
      AppIconButtonSize.small: 36.0,
    };
    for (final entry in expected.entries) {
      await tester.pumpWidget(
        wrapKit(
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.bell),
            size: entry.key,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(AppIconButton)),
        const Size.square(44),
      );
      expect(
        tester.getSize(find.byType(AnimatedContainer)),
        Size.square(entry.value),
      );
    }

    await tester.pumpWidget(
      wrapKit(
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.bell),
          onPressed: () {},
        ),
      ),
    );
    expect(
      decorationOf(tester).borderRadius,
      BorderRadius.circular(AppRadius.field),
    );

    await tester.pumpWidget(
      wrapKit(
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.bell),
          shape: AppIconButtonShape.circle,
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(decorationOf(tester).borderRadius, BorderRadius.circular(22));
  });

  group('dot badge', () {
    testWidgets('shows a badge when dot: true', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const AppIconButton(
            icon: AppLineIconWidget(AppLineIcon.bell),
            dot: true,
          ),
        ),
      );
      expect(dot(), findsOneWidget);
    });

    testWidgets('has no badge by default', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const AppIconButton(icon: AppLineIconWidget(AppLineIcon.bell)),
        ),
      );
      expect(dot(), findsNothing);
    });
  });

  testWidgets('AppFab is a 56px accent circle', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppFab(icon: AppLineIcon.plus, onPressed: () {})),
    );

    expect(tester.getSize(find.byType(AppFab)), const Size.square(56));
    expect(kitDecorationOf(tester, AppFab).color, kitColors.accent);
  });

  testWidgets('AppBackButton pops the route', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrapKit(AppBackButton(onPressed: () => taps++)));

    await tester.tap(find.byType(AppBackButton));
    expect(taps, 1);
  });
}
