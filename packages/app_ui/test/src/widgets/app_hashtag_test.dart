import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppHashTag', () {
    testWidgets('renders #label and fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppHashTag(
            label: 'краш',
            color: const Color(0xFFFF5FA2),
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('#краш'), findsOneWidget);
      expect(
        tester.getSize(find.byType(AppHashTag)).height,
        greaterThanOrEqualTo(44),
      );
      await tester.tap(find.byType(AppHashTag));
      expect(tapped, isTrue);
    });
  });
}
