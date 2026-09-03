import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppTag', () {
    testWidgets('renders the label and an optional leading dot',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppTag(
            label: 'Идёт',
            tone: AppTagTone.live,
            leading: AppLiveDot(),
          ),
        ),
      );

      expect(find.text('Идёт'), findsOneWidget);
      expect(tester.getSize(find.byType(AppLiveDot)), const Size(6, 6));
    });

    testWidgets('every tone builds', (tester) async {
      for (final tone in AppTagTone.values) {
        await tester.pumpWidget(wrap(AppTag(label: tone.name, tone: tone)));
        expect(find.text(tone.name), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('long scaled labels wrap within available width',
        (tester) async {
      for (final dark in [false, true]) {
        for (final hasLeading in [false, true]) {
          await tester.pumpWidget(
            wrapKit(
              SizedBox(
                key: const ValueKey('tag-bounds'),
                width: 248,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppTag(
                    label: 'заявка отправлена',
                    leading: hasLeading ? const AppLiveDot() : null,
                  ),
                ),
              ),
              dark: dark,
              textScale: 2,
            ),
          );
          expect(tester.takeException(), isNull);
          final bounds =
              tester.getRect(find.byKey(const ValueKey('tag-bounds')));
          final tag = tester.getRect(find.byType(AppTag));
          expect(tag.left, greaterThanOrEqualTo(bounds.left));
          expect(tag.right, lessThanOrEqualTo(bounds.right));
          expect(
            tester.getSize(find.text('заявка отправлена')).height,
            greaterThan(AppText.badge.fontSize! * 2 * AppText.badge.height!),
          );
          expect(
            tester.getSemantics(find.text('заявка отправлена')).label,
            'заявка отправлена',
          );
        }
      }
    });

    testWidgets('compact tags retain intrinsic geometry in an unbounded row',
        (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [AppTag(label: 'Идёт'), Text('Рядом')],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final labelSize = tester.getSize(find.text('Идёт'));
      final tagSize = tester.getSize(find.byType(AppTag));
      expect(
        tagSize.width,
        closeTo(labelSize.width + AppSpacing.badgeInset * 2, .001),
      );
      expect(
        tagSize.height,
        closeTo(labelSize.height + AppSpacing.fine * 2, .001),
      );
    });
  });
}
