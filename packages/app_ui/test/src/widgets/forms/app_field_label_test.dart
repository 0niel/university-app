import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  testWidgets('renders muted 12px caption text', (tester) async {
    await tester.pumpWidget(wrapKit(const AppFieldLabel('Почта')));

    expect(find.text('Почта'), findsOneWidget);
    final style = kitStyleOf(tester, 'Почта');
    expect(style?.color, kitColors.muted);
    expect(style?.fontSize, 12);
    expect(style?.fontWeight, FontWeight.w500);
  });

  testWidgets('hint is appended in muted2', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppFieldLabel('Почта', hint: 'focused')),
    );

    expect(find.textContaining('focused', findRichText: true), findsOneWidget);
  });
}
