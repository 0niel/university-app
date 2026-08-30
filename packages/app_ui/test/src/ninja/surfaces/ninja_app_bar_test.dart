import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(NinjaAppBar appBar) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(appBar: appBar, body: const SizedBox()),
      );

  group('NinjaAppBar (root)', () {
    testWidgets('renders the display title and outline actions', (
      tester,
    ) async {
      var searched = 0;
      await tester.pumpWidget(
        wrap(
          NinjaAppBar(
            title: 'Расписание',
            actions: [
              NinjaAppBarAction(
                icon: const Icon(Icons.search),
                onPressed: () => searched++,
                semanticLabel: 'Поиск',
              ),
              const NinjaAppBarAction(
                icon: Icon(Icons.notifications_none),
                hasBadge: true,
              ),
            ],
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Расписание')).style;
      expect(title?.fontSize, 20);
      expect(title?.fontWeight, FontWeight.w700);
      expect(title?.letterSpacing, -0.3);

      final iconTheme = IconTheme.of(tester.element(find.byIcon(Icons.search)));
      expect(iconTheme.size, 18);
      expect(iconTheme.color, colors.ink);

      final badges = tester.widgetList<Container>(find.byType(Container)).where(
            (container) =>
                (container.decoration as BoxDecoration?)?.color ==
                colors.scarlet,
          );
      expect(badges, hasLength(1));

      await tester.tap(find.byIcon(Icons.search));
      expect(searched, 1);
      expect(
        tester.getSize(
          find
              .ancestor(
                of: find.byIcon(Icons.search),
                matching: find.byType(SizedBox),
              )
              .first,
        ),
        const Size(44, 44),
      );
    });

    testWidgets('reserves 72px of height', (tester) async {
      const bar = NinjaAppBar(title: 'Расписание');
      expect(bar.preferredSize.height, 72);
    });
  });

  group('NinjaAppBar.inner', () {
    testWidgets('renders back arrow, title and brand action', (tester) async {
      var back = 0;
      var help = 0;
      await tester.pumpWidget(
        wrap(
          NinjaAppBar.inner(
            title: 'Отчёт по лабе №3',
            onBack: () => back++,
            backSemanticLabel: 'Назад',
            actionLabel: 'помощь',
            onAction: () => help++,
          ),
        ),
      );

      expect(find.byType(NinjaGlyphIcon), findsOneWidget);
      final title = tester.widget<Text>(find.text('Отчёт по лабе №3')).style;
      expect(title?.fontSize, 15);
      expect(title?.fontWeight, FontWeight.w600);

      final action = tester.widget<Text>(find.text('помощь')).style;
      expect(action?.fontSize, 12.5);
      expect(action?.fontWeight, FontWeight.w700);
      expect(action?.color, colors.brandInk);

      await tester.tap(find.byType(NinjaGlyphIcon));
      expect(back, 1);
      await tester.tap(find.text('помощь'));
      expect(help, 1);
      expect(
        tester.getSize(
          find
              .ancestor(
                of: find.byType(NinjaGlyphIcon),
                matching: find.byType(SizedBox),
              )
              .first,
        ),
        const Size(44, 44),
      );
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('помощь'),
                    matching: find.byType(ConstrainedBox),
                  )
                  .first,
            )
            .height,
        greaterThanOrEqualTo(44),
      );
    });

    testWidgets('hides the arrow without a handler', (tester) async {
      await tester.pumpWidget(wrap(const NinjaAppBar.inner(title: 'Заявка')));
      expect(find.byType(NinjaGlyphIcon), findsNothing);
      const bar = NinjaAppBar.inner(title: 'Заявка');
      expect(bar.preferredSize.height, 56);
    });
  });
}
