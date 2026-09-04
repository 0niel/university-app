import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/kit/kit_slider_dropdown_parsers.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

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

  group('slider', () {
    testWidgets('reads value, min, max and divisions from JSON', (
      tester,
    ) async {
      await pumpKit(tester, const StacSliderKitParser(), {
        'value': 4,
        'min': 0,
        'max': 10,
        'divisions': 10,
        'label': 'Громкость',
      });
      final slider = tester.widget<AppSlider>(find.byType(AppSlider));
      expect(slider.value, 4);
      expect(slider.min, 0);
      expect(slider.max, 10);
      expect(slider.divisions, 10);
      expect(slider.label, 'Громкость');
      expect(find.byType(Slider), findsNothing);
    });

    testWidgets(
      'drag writes the new value into bound state and fires onChanged',
      (
        tester,
      ) async {
        final store = MiniAppStateStore()..seed({'vol': 4});
        addTearDown(store.dispose);
        await pumpKit(tester, const StacSliderKitParser(), {
          'stateKey': 'vol',
          'min': 0,
          'max': 10,
          'divisions': 10,
          'onChanged': {'actionType': 'none'},
        }, store: store);
        expect(
          tester.widget<AppSlider>(find.byType(AppSlider)).value,
          4,
        );

        await tester.drag(find.byType(AppSlider), const Offset(5000, 0));
        await tester.pump();

        expect(store.get('vol'), 10);
        expect(
          tester.widget<AppSlider>(find.byType(AppSlider)).value,
          10,
        );
      },
    );

    testWidgets('disabled slider is not interactive', (tester) async {
      await pumpKit(tester, const StacSliderKitParser(), {
        'value': 5,
        'enabled': false,
      });
      final slider = tester.widget<AppSlider>(find.byType(AppSlider));
      expect(slider.onChanged, isNull);
      expect(slider.onChangeEnd, isNull);
    });
  });

  group('dropdownMenu', () {
    testWidgets(
      'resolves the initial selection label from dropdownMenuEntries',
      (
        tester,
      ) async {
        await pumpKit(tester, const StacDropdownMenuKitParser(), {
          'initialSelection': 'week',
          'hintText': 'Выберите период',
          'dropdownMenuEntries': [
            {'value': 'day', 'label': 'День'},
            {'value': 'week', 'label': 'Неделя'},
          ],
        });
        final select = tester.widget<AppSelectField>(
          find.byType(AppSelectField),
        );
        expect(select.value, 'Неделя');
        expect(select.placeholder, 'Выберите период');
        expect(find.byType(DropdownMenu), findsNothing);
      },
    );

    testWidgets('opens the kit sheet and selects an entry into bound state', (
      tester,
    ) async {
      final store = MiniAppStateStore()..seed({'plan': 'week'});
      addTearDown(store.dispose);
      await pumpKit(tester, const StacDropdownMenuKitParser(), {
        'stateKey': 'plan',
        'entries': [
          {'value': 'day', 'label': 'День'},
          {'value': 'week', 'label': 'Неделя'},
        ],
        'onSelected': {
          'actionType': 'setState',
          'key': 'picked',
          'value': true,
        },
      }, store: store);
      expect(
        tester.widget<AppSelectField>(find.byType(AppSelectField)).value,
        'Неделя',
      );

      await tester.tap(find.byType(AppSelectField));
      await tester.pumpAndSettle();
      expect(find.text('День'), findsOneWidget);

      await tester.tap(find.text('День'));
      await tester.pumpAndSettle();

      expect(store.get('plan'), 'day');
      expect(store.get('picked'), isTrue);
      expect(
        tester.widget<AppSelectField>(find.byType(AppSelectField)).value,
        'День',
      );
    });

    testWidgets('disabled dropdown keeps onTap null', (tester) async {
      await pumpKit(tester, const StacDropdownMenuKitParser(), {
        'dropdownMenuEntries': [
          {'value': 'a', 'label': 'A'},
        ],
        'enabled': false,
      });
      final select = tester.widget<AppSelectField>(
        find.byType(AppSelectField),
      );
      expect(select.enabled, isFalse);
      expect(select.onTap, isNull);
    });
  });

  testWidgets(
    'bridge registration lets slider and dropdownMenu win over built-ins',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  Stac.fromJson({'type': 'slider', 'value': 0.5}, context)!,
                  Stac.fromJson({
                    'type': 'dropdownMenu',
                    'dropdownMenuEntries': [
                      {'value': 'a', 'label': 'A'},
                    ],
                  }, context)!,
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AppSlider), findsOneWidget);
      expect(find.byType(Slider), findsNothing);
      expect(find.byType(AppSelectField), findsOneWidget);
      expect(find.byType(DropdownMenu), findsNothing);
    },
  );
}
