import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('interactive chips keep a 44px selected semantic target', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(
            child: AppFilterChip(
              label: 'Сегодня',
              isSelected: true,
              small: true,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppFilterChip)).height, 44);
    final semantics = tester.getSemantics(find.byType(AppFilterChip));
    expect(semantics.label, 'Сегодня');
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
  });
}
