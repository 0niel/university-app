import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget host(Widget child, {double scale = 1, bool rtl = false}) => wrapKit(
        Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: SizedBox(width: 320, child: child),
        ),
        textScale: scale,
      );

  Finder circle() => find.descendant(
        of: find.byType(AppHeaderCircleButton),
        matching: find.byType(Container),
      );

  testWidgets('42px header layout retains a real 44px target in its padding', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        AppScreenHeader(
          title: 'UI',
          actions: [
            AppHeaderAction(
              icon: AppLineIcon.tune,
              semanticsLabel: 'Настройки',
              onTap: () => taps++,
            ),
          ],
        ),
      ),
    );
    final header = tester.getRect(find.byType(AppScreenHeader));
    final visual = tester.getRect(circle());
    final target = tester.getRect(find.byType(AppHeaderCircleButton));
    expect(header.height, 98);
    expect(visual.size, const Size.square(42));
    expect(visual.top - header.top, 56);
    expect(target.size, const Size.square(44));
    expect(header.contains(target.topLeft), isTrue);
    expect(header.contains(target.bottomRight - const Offset(.1, .1)), isTrue);
    final node = tester.getSemantics(find.byType(AppHeaderCircleButton));
    expect(node.rect.size, const Size.square(44));
    await tester.tapAt(target.topLeft + const Offset(.5, .5));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('notification badge is anchored to the circle not the icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        AppScreenHeader(
          title: 'UI',
          actions: [
            AppHeaderAction(icon: AppLineIcon.bell, badge: true, onTap: () {}),
          ],
        ),
      ),
    );
    final visual = tester.getRect(circle());
    final badge = tester.getRect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 7 && widget.height == 7,
      ),
    );
    expect(badge.center.dx, greaterThan(visual.center.dx));
    expect(badge.center.dy, lessThan(visual.center.dy));
    expect(badge.right, closeTo(visual.right - 42 * .18, .01));
    expect(badge.top, closeTo(visual.top + 42 * .18, .01));
    expect(tester.takeException(), isNull);
  });

  for (final rtl in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
          'inner header adapts its trailing label scale=$scale rtl=$rtl',
          (tester) async {
        var taps = 0;
        await tester.pumpWidget(
          host(
            AppInnerHeader(
              title: 'Контроль',
              trailingLabel: 'сессия через 12 дн',
              onBack: () {},
              onTrailingLabelTap: () => taps++,
            ),
            scale: scale,
            rtl: rtl,
          ),
        );
        expect(tester.takeException(), isNull);
        final target = find.ancestor(
          of: find.text('сессия через 12 дн'),
          matching: find.byType(AppPressable),
        );
        expect(tester.getSize(target).height, greaterThanOrEqualTo(44));
        expect(tester.getSize(target).width, greaterThanOrEqualTo(44));
        await tester.tap(target);
        expect(taps, 1);
      });
    }
    testWidgets('header actions stay separate at 200 percent rtl=$rtl', (
      tester,
    ) async {
      final taps = [0, 0];
      await tester.pumpWidget(
        host(
          AppScreenHeader(
            title: 'Длинный заголовок',
            subtitle: 'Описание экрана',
            actions: [
              for (var index = 0; index < 2; index++)
                AppHeaderAction(
                  icon: AppLineIcon.bell,
                  semanticsLabel: '$index',
                  onTap: () => taps[index]++,
                ),
            ],
          ),
          scale: 2,
          rtl: rtl,
        ),
      );
      final first = tester.getRect(find.byType(AppHeaderCircleButton).first);
      final last = tester.getRect(find.byType(AppHeaderCircleButton).last);
      expect(first.overlaps(last), isFalse);
      expect(first.size, const Size.square(44));
      for (final target in [first, last]) {
        await tester.tapAt(target.center);
      }
      expect(taps, [1, 1]);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('header with no padding safely reserves its minimum target', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        AppScreenHeader(
          title: 'Экран',
          padding: EdgeInsets.zero,
          actions: [AppHeaderAction(icon: AppLineIcon.bell, onTap: () {})],
        ),
      ),
    );
    expect(tester.getSize(find.byType(AppScreenHeader)).height, 44);
    expect(tester.getSize(find.byType(AppHeaderCircleButton)).height, 44);
    expect(tester.takeException(), isNull);
  });

  testWidgets('section title keeps its 33px baseline row and 44px hit area', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        AppSectionTitle(
          title: 'Достижения',
          action: 'Все',
          topMargin: 28,
          bottomPadding: 14,
          onActionTap: () => taps++,
        ),
      ),
    );
    final section = tester.getRect(find.byType(AppSectionTitle));
    final target = tester.getRect(find.byType(AppPressable));
    final label = tester.getRect(find.text('Все'));
    expect(section.height, 75);
    expect(target.height, 44);
    expect(target.width, greaterThanOrEqualTo(44));
    expect(target.contains(label.center), isTrue);
    expect(tester.getSemantics(find.byType(AppPressable)).rect.height, 44);
    double baseline(String text) {
      final finder = find.text(text);
      final box = tester.renderObject<RenderBox>(finder);
      return tester.getTopLeft(finder).dy +
          box.getDryBaseline(box.constraints, TextBaseline.alphabetic)!;
    }

    expect(baseline('Все'), closeTo(baseline('Достижения'), .01));
    await tester.tapAt(target.topLeft + const Offset(1, 1));
    expect(taps, 1);
    await tester.tap(find.text('Все'));
    expect(taps, 2);
    expect(tester.takeException(), isNull);
  });

  for (final margins in [0.0, 28.0]) {
    testWidgets('section action works at 200 percent with margins=$margins', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          AppSectionTitle(
            title: 'Достижения университета',
            subtitle: 'Подробности',
            action: 'Все достижения',
            topMargin: margins,
            bottomPadding: margins,
            onActionTap: () => taps++,
          ),
          scale: 2,
        ),
      );
      final target = tester.getRect(find.byType(AppPressable));
      expect(target.height, greaterThanOrEqualTo(44));
      expect(
        target.contains(tester.getCenter(find.text('Все достижения'))),
        isTrue,
      );
      await tester.tap(find.text('Все достижения'));
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
