import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/onboarding/widgets/setting_toggle_row.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets(
    'row matches compact source height while keeping a 44px switch target',
    (tester) async {
      bool? value;
      await tester.pumpApp(
        Scaffold(
          body: SettingToggleRow(
            title: 'Геолокация',
            subtitle: 'Для карты',
            value: false,
            onChanged: (next) => value = next,
          ),
        ),
        size: const Size(390, 844),
      );
      final row = tester.getRect(find.byType(SettingToggleRow));
      final toggle = tester.getRect(find.byType(AppSwitch));
      expect(row.height, closeTo(65.75, 1));
      expect(toggle.height, 44);
      expect(toggle.center.dy, closeTo(row.center.dy, .01));
      await tester.tapAt(Offset(toggle.center.dx, toggle.top + 1));
      expect(value, isTrue);
    },
  );

  testWidgets(
    'long descriptions at 200 percent text retain the complete switch target',
    (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SettingToggleRow(
            title: 'Друзья на кампусе',
            subtitle: 'Показывать моё местоположение только друзьям',
            value: false,
            onChanged: (_) {},
          ),
        ),
        size: const Size(320, 568),
        textScaler: const TextScaler.linear(2),
      );
      expect(tester.getSize(find.byType(AppSwitch)).height, 44);
      expect(tester.takeException(), isNull);
    },
  );
}
