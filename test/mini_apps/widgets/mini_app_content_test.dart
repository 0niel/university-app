import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_body.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';
import 'package:stac_bridge/stac_bridge.dart';

import '../../helpers/pump_app.dart';

const _surfaceColor = Color(0xFF19334D);
const _bottomInset = 96.0;
const _height = 844.0;
const _button = {'type': 'appButton', 'label': 'Last action'};

Future<void> _pumpScreen(
  WidgetTester tester,
  Map<String, dynamic> screen,
) async {
  await tester.pumpApp(
    AppBottomBarViewport(
      bottomInset: _bottomInset,
      child: MiniAppScaffold(
        title: 'Mini app',
        body: MiniAppRunnerBody(
          state: MiniAppRunnerState(status: .ready, screen: screen),
        ),
      ),
    ),
    size: const Size(360, _height),
  );
  await tester.pumpAndSettle();
}

void _expectVisibleAction(WidgetTester tester) {
  final action = find.byType(AppButton);
  expect(action.hitTestable(), findsOneWidget);
  expect(tester.getRect(action).bottom, closeTo(_height - _bottomInset, 0.1));
  expect(MediaQuery.paddingOf(tester.element(action)).bottom, 0);
  expect(tester.takeException(), isNull);
}

void _expectFullHeightBackground(WidgetTester tester) {
  final surface = find.byWidgetPredicate(
    (widget) => widget is Scaffold && widget.backgroundColor == _surfaceColor,
  );
  expect(surface, findsOneWidget);
  expect(tester.getRect(surface).bottom, _height);
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

  for (final type in ['listView', 'singleChildScrollView']) {
    testWidgets('$type exposes last action above bar with full background', (
      tester,
    ) async {
      final children = [
        for (var index = 0; index < 20; index++)
          {
            'type': 'sizedBox',
            'height': 72,
            'child': {'type': 'appText', 'data': 'Row $index'},
          },
        _button,
      ];
      await _pumpScreen(tester, {
        'type': 'scaffold',
        'backgroundColor': '#19334D',
        'body': {
          'type': type,
          if (type == 'listView') 'children': children,
          if (type == 'singleChildScrollView')
            'child': {'type': 'column', 'children': children},
        },
      });
      final scrollable = find.byType(Scrollable);
      await tester.drag(scrollable, const Offset(0, -2000));
      await tester.pumpAndSettle();
      _expectVisibleAction(tester);
      _expectFullHeightBackground(tester);
    });
  }

  for (final existingSafeArea in [false, true]) {
    testWidgets(
      'bottom column consumes inset once safeArea=$existingSafeArea',
      (
        tester,
      ) async {
        const column = {
          'type': 'column',
          'mainAxisAlignment': 'end',
          'children': [_button],
        };
        await _pumpScreen(tester, {
          'type': 'appStateScope',
          'initial': <String, Object?>{},
          'child': {
            'type': 'scaffold',
            'backgroundColor': '#19334D',
            'body': existingSafeArea
                ? {'type': 'safeArea', 'child': column}
                : column,
          },
        });
        _expectVisibleAction(tester);
        _expectFullHeightBackground(tester);
      },
    );
  }

  testWidgets('decorative root keeps its color beneath foreground inset', (
    tester,
  ) async {
    await _pumpScreen(tester, {
      'type': 'container',
      'color': '#19334D',
      'child': {
        'type': 'column',
        'mainAxisAlignment': 'end',
        'children': [_button],
      },
    });
    _expectVisibleAction(tester);
    final surface = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == _surfaceColor,
    );
    expect(surface, findsOneWidget);
    expect(tester.getRect(surface).bottom, _height);
  });
}
