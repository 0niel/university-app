import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations.dart';

class _MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class _MockFeedBloc extends MockBloc<FeedEvent, FeedState>
    implements FeedBloc {}

Widget _wrapFeed({
  required CategoriesBloc categoriesBloc,
  required FeedBloc feedBloc,
  required Widget child,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CategoriesBloc>.value(value: categoriesBloc),
      BlocProvider<FeedBloc>.value(value: feedBloc),
    ],
    child: MaterialApp(
      theme: NinjaTheme.light(),
      locale: const Locale('ru'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('category tabs switch content without a full-page pager', (
    tester,
  ) async {
    const all = Category(id: 'all', name: 'Все');
    const science = Category(id: 'science', name: 'Наука');
    final categoriesBloc = _MockCategoriesBloc();
    final feedBloc = _MockFeedBloc();
    when(() => categoriesBloc.state).thenReturn(
      const CategoriesState(
        status: CategoriesStatus.populated,
        categories: [all, science],
        selectedCategory: all,
      ),
    );
    when(() => feedBloc.state).thenReturn(
      const FeedState(
        status: FeedStatus.populated,
        hasMoreNews: {'all': false, 'science': false},
      ),
    );

    await tester.pumpWidget(
      _wrapFeed(
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        child: const FeedViewPopulated(categories: [all, science]),
      ),
    );

    expect(find.byType(TabBarView), findsNothing);
    expect(find.byType(IndexedStack), findsOneWidget);
    await tester.tap(find.text('Наука'));
    await tester.pump();

    verify(
      () => categoriesBloc.add(const CategorySelected(category: science)),
    ).called(1);
    expect(tester.takeException(), isNull);
  });

  for (final status in [CategoriesStatus.loading, CategoriesStatus.failure]) {
    testWidgets('keeps cached feed visible while categories are $status', (
      tester,
    ) async {
      const all = Category(id: 'all', name: 'Все');
      final categoriesBloc = _MockCategoriesBloc();
      final feedBloc = _MockFeedBloc();
      when(() => categoriesBloc.state).thenReturn(
        CategoriesState(
          status: status,
          categories: const [all],
          selectedCategory: all,
        ),
      );
      when(() => feedBloc.state).thenReturn(
        const FeedState(
          status: FeedStatus.populated,
          hasMoreNews: {'all': false},
        ),
      );

      await tester.pumpWidget(
        _wrapFeed(
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          child: const FeedView(),
        ),
      );

      expect(find.byType(FeedViewPopulated), findsOneWidget);
      expect(find.byKey(const Key('feedView_failure')), findsNothing);
      expect(find.byType(CategoryFeedLoaderItem), findsNothing);
    });
  }

  testWidgets('cold feed loading uses one scene and one live region', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final categoriesBloc = _MockCategoriesBloc();
    final feedBloc = _MockFeedBloc();
    when(() => categoriesBloc.state).thenReturn(
      const CategoriesState(status: CategoriesStatus.loading),
    );
    when(() => feedBloc.state).thenReturn(const FeedState());

    await tester.pumpWidget(
      _wrapFeed(
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        child: const FeedView(),
      ),
    );

    final loading = find.bySemanticsLabel('Загрузка');
    expect(find.byType(CategoryFeedLoaderItem), findsOneWidget);
    expect(loading, findsOneWidget);
    expect(tester.getSemantics(loading).flagsCollection.isLiveRegion, isTrue);
    expect(tester.binding.transientCallbackCount, 1);
    semantics.dispose();
  });
}
