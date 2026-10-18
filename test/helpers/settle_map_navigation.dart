import 'package:flutter_test/flutter_test.dart';

Future<void> settleMapNavigation(
  WidgetTester tester, {
  required bool Function() isReady,
}) async {
  for (var attempt = 0; attempt < 200 && !isReady(); attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pump();
  }
  expect(
    isReady(),
    isTrue,
    reason: 'Map navigation preparation did not finish',
  );
  await tester.pumpAndSettle();
}
