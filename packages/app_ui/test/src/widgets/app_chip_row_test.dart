import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('renders filter pills and reports the selected value', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppChipRow<String>(
            value: 'news',
            items: const [
              AppChipRowItem(value: 'news', label: 'Новости'),
              AppChipRowItem(value: 'events', label: 'События'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppChip), findsNWidgets(2));
    await tester.tap(find.text('События'));
    expect(selected, 'events');
  });

  testWidgets('the selected pill is accent and the rest surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppChipRow<String>(
            value: 'news',
            items: const [
              AppChipRowItem(value: 'news', label: 'Новости'),
              AppChipRowItem(value: 'events', label: 'События'),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(kitStyleOf(tester, 'Новости')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'События')?.color, kitColors.ink);
  });

  testWidgets('scrolls full-bleed with padding on the scroller', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppChipRow<int>(
            value: 0,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            items: const [
              AppChipRowItem(value: 0, label: 'Один'),
              AppChipRowItem(value: 1, label: 'Два'),
              AppChipRowItem(value: 2, label: 'Три'),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final scroller = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(scroller.scrollDirection, Axis.horizontal);
    expect(
      scroller.padding,
      const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    );
  });
}
