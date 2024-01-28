import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/src/theme/theme.dart';
import 'package:neon_framework/src/widgets/server_icon.dart';
import 'package:vector_graphics/vector_graphics.dart';

Widget wrapWidget(Widget widget, [TargetPlatform platform = TargetPlatform.android]) {
  final theme = AppTheme.test(platform: platform);

  return MaterialApp(
    theme: theme.lightTheme,
    home: widget,
  );
}

void main() {
  testWidgets('NeonServerIcon', (widgetTester) async {
    var widget = const NeonServerIcon(icon: 'icon-logo-dark');

    await widgetTester.pumpWidget(wrapWidget(widget));
    expect(find.byType(VectorGraphic), findsOneWidget);

    widget = const NeonServerIcon(
      icon: 'icon-logo-dark',
      colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
    );
    await widgetTester.pumpWidget(wrapWidget(widget));

    await expectLater(find.byType(VectorGraphic), matchesGoldenFile('goldens/neon_server_icon_nextcloud_logo.png'));
  });
}
