import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('separators stay subtle on dense screens, dark $dark', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const MediaQuery(
            data: MediaQueryData(devicePixelRatio: 3),
            child: SizedBox(
              width: 300,
              child: AppListGroup(
                dividerIndent: 20,
                children: [
                  SizedBox(
                    key: Key('first-row'),
                    height: 44,
                    child: Text('First'),
                  ),
                  AppListRow(title: 'Second'),
                ],
              ),
            ),
          ),
          dark: dark,
        ),
      );
      final separator = find.descendant(
        of: find.byType(AppDivider),
        matching: find.byType(ColoredBox),
      );
      expect(tester.getSize(separator).height * 3, closeTo(1, .001));
      expect(tester.getSize(separator).width, 280);
      expect(tester.widget<ColoredBox>(separator).color.a, lessThan(.09));
      final first = tester.getRect(find.byKey(const Key('first-row')));
      final second = tester.getRect(find.byType(AppListRow));
      expect(second.top - first.bottom, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('dividers fill the group and sized rows remain visible', (
    tester,
  ) async {
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
    expect(tester.getSize(divider).width, 280);
    expect(
      tester.getSize(divider).height *
          MediaQuery.devicePixelRatioOf(tester.element(divider)),
      closeTo(1, .001),
    );
    expect(tester.takeException(), isNull);
  });
}
