import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';

import '../../helpers/mocks/mock_marketplace_cubit.dart';

class _MockContactPrefsCubit extends MockCubit<String>
    implements MarketContactPrefsCubit {}

MarketContactPrefsCubit _contactCubit() {
  final cubit = _MockContactPrefsCubit();
  whenListen(cubit, const Stream<String>.empty(), initialState: '');
  when(() => cubit.rememberHandle(any())).thenReturn(null);
  return cubit;
}

void main() {
  setUpAll(() {
    registerFallbackValue(const MarketListingDraft(title: 'fallback'));
  });

  group('MarketplaceView', () {
    late MarketplaceCubit cubit;

    setUp(() => cubit = MockMarketplaceCubit());

    Widget buildSubject(MarketplaceState state) {
      when(() => cubit.state).thenReturn(state);
      return _app(
        MultiBlocProvider(
          providers: [
            BlocProvider<MarketplaceCubit>.value(value: cubit),
            BlocProvider<MarketContactPrefsCubit>.value(
              value: _contactCubit(),
            ),
          ],
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
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('grid uses honest missing-photo placeholders', (
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

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(AppStripePlaceholder), findsOneWidget);
    });

    testWidgets('loading keeps the same grid geometry as the loaded state', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const MarketplaceState(status: .loading)),
      );

      expect(find.byType(MarketplaceGridSkeleton), findsOneWidget);
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
      expect(delegate.mainAxisExtent, 263);
    });

    testWidgets('the empty state offers a real sell action', (tester) async {
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      expect(find.byType(AppEmptyState), findsOneWidget);
      final cta = find.descendant(
        of: find.byType(AppEmptyState),
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

      await tester.enterText(
        find.descendant(
          of: find.byType(AppSearchField),
          matching: find.byType(TextField),
        ),
        'зззз',
      );
      await tester.pumpAndSettle();

      expect(find.text('Ничего не нашлось'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AppEmptyState),
          matching: find.text('Очистить'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Учебник физики'), findsOneWidget);
    });

    testWidgets('the page header keeps a 44px circular back action', (
      tester,
    ) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      final button = find.bySemanticsLabel('Назад');
      expect(button, findsOneWidget);
      expect(
        tester.getSize(button),
        const Size(
          AppControlSize.touchTarget,
          AppControlSize.touchTarget,
        ),
      );

      expect(find.text('Маркет'), findsOneWidget);
    });

    testWidgets('includes every configured category including other', (
      tester,
    ) async {
      when(() => cubit.filterChanged(any())).thenReturn(null);
      await tester.pumpWidget(buildSubject(const MarketplaceState()));

      await tester.drag(find.byType(AppChipRow<String>), const Offset(-500, 0));
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

      await tester.enterText(
        find.descendant(
          of: find.byType(AppSearchField),
          matching: find.byType(TextField),
        ),
        'мышь',
      );
      await tester.pumpAndSettle();

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

      await tester.tap(find.byType(MarketListingCard));
      await tester.pumpAndSettle();

      expect(find.text('Удалить объявление?'), findsNothing);
      await tester.ensureVisible(find.text('Удалить объявление'));
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
      await tester.pump(const Duration(seconds: 3));
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
              telegramHandle: 'anna_dev',
              showContact: true,
            ),
            onContact: () => contacted = true,
            onShare: () {},
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
        MultiBlocProvider(
          providers: [
            BlocProvider<MarketplaceCubit>.value(value: cubit),
            BlocProvider<MarketContactPrefsCubit>.value(
              value: _contactCubit(),
            ),
          ],
          child: const Scaffold(body: MarketSellSheet()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Учебник');
    await tester.enterText(find.byType(TextField).at(2), '0');
    await tester.ensureVisible(find.text('Выложить'));
    await tester.tap(find.text('Выложить'));
    await tester.pump();

    expect(find.text('Укажите цену больше нуля'), findsOneWidget);
    verifyNever(() => cubit.create(any()));
  });

  testWidgets('the free toggle publishes an exact zero-price draft', (
    tester,
  ) async {
    final cubit = MockMarketplaceCubit();
    when(() => cubit.state).thenReturn(const MarketplaceState());
    const draft = MarketListingDraft(
      title: 'Конспект',
      price: 0,
      category: 'books',
      isFree: true,
      telegramHandle: 'seller_user',
    );
    when(() => cubit.create(draft)).thenAnswer((_) async => true);
    await tester.pumpWidget(
      _app(
        MultiBlocProvider(
          providers: [
            BlocProvider<MarketplaceCubit>.value(value: cubit),
            BlocProvider<MarketContactPrefsCubit>.value(
              value: _contactCubit(),
            ),
          ],
          child: const Scaffold(body: MarketSellSheet()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Конспект');
    await tester.tap(find.byType(AppToggle));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(3), 'seller_user');
    await tester.ensureVisible(find.text('Выложить'));
    await tester.tap(find.text('Выложить'));
    await tester.pump();

    verify(() => cubit.create(draft)).called(1);
  });

  testWidgets('an invalid telegram handle blocks publishing', (
    tester,
  ) async {
    final cubit = MockMarketplaceCubit();
    when(() => cubit.state).thenReturn(const MarketplaceState());
    await tester.pumpWidget(
      _app(
        MultiBlocProvider(
          providers: [
            BlocProvider<MarketplaceCubit>.value(value: cubit),
            BlocProvider<MarketContactPrefsCubit>.value(
              value: _contactCubit(),
            ),
          ],
          child: const Scaffold(body: MarketSellSheet()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Учебник');
    await tester.enterText(find.byType(TextField).at(2), '500');
    await tester.enterText(find.byType(TextField).at(3), 'no');
    await tester.ensureVisible(find.text('Выложить'));
    await tester.tap(find.text('Выложить'));
    await tester.pump();

    expect(
      find.text('От 5 до 32 символов: латиница, цифры, _'),
      findsOneWidget,
    );
    verifyNever(() => cubit.create(any()));
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider<MarketplaceCubit>.value(value: cubit),
              BlocProvider<MarketContactPrefsCubit>.value(
                value: _contactCubit(),
              ),
            ],
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
  theme: AppTheme.lightTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('ru'),
  home: home,
);
