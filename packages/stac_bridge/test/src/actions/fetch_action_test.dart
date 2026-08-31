import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/fetch_action.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/stac_bridge.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

class FetchActionTest extends MiniAppHost {
  FetchActionTest({this.response});

  final Object? response;
  String? lastPath;
  String? lastMethod;
  Map<String, dynamic>? lastQuery;

  @override
  Future<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, Object?>? query,
    Object? body,
  }) async {
    lastPath = path;
    lastMethod = method;
    lastQuery = query;
    return response;
  }

  @override
  void closeMiniApp() => ();
  @override
  Future<void> openExternalUrl(Uri url) => .value();
  @override
  Future<void> openLocation(String location) => .value();
  @override
  Future<void> openMiniApp({required String slug, String? path}) => .value();
  @override
  Future<void> openPage({required String path, String? title}) => .value();
  @override
  Future<void> reload() => .value();
  @override
  Future<void> setStorage(String key, Object? value) => .value();
}

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

  // Initialised once so the success/error follow-ups (setState) resolve through
  // Stac.onCallFromJson the way they do at runtime.
  setUpAll(() async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => 'token',
      ),
    );
  });

  group('StacFetchActionParser (success)', () {
    late FetchActionTest host;
    late MiniAppSession session;

    setUp(() {
      host = FetchActionTest(
        response: {
          'data': {
            'items': [1, 2, 3],
          },
        },
      );
      session = MiniAppSession(slug: 'demo', host: host);
      MiniAppSessionStack.push(session);
    });
    tearDown(() => MiniAppSessionStack.pop(session));

    testWidgets('writes the picked sub-path into state', (tester) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      const parser = StacFetchActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {
          'path': '/api/x',
          'saveAs': 'items',
          'pick': 'data.items',
        }),
      );

      expect(store.get('items'), [1, 2, 3]);
      expect(host.lastPath, '/api/x');
      expect(host.lastMethod, 'GET');
    });

    testWidgets('adds a leading slash, forwards query, stores whole response', (
      tester,
    ) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      const parser = StacFetchActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {
          'path': 'api/y',
          'query': {'day': 'mon'},
        }),
      );

      expect(host.lastPath, '/api/y');
      expect(host.lastQuery, {'day': 'mon'});
      expect(store.get('data'), {
        'data': {
          'items': [1, 2, 3],
        },
      });
    });

    testWidgets('runs onResult after a successful fetch', (tester) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      const parser = StacFetchActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {
          'path': '/api/x',
          'saveAs': 'd',
          'onResult': {'actionType': 'setState', 'key': 'ok', 'value': true},
        }),
      );

      expect(store.get('ok'), true);
    });

    testWidgets('flips loadingKey false once settled', (tester) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      const parser = StacFetchActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {'path': '/api/x', 'loadingKey': 'busy'}),
      );

      expect(store.get('busy'), false);
    });
  });

  group('StacFetchActionParser (failure)', () {
    late MiniAppSession session;

    setUp(() {
      session = MiniAppSession(slug: 'demo', host: FetchActionTest());
      MiniAppSessionStack.push(session);
    });
    tearDown(() => MiniAppSessionStack.pop(session));

    testWidgets('a null response writes nothing and runs onError', (
      tester,
    ) async {
      final store = MiniAppStateStore();
      addTearDown(store.dispose);
      final context = await _pumpScope(tester, store);

      const parser = StacFetchActionParser();
      await parser.onCall(
        context,
        parser.getModel(const {
          'path': '/api/x',
          'saveAs': 'd',
          'onError': {'actionType': 'setState', 'key': 'failed', 'value': true},
        }),
      );

      expect(store.get('d'), isNull);
      expect(store.get('failed'), true);
    });
  });
}
