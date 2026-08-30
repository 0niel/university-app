import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/view/services_header.dart';

import '../../helpers/pump_app.dart';

void main() {
  const buttonKey = ValueKey('services-configure-button');

  testWidgets('the title uses the display style and the action is a circle', (
    tester,
  ) async {
    var toggled = 0;
    await tester.pumpApp(
      Scaffold(
        body: ServicesHeader(editMode: false, onToggleEdit: () => toggled++),
      ),
    );

    final title = tester.widget<Text>(find.text('Сервисы'));
    expect(title.style?.fontSize, NinjaText.display.fontSize);

    final button = find.byKey(buttonKey);
    expect(button, findsOneWidget);
    final size = tester.getSize(button);
    expect(size.width, NinjaMetrics.minTouchTarget);
    expect(size.height, NinjaMetrics.minTouchTarget);

    await tester.tap(button);
    expect(toggled, 1);
  });

  testWidgets('edit mode fills the circle and swaps to the done icon', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(body: ServicesHeader(editMode: true, onToggleEdit: () {})),
    );

    final button = tester.widget<NinjaIconButton>(find.byKey(buttonKey));
    expect(button.variant, NinjaIconButtonVariant.filled);
    expect(button.tooltip, 'Готово');
    expect(
      find.descendant(
        of: find.byKey(buttonKey),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is AppLineIconWidget && widget.icon == AppLineIcon.check,
        ),
      ),
      findsOneWidget,
    );
  });
}
