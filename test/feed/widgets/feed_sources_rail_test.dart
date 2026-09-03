import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  const source = FeedSourceRailItem(
    id: 'source:telegram:rtumirea_official',
    name: 'РТУ МИРЭА',
    abbr: 'РМ',
  );

  testWidgets('source rail renders source names', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: FeedSourcesRail(
          items: const [source],
          selectedId: '',
          onSelected: (_) {},
        ),
      ),
    );
    expect(find.text('РТУ МИРЭА'), findsOneWidget);
  });

  testWidgets('source tap returns the exact source identity', (tester) async {
    FeedSourceRailItem? selected;
    await tester.pumpApp(
      Scaffold(
        body: FeedSourcesRail(
          items: const [source],
          selectedId: '',
          onSelected: (value) => selected = value,
        ),
      ),
    );
    await tester.tap(find.text('РТУ МИРЭА'));
    expect(selected, same(source));
  });

  testWidgets('empty sources have no fabricated source labels', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: FeedSourcesRail(
          items: const [],
          selectedId: '',
          onSelected: (_) {},
        ),
      ),
    );
    expect(find.text('РТУ МИРЭА'), findsNothing);
    expect(find.byType(AppPressState), findsNothing);
  });

  testWidgets('source circles remain accessible at 320px and 200 percent', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: FeedSourcesRail(
          items: const [source],
          selectedId: source.id,
          onSelected: (_) {},
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
    final semantics = find.bySemanticsLabel(source.name);
    expect(tester.getSize(semantics).height, greaterThanOrEqualTo(44));
    expect(
      tester.getSemantics(semantics).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('loader is a single shared spatial skeleton', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: SingleChildScrollView(child: FeedLoaderItem())),
    );
    expect(find.byType(FeedListSkeleton), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
  });
}
