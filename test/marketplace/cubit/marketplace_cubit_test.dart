import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  late CampusRepository repository;
  const book = MarketListing(
    id: 'l-1',
    title: 'Учебник',
    price: 500,
    category: 'books',
  );
  const gadget = MarketListing(
    id: 'l-2',
    title: 'Калькулятор',
    price: 1200,
    category: 'tech',
  );

  setUp(() => repository = MockCampusRepository());

  MarketplaceCubit buildCubit() => .new(repository);

  test('loads listings and keeps cached items on refresh failure', () async {
    when(() => repository.getListings()).thenAnswer((_) async => [book]);
    final cubit = buildCubit();
    expect(await cubit.load(), isTrue);
    when(() => repository.getListings()).thenThrow(Exception('offline'));

    expect(await cubit.load(), isFalse);
    expect(cubit.state.status, MarketplaceStatus.failure);
    expect(cubit.state.items, [book]);
    await cubit.close();
  });

  test('ignores a superseded load', () async {
    final first = Completer<List<MarketListing>>();
    var calls = 0;
    when(() => repository.getListings()).thenAnswer(
      (_) => calls++ == 0 ? first.future : Future.value([book]),
    );
    final cubit = buildCubit();

    final loads = (cubit.load(), cubit.load());
    expect(await loads.$2, isTrue);
    first.complete([gadget]);
    expect(await loads.$1, isFalse);
    expect(cubit.state.items, [book]);
    await cubit.close();
  });

  test('uses a stable category filter key', () async {
    when(
      () => repository.getListings(),
    ).thenAnswer((_) async => [book, gadget]);
    final cubit = buildCubit();
    await cubit.load();

    cubit.filterChanged('tech');

    expect(cubit.state.filterKey, 'tech');
    expect(cubit.state.filteredItems, [gadget]);
    await cubit.close();
  });

  test('normalizes a valid draft and reloads after create', () async {
    when(
      () => repository.createListing(
        title: 'Desk',
        price: 3000,
        category: 'furniture',
        description: 'Almost new',
        showContact: true,
      ),
    ).thenAnswer((_) async => '123e4567-e89b-42d3-a456-426614174000');
    when(() => repository.getListings()).thenAnswer((_) async => [book]);
    final cubit = buildCubit();

    expect(
      await cubit.create(
        const MarketListingDraft(
          title: ' Desk ',
          price: 3000,
          category: ' furniture ',
          description: ' Almost new ',
          showContact: true,
        ),
      ),
      isTrue,
    );
    expect(cubit.state.items, [book]);
    verify(
      () => repository.createListing(
        title: 'Desk',
        price: 3000,
        category: 'furniture',
        description: 'Almost new',
        showContact: true,
      ),
    ).called(1);
    await cubit.close();
  });

  test(
    'rejects invalid free-price combinations before the repository',
    () async {
      final cubit = buildCubit();

      expect(
        await cubit.create(
          const MarketListingDraft(
            title: 'Fake gift',
            price: 100,
            category: 'free',
          ),
        ),
        isFalse,
      );
      verifyNever(
        () => repository.createListing(
          title: any(named: 'title'),
          price: any(named: 'price'),
          category: any(named: 'category'),
          description: any(named: 'description'),
          showContact: any(named: 'showContact'),
        ),
      );
      await cubit.close();
    },
  );

  test('optimistically toggles once and rolls back on failure', () async {
    when(() => repository.getListings()).thenAnswer((_) async => [book]);
    final changed = Completer<void>();
    when(
      () => repository.setListingSold(id: 'l-1', sold: true),
    ).thenAnswer((_) => changed.future);
    final cubit = buildCubit();
    await cubit.load();

    final firstToggle = cubit.toggleSold(book);
    expect(cubit.state.items.firstOrNull?.isSold, isTrue);
    expect(await cubit.toggleSold(book), isFalse);
    changed.completeError(Exception('offline'), .current);
    expect(await firstToggle, isFalse);
    expect(cubit.state.items.firstOrNull?.isSold, isFalse);
    expect(cubit.state.pendingSoldIds, isEmpty);
    await cubit.close();
  });

  test('does not refresh while a sold mutation is pending', () async {
    when(() => repository.getListings()).thenAnswer((_) async => [book]);
    final changed = Completer<void>();
    when(
      () => repository.setListingSold(id: 'l-1', sold: true),
    ).thenAnswer((_) => changed.future);
    final cubit = buildCubit();
    await cubit.load();

    final toggle = cubit.toggleSold(book);
    expect(await cubit.load(), isFalse);
    verify(() => repository.getListings()).called(1);
    changed.complete();
    expect(await toggle, isTrue);
    expect(cubit.state.items.firstOrNull?.isSold, isTrue);
    await cubit.close();
  });

  test(
    'optimistically deletes once and restores the original position',
    () async {
      when(
        () => repository.getListings(),
      ).thenAnswer((_) async => [book, gadget]);
      final deleted = Completer<void>();
      when(
        () => repository.deleteListing('l-1'),
      ).thenAnswer((_) => deleted.future);
      final cubit = buildCubit();
      await cubit.load();

      final firstDelete = cubit.delete(book);
      expect(cubit.state.items, [gadget]);
      expect(await cubit.delete(book), isFalse);
      deleted.completeError(Exception('offline'), .current);
      expect(await firstDelete, isFalse);
      expect(cubit.state.items, [book, gadget]);
      expect(cubit.state.pendingDeleteIds, isEmpty);
      await cubit.close();
    },
  );

  test('does not refresh while a deletion is pending', () async {
    when(
      () => repository.getListings(),
    ).thenAnswer((_) async => [book, gadget]);
    final deleted = Completer<void>();
    when(
      () => repository.deleteListing('l-1'),
    ).thenAnswer((_) => deleted.future);
    final cubit = buildCubit();
    await cubit.load();

    final deletion = cubit.delete(book);
    expect(await cubit.load(), isFalse);
    verify(() => repository.getListings()).called(1);
    deleted.complete();
    expect(await deletion, isTrue);
    expect(cubit.state.items, [gadget]);
    await cubit.close();
  });
}
