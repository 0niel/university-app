import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: SizedBox(width: 360, child: child))),
      );

  ActionCardItem item(String title, {String? badge, VoidCallback? onTap}) =>
      ActionCardItem(
        title: title,
        subtitle: 'Подзаголовок',
        icon: AppLineIcon.book,
        onTap: onTap ?? () {},
        badge: badge,
      );

  group('ActionCard', () {
    testWidgets('renders the item and fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(ActionCard(item: item('Зачётка', onTap: () => tapped = true))),
      );

      expect(find.text('Зачётка'), findsOneWidget);
      expect(find.text('Подзаголовок'), findsOneWidget);

      await tester.tap(find.byType(ActionCardTile));
      expect(tapped, isTrue);
    });

    testWidgets('badge renders in a tinted pill', (tester) async {
      await tester.pumpWidget(
        wrap(ActionCard(item: item('Зачётка', badge: '3'))),
      );

      final badge = tester.widget<Text>(find.text('3'));
      expect(badge.style?.color, AppColors.light.accent);
      expect(badge.style?.fontSize, 11.5);
    });
  });

  group('ActionCardGroup', () {
    testWidgets('stacks the tiles inside a list group', (tester) async {
      await tester.pumpWidget(
        wrap(ActionCardGroup(items: [item('Первый'), item('Второй')])),
      );

      expect(find.byType(ActionCardTile), findsNWidgets(2));
      expect(find.byType(AppListGroup), findsOneWidget);
    });
  });
}
