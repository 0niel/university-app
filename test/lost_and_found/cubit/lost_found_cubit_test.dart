import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';

import '../../helpers/mocks/mock_lost_found_repository.dart';

void main() {
  late LostFoundRepository repository;
  final createdAt = DateTime.utc(2026, 7, 11);
  late LostFoundItem keys;
  late LostFoundItem notebook;

  setUpAll(() {
    registerFallbackValue(LostFoundItemStatus.lost);
    registerFallbackValue(<LostFoundImageUpload>[]);
  });

  setUp(() {
    repository = MockLostFoundRepository();
    keys = LostFoundItem(
      id: 'item-1',
      authorId: 'user-1',
      itemName: 'Keys',
      status: .found,
      createdAt: createdAt,
      category: 'keys',
      isMine: true,
    );
    notebook = LostFoundItem(
      id: 'item-2',
      authorId: 'user-2',
      itemName: 'Notebook',
      status: .lost,
      createdAt: createdAt,
      category: 'docs',
    );
  });

  LostFoundCubit buildCubit() => .new(lostFoundRepository: repository);

  void stubItems(Future<List<LostFoundItem>> Function() answer) {
    when(
      () => repository.getItems(limit: 100),
    ).thenAnswer((_) => answer());
  }

  test('loads items and keeps cached data on refresh failure', () async {
    stubItems(() async => [keys]);
    final cubit = buildCubit();
    expect(await cubit.load(), isTrue);
    when(
      () => repository.getItems(limit: 100),
    ).thenThrow(Exception('offline'));

    expect(await cubit.load(), isFalse);
    expect(cubit.state.status, LostFoundStatus.failure);
    expect(cubit.state.items, [keys]);
    await cubit.close();
  });

  test('ignores a superseded load', () async {
    final first = Completer<List<LostFoundItem>>();
    var calls = 0;
    stubItems(
      () => calls++ == 0 ? first.future : Future.value([notebook]),
    );
    final cubit = buildCubit();

    final loads = (cubit.load(), cubit.load());
    expect(await loads.$2, isTrue);
    first.complete([keys]);
    expect(await loads.$1, isFalse);
    expect(cubit.state.items, [notebook]);
    await cubit.close();
  });

  test('applies tab, category, and query filters locally', () async {
    stubItems(() async => [keys, notebook]);
    final cubit = buildCubit();
    await cubit.load();

    cubit
      ..tabChanged(.lost)
      ..categoryChanged('docs')
      ..queryChanged('note');

    expect(cubit.state.filteredItems, [notebook]);
    await cubit.close();
  });

  test('rejects invalid report drafts before the repository', () async {
    final cubit = buildCubit();

    expect(await cubit.create(const LostFoundReportDraft()), isFalse);
    verifyNever(
      () => repository.createItem(
        title: any(named: 'title'),
        status: any(named: 'status'),
        category: any(named: 'category'),
        description: any(named: 'description'),
        telegram: any(named: 'telegram'),
        phoneNumber: any(named: 'phoneNumber'),
        location: any(named: 'location'),
        showContact: any(named: 'showContact'),
        images: any(named: 'images'),
      ),
    );
    await cubit.close();
  });

  test('normalizes and prepends a created item', () async {
    when(
      () => repository.createItem(
        title: 'Umbrella',
        status: .found,
        category: 'other',
        description: 'Near cafe',
        telegram: '@student',
        location: 'Cafe',
        showContact: true,
      ),
    ).thenAnswer((_) async => keys.copyWith(id: 'created'));
    final cubit = buildCubit();

    expect(
      await cubit.create(
        const LostFoundReportDraft(
          title: ' Umbrella ',
          category: ' other ',
          description: ' Near cafe ',
          telegram: ' @student ',
          location: ' Cafe ',
          showContact: true,
        ),
      ),
      isTrue,
    );
    expect(cubit.state.items.firstOrNull?.id, 'created');
    await cubit.close();
  });

  test('optimistic status change blocks refresh and rolls back', () async {
    stubItems(() async => [keys]);
    final changed = Completer<void>();
    when(
      () => repository.updateItemStatus(itemId: keys.id, newStatus: .lost),
    ).thenAnswer((_) => changed.future);
    final cubit = buildCubit();
    await cubit.load();

    final mutation = cubit.toggleItemStatus(keys);
    expect(cubit.state.items.firstOrNull?.status, LostFoundItemStatus.lost);
    expect(await cubit.load(), isFalse);
    expect(await cubit.toggleItemStatus(keys), isFalse);
    verify(() => repository.getItems(limit: 100)).called(1);
    changed.completeError(Exception('offline'), .current);
    expect(await mutation, isFalse);
    expect(cubit.state.items.firstOrNull?.status, LostFoundItemStatus.found);
    expect(cubit.state.pendingStatusIds, isEmpty);
    await cubit.close();
  });

  test(
    'status mutation supersedes an active refresh without staying loading',
    () async {
      stubItems(() async => [keys]);
      final cubit = buildCubit();
      await cubit.load();
      final refresh = Completer<List<LostFoundItem>>();
      stubItems(() => refresh.future);
      when(
        () => repository.updateItemStatus(itemId: keys.id, newStatus: .lost),
      ).thenAnswer((_) => Future<void>.value());

      final loading = cubit.load();
      expect(cubit.state.status, LostFoundStatus.loading);
      expect(await cubit.toggleItemStatus(keys), isTrue);
      expect(cubit.state.status, isNot(LostFoundStatus.loading));
      refresh.complete([notebook]);

      expect(await loading, isFalse);
      expect(cubit.state.status, LostFoundStatus.ready);
      expect(cubit.state.items.singleOrNull?.status, LostFoundItemStatus.lost);
      await cubit.close();
    },
  );

  test(
    'optimistic deletion restores its original position on failure',
    () async {
      stubItems(() async => [keys, notebook]);
      final deleted = Completer<LostFoundDeleteResult>();
      when(
        () => repository.deleteItem(itemId: keys.id),
      ).thenAnswer((_) => deleted.future);
      final cubit = buildCubit();
      await cubit.load();

      final mutation = cubit.deleteItem(keys);
      expect(cubit.state.items, [notebook]);
      expect(await cubit.load(), isFalse);
      deleted.completeError(Exception('offline'), .current);
      expect(await mutation, isFalse);
      expect(cubit.state.items, [keys, notebook]);
      await cubit.close();
    },
  );

  test(
    'deletion supersedes an active refresh without staying loading',
    () async {
      stubItems(() async => [keys]);
      final cubit = buildCubit();
      await cubit.load();
      final refresh = Completer<List<LostFoundItem>>();
      stubItems(() => refresh.future);
      when(
        () => repository.deleteItem(itemId: keys.id),
      ).thenAnswer((_) async => const LostFoundDeleteResult());

      final loading = cubit.load();
      expect(await cubit.deleteItem(keys), isTrue);
      expect(cubit.state.status, isNot(LostFoundStatus.loading));
      refresh.complete([notebook]);

      expect(await loading, isFalse);
      expect(cubit.state.status, LostFoundStatus.ready);
      expect(cubit.state.items, isEmpty);
      await cubit.close();
    },
  );

  test(
    'reports deferred image cleanup without restoring deleted item',
    () async {
      stubItems(() async => [keys]);
      when(
        () => repository.deleteItem(itemId: keys.id),
      ).thenAnswer(
        (_) async => const LostFoundDeleteResult(
          failedCleanupPaths: ['user-1/photo.jpg'],
        ),
      );
      final cubit = buildCubit();
      await cubit.load();

      expect(await cubit.deleteItem(keys), isTrue);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.cleanupWarningRevision, 1);
      await cubit.close();
    },
  );
}
