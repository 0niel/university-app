import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({bool reduced = false, bool accessible = false}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(
          disableAnimations: reduced,
          accessibleNavigation: accessible,
        ),
        child: const _Counter().animatePageEntrance(),
      ),
    );

void main() {
  for (final accessible in [false, true]) {
    testWidgets('entrance respects reduced motion immediately ($accessible)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(reduced: !accessible, accessible: accessible),
      );
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.tap(find.text('0'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });
  }

  testWidgets('changing motion preferences preserves child state',
      (tester) async {
    await tester.pumpWidget(_host(reduced: true));
    await tester.tap(find.text('0'));
    await tester.pump();
    await tester.pumpWidget(_host());
    expect(find.text('1'), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('enabling accessibility completes an active entrance',
      (tester) async {
    await tester.pumpWidget(_host());
    await tester.pump(const Duration(milliseconds: 40));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, lessThan(1));
    await tester.pumpWidget(_host(accessible: true));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _count = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => setState(() => _count++),
        child: Text('$_count'),
      );
}
