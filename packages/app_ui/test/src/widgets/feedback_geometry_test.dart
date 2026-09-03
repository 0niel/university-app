import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  test('avatar initials preserve unicode grapheme clusters', () {
    expect(AppAvatar.initialsOf('👩🏽‍💻 Иванова'), '👩🏽‍💻И');
    expect(AppAvatar.initialsOf('А\u0301нна Иванова'), 'А\u0301И');
  });

  testWidgets('action banner announces message and action', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppBanner(
          message: 'Неверный код',
          actionLabel: 'Повторить',
          onAction: () {},
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppBanner)).label,
      contains('Неверный код'),
    );
    expect(
      tester.getSemantics(find.byType(AppBanner)).label,
      contains('Повторить'),
    );
  });
  for (final legacy in [false, true]) {
    testWidgets('ring uses reference radius27 and no zero-value cap $legacy',
        (tester) async {
      await tester.pumpWidget(
        wrapKit(
          legacy
              ? const NinjaProgressRing(value: 0)
              : const AppProgressRing(value: 0),
        ),
      );
      final painter = tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(AppProgressRing),
              matching: find.byType(CustomPaint),
            ),
          )
          .painter!;
      final recorder = ui.PictureRecorder();
      painter.paint(Canvas(recorder), const Size(64, 64));
      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(64, 64);
        final bytes = (await image.toByteData())!;
        int channel(int x, int y, int c) =>
            bytes.getUint8((y * 64 + x) * 4 + c);
        expect(channel(32, 0, 3), 0);
        expect(channel(32, 1, 3), 0);
        expect(channel(32, 4, 3), 255);
        expect(channel(32, 4, 0), (kitColors.surface2.toARGB32() >> 16) & 255);
        expect(channel(32, 9, 3), 0);
        image.dispose();
      });
      picture.dispose();
    });
  }

  testWidgets('ring label is exactly14 at64px', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const AppProgressRing(value: .66, label: '66%'),
      ),
    );
    expect(kitStyleOf(tester, '66%')?.fontSize, 14);
  });

  testWidgets('busy hatch uses135deg and5px perpendicular period',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 40,
          child: AppWeekGridCell(variant: AppWeekGridCellVariant.busy),
        ),
      ),
    );
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(AppWeekGridCell),
            matching: find.byWidgetPredicate(
              (widget) => widget is CustomPaint && widget.painter != null,
            ),
          ),
        )
        .painter!;
    final recorder = ui.PictureRecorder();
    painter.paint(Canvas(recorder), const Size(40, 40));
    final picture = recorder.endRecording();
    await tester.runAsync(() async {
      final image = await picture.toImage(40, 40);
      final bytes = (await image.toByteData())!;
      int alpha(int x, int y) => bytes.getUint8((y * 40 + x) * 4 + 3);
      expect(alpha(1, 1), 0);
      expect(alpha(3, 3), greaterThan(0));
      expect(alpha(5, 1), closeTo(alpha(1, 5), 2));
      expect(alpha(0, 0), alpha(7, 0));
      expect(alpha(0, 0), alpha(14, 0));
      image.dispose();
    });
    picture.dispose();
  });

  for (final dark in [false, true]) {
    testWidgets('feedback states remain readable at200percent $dark',
        (tester) async {
      const action = 'Просмотреть все изменения';
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBanner(
                  message: 'Показаны сохранённые данные',
                  actionLabel: action,
                  onAction: () {},
                ),
                AppToast(
                  message: 'Обновление сохранено',
                  actionLabel: action,
                  onAction: () {},
                ),
                const AppCountBadge(999),
              ],
            ),
          ),
          dark: dark,
          textScale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text(action), findsNWidgets(2));
    });
    testWidgets('tinted dot badge uses ink text $dark', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const AppBadge(label: 'Перенос', tone: AppBadgeTone.warn, dot: true),
          dark: dark,
        ),
      );
      expect(
        kitStyleOf(tester, 'Перенос')?.color,
        dark ? AppColors.dark.ink : kitColors.ink,
      );
    });
  }

  testWidgets('toast action is40px inside44px target and64px surface',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppToast(
            message: 'Дедлайн скрыт',
            showIcon: false,
            actionLabel: 'Вернуть',
            onAction: () {},
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(AppToast)).height, 64);
    expect(tester.getSize(find.byType(AppPressable)).height, 44);
    expect(
      tester
          .getSize(
            find
                .ancestor(
                  of: find.text('Вернуть'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .height,
      40,
    );
  });
}
