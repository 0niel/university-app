import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SizedBox(width: 200, child: child),
        ),
      );

  group('AppExpandableText', () {
    testWidgets('short text renders without a toggle', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppExpandableText(
            text: 'Коротко',
            expandLabel: 'Показать полностью',
            collapseLabel: 'Свернуть',
          ),
        ),
      );

      expect(find.text('Коротко'), findsOneWidget);
      expect(find.text('Показать полностью'), findsNothing);
    });

    testWidgets('long text shows an expand toggle that reveals it all', (
      tester,
    ) async {
      final longText = List.generate(20, (i) => 'Слово$i').join(' ');
      await tester.pumpWidget(
        wrap(
          AppExpandableText(
            text: longText,
            expandLabel: 'Показать полностью',
            collapseLabel: 'Свернуть',
            collapsedMaxLines: 2,
          ),
        ),
      );

      expect(find.text('Показать полностью'), findsOneWidget);

      await tester.tap(find.text('Показать полностью'));
      await tester.pumpAndSettle();

      expect(find.text('Свернуть'), findsOneWidget);
      final text = tester.widget<Text>(find.text(longText));
      expect(text.maxLines, isNull);
    });
  });
}
