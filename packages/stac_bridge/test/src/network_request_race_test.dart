import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/stac_network_request_action_parser.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';
import 'package:stac_bridge/stac_bridge.dart';

class _PendingRequests implements HttpClientAdapter {
  final responses = <Completer<ResponseBody>>[];
  Completer<void> _arrival = Completer<void>();

  Future<void> waitFor(int count) async {
    while (responses.length < count) {
      await _arrival.future;
    }
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    final response = Completer<ResponseBody>();
    responses.add(response);
    _arrival.complete();
    _arrival = Completer<void>();
    return response.future;
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  late _PendingRequests adapter;
  late MiniAppStateStore store;
  const parser = StacNetworkRequestActionParser();

  setUp(() {
    adapter = _PendingRequests();
    final client = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter;
    StacNetworkRequestActionParser.client = client;
    store = MiniAppStateStore();
    addTearDown(() => client.close(force: true));
    addTearDown(store.dispose);
  });

  Future<BuildContext> pumpScope(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MiniAppStateScope(
        store: store,
        child: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return captured;
  }

  ResponseBody response(int revision) => ResponseBody.fromString(
    '{"revision":$revision}',
    200,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  const request = <String, Object?>{
    'url': '/search',
    'saveAs': 'results',
    'loadingKey': 'searchLoading',
    'errorKey': 'searchError',
    'onResult': {
      'actionType': 'setState',
      'key': 'successCount',
      'add': 1,
    },
    'onError': {
      'actionType': 'setState',
      'key': 'errorCount',
      'add': 1,
    },
    'onFinally': {
      'actionType': 'setState',
      'key': 'finallyCount',
      'add': 1,
    },
  };

  testWidgets('an older response cannot replace newer results or callbacks', (
    tester,
  ) async {
    final context = await pumpScope(tester);
    await tester.runAsync(() async {
      final older = parser.onCall(context, request);
      await adapter.waitFor(1);
      final newer = parser.onCall(context, request);
      await adapter.waitFor(2);

      adapter.responses[1].complete(response(2));
      await newer;
      expect(store.get('results'), {'revision': 2});
      expect(store.get('searchLoading'), false);
      expect(store.get('successCount'), 1);
      expect(store.get('finallyCount'), 1);

      adapter.responses[0].complete(response(1));
      await older;
      expect(store.get('results'), {'revision': 2});
      expect(store.get('successCount'), 1);
      expect(store.get('finallyCount'), 1);
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('stale failure does not clear a newer loading state', (
    tester,
  ) async {
    final context = await pumpScope(tester);
    await tester.runAsync(() async {
      final older = parser.onCall(context, request);
      await adapter.waitFor(1);
      final newer = parser.onCall(context, request);
      await adapter.waitFor(2);

      adapter.responses[0].complete(ResponseBody.fromString('{}', 500));
      await older;
      expect(store.get('searchLoading'), true);
      expect(store.get('searchError'), isNull);
      expect(store.get('errorCount'), isNull);
      expect(store.get('finallyCount'), isNull);

      adapter.responses[1].complete(response(2));
      await newer;
      expect(store.get('searchLoading'), false);
      expect(store.get('results'), {'revision': 2});
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('independent mutations both run their completion callbacks', (
    tester,
  ) async {
    final context = await pumpScope(tester);
    final mutation = Map<String, Object?>.from(request)
      ..remove('saveAs')
      ..remove('loadingKey')
      ..remove('errorKey')
      ..['method'] = 'post';
    await tester.runAsync(() async {
      final first = parser.onCall(context, mutation);
      final second = parser.onCall(context, mutation);
      await adapter.waitFor(2);

      adapter.responses[1].complete(response(2));
      adapter.responses[0].complete(response(1));
      await Future.wait([first, second]);
      expect(store.get('successCount'), 2);
      expect(store.get('finallyCount'), 2);
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('request completion after unmount cannot write state', (
    tester,
  ) async {
    final context = await pumpScope(tester);
    late Future<Object?> pending;
    await tester.runAsync(() async {
      pending = parser.onCall(context, request);
      await adapter.waitFor(1);
    });
    await tester.pumpWidget(const SizedBox.shrink());

    await tester.runAsync(() async {
      adapter.responses.single.complete(response(1));
      await pending;
    });
    expect(store.get('results'), isNull);
    expect(store.get('successCount'), isNull);
    expect(tester.takeException(), isNull);
  });
}
