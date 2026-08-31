import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/flow_control_actions.dart';
import 'package:stac_bridge/src/stac_bridge.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

Future<BuildContext> _pumpScope(
  WidgetTester tester,
  MiniAppStateStore store,
) async {
  late BuildContext context;
  await tester.pumpWidget(
    MiniAppStateScope(
      store: store,
      child: Builder(
        builder: (builderContext) {
          context = builderContext;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return context;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialised so the branch/loop bodies (setState) resolve through
  // Stac.onCallFromJson exactly as they do at runtime.
  setUpAll(() async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => 'token',
      ),
    );
  });

  group('StacRunIfActionParser', () {
    const parser = StacRunIfActionParser();
    const model = {
      'condition': 'state.n > 5',
      'then': {'actionType': 'setState', 'key': 'big', 'value': true},
      'else': {'actionType': 'setState', 'key': 'big', 'value': false},
    };

    testWidgets('runs then when the condition holds', (tester) async {
      final store = MiniAppStateStore()..seed({'n': 10});
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(context, parser.getModel(model));
      expect(store.get('big'), true);
    });

    testWidgets('runs else when the condition fails', (tester) async {
      final store = MiniAppStateStore()..seed({'n': 1});
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(context, parser.getModel(model));
      expect(store.get('big'), false);
    });

    testWidgets('is a no-op when the chosen branch is absent', (tester) async {
      final store = MiniAppStateStore()..seed({'n': 1});
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(
        context,
        parser.getModel(const {
          'condition': 'state.n > 5',
          'then': {'actionType': 'setState', 'key': 'big', 'value': true},
        }),
      );
      expect(store.get('big'), isNull);
    });
  });

  group('StacForEachActionParser', () {
    const parser = StacForEachActionParser();

    testWidgets('runs do per item with item and index substituted', (
      tester,
    ) async {
      final store = MiniAppStateStore()
        ..seed({
          'tags': ['a', 'b', 'c'],
        });
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(
        context,
        parser.getModel(const {
          'items': 'state.tags',
          'do': {
            'actionType': 'setState',
            'key': 'v{{index}}',
            'value': '{{item}}',
          },
        }),
      );

      expect(store.get('v0'), 'a');
      expect(store.get('v1'), 'b');
      expect(store.get('v2'), 'c');
    });

    testWidgets('non-list items is a no-op', (tester) async {
      final store = MiniAppStateStore()..seed({'x': 5});
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(
        context,
        parser.getModel(const {
          'items': 'state.x',
          'do': {'actionType': 'setState', 'key': 'touched', 'value': true},
        }),
      );
      expect(store.get('touched'), isNull);
    });

    testWidgets('honours a custom itemVar', (tester) async {
      final store = MiniAppStateStore()
        ..seed({
          'nums': [7],
        });
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      await parser.onCall(
        context,
        parser.getModel(const {
          'items': 'state.nums',
          'itemVar': 'n',
          'do': {'actionType': 'setState', 'key': 'first', 'value': '{{n}}'},
        }),
      );
      expect(store.get('first'), 7);
    });
  });
}
