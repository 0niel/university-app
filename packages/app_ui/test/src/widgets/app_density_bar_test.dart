import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: SizedBox(width: 240, child: child))),
      );

  group('AppDensityBar', () {
    testWidgets('maps every colour onto a segmented bar part', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppDensityBar(
            segments: [Color(0xFF0E8A63), Color(0xFF2F7AFF)],
            leftLabel: '8:30',
            centerLabel: 'окно',
            rightLabel: '18:00',
          ),
        ),
      );

      final bar = tester.widget<AppSegmentedBar>(find.byType(AppSegmentedBar));
      expect(bar.segments.length, 2);
      expect(find.text('8:30'), findsOneWidget);
      expect(find.text('окно'), findsOneWidget);
      expect(find.text('18:00'), findsOneWidget);
    });

    testWidgets('renders without labels', (tester) async {
      await tester.pumpWidget(
        wrap(const AppDensityBar(segments: [Color(0xFF2F7AFF)])),
      );

      expect(find.byType(AppSegmentedBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
