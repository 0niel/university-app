import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';

import '../../helpers/mocks/mock_marketplace_cubit.dart';

void main() {
  group('MarketplaceView', () {
    late MarketplaceCubit cubit;

    setUp(() => cubit = MockMarketplaceCubit());

    Widget buildSubject(MarketplaceState state) {
      when(() => cubit.state).thenReturn(state);
      return _app(
        BlocProvider<MarketplaceCubit>.value(
          value: cubit,
          child: const MarketplaceView(),
        ),
      );
    }

    testWidgets('uses a skeleton instead of a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const MarketplaceState(status: .loading)),
      );

      expect(find.byType(MarketplaceGridSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows a retryable error instead of an empty marketplace', (
      tester,
    ) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const MarketplaceState(status: .failure)),
      );

      expect(find.text('Не удалось загрузить барахолку'), findsOneWidget);
      expect(find.text('Пока пусто'), findsNothing);
      expect(find.byType(MarketplaceHero), findsNothing);
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('the pastel hero is the only accent surface on the screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const MarketplaceState(
            status: .ready,
            items: [
              MarketListing(id: 'book', title: 'Учебник физики', price: 500),
            ],
          ),
        ),
      );

      final accent = NinjaColors.dark().accentSoft;
      final accentSurfaces = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (widget) =>
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color == accent,
          );
      expect(accentSurfaces, hasLength(1));
      expect(find.byType(MarketplaceHero), findsOneWidget);
    });

    testWidgets('the hero keeps a plain surface while the grid loads', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const MarketplaceState(status: .loading)),
      );

      final hero = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(MarketplaceHero),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (hero.decoration as BoxDecoration).color,
        NinjaColors.dark().surface,
      );
    });

    testWidgets('the empty state offers a real sell action', (tester) async {
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      expect(find.byType(NinjaEmptyState), findsOneWidget);
      final cta = find.descendant(
        of: find.byType(NinjaEmptyState),
        matching: find.text('Продать'),
      );
      expect(cta, findsOneWidget);
      await tester.tap(cta);
      await tester.pumpAndSettle();

      expect(find.text('Продать вещь'), findsOneWidget);
    });

    testWidgets('a fruitless search offers a clear action', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          const MarketplaceState(
            status: .ready,
            items: [
              MarketListing(id: 'book', title: 'Учебник физики', price: 500),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'зззз');
      await tester.pumpAndSettle();

      expect(find.text('Ничего не нашлось'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Очистить'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Учебник физики'), findsOneWidget);
    });

    testWidgets('the page header keeps a 44px circular refresh action', (
      tester,
    ) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      final button = find.byKey(const ValueKey('marketplace-refresh-button'));
      expect(button, findsOneWidget);
      expect(
        tester.getSize(button),
        const Size(
          NinjaMetrics.minTouchTarget,
          NinjaMetrics.minTouchTarget,
        ),
      );

      final title = tester.widget<Text>(find.text('Барахолка'));
      expect(title.style?.fontSize, NinjaText.display.fontSize);
    });

    testWidgets('includes every configured category including other', (
      tester,
    ) async {
      when(() => cubit.filterChanged(any())).thenReturn(null);
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      await tester.drag(find.byType(NinjaChipRow), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('Разное'), findsOneWidget);
    });

    testWidgets('search narrows listings without changing the category', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const MarketplaceState(
            status: .ready,
            items: [
              MarketListing(id: 'book', title: 'Учебник физики', price: 500),
              MarketListing(
                id: 'mouse',
                title: 'Беспроводная мышь',
                price: 900,
              ),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).first, 'мышь');
      await tester.pump();

      expect(find.text('Беспроводная мышь'), findsOneWidget);
      expect(find.text('Учебник физики'), findsNothing);
      expect(cubit.state.filterKey, 'all');
    });

    testWidgets('confirms deletion before invoking the Cubit', (tester) async {
      const item = MarketListing(
        id: 'listing-1',
        title: 'Учебник',
        price: 500,
        isMine: true,
      );
      when(() => cubit.delete(item)).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const MarketplaceState(status: .ready, items: [item])),
      );

      // The persistent owner-actions pill was replaced by a long-press /
      // discoverability-chip sheet.
      expect(find.byTooltip('Удалить объявление'), findsNothing);
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppLineIconWidget && widget.icon == AppLineIcon.more,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Удалить объявление'));
      await tester.pumpAndSettle();

      expect(find.text('Удалить объявление?'), findsOneWidget);
      verifyNever(() => cubit.delete(item));
      await tester.tap(
        find.descendant(
          of: find.byType(NinjaDialog),
          matching: find.text('Удалить объявление'),
        ),
      );
      await tester.pumpAndSettle();
      verify(() => cubit.delete(item)).called(1);
    });
  });

  testWidgets('details show description and explicit contact availability', (
    tester,
  ) async {
    var contacted = false;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: MarketListingDetailsSheet(
            item: const MarketListing(
              id: 'listing-1',
              title: 'Учебник',
              price: 500,
              description: 'Без пометок',
              sellerName: 'Анна',
              sellerHandle: 'anna_dev',
              showContact: true,
            ),
            onContact: () => contacted = true,
          ),
        ),
      ),
    );

    expect(find.text('Без пометок'), findsOneWidget);
    await tester.tap(find.text('Написать продавцу в Telegram'));
    expect(contacted, isTrue);
  });

  testWidgets('sell sheet rejects a zero non-free price locally', (
    tester,
  ) async {
    final cubit = MockMarketplaceCubit();
    when(() => cubit.state).thenReturn(const MarketplaceState());
    await tester.pumpWidget(
      _app(
        BlocProvider<MarketplaceCubit>.value(
          value: cubit,
          child: const Scaffold(body: MarketSellSheet()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'Учебник');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.tap(find.text('Выложить'));
    await tester.pump();

    expect(find.text('Укажите цену больше нуля'), findsOneWidget);
    verifyNever(
      () => cubit.create(
        const MarketListingDraft(
          title: 'Учебник',
          price: 0,
          category: 'books',
        ),
      ),
    );
  });

  testWidgets('free category publishes an exact zero-price draft', (
    tester,
  ) async {
    final cubit = MockMarketplaceCubit();
    when(() => cubit.state).thenReturn(const MarketplaceState());
    const draft = MarketListingDraft(
      title: 'Конспект',
      price: 0,
      category: 'free',
    );
    when(() => cubit.create(draft)).thenAnswer((_) async => true);
    await tester.pumpWidget(
      _app(
        BlocProvider<MarketplaceCubit>.value(
          value: cubit,
          child: const Scaffold(body: MarketSellSheet()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'Конспект');
    await tester.tap(find.textContaining('Даром'));
    await tester.pump();
    await tester.tap(find.text('Выложить'));
    await tester.pump();

    verify(() => cubit.create(draft)).called(1);
  });

  testWidgets('marketplace supports 320px at 200% text scale', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final cubit = MockMarketplaceCubit();
    when(() => cubit.state).thenReturn(
      const MarketplaceState(
        status: .ready,
        items: [
          MarketListing(
            id: 'listing-1',
            title: 'Очень длинное название учебника для проверки',
            price: 500,
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      _app(
        MediaQuery.withClampedTextScaling(
          minScaleFactor: 2,
          maxScaleFactor: 2,
          child: BlocProvider<MarketplaceCubit>.value(
            value: cubit,
            child: const MarketplaceView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(MarketListingCard), findsOneWidget);
  });
}

Widget _app(Widget home) => MaterialApp(
  theme: NinjaTheme.dark(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('ru'),
  home: home,
);
