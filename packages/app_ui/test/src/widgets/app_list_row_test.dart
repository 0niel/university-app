import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppListRow', () {
    testWidgets('renders title and fires onTap via AppPressable',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppListRow(
            title: 'Настройки',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Настройки'), findsOneWidget);
      expect(find.byType(AppPressable), findsOneWidget);

      await tester.tap(find.byType(AppListRow));
      expect(tapped, isTrue);
      expect(
        tester.getSize(find.byType(AppListRow)).height,
        greaterThanOrEqualTo(48),
      );
      expect(tester.getSemantics(find.byType(AppListRow)).label, 'Настройки');
    });

    testWidgets('a trailing button keeps handling its own tap', (
      tester,
    ) async {
      var rowTapped = false;
      var trailingTapped = false;
      await tester.pumpWidget(
        wrap(
          AppListRow(
            title: 'Уведомления',
            onTap: () => rowTapped = true,
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => trailingTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(trailingTapped, isTrue);
      expect(rowTapped, isFalse);
    });
  });

  group('AppSettingsRow', () {
    testWidgets('fires onTap via AppPressable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppSettingsRow(
            title: 'Приватность',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(AppSettingsRow));
      expect(tapped, isTrue);
    });
  });
}
