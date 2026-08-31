import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/flow_actions.dart';
import 'package:stac_bridge/src/stac_bridge.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => 'token',
      ),
    );
  });

  testWidgets('confirm dispatches only the confirmed follow-up', (
    tester,
  ) async {
    final store = MiniAppStateStore();
    addTearDown(store.dispose);
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: MiniAppStateScope(
          store: store,
          child: Builder(
            builder: (builderContext) {
              context = builderContext;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    const parser = StacConfirmActionParser();
    final operation = parser.onCall(
      context,
      parser.getModel(const {
        'title': 'Удалить запись?',
        'confirmLabel': 'Удалить',
        'onConfirm': {
          'actionType': 'setState',
          'key': 'confirmed',
          'value': true,
        },
        'onCancel': {
          'actionType': 'setState',
          'key': 'confirmed',
          'value': false,
        },
      }),
    );
    await tester.pump();
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    await operation;

    expect(store.get('confirmed'), isTrue);
  });
}
