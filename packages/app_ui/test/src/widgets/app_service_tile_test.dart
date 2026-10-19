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

    testWidgets('uses the glass accent and the requested size', (tester) async {
      const accent = Color(0xFFFF7A00);
      await tester.pumpWidget(
        wrap(const AppServiceTile(emoji: '🧩', color: accent, size: 60)),
      );

      expect(tester.getSize(find.byType(AppServiceTile)), const Size(60, 60));
      final surface = tester.widget<AppGlassSurface>(
        find.byType(AppGlassSurface),
      );
      expect(surface.tint, accent);
      expect(surface.tone, AppGlassTone.subtle);
      expect(surface.borderRadius, 18);
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

    testWidgets('small service icons retain a 44px action target', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppServiceTile.icon(
            icon: const AppLineIconWidget(AppLineIcon.map),
            color: Colors.blue,
            semanticsLabel: 'Карта кампуса',
            size: 24,
            onTap: () => taps++,
          ),
        ),
      );
      final action = find.byType(AppServiceTile);
      expect(tester.getSize(action), const Size.square(44));
      final bounds = tester.getRect(action);
      await tester.tapAt(bounds.topLeft + const Offset(1, 1));
      expect(taps, 1);
      expect(tester.getSemantics(action).label, 'Карта кампуса');
      expect(tester.takeException(), isNull);
    });

    testWidgets('compact action keeps its full semantics and callback', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 70,
            child: AppServiceTile.compact(
              icon: const AppLineIconWidget(AppLineIcon.map),
              color: Colors.blue,
              label: 'Карта',
              semanticsLabel: 'Карта кампуса',
              onTap: () => taps++,
            ),
          ),
        ),
      );
      final label = tester.widget<Text>(find.text('Карта'));
      expect(label.style?.fontSize, 10.5);
      expect(label.style?.height, 1.2);
      expect(label.maxLines, 1);
      expect(
        tester.getSize(find.byType(AppGlassSurface)),
        const Size.square(48),
      );
      final node = tester.getSemantics(find.byType(AppServiceTile));
      expect(node.label, 'Карта кампуса');
      expect(node.flagsCollection.isButton, isTrue);
      expect(
        tester.getSize(find.byType(AppServiceTile)).width,
        greaterThanOrEqualTo(44),
      );
      expect(
        tester.getSize(find.byType(AppServiceTile)).height,
        greaterThanOrEqualTo(44),
      );
      await tester.tap(find.text('Карта'));
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('compact labels adapt to large text within a narrow tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: SizedBox(
              width: 80,
              child: AppServiceTile.compact(
                icon: const AppLineIconWidget(AppLineIcon.map),
                color: Colors.blue,
                label: 'Аудитории',
                semanticsLabel: 'Свободные аудитории',
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      final label = tester.widget<Text>(find.text('Аудитории'));
      expect(label.maxLines, 3);
      expect(label.style?.fontSize, 10.5);
      expect(
        tester.getSemantics(find.byType(AppServiceTile)).label,
        'Свободные аудитории',
      );
      final tile = tester.getRect(find.byType(AppServiceTile));
      final text = tester.getRect(find.text('Аудитории'));
      expect(text.left, greaterThanOrEqualTo(tile.left));
      expect(text.right, lessThanOrEqualTo(tile.right));
      expect(tester.takeException(), isNull);
    });

    testWidgets('compact skeleton matches the icon and label spacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 70,
                child: AppServiceTile.compact(
                  icon: AppLineIconWidget(AppLineIcon.map),
                  color: Colors.blue,
                  label: 'Карта',
                ),
              ),
              SizedBox(width: 70, child: AppServiceTile.skeleton()),
            ],
          ),
        ),
      );
      final icon = find.byWidgetPredicate(
        (widget) => widget is NinjaSkeleton && widget.height == 48,
      );
      expect(tester.getSize(icon), const Size.square(48));
      final label = find.byWidgetPredicate(
        (widget) => widget is NinjaSkeleton && widget.widthFactor == .6,
      );
      expect(
        tester.getTopLeft(label).dy - tester.getBottomLeft(icon).dy,
        7,
      );
      expect(
        tester.getTopLeft(find.text('Карта')).dy -
            tester.getBottomLeft(find.byType(AppGlassSurface)).dy,
        7,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
