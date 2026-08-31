import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();
  const duration = Duration(seconds: 1);
  const settle = Duration(milliseconds: 300);

  Widget host(void Function(BuildContext context) onReady) => MaterialApp(
        theme: NinjaTheme.light(),
        home: NinjaToastHost(
          child: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: GestureDetector(
                  onTap: () => onReady(context),
                  child: const Text('запустить'),
                ),
              ),
            ),
          ),
        ),
      );

  testWidgets('NinjaToast renders the lime check and inverse copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        home: const Scaffold(
          body: Center(child: NinjaToast(message: 'Отчёт загружен · +50 XP')),
        ),
      ),
    );

    final style =
        tester.widget<Text>(find.text('Отчёт загружен · +50 XP')).style;
    expect(style?.fontSize, 13.5);
    expect(style?.fontWeight, FontWeight.w600);
    expect(style?.color, colors.onInk);

    final glyph = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(glyph.icon, AppLineIcon.check);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(NinjaToast),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, colors.ink);
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('stays flat in dark', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.dark(),
        home: const Scaffold(body: Center(child: NinjaToast(message: 'Тост'))),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(NinjaToast),
        matching: find.byType(Container),
      ),
    );
    expect((container.decoration! as BoxDecoration).boxShadow, isNull);
  });

  testWidgets('host shows queued toasts one at a time', (tester) async {
    await tester.pumpWidget(
      host((context) {
        showNinjaToast(context, message: 'Первый', duration: duration);
        showNinjaToast(context, message: 'Второй', duration: duration);
      }),
    );

    await tester.tap(find.text('запустить'));
    await tester.pump();
    expect(find.text('Первый'), findsOneWidget);
    expect(find.text('Второй'), findsNothing);

    await tester.pump(duration);
    await tester.pump(settle);
    expect(find.text('Первый'), findsNothing);
    expect(find.text('Второй'), findsOneWidget);

    await tester.pump(duration);
    await tester.pump(settle);
    expect(find.text('Второй'), findsNothing);
  });

  testWidgets('hosted toast clears the outer fallback text decoration', (
    tester,
  ) async {
    late BuildContext toastContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        builder: (context, child) => DefaultTextStyle(
          style: const TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.yellow,
            decorationStyle: TextDecorationStyle.double,
          ),
          child: NinjaToastHost(child: child!),
        ),
        home: Builder(
          builder: (context) {
            toastContext = context;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );

    showNinjaToast(toastContext, message: 'Готово');
    await tester.pump();

    final finder = find.text('Готово');
    final text = tester.widget<Text>(finder);
    final inherited = DefaultTextStyle.of(tester.element(finder)).style;
    expect(inherited.merge(text.style).decoration, TextDecoration.none);
  });

  testWidgets('action dismisses the toast and fires the callback', (
    tester,
  ) async {
    var undone = 0;
    await tester.pumpWidget(
      host(
        (context) => showNinjaToast(
          context,
          message: 'Напоминание удалено',
          showCheck: false,
          actionLabel: 'Вернуть',
          onAction: () => undone++,
          duration: const Duration(seconds: 5),
        ),
      ),
    );

    await tester.tap(find.text('запустить'));
    await tester.pump();
    await tester.pump(settle);
    expect(find.byType(AppLineIconWidget), findsNothing);

    final actionSize = tester.getSize(
      find
          .ancestor(
            of: find.text('Вернуть'),
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
    expect(actionSize.width, greaterThanOrEqualTo(44));
    expect(actionSize.height, greaterThanOrEqualTo(44));
    expect(
      tester.getSemantics(find.text('Вернуть')).flagsCollection.isButton,
      isTrue,
    );

    await tester.tap(find.text('Вернуть'));
    await tester.pump();
    await tester.pump(settle);
    expect(undone, 1);
    expect(find.text('Напоминание удалено'), findsNothing);
  });

  testWidgets('throws without a host above the context', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        home: Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(
      () => showNinjaToast(ctx, message: 'нет хоста'),
      throwsA(isA<FlutterError>()),
    );
  });

  testWidgets('stacks the action without overflow at 320px and 200% text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(320, 568),
            textScaler: TextScaler.linear(2),
          ),
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: NinjaToast(
                message: 'Расписание обновлено и готово к просмотру',
                actionLabel: 'Открыть',
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final actionTop = tester.getTopLeft(find.text('Открыть')).dy;
    final messageBottom = tester
        .getBottomLeft(
          find.text('Расписание обновлено и готово к просмотру'),
        )
        .dy;
    expect(actionTop, greaterThan(messageBottom));
  });

  testWidgets('accessible navigation presents and dismisses without motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(accessibleNavigation: true),
        child: host(
          (context) => showNinjaToast(
            context,
            message: 'Готово',
            duration: duration,
          ),
        ),
      ),
    );

    await tester.tap(find.text('запустить'));
    await tester.pump();
    expect(find.text('Готово'), findsOneWidget);

    await tester.pump(duration);
    expect(find.text('Готово'), findsNothing);
  });

  testWidgets('accessible action remains until it is used', (tester) async {
    var actions = 0;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(accessibleNavigation: true),
        child: host(
          (context) => showNinjaToast(
            context,
            message: 'Изменения сохранены',
            actionLabel: 'Вернуть',
            onAction: () => actions++,
            duration: duration,
          ),
        ),
      ),
    );

    await tester.tap(find.text('запустить'));
    await tester.pump(duration * 2);
    expect(find.text('Изменения сохранены'), findsOneWidget);

    await tester.tap(find.text('Вернуть'));
    await tester.pump();
    expect(actions, 1);
    expect(find.text('Изменения сохранены'), findsNothing);
  });

  testWidgets('hidden action does not leave an accessible toast forever', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(accessibleNavigation: true),
        child: host(
          (context) => showNinjaToast(
            context,
            message: 'Готово',
            onAction: () {},
            duration: duration,
          ),
        ),
      ),
    );

    await tester.tap(find.text('запустить'));
    await tester.pump(duration);

    expect(find.text('Готово'), findsNothing);
  });
}
