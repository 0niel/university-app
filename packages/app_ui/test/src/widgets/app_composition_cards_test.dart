import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  for (final sample in [
    (width: 280.0, scale: 1.0, columns: 1),
    (width: 340.0, scale: 1.0, columns: 2),
    (width: 660.0, scale: 1.0, columns: 3),
    (width: 940.0, scale: 1.0, columns: 4),
    (width: 940.0, scale: 2.0, columns: 1),
  ]) {
    testWidgets('adaptive grid fits ${sample.width}/${sample.scale}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: sample.width,
            child: AppAdaptiveGrid(
              children: [
                for (final (index, height) in [20.0, 60.0, 30.0, 40.0].indexed)
                  SizedBox(key: ValueKey(index), height: height),
              ],
            ),
          ),
          textScale: sample.scale,
          accessibleNavigation: true,
        ),
      );
      final first = tester.getRect(find.byKey(const ValueKey(0)));
      final second = tester.getRect(find.byKey(const ValueKey(1)));
      expect(
        first.width,
        closeTo(
          (sample.width - (sample.columns - 1) * 10) / sample.columns,
          .01,
        ),
      );
      if (sample.columns == 1) {
        expect(second.top - first.bottom, 10);
      } else {
        expect(first.top, second.top);
        expect(first.height, second.height);
        expect(second.left - first.right, 10);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('action tile keeps trailing action independent of opening', (
    tester,
  ) async {
    var opened = 0;
    var toggled = 0;
    var held = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 340,
          child: AppActionTile(
            leading: const AppIconTile(icon: AppLineIcon.book),
            title: const Text('Library'),
            subtitle: const Text('Books and materials'),
            trailing: AppIconButton(
              key: const ValueKey('pin'),
              icon: const AppLineIconWidget(AppLineIcon.star),
              onPressed: () => toggled++,
            ),
            onTap: () => opened++,
            onLongPress: () => held++,
          ),
        ),
        accessibleNavigation: true,
      ),
    );
    await tester.tap(find.byKey(const ValueKey('pin')));
    expect(toggled, 1);
    expect(opened, 0);
    await tester.tap(find.text('Library'));
    expect(opened, 1);
    await tester.longPress(find.text('Library'));
    expect(held, 1);
    expect(opened, 1);
    expect(
      kitStyleOf(tester, 'Library')!.fontSize,
      AppText.headlineStrong.fontSize,
    );
  });

  testWidgets('large action labels remain complete and scrollable', (
    tester,
  ) async {
    const title = 'A complete long action title with important details';
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            child: AppActionTile(
              leading: const AppIconTile(icon: AppLineIcon.book),
              title: const Text(title),
              subtitle: const Text('Additional information stays readable'),
              trailing: const AppLineIconWidget(AppLineIcon.chevronR),
              onTap: () {},
            ),
          ),
        ),
        textScale: 2,
        accessibleNavigation: true,
      ),
    );
    expect(
      DefaultTextStyle.of(tester.element(find.text(title))).maxLines,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'bento cards stay compact with two-line titles and edit targets',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 160,
            child: AppActionTile(
              leading: const AppIconTile(
                icon: AppLineIcon.book,
                size: AppControlSize.iconTileCompact,
              ),
              title: const Text('A useful campus service'),
              subtitle: const Text('Additional information'),
              trailing: AppIconButton(
                key: const ValueKey('compact-pin'),
                icon: const AppLineIconWidget(AppLineIcon.star),
                size: AppIconButtonSize.small,
                onPressed: () {},
              ),
            ),
          ),
          accessibleNavigation: true,
        ),
      );
      final card = tester.getSize(find.byType(AppActionTile));
      final target = tester.getSize(find.byKey(const ValueKey('compact-pin')));
      expect(card.height, lessThanOrEqualTo(130));
      expect(target.width, greaterThanOrEqualTo(44));
      expect(target.height, greaterThanOrEqualTo(44));
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets('compact feature preserves complete large text at $scale', (
      tester,
    ) async {
      const title = 'Campus mini apps';
      const subtitle = 'Helpful services for every day';
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 280,
            child: SingleChildScrollView(
              child: AppFeatureCard(
                leading: AppIconTile(
                  icon: AppLineIcon.book,
                  size: AppControlSize.iconTileMedium,
                ),
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: AppLineIconWidget(AppLineIcon.chevronR),
              ),
            ),
          ),
          textScale: scale,
          accessibleNavigation: true,
        ),
      );
      if (scale == 1) {
        expect(
          tester.getSize(find.byType(AppFeatureCard)).height,
          lessThanOrEqualTo(128),
        );
      } else {
        for (final label in [title, subtitle]) {
          final style = DefaultTextStyle.of(tester.element(find.text(label)));
          expect(style.maxLines, isNull);
          expect(style.overflow, TextOverflow.visible);
        }
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final identity in [false, true]) {
    final variant = identity ? 'identity' : 'standard';
    testWidgets('feature $variant shares typography and actions', (
      tester,
    ) async {
      var opened = 0;
      var edited = 0;
      const leading = SizedBox.square(dimension: 72);
      final trailing = AppIconButton(
        key: const ValueKey('edit'),
        icon: const AppLineIconWidget(AppLineIcon.pencil),
        onPressed: () => edited++,
      );
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 340,
            child: identity
                ? AppFeatureCard.identity(
                    title: const Text('Your space'),
                    subtitle: const Text('Connected services'),
                    leading: leading,
                    trailing: trailing,
                    onTap: () => opened++,
                  )
                : AppFeatureCard(
                    title: const Text('Your space'),
                    subtitle: const Text('Connected services'),
                    leading: leading,
                    trailing: trailing,
                    onTap: () => opened++,
                  ),
          ),
          accessibleNavigation: true,
        ),
      );
      expect(
        kitStyleOf(tester, 'Your space')!.fontSize,
        identity ? AppText.identityTitle.fontSize : AppText.section.fontSize,
      );
      expect(
        kitStyleOf(tester, 'Connected services')!.fontSize,
        identity ? AppText.body.fontSize : AppText.cardSubtitle.fontSize,
      );
      await tester.tap(find.byKey(const ValueKey('edit')));
      expect(edited, 1);
      expect(opened, 0);
      await tester.tap(find.text('Your space'));
      expect(opened, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('tile placeholders share intrinsic grid layout at large scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 280,
          child: SingleChildScrollView(
            child: NinjaSkeletonGroup(
              child: AppAdaptiveGrid(
                children: [AppActionTile.skeleton(), AppActionTile.skeleton()],
              ),
            ),
          ),
        ),
        textScale: 2,
        accessibleNavigation: true,
      ),
    );
    expect(find.byType(AppActionTile), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('skeleton text matches wrapped metrics without exposing sample', (
    tester,
  ) async {
    const sample = 'A localized title that needs multiple lines';
    final semantics = tester.ensureSemantics();
    Widget frame(Widget child) => wrapKit(
      SizedBox(
        width: 130,
        child: SingleChildScrollView(
          child: DefaultTextStyle(style: AppText.section, child: child),
        ),
      ),
      textScale: 2,
      accessibleNavigation: true,
    );
    await tester.pumpWidget(frame(const AppSkeletonText(sample: sample)));
    final height = tester.getSize(find.byType(AppSkeletonText)).height;
    expect(find.bySemanticsLabel(sample), findsNothing);
    await tester.pumpWidget(frame(const Text(sample)));
    expect(height, closeTo(tester.getSize(find.text(sample)).height, .01));
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
