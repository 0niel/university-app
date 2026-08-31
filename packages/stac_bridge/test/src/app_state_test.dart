import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/state_actions.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

void main() {
  group('MiniAppStateStore', () {
    test('seed initializes local values', () {
      final store = MiniAppStateStore()..seed({'count': 0, 'tab': 'today'});
      addTearDown(store.dispose);
      expect(store.get('count'), 0);
      expect(store.get('tab'), 'today');
    });

    test('set updates the value and notifies listeners', () {
      final store = MiniAppStateStore()..seed({'flag': false});
      addTearDown(store.dispose);
      var notified = 0;
      void onChanged() => notified++;
      store
        ..addListener(onChanged)
        ..set('flag', true);

      expect(store.get('flag'), true);
      expect(notified, 1);
    });

    test('add increments a numeric key, treating a missing value as 0', () {
      final store = MiniAppStateStore()..seed({'n': 5});
      addTearDown(store.dispose);

      store.add('n', 5);
      expect(store.get('n'), 10);

      store.add('fresh', 3);
      expect(store.get('fresh'), 3);
    });

    test('dispose clears local values', () {
      final store = MiniAppStateStore()
        ..seed({'temp': 1})
        ..dispose();
      expect(store.snapshot(), isEmpty);
    });

    test('snapshot exposes an immutable view of current values', () {
      final store = MiniAppStateStore()..seed({'count': 1, 'tab': 'today'});
      addTearDown(store.dispose);
      store.set('count', 2);

      final snapshot = store.snapshot();
      expect(snapshot, {'count': 2, 'tab': 'today'});
      expect(() => snapshot['count'] = 9, throwsUnsupportedError);
    });
  });

  group('StacSetStateActionParser', () {
    Future<BuildContext> pumpScope(
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

    testWidgets('add mutates the nearest scope store', (tester) async {
      final store = MiniAppStateStore()..seed({'count': 0});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacSetStateActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {'key': 'count', 'add': 5}),
      );

      expect(store.get('count'), 5);
    });

    testWidgets('value sets a literal on the scope store', (tester) async {
      final store = MiniAppStateStore()..seed({'tab': 'today'});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacSetStateActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {'key': 'tab', 'value': 'week'}),
      );

      expect(store.get('tab'), 'week');
    });

    testWidgets('expression computes from the current snapshot', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'a': 3, 'b': 4});
      addTearDown(store.dispose);
      final context = await pumpScope(tester, store);

      const parser = StacSetStateActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {
          'key': 'total',
          'expression': 'state.a + state.b',
        }),
      );

      expect(store.get('total'), 7);
    });

    testWidgets('is a no-op without an enclosing scope', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        Builder(
          builder: (builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      );

      const parser = StacSetStateActionParser();
      // Must not throw when there is no MiniAppStateScope ancestor.
      await parser.onCall(
        context,
        parser.getModel(const {'key': 'count', 'add': 1}),
      );
    });
  });
}
