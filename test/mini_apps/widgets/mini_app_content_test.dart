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

void _expectVisibleAction(WidgetTester tester, {double bottomPadding = 0}) {
  final action = find.byType(AppButton);
  expect(action.hitTestable(), findsOneWidget);
  expect(
    tester.getRect(action).bottom,
    closeTo(_height - _bottomInset - bottomPadding, 0.1),
  );
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

  for (final type in ['listView', 'gridView', 'singleChildScrollView']) {
    testWidgets('$type scrolls beneath bar and exposes last action above it', (
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
          if (type != 'singleChildScrollView') 'children': children,
          if (type == 'gridView') ...{
            'crossAxisCount': 1,
            'mainAxisExtent': 72,
          },
          if (type == 'singleChildScrollView')
            'child': {'type': 'column', 'children': children},
        },
      });
      final scrollable = find.byType(Scrollable);
      expect(tester.getRect(scrollable).bottom, _height);
      await tester.dragFrom(
        const Offset(180, _height - _bottomInset / 2),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      expect(
        tester.state<ScrollableState>(scrollable).position.pixels,
        greaterThan(0),
      );
      await tester.drag(scrollable, const Offset(0, -2000));
      await tester.pumpAndSettle();
      _expectVisibleAction(tester);
      _expectFullHeightBackground(tester);
    });
  }

  testWidgets('safe area preserves custom scroll padding without clipping', (
    tester,
  ) async {
    await _pumpScreen(tester, {
      'type': 'safeArea',
      'child': {
        'type': 'singleChildScrollView',
        'padding': {'left': 20, 'top': 12, 'right': 24, 'bottom': 28},
        'child': {
          'type': 'column',
          'children': [
            {'type': 'sizedBox', 'height': 1200},
            _button,
          ],
        },
      },
    });
    final scrollable = find.byType(Scrollable);
    expect(tester.getRect(scrollable).bottom, _height);
    expect(
      tester
          .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .padding,
      const EdgeInsets.fromLTRB(20, 12, 24, 28 + _bottomInset),
    );
    await tester.drag(scrollable, const Offset(0, -2000));
    await tester.pumpAndSettle();
    _expectVisibleAction(tester, bottomPadding: 28);
  });

  testWidgets('reverse list starts with its first action above the bar', (
    tester,
  ) async {
    await _pumpScreen(tester, {
      'type': 'listView',
      'reverse': true,
      'padding': 16,
      'children': [
        _button,
        for (var index = 0; index < 20; index++)
          {'type': 'sizedBox', 'height': 72},
      ],
    });
    expect(tester.getRect(find.byType(Scrollable)).bottom, _height);
    _expectVisibleAction(tester, bottomPadding: 16);
  });

  testWidgets('reactive padding updates without replacing local input', (
    tester,
  ) async {
    await _pumpScreen(tester, {
      'type': 'appStateScope',
      'initial': {'padding': 16},
      'child': {
        'type': 'singleChildScrollView',
        'padding': '{{state.padding}}',
        'child': {
          'type': 'column',
          'children': [
            {'type': 'appInputField', 'stateKey': 'draft', 'label': 'Draft'},
            {
              'type': 'appButton',
              'label': 'Change padding',
              'onPressed': {
                'actionType': 'setState',
                'key': 'padding',
                'value': 28,
              },
            },
          ],
        },
      },
    });
    final scrollView = find.byType(SingleChildScrollView);
    expect(
      tester.widget<SingleChildScrollView>(scrollView).padding,
      const EdgeInsets.fromLTRB(16, 16, 16, 16 + _bottomInset),
    );
    await tester.enterText(find.byType(TextField), 'Local draft');
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField));
    await tester.tap(find.text('Change padding'));
    await tester.pumpAndSettle();
    final updatedField = tester.widget<TextField>(find.byType(TextField));
    expect(updatedField.controller, same(field.controller));
    expect(updatedField.controller!.text, 'Local draft');
    expect(
      tester.widget<SingleChildScrollView>(scrollView).padding,
      const EdgeInsets.fromLTRB(28, 28, 28, 28 + _bottomInset),
    );
    expect(tester.getRect(scrollView).bottom, _height);
    expect(tester.takeException(), isNull);
  });

  testWidgets('generated root list retains full viewport and safe last row', (
    tester,
  ) async {
    await _pumpScreen(tester, {
      'type': 'appForEach',
      'as': 'listView',
      'items': [for (var index = 0; index < 20; index++) index],
      'template': {
        'type': 'sizedBox',
        'height': 72,
        'child': {'type': 'appText', 'data': 'Row {{item}}'},
      },
    });
    final scrollable = find.byType(Scrollable);
    expect(tester.getRect(scrollable).bottom, _height);
    await tester.drag(scrollable, const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text('Row 19').hitTestable(), findsOneWidget);
    expect(
      tester.getRect(find.text('Row 19')).bottom,
      lessThanOrEqualTo(_height - _bottomInset),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('horizontal list keeps its vertical safe area', (tester) async {
    await _pumpScreen(tester, {
      'type': 'listView',
      'scrollDirection': 'horizontal',
      'children': [
        {
          'type': 'sizedBox',
          'width': 240,
          'child': {
            'type': 'column',
            'mainAxisAlignment': 'end',
            'children': [_button],
          },
        },
        {'type': 'sizedBox', 'width': 600},
      ],
    });
    expect(
      tester.getRect(find.byType(Scrollable)).bottom,
      _height - _bottomInset,
    );
    _expectVisibleAction(tester);
    await tester.drag(find.byType(Scrollable), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
      greaterThan(0),
    );
  });

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
