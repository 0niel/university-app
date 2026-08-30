import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';

class _TestAmbientModeListener extends ValueNotifier<bool>
    implements AmbientModeListener {
  _TestAmbientModeListener({required bool initialValue}) : super(initialValue);

  @override
  bool get isAmbientModeActive => value;
}

void main() {
  group('$AmbientModeBuilder', () {
    test('can be instantiated', () {
      final builder = AmbientModeBuilder(
        child: Container(),
        builder: (context, isAmbientMode, _) => Container(),
      );
      expect(builder.child, isA<Container>());
    });

    testWidgets('builds with ambient mode', (tester) async {
      final listener = _TestAmbientModeListener(initialValue: true);

      await tester.pumpWidget(
        MaterialApp(
          home: AmbientModeBuilder(
            listener: listener,
            builder: (context, isAmbientMode, _) {
              return Text(isAmbientMode.toString());
            },
          ),
        ),
      );
      expect(find.text('true'), findsOneWidget);

      listener.value = false;
      await tester.pumpAndSettle();

      expect(find.text('false'), findsOneWidget);
    });
  });
}
