import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  for (final legacy in [false, true]) {
    for (final kind in [PointerDeviceKind.touch, PointerDeviceKind.mouse]) {
      testWidgets('chip row scrolls with $kind legacy=$legacy', (tester) async {
        final controller = ScrollController();
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapKit(
            SizedBox(
              width: 240,
              child: legacy
                  ? NinjaChipRow(
                      controller: controller,
                      children: [
                        for (var index = 0; index < 8; index++)
                          NinjaChip(label: 'Категория $index', onTap: () {}),
                      ],
                    )
                  : AppChipRow<int>(
                      controller: controller,
                      value: 0,
                      onChanged: (_) {},
                      items: [
                        for (var index = 0; index < 8; index++)
                          AppChipRowItem(
                            value: index,
                            label: 'Категория $index',
                          ),
                      ],
                    ),
            ),
          ),
        );
        final row = find.byType(SingleChildScrollView);
        await tester.drag(row, const Offset(-160, 0), kind: kind);
        await tester.pumpAndSettle();
        expect(controller.offset, greaterThan(80));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
