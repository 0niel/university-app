import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_page.dart';

class _Catalog extends MockCubit<MiniAppsCatalogState>
    implements MiniAppsCatalogCubit {}

void main() {
  const longName = 'Свободные аудитории для самостоятельной подготовки';
  const recent = MiniApp(id: 'recent', slug: 'recent', name: longName);
  late _Catalog catalog;

  setUp(() {
    catalog = _Catalog();
    when(() => catalog.state).thenReturn(
      MiniAppsCatalogState(
        status: MiniAppsCatalogStatus.populated,
        apps: List.generate(
          12,
          (index) => MiniApp(
            id: '$index',
            slug: 'app-$index',
            name: 'Приложение $index',
            description: 'Полезный сервис для учёбы и жизни в университете',
          ),
        ),
        recents: const [
          recent,
          MiniApp(id: 'next', slug: 'next', name: 'Следующий сервис'),
        ],
        myApps: const [
          MiniApp(
            id: 'own',
            slug: 'own',
            name: longName,
            status: MiniAppStatus.pendingReview,
          ),
        ],
      ),
    );
    when(
      () => catalog.categoryChanged(MiniAppCategory.other),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, double width, double scale) async {
    tester.view
      ..physicalSize = Size(width, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => BlocProvider<MiniAppsCatalogCubit>.value(
            value: catalog,
            child: const MiniAppsView(),
          ),
        ),
        GoRoute(
          path: '/services/apps/submit',
          builder: (_, _) => const Scaffold(body: Text('Editor opened')),
        ),
        GoRoute(
          path: '/services/apps/recent/run',
          builder: (_, _) => const Scaffold(body: Text('Recent opened')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: true,
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final width in [320.0, 768.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'catalog fits width=$width text=$scale without overlapping actions',
        (tester) async {
          await pump(tester, width, scale);
          expect(tester.takeException(), isNull);
          expect(find.byType(AppFab), findsNothing);
          final categories = find.byKey(const ValueKey('mini-apps-categories'));
          expect(tester.getSize(categories).width, width);
          final sort = find.byKey(const ValueKey('mini-apps-sort-button'));
          expect(
            tester.getRect(sort).bottom,
            lessThanOrEqualTo(tester.getRect(categories).top),
          );
          expect(find.text('Популярные'), findsOneWidget);
          expect(
            tester.getTopLeft(find.text('Мини-аппы')).dx,
            AppSpacing.screen,
          );
          final heading = find.text('Недавно открывали');
          expect(tester.getTopLeft(heading).dx, AppSpacing.screen);
          expect(
            tester.getTopLeft(heading).dy - tester.getRect(categories).bottom,
            lessThan(35),
          );
          await tester.drag(categories, const Offset(-1800, 0));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Другое'));
          verify(
            () => catalog.categoryChanged(MiniAppCategory.other),
          ).called(1);
          await tester.drag(
            find.byType(CustomScrollView),
            const Offset(0, -6000),
          );
          await tester.pumpAndSettle();
          expect(
            find.byKey(const ValueKey('mini-apps-create-button')).hitTestable(),
            findsNothing,
          );
          final last = find.byKey(const ValueKey('catalog-11'));
          await tester.scrollUntilVisible(
            last,
            500,
            scrollable: find
                .descendant(
                  of: find.byType(CustomScrollView),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.drag(
            find.byType(CustomScrollView),
            const Offset(0, -1000),
          );
          await tester.pumpAndSettle();
          expect(tester.getRect(last).bottom, lessThanOrEqualTo(900 - 34));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('inline create opens editor without covering catalog cards', (
    tester,
  ) async {
    await pump(tester, 320, 2);
    await tester.tap(find.byKey(const ValueKey('mini-apps-create-button')));
    await tester.pumpAndSettle();
    expect(find.text('Editor opened'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('recent cards retain full names for accessibility and open app', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, 320, 2);
    final card = find.byKey(const ValueKey('recent-recent'));
    final name = find.descendant(of: card, matching: find.byType(Text));
    expect(tester.widget<Text>(name.first).data, isNotEmpty);
    expect(find.bySemanticsLabel(longName), findsWidgets);
    final names = tester
        .widgetList<Text>(name)
        .where((text) => text.data == longName);
    expect(names.single.maxLines, 2);
    expect(names.single.overflow, TextOverflow.ellipsis);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('Recent opened'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
