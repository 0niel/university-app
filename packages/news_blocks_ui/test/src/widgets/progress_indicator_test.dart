import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ProgressIndicator', () {
    testWidgets('renders ColoredBox '
        'with shimmer base color as default', (tester) async {
      await tester.pumpApp(
        const ProgressIndicator(progress: 0.5),
        theme: AppTheme.lightTheme,
      );

      final context = tester.element(find.byType(ProgressIndicator));
      final colors = Theme.of(context).colors;

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox && widget.color == colors.shimmerBase,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders ColoredBox '
        'with provided color', (tester) async {
      const color = Colors.orange;

      await tester.pumpApp(
        const ProgressIndicator(progress: 0.5, color: color),
        theme: AppTheme.lightTheme,
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == color,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator', (tester) async {
      const progress = 0.5;

      await tester.pumpApp(
        const ProgressIndicator(progress: progress),
        theme: AppTheme.lightTheme,
      );

      expect(
        find.descendant(
          of: find.byType(ColoredBox),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is CircularProgressIndicator && widget.value == progress,
          ),
        ),
        findsOneWidget,
      );
    });
  });
}
