import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDashedBorder', () {
    testWidgets('renders its child inside a CustomPaint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppDashedBorder(
            color: Color(0xFF000000),
            radius: 12,
            child: SizedBox(width: 100, height: 40, child: Text('drop')),
          ),
        ),
      );

      expect(find.text('drop'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppDashedBorder),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });
  });
}
