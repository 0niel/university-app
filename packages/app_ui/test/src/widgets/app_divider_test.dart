import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('horizontal dividers fill loose column constraints',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [AppDivider(indent: 16, endIndent: 8)],
          ),
        ),
      ),
    );
    final line = find.descendant(
      of: find.byType(AppDivider),
      matching: find.byType(ColoredBox),
    );
    expect(tester.getSize(line), const Size(296, 1));
  });

  testWidgets('settings rows keep their inset separator visible',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 320,
          child: AppSettingsRow(title: 'Setting'),
        ),
      ),
    );
    final line = find.descendant(
      of: find.byType(AppDivider),
      matching: find.byType(ColoredBox),
    );
    expect(tester.getSize(line).width, greaterThan(200));
    expect(tester.getSize(line).height, 1);
  });
}
