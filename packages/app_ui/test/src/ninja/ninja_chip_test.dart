import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration chipOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaChip),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return box.decoration as BoxDecoration;
  }

  Color? labelColorOf(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).style?.color;

  group('NinjaChip', () {
    testWidgets('selected uses an accent tint and default uses a quiet fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(NinjaChip(label: 'Все · 14', selected: true, onTap: () {})),
      );
      final selected = chipOf(tester);
      expect(selected.color, colors.brandTint);
      expect(selected.border, isNull);
      expect(labelColorOf(tester, 'Все · 14'), colors.brandInk);

      await tester.pumpWidget(
        wrap(NinjaChip(label: 'Электроника', onTap: () {})),
      );
      final unselected = chipOf(tester);
      expect(unselected.color, colors.surfaceAlt);
      expect(unselected.border, isNull);
      expect(labelColorOf(tester, 'Электроника'), colors.mutedDark);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(NinjaChip(label: 'Документы', onTap: () => tapped = true)),
      );

      await tester.tap(find.byType(NinjaChip));
      expect(tapped, isTrue);
    });

    testWidgets('the dot renders in scarlet', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaChip(label: 'Документы', showDot: true, onTap: () {})),
      );

      final dot = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(NinjaChip),
              matching: find.byType(DecoratedBox),
            )
            .last,
      );
      expect((dot.decoration as BoxDecoration).color, colors.scarlet);
      expect((dot.decoration as BoxDecoration).shape, BoxShape.circle);
    });

    testWidgets('prints the counter in the same quiet filter language', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(NinjaChip(label: 'Находки', count: 3, onTap: () {})),
      );

      expect(labelColorOf(tester, '3'), colors.mutedDark);
      expect(labelColorOf(tester, 'Находки'), colors.mutedDark);
    });

    testWidgets('keeps the kit 44px touch target', (tester) async {
      await tester.pumpWidget(wrap(NinjaChip(label: 'Все', onTap: () {})));

      expect(
        tester.getSize(find.byType(NinjaChip)).height,
        NinjaMetrics.minTouchTarget,
      );
    });

    testWidgets('removable chips route the × to onRemove', (tester) async {
      var removed = false;
      await tester.pumpWidget(
        wrap(
          NinjaChip(
            label: 'Выбран',
            selected: true,
            removeSemanticLabel: 'Удалить выбранное',
            onRemove: () => removed = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(
        tester.getSize(find.bySemanticsLabel('Удалить выбранное')),
        const Size.square(NinjaMetrics.minTouchTarget),
      );
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(removed, isTrue);
    });

    testWidgets('disabled uses the surface pill and blocks taps', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          NinjaChip(
            label: 'Недоступен',
            enabled: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(chipOf(tester).color, colors.surface);
      expect(labelColorOf(tester, 'Недоступен'), colors.disabled);

      await tester.tap(find.byType(NinjaChip));
      expect(tapped, isFalse);
    });
  });

  group('NinjaChipRow', () {
    testWidgets('lays the chips out behind its own padding', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: NinjaChipRow(
              children: [
                NinjaChip(label: 'Все'),
                NinjaChip(label: 'Электроника'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(NinjaChip), findsNWidgets(2));
      expect(
        tester.getTopLeft(find.byType(NinjaChip).first).dx -
            tester.getTopLeft(find.byType(NinjaChipRow)).dx,
        NinjaMetrics.screenPadding,
      );
    });

    testWidgets('scrolls horizontally when the chips overflow', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            child: NinjaChipRow(
              children: [
                NinjaChip(label: 'Электроника'),
                NinjaChip(label: 'Документы'),
                NinjaChip(label: 'Одежда'),
              ],
            ),
          ),
        ),
      );

      final before = tester.getTopLeft(find.byType(NinjaChip).first).dx;
      await tester.drag(find.byType(NinjaChipRow), const Offset(-80, 0));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.byType(NinjaChip).first).dx,
        lessThan(before),
      );
    });
  });
}
