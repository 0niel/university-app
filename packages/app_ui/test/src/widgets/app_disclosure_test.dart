import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('announces expansion and mounts content only when opened', (
    tester,
  ) async {
    var builds = 0;
    final changes = <bool>[];
    await tester.pumpWidget(
      wrapKit(
        AppDisclosure(
          title: 'Фотографии',
          onExpansionChanged: changes.add,
          child: Builder(
            builder: (_) {
              builds++;
              return const Text('Галерея');
            },
          ),
        ),
      ),
    );
    final header = find.byType(MergeSemantics);
    var semantics = tester.getSemantics(header).getSemanticsData();
    expect(semantics.flagsCollection.isExpanded, ui.Tristate.isFalse);
    expect(semantics.hasAction(ui.SemanticsAction.tap), isTrue);
    expect(builds, 0);
    expect(find.text('Галерея'), findsNothing);

    tester.semantics.performAction(
      find.semantics.byLabel('Фотографии'),
      ui.SemanticsAction.tap,
    );
    await tester.pumpAndSettle();
    semantics = tester.getSemantics(header).getSemanticsData();
    expect(semantics.flagsCollection.isExpanded, ui.Tristate.isTrue);
    expect(builds, greaterThan(0));
    expect(find.text('Галерея'), findsOneWidget);
    await tester.tap(find.text('Фотографии'));
    await tester.pumpAndSettle();
    expect(find.text('Галерея'), findsNothing);
    expect(changes, [true, false]);
  });

  testWidgets('supports keyboard focus enter and space', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const AppDisclosure(title: 'Параметры', child: Text('Доступность')),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Доступность'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(find.text('Доступность'), findsNothing);
  });

  testWidgets('large text keeps the header and content action reachable', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SingleChildScrollView(
          child: AppListGroup(
            children: [
              AppDisclosure(
                title: 'Фотографии учебной аудитории',
                leading: const AppIconTile(icon: AppLineIcon.image),
                child: Column(
                  children: [
                    Text('Снимки помещения и его оснащения. ' * 12),
                    AppButton.secondary(
                      label: 'Добавить фотографию',
                      expanded: true,
                      onPressed: () => taps++,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        textScale: 2,
      ),
    );
    await tester.tap(find.text('Фотографии учебной аудитории'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(AppButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppButton));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion reveals content in one frame', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const AppDisclosure(
          title: 'Фотографии',
          child: SizedBox(height: 180, child: Text('Галерея')),
        ),
        accessibleNavigation: true,
      ),
    );
    final collapsed = tester.getSize(find.byType(AppDisclosure)).height;
    await tester.tap(find.text('Фотографии'));
    await tester.pump();
    final expanded = tester.getSize(find.byType(AppDisclosure)).height;
    expect(expanded, greaterThanOrEqualTo(collapsed + 180));
    await tester.pump(const Duration(milliseconds: 60));
    expect(tester.getSize(find.byType(AppDisclosure)).height, expanded);
    expect(tester.takeException(), isNull);
  });
}
