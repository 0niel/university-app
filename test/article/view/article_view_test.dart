import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/article/view/article_view.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class _MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  testWidgets('article chrome is flat, responsive, and uses line actions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final articleBloc = _MockArticleBloc();
    final categoriesBloc = _MockCategoriesBloc();
    final uri = Uri.parse('https://example.com/article');
    when(() => articleBloc.state).thenReturn(ArticleState(uri: uri));
    when(() => categoriesBloc.state).thenReturn(const CategoriesState());

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
          ),
          child: child!,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ArticleBloc>.value(value: articleBloc),
            BlocProvider<CategoriesBloc>.value(value: categoriesBloc),
          ],
          child: const ArticleView(isVideoArticle: false),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(AppLineIconWidget), findsNWidgets(2));
    expect(
      tester.getSize(find.byKey(const Key('articlePage_shareButton'))),
      const Size(44, 44),
    );

    await tester.tap(find.byKey(const Key('articlePage_shareButton')));
    verify(
      () => articleBloc.add(ShareRequested(uri: uri)),
    ).called(1);
  });

  testWidgets('article failure is an inline retryable state, not a dialog', (
    tester,
  ) async {
    final articleBloc = _MockArticleBloc();
    final categoriesBloc = _MockCategoriesBloc();
    when(() => articleBloc.state).thenReturn(
      const ArticleState(status: ArticleStatus.failure),
    );
    when(() => categoriesBloc.state).thenReturn(const CategoriesState());

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ArticleBloc>.value(value: articleBloc),
            BlocProvider<CategoriesBloc>.value(value: categoriesBloc),
          ],
          child: const ArticleView(isVideoArticle: false),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NinjaDialog), findsNothing);
    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byKey(const Key('articleContent_failure')), findsOneWidget);

    await tester.tap(find.text('Повторить'));
    verify(() => articleBloc.add(const ArticleRequested())).called(1);
  });
}
