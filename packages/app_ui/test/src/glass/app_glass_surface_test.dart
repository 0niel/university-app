import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'glass works without a shader host and preserves input, dark $dark',
      (tester) async {
        final text = TextEditingController();
        final focus = FocusNode();
        addTearDown(text.dispose);
        addTearDown(focus.dispose);
        var highContrast = false;
        late StateSetter update;
        var taps = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return MediaQuery(
                  data: const MediaQueryData(
                    disableAnimations: true,
                  ).copyWith(highContrast: highContrast),
                  child: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: 280,
                        child: AppGlassSurface(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: text, focusNode: focus),
                              AppButton.primary(
                                label: 'Action',
                                onPressed: () => taps++,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'query');
        expect(focus.hasFocus, isTrue);
        final bounds = tester.getRect(find.byType(TextField));
        update(() => highContrast = true);
        await tester.pumpAndSettle();
        expect(text.text, 'query');
        expect(focus.hasFocus, isTrue);
        expect(tester.getRect(find.byType(TextField)), bounds);
        await tester.tap(find.text('Action'));
        expect(taps, 1);
        expect(tester.takeException(), isNull);
        expect(tester.binding.transientCallbackCount, 0);
      },
    );
  }
}
