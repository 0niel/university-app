import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/stac_bridge.dart';

void main() {
  setUpAll(() async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'test',
        onAccessTokenRequested: () async => null,
      ),
    );
  });

  Future<void> pump(WidgetTester tester, Map<String, Object?> child) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => StacBridge.render(child, context)!,
            ),
          ),
        ),
      );

  testWidgets(
    'keyed foreach retains separate input identities when reordered',
    (
      tester,
    ) async {
      await pump(tester, {
        'type': 'appStateScope',
        'initial': {
          'items': ['a', 'b'],
        },
        'child': {
          'type': 'column',
          'children': [
            {
              'type': 'appForEach',
              'items': 'state.items',
              'template': {
                'type': 'appInputField',
                'key': '{{item}}',
                'id': '{{item}}',
                'label': '{{item}}',
              },
            },
            {
              'type': 'appButton',
              'label': 'Reverse',
              'onPressed': {
                'actionType': 'setState',
                'key': 'items',
                'value': ['b', 'a'],
              },
            },
          ],
        },
      });
      await tester.enterText(find.byType(TextField).first, 'First draft');
      await tester.enterText(find.byType(TextField).last, 'Second draft');
      await tester.tap(find.text('Reverse'));
      await tester.pumpAndSettle();
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(fields[0].controller?.text, 'Second draft');
      expect(fields[1].controller?.text, 'First draft');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('hidden branches do not contribute spacing', (tester) async {
    await pump(tester, {
      'type': 'column',
      'spacing': 12,
      'children': [
        {
          'type': 'sizedBox',
          'height': 20,
          'child': {'type': 'appText', 'data': 'First'},
        },
        {
          'type': 'appIf',
          'condition': 'false',
          'child': {'type': 'appText', 'data': 'Hidden'},
        },
        {'type': 'appSwitch', 'value': '1', 'cases': <Object?>[]},
        {'type': 'appText', 'data': 'Last'},
      ],
    });
    expect(find.text('Hidden'), findsNothing);
    expect(
      tester.getTopLeft(find.text('Last')).dy,
      tester.getTopLeft(find.text('First')).dy + 32,
    );
    expect(tester.takeException(), isNull);
  });
}
