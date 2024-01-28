import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/l10n/localizations_en.dart';
import 'package:neon_framework/src/theme/theme.dart';
import 'package:neon_framework/src/widgets/nextcloud_logo.dart';
import 'package:vector_graphics/vector_graphics.dart';

Widget wrapWidget(Widget dialog, [TargetPlatform platform = TargetPlatform.android]) {
  final theme = AppTheme.test(platform: platform);
  const locale = Locale('en');

  return MaterialApp(
    theme: theme.lightTheme,
    localizationsDelegates: NeonLocalizations.localizationsDelegates,
    supportedLocales: NeonLocalizations.supportedLocales,
    locale: locale,
    home: dialog,
  );
}

void main() {
  testWidgets('NextcloudLogo', (widgetTester) async {
    const widget = NextcloudLogo();

    await widgetTester.pumpWidget(wrapWidget(widget));
    expect(find.byType(VectorGraphic), findsOneWidget);
    expect(find.bySemanticsLabel(NeonLocalizationsEn().nextcloudLogo), findsOneWidget);

    await expectLater(find.byType(VectorGraphic), matchesGoldenFile('goldens/nextcloud_logo.png'));
  });
}
