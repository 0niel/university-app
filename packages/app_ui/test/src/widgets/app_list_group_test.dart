import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('dividers fill the group and sized rows remain visible',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 300,
          child: AppListGroup(
            dividerIndent: 20,
            children: [
              SizedBox(height: 44, child: Text('First')),
              SizedBox.shrink(),
              AppListRow(title: 'Second'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('First'), findsOneWidget);
    final divider = find.descendant(
      of: find.byType(AppListGroup),
      matching: find.byType(ColoredBox),
    );
    expect(tester.getSize(divider), const Size(280, 1));
    expect(tester.takeException(), isNull);
  });
}
