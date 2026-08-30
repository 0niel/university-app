import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';
import 'package:wear/app/app.dart';
import 'package:wear/nfc_pass/nfc_pass.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    setUpAll(() {
      AmbientModeListener.instance.value = false;
    });

    testWidgets('navigates to NfcPassPage', (tester) async {
      await tester.pumpWidget(const App());

      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(NfcPassPage), findsOneWidget);
    });

    group('updates ambient colors', () {
      testWidgets('on ambient mode updates', (tester) async {
        await tester.pumpWidget(const App());

        ThemeData getTheme() {
          final [materialAppElement] = find
              .byType(MaterialApp)
              .evaluate()
              .toList();
          final materialApp = materialAppElement.widget as MaterialApp;
          return materialApp.theme!;
        }

        AppColors getColors() {
          return getTheme().extension<AppColors>()!;
        }

        expect(getColors().primary, AppColors.dark.primary);

        await simulatePlatformCall('ambient_mode', 'onUpdateAmbient');
        await tester.pumpAndSettle();

        expect(getColors().primary, Colors.white24);
        expect(getColors().active, Colors.white70);
        expect(getColors().deactive, Colors.white38);

        await simulatePlatformCall('ambient_mode', 'onExitAmbient');
        await tester.pumpAndSettle();

        expect(getColors(), AppColors.dark);
      });
    });
  });
}
