// ignore_for_file: discarded_futures

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/settings/models/option.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:neon_framework/src/settings/widgets/option_settings_tile.dart';
import 'package:neon_framework/src/theme/theme.dart';

// ignore: missing_override_of_must_be_overridden
class MockStorage extends Mock implements SettingsStorage {}

enum StorageKey implements Storable {
  key._('storage-key');

  const StorageKey._(this.value);

  @override
  final String value;
}

enum SelectValues {
  first,
  second,
  third,
}

Widget wrapWidget(Widget widget, [TargetPlatform platform = TargetPlatform.android]) {
  final theme = AppTheme.test(platform: platform);
  const locale = Locale('en');

  return MaterialApp(
    theme: theme.lightTheme,
    localizationsDelegates: NeonLocalizations.localizationsDelegates,
    supportedLocales: NeonLocalizations.supportedLocales,
    locale: locale,
    home: Material(child: widget),
  );
}

void main() {
  final storage = MockStorage();
  const key = StorageKey.key;

  setUp(() {
    when(() => storage.setBool(key.value, any())).thenAnswer((_) async => true);
    when(() => storage.setString(key.value, any())).thenAnswer((_) async => true);
    when(() => storage.remove(key.value)).thenAnswer((_) async => true);
  });

  group('OptionSettingsTile', () {
    testWidgets('ToggleOption', (widgetTester) async {
      final option = ToggleOption(
        storage: storage,
        key: key,
        label: (_) => 'label',
        defaultValue: true,
      );

      final widget = wrapWidget(OptionSettingsTile(option: option));
      await widgetTester.pumpWidget(widget);

      expect(find.text('label'), findsOneWidget);

      await widgetTester.tap(find.byType(SwitchListTile));
      await widgetTester.pumpAndSettle();

      expect(option.value, isFalse);
    });

    group('ToggleOption', () {
      final valuesLabel = {
        null: (_) => 'null',
        SelectValues.first: (_) => 'first',
        SelectValues.second: (_) => 'second',
        SelectValues.third: (_) => 'third',
      };

      late SelectOption<SelectValues?> option;

      setUp(() {
        option = SelectOption<SelectValues?>(
          storage: storage,
          key: key,
          label: (_) => 'label',
          defaultValue: SelectValues.first,
          values: valuesLabel,
        );
      });

      testWidgets('ToggleOption material', (widgetTester) async {
        final widget = wrapWidget(OptionSettingsTile(option: option));
        await widgetTester.pumpWidget(widget);

        expect(find.text('label'), findsOneWidget);
        expect(find.text('first'), findsOneWidget);

        await widgetTester.tap(find.byType(SelectSettingsTile));
        await widgetTester.pumpAndSettle();
        expect(find.byType(SelectSettingsTileDialog), findsOneWidget);

        // cancel selection
        await widgetTester.tapAt(Offset.zero);
        await widgetTester.pumpAndSettle();
        expect(option.value, SelectValues.first);

        await widgetTester.tap(find.byType(SelectSettingsTile));
        await widgetTester.pumpAndSettle();

        // Select null value
        await widgetTester.tap(find.text('null'));
        await widgetTester.pumpAndSettle();
        expect(option.value, isNull);
      });

      testWidgets('ToggleOption cupertino', (widgetTester) async {
        final widget = wrapWidget(OptionSettingsTile(option: option), TargetPlatform.macOS);
        await widgetTester.pumpWidget(widget);

        expect(find.text('label'), findsOneWidget);
        expect(find.text('first'), findsOneWidget);

        await widgetTester.tap(find.byType(SelectSettingsTile));
        await widgetTester.pumpAndSettle();
        expect(find.byType(SelectSettingsTileScreen), findsOneWidget);

        // Select null value
        await widgetTester.tap(find.text('null'));
        await widgetTester.pumpAndSettle();
        expect(option.value, isNull);

        // Select second value
        await widgetTester.tap(find.text('second'));
        await widgetTester.pumpAndSettle();
        expect(option.value, SelectValues.second);
      });
    });
  });
}
