import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_trending_group.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

import '../../helpers/pump_app.dart';

void main() {
  DiscourseTopic topic(int id) => DiscourseTopic(
    id: id,
    title: 'Тема $id',
    postsCount: id,
    replyCount: id,
    likeCount: id + 1,
    views: id * 10,
    posters: const [],
  );

  testWidgets('shows up to five topics with reply and like meta', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: HomeTrendingGroup(
          state: DiscourseState(
            status: DiscourseStatus.loaded,
            topTopics: TopTopicsResponse(
              users: const [],
              topics: List.generate(8, (i) => topic(i + 1)),
            ),
          ),
          onAll: () {},
          onOpen: (_) {},
          onRetry: () {},
        ),
      ),
    );
    expect(find.text('Тема 1'), findsOneWidget);
    expect(find.text('Тема 5'), findsOneWidget);
    expect(find.text('Тема 6'), findsNothing);
    expect(find.text('1 ответ · 2 лайка'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state renders five skeleton rows', (tester) async {
    await tester.pumpApp(
      Scaffold(
        body: HomeTrendingGroup(
          state: const DiscourseState(status: DiscourseStatus.loading),
          onAll: () {},
          onOpen: (_) {},
          onRetry: () {},
        ),
      ),
    );
    expect(find.byType(AppSkeletonRow), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty state renders the compact empty message', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: HomeTrendingGroup(
          state: const DiscourseState(
            status: DiscourseStatus.loaded,
            topTopics: TopTopicsResponse(users: [], topics: []),
          ),
          onAll: () {},
          onOpen: (_) {},
          onRetry: () {},
        ),
      ),
    );
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failure state shows a retry banner', (tester) async {
    var retried = false;
    await tester.pumpApp(
      Scaffold(
        body: HomeTrendingGroup(
          state: const DiscourseState(status: DiscourseStatus.failure),
          onAll: () {},
          onOpen: (_) {},
          onRetry: () => retried = true,
        ),
      ),
    );
    expect(find.byType(AppBanner), findsOneWidget);
    await tester.tap(find.byType(AppBanner));
    expect(retried, isTrue);
    expect(tester.takeException(), isNull);
  });
}
