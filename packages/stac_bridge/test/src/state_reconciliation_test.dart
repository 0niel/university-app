import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/app_state_scope_view.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/stac_bridge.dart';

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

  Future<void> pumpScreen(
    WidgetTester tester,
    Map<String, Object?> initial,
    Map<String, Object?> child,
  ) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) => Stac.fromJson({
          'type': 'appStateScope',
          'initial': initial,
          'child': child,
        }, context)!,
      ),
    ),
  );

  testWidgets(
    'server refresh updates nested leaves and preserves local edits',
    (
      tester,
    ) async {
      const screen = <String, Object?>{
        'type': 'scaffold',
        'body': {
          'type': 'column',
          'children': [
            {
              'type': 'appCard',
              'child': {
                'type': 'column',
                'children': [
                  {'type': 'appText', 'data': 'Server: {{state.server}}'},
                  {'type': 'appText', 'data': 'Draft: {{state.draft}}'},
                ],
              },
            },
            {
              'type': 'appInputField',
              'stateKey': 'draft',
              'label': 'Draft',
            },
          ],
        },
      };
      await pumpScreen(tester, {
        'server': 'Before',
        'draft': 'Original',
      }, screen);
      final firstScope = tester.state(find.byType(AppStateScopeView));
      await tester.enterText(find.byType(TextField), 'Local edit');
      await tester.pumpAndSettle();
      expect(find.text('Draft: Local edit'), findsOneWidget);

      await pumpScreen(tester, {
        'server': 'After',
        'draft': 'Remote edit',
      }, screen);
      await tester.pumpAndSettle();

      expect(tester.state(find.byType(AppStateScopeView)), same(firstScope));
      expect(find.text('Server: After'), findsOneWidget);
      expect(find.text('Server: Before'), findsNothing);
      expect(find.text('Draft: Local edit'), findsOneWidget);
      expect(find.text('Local edit'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('legacy app bars and nested button labels remain reactive', (
    tester,
  ) async {
    const screen = <String, Object?>{
      'type': 'scaffold',
      'appBar': {
        'type': 'appBar',
        'title': {'type': 'text', 'data': '{{state.title}}'},
      },
      'body': {
        'type': 'center',
        'child': {
          'type': 'elevatedButton',
          'child': {
            'type': 'row',
            'children': [
              {'type': 'text', 'data': '{{state.label}}'},
            ],
          },
          'onPressed': {
            'actionType': 'setState',
            'key': 'title',
            'value': 'Updated title',
          },
        },
      },
    };
    await pumpScreen(tester, {
      'title': 'Initial title',
      'label': 'Save profile',
    }, screen);
    expect(find.text('Initial title'), findsOneWidget);
    expect(find.text('Save profile'), findsOneWidget);
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(find.text('Updated title'), findsOneWidget);

    final store = MiniAppStateScope.of(tester.element(find.byType(AppButton)));
    store!.set('label', 'Saved');
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Save profile'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
