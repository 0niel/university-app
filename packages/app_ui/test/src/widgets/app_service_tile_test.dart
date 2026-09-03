import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: child)),
      );

  group('AppServiceTile', () {
    testWidgets('renders emoji + label and fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppServiceTile(
            emoji: '🧮',
            label: 'GPA',
            color: const Color(0xFF1FB872),
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('🧮'), findsOneWidget);
      expect(find.text('GPA'), findsOneWidget);

      await tester.tap(find.byType(AppServiceTile));
      expect(tapped, isTrue);

      final semantics = tester.getSemantics(find.byType(AppServiceTile));
      expect(semantics.label, 'GPA');
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('uses the tinted accent and the requested size',
        (tester) async {
      const accent = Color(0xFFFF7A00);
      await tester.pumpWidget(
        wrap(const AppServiceTile(emoji: '🧩', color: accent, size: 60)),
      );

      expect(tester.getSize(find.byType(AppServiceTile)), const Size(60, 60));
      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>();
      expect(
        decorations.any(
          (decoration) =>
              decoration.color == AppColors.light.tintOf(accent) &&
              decoration.borderRadius == BorderRadius.circular(18),
        ),
        isTrue,
      );
    });

    testWidgets('solid fills the tile with the raw colour', (tester) async {
      const accent = Color(0xFFFF7A00);
      await tester.pumpWidget(
        wrap(
          const AppServiceTile(emoji: '🧩', color: accent, solid: true),
        ),
      );

      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>();
      expect(decorations.any((d) => d.color == accent), isTrue);
    });

    testWidgets('renders UIKit icon content without an emoji', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppServiceTile.icon(
            icon: AppLineIconWidget(AppLineIcon.map),
            color: Color(0xFF087F5B),
            label: 'Карта',
          ),
        ),
      );

      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.text('Карта'), findsOneWidget);
    });
  });
}
