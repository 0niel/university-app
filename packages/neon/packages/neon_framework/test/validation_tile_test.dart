import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/theme/theme.dart';
import 'package:neon_framework/src/widgets/validation_tile.dart';

Widget wrapWidget(Widget widget, [TargetPlatform platform = TargetPlatform.android]) {
  final theme = AppTheme.test(platform: platform);
  const locale = Locale('en');

  var child = widget;
  if (platform != TargetPlatform.iOS && platform != TargetPlatform.macOS) {
    child = Material(child: child);
  }

  return MaterialApp(
    theme: theme.lightTheme,
    localizationsDelegates: NeonLocalizations.localizationsDelegates,
    supportedLocales: NeonLocalizations.supportedLocales,
    locale: locale,
    home: child,
  );
}

void main() {
  group('NeonValidationTile', () {
    testWidgets('NeonValidationTile material', (widgetTester) async {
      var widget = const NeonValidationTile(title: 'title', state: ValidationState.loading);
      await widgetTester.pumpWidget(wrapWidget(widget));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // We do not change the theme throughout the test so getting once is enough.
      final theme = (widgetTester.firstWidget(find.byType(Theme)) as Theme).data;

      widget = const NeonValidationTile(title: 'title', state: ValidationState.failure);
      await widgetTester.pumpWidget(wrapWidget(widget));
      var iconFinder = find.byIcon(Icons.error_outline);
      expect(iconFinder, findsOneWidget);
      var icon = widgetTester.firstWidget(iconFinder) as Icon;
      expect(icon.color, theme.colorScheme.error);

      widget = const NeonValidationTile(title: 'title', state: ValidationState.canceled);
      await widgetTester.pumpWidget(wrapWidget(widget));
      iconFinder = find.byIcon(Icons.cancel_outlined);
      expect(iconFinder, findsOneWidget);
      icon = widgetTester.firstWidget(iconFinder) as Icon;
      expect(icon.color, theme.disabledColor);
      final text = widgetTester.firstWidget(find.text('title')) as Text;
      expect(text.style?.color, theme.disabledColor);

      widget = const NeonValidationTile(title: 'title', state: ValidationState.success);
      await widgetTester.pumpWidget(wrapWidget(widget));
      iconFinder = find.byIcon(Icons.check_circle);
      expect(iconFinder, findsOneWidget);
      icon = widgetTester.firstWidget(iconFinder) as Icon;
      expect(icon.color, theme.colorScheme.primary);
    });

    testWidgets('NeonValidationTile cupertino', (widgetTester) async {
      const widget = NeonValidationTile(title: 'title', state: ValidationState.canceled);

      await widgetTester.pumpWidget(wrapWidget(widget, TargetPlatform.macOS));
      expect(find.byType(CupertinoListTile), findsOneWidget);
    });
  });
}
