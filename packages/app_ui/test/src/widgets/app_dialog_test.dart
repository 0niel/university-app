import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget host(Future<void> Function(BuildContext) onTap) => wrapKit(
        Builder(
          builder: (context) => AppPressable(
            onTap: () => onTap(context),
            child: const Text('open'),
          ),
        ),
      );

  group('showAppConfirmDialog', () {
    testWidgets('resolves true on confirm and renders the icon', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        host(
          (context) async {
            result = await showAppConfirmDialog(
              context,
              title: 'Удалить?',
              message: 'Это действие необратимо',
              confirmLabel: 'Удалить',
              cancelLabel: 'Отмена',
              destructive: true,
              icon: const AppLineIconWidget(AppLineIcon.trash),
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Удалить?'), findsOneWidget);
      expect(find.text('Это действие необратимо'), findsOneWidget);
      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);

      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      bool? result;
      await tester.pumpWidget(
        host(
          (context) async {
            result = await showAppConfirmDialog(
              context,
              title: 'T',
              confirmLabel: 'Да',
              cancelLabel: 'Нет',
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Нет'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });

  group('showAppDialog', () {
    testWidgets('wraps custom content in a canvas r28 card', (tester) async {
      await tester.pumpWidget(
        host(
          (context) => showAppDialog<void>(
            context,
            builder: (_) => const Padding(
              padding: EdgeInsets.all(20),
              child: Text('custom'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('custom'), findsOneWidget);

      final card = kitDecoration(
        tester,
        find
            .ancestor(
              of: find.text('custom'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(card.color, kitColors.canvas);
      expect(card.borderRadius, BorderRadius.circular(AppRadius.dialog));
    });
  });
}
