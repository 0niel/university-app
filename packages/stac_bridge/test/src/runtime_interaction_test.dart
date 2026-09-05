import 'dart:async';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/actions/stac_network_request_action_parser.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'device_actions_test.dart' show DeviceActionsTest;

class _Host extends DeviceActionsTest {
  final photo = Completer<String?>();
  final requests = <Object?>[];

  @override
  Future<String?> pickImage({required bool fromCamera}) => photo.future;

  @override
  Future<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, Object?>? query,
    Object? body,
  }) async {
    requests.add(body);
    return {'ok': true};
  }
}

class _Adapter implements HttpClientAdapter {
  final response = Completer<ResponseBody>();
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    request = options;
    return response.future;
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() async {
    await StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'test',
        onAccessTokenRequested: () async => 'token',
      ),
    );
  });

  Future<void> pump(WidgetTester tester, Map<String, Object?> screen) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => StacBridge.render(screen, context)!,
            ),
          ),
        ),
      );

  testWidgets('capture follow-up uses selected photo before another frame', (
    tester,
  ) async {
    final host = _Host();
    final session = MiniAppSession(slug: 'test', host: host);
    MiniAppSessionStack.push(session);
    addTearDown(() => MiniAppSessionStack.pop(session));
    await pump(tester, {
      'type': 'appStateScope',
      'initial': {'photo': '', 'picking': false},
      'child': {
        'type': 'column',
        'children': [
          {
            'type': 'appButton',
            'label': 'Choose',
            'onPressed': {
              'actionType': 'multiAction',
              'sync': true,
              'actions': [
                {'actionType': 'setState', 'key': 'picking', 'value': true},
                {
                  'actionType': 'pickImage',
                  'source': 'gallery',
                  'onResult': {
                    'actionType': 'fetch',
                    'path': '/photo',
                    'body': {'photoUrl': '{{state.photo}}'},
                    'onResult': {
                      'actionType': 'setState',
                      'key': 'picking',
                      'value': false,
                    },
                  },
                },
              ],
            },
          },
          {'type': 'appText', 'data': '{{state.photo}}'},
        ],
      },
    });
    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
    host.photo.complete('https://example.test/photo.webp');
    await tester.pumpAndSettle();
    expect(host.requests, [
      {'photoUrl': 'https://example.test/photo.webp'},
    ]);
    expect(find.text('https://example.test/photo.webp'), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'form submission keeps text and indicates request until complete',
    (
      tester,
    ) async {
      final adapter = _Adapter();
      final dio = Dio()..httpClientAdapter = adapter;
      StacNetworkRequestActionParser.client = dio;
      addTearDown(() => dio.close(force: true));
      await pump(tester, {
        'type': 'form',
        'child': {
          'type': 'column',
          'children': [
            {'type': 'appText', 'data': 'Profile'},
            {
              'type': 'appInputField',
              'id': 'name',
              'stateKey': 'name',
              'label': 'Name',
              'required': true,
            },
            {'type': 'appText', 'data': '{{state.name}}'},
            {
              'type': 'appButton',
              'label': 'Save',
              'loadingLabel': 'Saving',
              'onPressed': {
                'actionType': 'validateForm',
                'isValid': {
                  'actionType': 'networkRequest',
                  'url': 'https://example.test/save',
                  'method': 'post',
                  'body': {
                    'name': {'actionType': 'getFormValue', 'id': 'name'},
                  },
                  'results': [
                    {
                      'statusCode': 200,
                      'action': {
                        'actionType': 'setState',
                        'key': 'saved',
                        'value': true,
                      },
                    },
                  ],
                },
              },
            },
            {'type': 'appText', 'data': 'Saved: {{state.saved}}'},
          ],
        },
      });
      final heading = tester.widget<Text>(find.text('Profile'));
      await tester.enterText(find.byType(TextField), 'Анна');
      await tester.pump();
      expect(tester.widget<Text>(find.text('Profile')), same(heading));
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Saving'), findsOneWidget);
      expect(adapter.request?.data, {'name': 'Анна'});
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
      adapter.response.complete(ResponseBody.fromString('{}', 200));
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Saved: true'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        'Анна',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('sequential conditions read prior step and loop bindings', (
    tester,
  ) async {
    await pump(tester, {
      'type': 'appStateScope',
      'initial': {'count': 0, 'total': 0},
      'child': {
        'type': 'column',
        'children': [
          {
            'type': 'appButton',
            'label': 'Run',
            'onPressed': {
              'actionType': 'multiAction',
              'sync': true,
              'actions': [
                {'actionType': 'setState', 'key': 'count', 'value': 1},
                {
                  'actionType': 'runIf',
                  'condition': '{{state.count == 1}}',
                  'then': {
                    'actionType': 'forEachAction',
                    'items': [2, 3],
                    'do': {
                      'actionType': 'setState',
                      'key': 'total',
                      'value': '{{state.total + item}}',
                    },
                  },
                },
              ],
            },
          },
          {'type': 'appText', 'data': 'Total: {{state.total}}'},
        ],
      },
    });
    await tester.tap(find.text('Run'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
