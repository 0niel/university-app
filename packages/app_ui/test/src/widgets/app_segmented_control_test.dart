import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps every normal-scale segment at least 44px tall', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: AppSegmentedControl<int>(
            value: 1,
            onChanged: (_) {},
            options: const [
              AppSegmentedOption(value: 0, label: 'Сегодня'),
              AppSegmentedOption(value: 1, label: 'Неделя'),
            ],
          ),
        ),
      ),
    );

    for (final semantics in find.byType(Semantics).evaluate()) {
      final widget = semantics.widget as Semantics;
      if (widget.properties.button == true) {
        expect(
          tester.getSize(find.byWidget(widget)).height,
          greaterThanOrEqualTo(44),
        );
      }
    }
  });

  testWidgets('stacks options without overflow at 200% text scale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const Scaffold(
          body: AppSegmentedControl<int>(
            value: 1,
            options: [
              AppSegmentedOption(value: 0, label: '🟢 Низкий'),
              AppSegmentedOption(value: 1, label: '🟡 Средний'),
              AppSegmentedOption(value: 2, label: '🔴 Срочно'),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('🟡 Средний'), findsOneWidget);
    final selected = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.selected == true,
      ),
    );
    expect(selected.properties.selected, isTrue);
    expect(selected.properties.enabled, isFalse);
  });
}
