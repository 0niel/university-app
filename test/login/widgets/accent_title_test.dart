import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/login/widgets/accent_title.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('accent stays upright and preserves the complete title', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: AccentTitle('Welcome back', accent: 'back'),
      ),
    );
    final rich = tester.widget<RichText>(
      find.descendant(
        of: find.byType(AccentTitle),
        matching: find.byType(RichText),
      ),
    );
    expect(rich.text.toPlainText(), 'Welcome back');
    TextSpan? accent;
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text == 'back') accent = span;
      return true;
    });
    expect(accent, isNotNull);
    expect(accent?.style?.fontFamily, AppText.sansFamily);
    expect(accent?.style?.fontStyle ?? FontStyle.normal, FontStyle.normal);
    expect(accent?.style?.fontWeight, FontWeight.w700);
    expect(
      accent?.style?.color,
      tester.element(find.byType(AccentTitle)).colors.accent,
    );
    expect(tester.takeException(), isNull);
  });
}
