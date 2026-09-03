import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('hero follows image editorial card at large text', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: FeedHeroPost(
            title: 'Главная новость университета с длинным заголовком',
            source: 'Главное',
            meta: 'Сегодня',
            onTap: () {},
          ),
        ),
      ),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(Card), findsNothing);
    expect(tester.widget<AppCard>(find.byType(AppCard)).radius, AppRadius.hero);
    expect(tester.getSize(find.byType(FeedImage)).height, 190);
    expect(find.byType(AppStripePlaceholder), findsOneWidget);
  });

  testWidgets('hero actions trigger both callbacks', (tester) async {
    var first = false;
    var second = false;
    await tester.pumpApp(
      Scaffold(
        body: FeedHeroPost(
          title: 'Хакатон',
          meta: 'Сегодня',
          actionLabel: 'Записаться',
          onAction: () => first = true,
          secondaryActionLabel: 'В команду',
          onSecondaryAction: () => second = true,
        ),
      ),
    );
    await tester.tap(find.text('Записаться'));
    await tester.tap(find.text('В команду'));
    expect(first, isTrue);
    expect(second, isTrue);
  });

  testWidgets('news row is flat and navigable with a 72px image', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpApp(
      Scaffold(
        body: FeedPostRow(
          title: 'Новая лаборатория',
          meta: 'Сегодня',
          onTap: () => tapped = true,
        ),
      ),
    );
    expect(find.byType(Card), findsNothing);
    expect(tester.getSize(find.byType(FeedImage)), const Size(72, 72));
    await tester.tap(find.text('Новая лаборатория'));
    expect(tapped, isTrue);
  });

  testWidgets('source circles preserve selected semantics at large text', (
    tester,
  ) async {
    const item = FeedSourceRailItem(id: 'science', name: 'Наука', abbr: 'НА');
    await tester.pumpApp(
      Scaffold(
        body: FeedSourcesRail(
          items: const [item],
          selectedId: 'science',
          onSelected: (_) {},
        ),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('Наука'))
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('loading feed shares a skeleton scene', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: SingleChildScrollView(child: FeedListSkeleton())),
    );
    expect(find.byType(FeedHeroSkeleton), findsOneWidget);
    expect(find.byType(FeedRowSkeleton), findsNWidgets(3));
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
  });
}
