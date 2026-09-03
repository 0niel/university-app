import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: child)),
      );

  group('ImagePlaceholder', () {
    testWidgets('renders a striped box with the image icon', (tester) async {
      await tester.pumpWidget(
        wrap(const ImagePlaceholder(width: 120, height: 80)),
      );

      expect(find.byType(AppStripePlaceholder), findsOneWidget);
      expect(
        tester.getSize(find.byType(ImagePlaceholder)),
        const Size(120, 80),
      );
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.image);
    });

    testWidgets('circle shape clips as an oval', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ImagePlaceholder(
            width: 64,
            height: 64,
            shape: BoxShape.circle,
          ),
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
    });
  });
}
