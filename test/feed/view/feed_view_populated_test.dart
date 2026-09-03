import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';

import '../../helpers/pump_app.dart';

class _Categories extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class _Feed extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

void main() {
  late CategoriesBloc categories;
  late FeedBloc feed;
  const all = Category(id: 'all', name: 'Все');
  const science = Category(id: 'source:telegram:science', name: 'Наука');

  setUp(() {
    categories = _Categories();
    feed = _Feed();
    when(() => categories.state).thenReturn(
      const CategoriesState(
        status: .populated,
        categories: [all, science],
        selectedCategory: all,
        sources: [
          NewsSourceItem(
            sourceType: 'telegram',
            sourceId: 'science',
            sourceName: 'Наука',
          ),
        ],
      ),
    );
    when(() => feed.state).thenReturn(
      const FeedState(
        status: .populated,
        feed: {'all': [], 'source:telegram:science': []},
        hasMoreNews: {'all': false, 'source:telegram:science': false},
      ),
    );
  });

  Widget subject() => MultiBlocProvider(
    providers: [
      BlocProvider<CategoriesBloc>.value(value: categories),
      BlocProvider<FeedBloc>.value(value: feed),
    ],
    child: const Scaffold(body: NewsFeedView()),
  );

  testWidgets('source selection switches through the real categories event', (
    tester,
  ) async {
    await tester.pumpApp(subject());
    await tester.tap(find.text('Наука'));
    verify(
      () => categories.add(const CategorySelected(category: science)),
    ).called(1);
    expect(find.byType(TabBarView), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final status in [CategoriesStatus.loading, CategoriesStatus.failure]) {
    testWidgets('cached feed stays visible while categories are $status', (
      tester,
    ) async {
      when(() => categories.state).thenReturn(
        CategoriesState(
          status: status,
          categories: const [all],
          selectedCategory: all,
        ),
      );
      await tester.pumpApp(subject());
      expect(find.byType(NewsFeedView), findsOneWidget);
      expect(find.byType(FeedLoaderItem), findsNothing);
      expect(find.byKey(const Key('newsFeed_empty')), findsOneWidget);
    });
  }

  testWidgets('cold feed loads once and announces a single skeleton scene', (
    tester,
  ) async {
    when(() => feed.state).thenReturn(const FeedState());
    await tester.pumpApp(subject());
    expect(find.byType(FeedLoaderItem), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    verify(() => feed.add(const FeedRequested(category: all))).called(1);
    await tester.pump(const Duration(milliseconds: 100));
    verifyNever(() => feed.add(const FeedRequested(category: all)));
  });
}
