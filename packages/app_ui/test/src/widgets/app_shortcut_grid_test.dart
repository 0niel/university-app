import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final (width, scale, columns) in [
    (350.0, 1.0, 5),
    (280.0, 1.0, 3),
    (320.0, 2.0, 3),
  ]) {
    testWidgets('shortcut grid preserves actions at $width px, text $scale', (
      tester,
    ) async {
      tester.view
        ..physicalSize = Size(width, 700)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var loading = false;
      int? picked;
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              disableAnimations: true,
            ),
            child: child!,
          ),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return AppShortcutGrid(
                  children: [
                    for (var index = 0; index < 5; index++)
                      if (loading)
                        AppServiceTile.skeleton(key: ValueKey('action-$index'))
                      else
                        AppServiceTile.compact(
                          key: ValueKey('action-$index'),
                          icon: const AppLineIconWidget(AppLineIcon.map),
                          color: Colors.blue,
                          label: '${index + 1}',
                          semanticsLabel: 'Action ${index + 1}',
                          onTap: () => picked = index,
                        ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bounds = [
        for (var index = 0; index < 5; index++)
          tester.getRect(find.byKey(ValueKey('action-$index'))),
      ];
      for (var index = 0; index < 5; index++) {
        expect(bounds[index].left, greaterThanOrEqualTo(0));
        expect(bounds[index].right, lessThanOrEqualTo(width));
        if (index < columns) {
          expect(bounds[index].top, bounds.first.top);
        } else {
          expect(bounds[index].top, greaterThan(bounds.first.bottom));
        }
        await tester.tap(find.byKey(ValueKey('action-$index')));
        expect(picked, index);
      }
      expect(
        bounds[1].left - bounds[0].right,
        closeTo(AppSpacing.sm, .001),
      );
      if (columns < 5) {
        expect(
          bounds[3].top - bounds[0].bottom,
          closeTo(AppSpacing.md, .001),
        );
      }
      rebuild(() => loading = true);
      await tester.pumpAndSettle();
      for (var index = 0; index < 5; index++) {
        final skeleton = tester.getRect(find.byKey(ValueKey('action-$index')));
        expect(skeleton.left, bounds[index].left);
        expect(skeleton.width, bounds[index].width);
      }
      expect(find.byType(AppServiceTile), findsNWidgets(5));
      expect(tester.takeException(), isNull);
    });
  }
}
