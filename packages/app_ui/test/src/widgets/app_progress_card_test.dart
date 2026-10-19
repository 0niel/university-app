import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('shared progress card retains slot geometry, type and action', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppProgressCard(
            title: const Text('Progress'),
            value: const Text('78%'),
            emblem: const SizedBox.square(dimension: 51),
            progress: const SizedBox(key: Key('progress'), height: 7),
            supporting: const Text('Keep learning'),
            metadata: const Text('Updated today'),
            onTap: () => taps++,
          ),
        ),
        accessibleNavigation: true,
      ),
    );
    final card = tester.widget<AppGlassSurface>(
      find.descendant(
        of: find.byType(AppProgressCard),
        matching: find.byType(AppGlassSurface),
      ),
    );
    expect(card.padding, const EdgeInsets.all(AppSpacing.contentGap));
    expect(card.borderRadius, AppRadius.dialog);
    expect(card.tone, AppGlassTone.regular);
    final header = tester.getRect(
      find.descendant(
        of: find.byType(AppProgressCard),
        matching: find.byType(Row),
      ),
    );
    final progress = tester.getRect(find.byKey(const Key('progress')));
    final supporting = tester.getRect(find.text('Keep learning'));
    final metadata = tester.getRect(find.text('Updated today'));
    expect(progress.top - header.bottom, closeTo(AppSpacing.xl, .01));
    expect(supporting.top - progress.bottom, closeTo(AppSpacing.md, .01));
    expect(metadata.top - supporting.bottom, closeTo(AppSpacing.sm, .01));
    final valueStyle = DefaultTextStyle.of(
      tester.element(find.text('78%')),
    ).style;
    expect(valueStyle.fontFamily, AppText.sansFamily);
    expect(valueStyle.fontSize, AppText.cardValue.fontSize);
    expect(valueStyle.color, kitColors.ink);
    expect(
      DefaultTextStyle.of(
        tester.element(find.text('Updated today')),
      ).style.color,
      kitColors.accent,
    );
    await tester.tap(find.text('Updated today'));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('progress skeleton shares real text metrics at $scale', (
      tester,
    ) async {
      Widget content({required bool loading}) => SizedBox(
        width: 320,
        child: AppProgressCard(
          title: loading
              ? const AppSkeletonText(sample: 'Learning progress')
              : const Text('Learning progress'),
          value: loading
              ? const AppSkeletonText(sample: '78 percent')
              : const Text('78 percent'),
          emblem: const SizedBox.square(dimension: 51),
          progress: const SizedBox(height: 7),
          supporting: loading
              ? const AppSkeletonText(sample: 'Keep learning every day')
              : const Text('Keep learning every day'),
          metadata: loading
              ? const AppSkeletonText(sample: 'Updated today')
              : const Text('Updated today'),
        ),
      );
      await tester.pumpWidget(
        wrapKit(
          content(loading: false),
          accessibleNavigation: true,
          textScale: scale,
        ),
      );
      final actualSize = tester.getSize(find.byType(AppProgressCard));
      await tester.pumpWidget(
        wrapKit(
          content(loading: true),
          accessibleNavigation: true,
          textScale: scale,
        ),
      );
      expect(tester.getSize(find.byType(AppProgressCard)), actualSize);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('absent optional slots leave no empty footer or emblem gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 320,
          child: AppProgressCard(
            title: Text('Progress'),
            value: Text('0'),
            progress: SizedBox(key: Key('progress'), height: 7),
          ),
        ),
        accessibleNavigation: true,
      ),
    );
    final card = tester.getRect(find.byType(AppProgressCard));
    final progress = tester.getRect(find.byKey(const Key('progress')));
    expect(card.bottom - progress.bottom, closeTo(AppSpacing.contentGap, .01));
    expect(card.height, lessThan(600));
    expect(tester.takeException(), isNull);
  });
}
