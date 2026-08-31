import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('showAppConfirmDialog', () {
    testWidgets('resolves true on confirm', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => AppButton.primary(
              label: 'open',
              onPressed: () async {
                result = await showAppConfirmDialog(
                  context,
                  title: 'Удалить?',
                  message: 'Это действие необратимо',
                  confirmLabel: 'Удалить',
                  cancelLabel: 'Отмена',
                  destructive: true,
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Удалить?'), findsOneWidget);
      expect(find.text('Это действие необратимо'), findsOneWidget);
      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('resolves false on cancel and on barrier dismiss', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => AppButton.primary(
              label: 'open',
              onPressed: () async {
                result = await showAppConfirmDialog(
                  context,
                  title: 'T',
                  confirmLabel: 'Да',
                  cancelLabel: 'Нет',
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Нет'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });

  group('AppButton loading', () {
    testWidgets('shows spinner and blocks taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          AppButton.primary(
            label: 'Сохранить',
            loading: true,
            onPressed: () => taps++,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(taps, 0);
    });
  });

  group('AppFab', () {
    testWidgets('renders extended label with null heroTag', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppFab.extended(
            icon: AppLineIcon.plus,
            label: 'Создать',
            onPressed: () {},
          ),
        ),
      );
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.heroTag, isNull);
      expect(find.text('Создать'), findsOneWidget);
    });
  });
}
