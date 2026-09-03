import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_stories_rail.dart';

import '../../helpers/pump_app.dart';

void main() {
  const source = NewsSourceItem(
    sourceType: 'telegram',
    sourceId: 'mirea',
    sourceName: 'МИРЭА',
  );

  testWidgets('renders nothing while there are no sources and no load', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: HomeStoriesRail(sources: [])),
    );
    expect(find.byType(HomeStoriesRail), findsOneWidget);
    expect(find.byKey(const Key('homeStoriesRail_skeleton')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a skeleton rail while sources are still loading', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: HomeStoriesRail(sources: [], loading: true)),
    );
    expect(find.byKey(const Key('homeStoriesRail_skeleton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders story items once sources arrive', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: HomeStoriesRail(sources: [source])),
    );
    expect(find.byKey(const Key('homeStoriesRail_skeleton')), findsNothing);
    expect(find.byType(HomeStoryItem), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
