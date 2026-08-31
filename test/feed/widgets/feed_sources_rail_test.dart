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

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  group('FeedSourcesRail', () {
    late CategoriesBloc categoriesBloc;

    const source = NewsSourceItem(
      sourceType: 'telegram',
      sourceId: 'rtumirea_official',
      sourceName: 'РТУ МИРЭА',
      subscribers: '23.9K',
    );
    const category = Category(
      id: 'source:telegram:rtumirea_official',
      name: 'РТУ МИРЭА',
    );

    setUp(() {
      categoriesBloc = MockCategoriesBloc();
      when(() => categoriesBloc.state).thenReturn(
        const CategoriesState(
          status: CategoriesStatus.populated,
          categories: [
            Category(id: 'all', name: 'Все'),
            category,
          ],
          selectedCategory: Category(id: 'all', name: 'Все'),
          sources: [source],
        ),
      );
    });

    Widget buildSubject({TextScaler textScaler = TextScaler.noScaling}) {
      return MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Scaffold(
          body: BlocProvider.value(
            value: categoriesBloc,
            child: const FeedSourcesRail(),
          ),
        ),
      );
    }

    testWidgets('renders source name', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('РТУ МИРЭА'), findsOneWidget);
    });

    testWidgets('tap selects the source category', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('РТУ МИРЭА'));
      verify(
        () => categoriesBloc.add(const CategorySelected(category: category)),
      ).called(1);
    });

    testWidgets('renders nothing without sources', (tester) async {
      when(() => categoriesBloc.state).thenReturn(const CategoriesState());
      await tester.pumpWidget(buildSubject());
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('РТУ МИРЭА'), findsNothing);
    });

    testWidgets('remains usable and semantic at 320px and 200% text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildSubject(textScaler: const TextScaler.linear(2)),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.button == true &&
              widget.properties.label == 'РТУ МИРЭА',
        ),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byType(FeedSourcesRail)).height,
        greaterThanOrEqualTo(136),
      );
    });

    testWidgets('loading composition reserves geometry without full slabs', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: CategoryFeedLoaderItem()),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CategoryFeedLoaderItem)).height,
        greaterThanOrEqualTo(1000),
      );
      expect(
        tester
            .widgetList<NinjaSkeleton>(find.byType(NinjaSkeleton))
            .every((skeleton) => skeleton.height < 220),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
