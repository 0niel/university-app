import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({required Future<void> Function(BuildContext) onTap}) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> open(
    WidgetTester tester, {
    String? title,
    String? subtitle,
    bool showClose = true,
    bool showGrabber = true,
    Widget child = const Text('sheet body'),
  }) async {
    await tester.pumpWidget(
      host(
        onTap: (context) => showAppSheet<void>(
          context,
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          showGrabber: showGrabber,
          child: child,
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('showAppSheet', () {
    testWidgets('shows grabber, title, subtitle, close and content',
        (tester) async {
      await open(tester, title: 'Экспорт', subtitle: 'Куда угодно');

      expect(find.text('Экспорт'), findsOneWidget);
      expect(find.text('Куда угодно'), findsOneWidget);
      expect(find.text('sheet body'), findsOneWidget);
      expect(find.byType(AppSheetCloseButton), findsOneWidget);
      expect(
        tester.getSize(find.byType(AppSheetCloseButton)),
        const Size(44, 44),
      );
    });

    testWidgets('uses the design top radius of 32', (tester) async {
      await open(tester, title: 'Радиус');

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppSheet),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(
        material.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(32)),
      );
    });

    testWidgets('the grabber is a line-colored pill', (tester) async {
      await open(tester, title: 'Граббер');

      final colors = AppTheme.darkTheme.extension<AppColors>()!;
      final grabber = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AppSheet),
              matching: find.byType(Container),
            ),
          )
          .firstWhere(
            (container) => container.constraints?.maxWidth == 40,
          );
      final decoration = grabber.decoration! as BoxDecoration;
      expect(decoration.color, colors.divider);
      expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));
    });

    testWidgets('close button pops the sheet', (tester) async {
      await open(tester, title: 'Закрыть');
      expect(find.text('sheet body'), findsOneWidget);

      await tester.tap(find.byType(AppSheetCloseButton));
      await tester.pumpAndSettle();

      expect(find.text('sheet body'), findsNothing);
    });

    testWidgets('renders a bare sheet without header when title is null',
        (tester) async {
      await open(tester, showGrabber: false);

      expect(find.text('sheet body'), findsOneWidget);
      expect(find.byType(AppSheetTitle), findsNothing);
      expect(find.byType(AppSheetCloseButton), findsNothing);
    });

    testWidgets('returns the value passed to Navigator.pop', (tester) async {
      Object? result;
      await tester.pumpWidget(
        host(
          onTap: (context) async {
            result = await showAppSheet<String>(
              context,
              title: 'Выбор',
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).pop('picked'),
                  child: const Text('pick'),
                ),
              ),
            );
          },
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();

      expect(result, 'picked');
    });
  });
}
