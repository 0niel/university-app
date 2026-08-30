import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(void Function(BuildContext context) onTap) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: GestureDetector(
                onTap: () => onTap(context),
                child: const Text('открыть'),
              ),
            ),
          ),
        ),
      );

  group('NinjaDialog', () {
    testWidgets('renders title, body and two actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: const Scaffold(
            body: Center(
              child: NinjaDialog(
                title: 'Выйти из аккаунта?',
                message: 'Оффлайн-пропуск перестанет работать.',
                cancelLabel: 'Отмена',
                confirmLabel: 'Выйти',
                destructive: true,
              ),
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Выйти из аккаунта?')).style;
      expect(title?.fontSize, 17);
      expect(title?.fontWeight, FontWeight.w700);

      final body = tester
          .widget<Text>(find.text('Оффлайн-пропуск перестанет работать.'))
          .style;
      expect(body?.fontSize, 13.5);
      expect(body?.height, 1.4);
      expect(body?.color, colors.mutedDark);

      expect(find.byType(NinjaActionButton), findsNWidgets(2));
      final confirm = tester.widget<NinjaActionButton>(
        find.widgetWithText(NinjaActionButton, 'Выйти'),
      );
      expect(confirm.tone, NinjaActionTone.scarlet);
      final cancel = tester.widget<NinjaActionButton>(
        find.widgetWithText(NinjaActionButton, 'Отмена'),
      );
      expect(cancel.tone, NinjaActionTone.surface);
      final cancelDecoration = tester.widget<Container>(
        find.descendant(
          of: find.widgetWithText(NinjaActionButton, 'Отмена'),
          matching: find.byType(Container),
        ),
      );
      expect(
        (cancelDecoration.decoration! as BoxDecoration).color,
        colors.surfaceAlt,
      );
    });

    testWidgets('stays flat without a border or shadow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.dark(),
          home: const Scaffold(
            body: Center(child: NinjaDialog(title: 'Тёмный')),
          ),
        ),
      );

      final box = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(NinjaDialog),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .firstWhere(
            (value) =>
                value.borderRadius == BorderRadius.circular(NinjaRadius.dialog),
          );
      expect(box.boxShadow, isNull);
      expect(box.border, isNull);
    });

    testWidgets('actions stack at 320px and 200 percent text', (tester) async {
      tester.view
        ..physicalSize = const Size(320, 568)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => GestureDetector(
                onTap: () => showNinjaDialog<void>(
                  context,
                  builder: (_) => const NinjaDialog(
                    title: 'Удалить сохранённое расписание?',
                    message: 'Это действие нельзя будет отменить.',
                    cancelLabel: 'Оставить расписание',
                    confirmLabel: 'Удалить расписание',
                    destructive: true,
                  ),
                ),
                child: const Text('открыть'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('открыть'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final button in tester.widgetList<NinjaActionButton>(
        find.byType(NinjaActionButton),
      )) {
        expect(button.expanded, isTrue);
      }
    });
  });

  group('showNinjaConfirmDialog', () {
    testWidgets('resolves true on confirm', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap((context) async {
          result = await showNinjaConfirmDialog(
            context,
            title: 'Удалить напоминание?',
            message: 'Отменить будет нельзя.',
            confirmLabel: 'Удалить',
            cancelLabel: 'Отмена',
            destructive: true,
          );
        }),
      );

      await tester.tap(find.text('открыть'));
      await tester.pumpAndSettle();
      expect(find.text('Удалить напоминание?'), findsOneWidget);

      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap((context) async {
          result = await showNinjaConfirmDialog(
            context,
            title: 'Выйти?',
            confirmLabel: 'Выйти',
            cancelLabel: 'Отмена',
          );
        }),
      );

      await tester.tap(find.text('открыть'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });

    testWidgets('resolves false when the barrier is tapped', (tester) async {
      bool? result;
      await tester.pumpWidget(
        wrap((context) async {
          result = await showNinjaConfirmDialog(
            context,
            title: 'Выйти?',
            confirmLabel: 'Выйти',
            cancelLabel: 'Отмена',
          );
        }),
      );

      await tester.tap(find.text('открыть'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(result, isFalse);
      expect(find.text('Выйти?'), findsNothing);
    });
  });
}
