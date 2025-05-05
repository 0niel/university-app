import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:university_app_server_api/client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockFile extends Mock implements File {}

// Create a class for Mocktail to use when registering fallback values
class FakeLostFoundItem extends Fake implements LostFoundItem {}

void main() {
  setUpAll(() {
    // Register fallback values for complex types used with matchers
    registerFallbackValue(FakeLostFoundItem());
    registerFallbackValue(LostFoundItemStatus.lost);
  });

  group('LostFoundRepository', () {
    late ApiClient apiClient;
    late LostFoundRepository repository;

    setUp(() {
      apiClient = MockApiClient();
      repository = LostFoundRepository(apiClient: apiClient);
    });

    group('createItem', () {
      final mockItem = LostFoundItem(
        authorId: 'user123',
        authorEmail: 'user@example.com',
        itemName: 'Test Item',
        status: LostFoundItemStatus.lost,
        description: 'Test description',
        telegramContactInfo: '@user',
        phoneNumberContactInfo: '+1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('creates item successfully', () async {
        when(() => apiClient.createLostFoundItem(item: any(named: 'item'))).thenAnswer((_) async => mockItem);

        final result = await repository.createItem(
          authorId: 'user123',
          authorEmail: 'user@example.com',
          title: 'Test Item',
          status: LostFoundItemStatus.lost,
          description: 'Test description',
          telegram: '@user',
          phoneNumber: '+1234567890',
        );

        expect(result, equals(mockItem));
        verify(() => apiClient.createLostFoundItem(item: any(named: 'item'))).called(1);
      });

      test('throws CreateLostFoundItemFailure on error', () async {
        when(() => apiClient.createLostFoundItem(item: any(named: 'item'))).thenThrow(Exception('Network error'));

        expect(
          () => repository.createItem(
            authorId: 'user123',
            authorEmail: 'user@example.com',
            title: 'Test Item',
            status: LostFoundItemStatus.lost,
          ),
          throwsA(isA<CreateLostFoundItemFailure>()),
        );
      });
    });

    group('updateItem', () {
      final mockItem = LostFoundItem(
        id: 'item123',
        authorId: 'user123',
        authorEmail: 'user@example.com',
        itemName: 'Updated Item',
        status: LostFoundItemStatus.found,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('updates item successfully', () async {
        when(
          () => apiClient.updateLostFoundItem(
            itemId: any(named: 'itemId'),
            item: any(named: 'item'),
          ),
        ).thenAnswer((_) async => mockItem);

        final result = await repository.updateItem(item: mockItem);

        expect(result, equals(mockItem));
        verify(
          () => apiClient.updateLostFoundItem(
            itemId: 'item123',
            item: mockItem,
          ),
        ).called(1);
      });

      test('throws UpdateLostFoundItemFailure when item id is null', () async {
        final itemWithoutId = LostFoundItem(
          authorId: 'user123',
          authorEmail: 'user@example.com',
          itemName: 'Invalid Item',
          status: LostFoundItemStatus.lost,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(
          () => repository.updateItem(item: itemWithoutId),
          throwsA(isA<UpdateLostFoundItemFailure>()),
        );
      });

      test('throws UpdateLostFoundItemFailure on error', () async {
        when(
          () => apiClient.updateLostFoundItem(
            itemId: any(named: 'itemId'),
            item: any(named: 'item'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.updateItem(item: mockItem),
          throwsA(isA<UpdateLostFoundItemFailure>()),
        );
      });
    });

    group('updateItemStatus', () {
      final mockItem = LostFoundItem(
        id: 'item123',
        authorId: 'user123',
        authorEmail: 'user@example.com',
        itemName: 'Status Updated Item',
        status: LostFoundItemStatus.found,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('updates item status successfully', () async {
        when(
          () => apiClient.updateLostFoundItemStatus(
            itemId: any(named: 'itemId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => mockItem);

        final result = await repository.updateItemStatus(
          itemId: 'item123',
          newStatus: LostFoundItemStatus.found,
        );

        expect(result, equals(mockItem));
        verify(
          () => apiClient.updateLostFoundItemStatus(
            itemId: 'item123',
            status: LostFoundItemStatus.found,
          ),
        ).called(1);
      });

      test('throws UpdateLostFoundItemFailure on error', () async {
        when(
          () => apiClient.updateLostFoundItemStatus(
            itemId: any(named: 'itemId'),
            status: any(named: 'status'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.updateItemStatus(
            itemId: 'item123',
            newStatus: LostFoundItemStatus.found,
          ),
          throwsA(isA<UpdateLostFoundItemFailure>()),
        );
      });
    });

    group('deleteItem', () {
      test('deletes item successfully', () async {
        when(() => apiClient.deleteLostFoundItem(itemId: any(named: 'itemId'))).thenAnswer((_) async => {});

        await repository.deleteItem(itemId: 'item123');

        verify(() => apiClient.deleteLostFoundItem(itemId: 'item123')).called(1);
      });

      test('throws DeleteLostFoundItemFailure on error', () async {
        when(() => apiClient.deleteLostFoundItem(itemId: any(named: 'itemId'))).thenThrow(Exception('Network error'));

        expect(
          () => repository.deleteItem(itemId: 'item123'),
          throwsA(isA<DeleteLostFoundItemFailure>()),
        );
      });
    });

    group('getItems', () {
      final mockItems = [
        LostFoundItem(
          id: 'item1',
          authorId: 'user1',
          authorEmail: 'user1@example.com',
          itemName: 'Item 1',
          status: LostFoundItemStatus.lost,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        LostFoundItem(
          id: 'item2',
          authorId: 'user2',
          authorEmail: 'user2@example.com',
          itemName: 'Item 2',
          status: LostFoundItemStatus.found,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final mockResponse = LostFoundItemsResponse(items: mockItems);

      test('gets items successfully', () async {
        when(
          () => apiClient.getLostFoundItems(
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getItems(
          status: LostFoundItemStatus.lost,
          limit: 10,
        );

        expect(result, equals(mockItems));
        verify(
          () => apiClient.getLostFoundItems(
            status: LostFoundItemStatus.lost,
            limit: 10,
            offset: 0,
          ),
        ).called(1);
      });

      test('throws GetLostFoundItemsFailure on error', () async {
        when(
          () => apiClient.getLostFoundItems(
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.getItems(),
          throwsA(isA<GetLostFoundItemsFailure>()),
        );
      });
    });

    group('getItemById', () {
      final mockItem = LostFoundItem(
        id: 'item123',
        authorId: 'user123',
        authorEmail: 'user@example.com',
        itemName: 'Test Item',
        status: LostFoundItemStatus.lost,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('gets item by id successfully', () async {
        when(() => apiClient.getLostFoundItem(itemId: any(named: 'itemId'))).thenAnswer((_) async => mockItem);

        final result = await repository.getItemById(itemId: 'item123');

        expect(result, equals(mockItem));
        verify(() => apiClient.getLostFoundItem(itemId: 'item123')).called(1);
      });

      test('throws GetLostFoundItemFailure on error', () async {
        when(() => apiClient.getLostFoundItem(itemId: any(named: 'itemId'))).thenThrow(Exception('Network error'));

        expect(
          () => repository.getItemById(itemId: 'item123'),
          throwsA(isA<GetLostFoundItemFailure>()),
        );
      });
    });

    group('searchItems', () {
      final mockItems = [
        LostFoundItem(
          id: 'item1',
          authorId: 'user1',
          authorEmail: 'user1@example.com',
          itemName: 'Lost Wallet',
          status: LostFoundItemStatus.lost,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final mockResponse = LostFoundItemsResponse(items: mockItems);

      test('searches items successfully', () async {
        when(
          () => apiClient.searchLostFoundItems(
            query: any(named: 'query'),
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.searchItems(
          query: 'wallet',
          status: LostFoundItemStatus.lost,
          limit: 10,
        );

        expect(result, equals(mockItems));
        verify(
          () => apiClient.searchLostFoundItems(
            query: 'wallet',
            status: LostFoundItemStatus.lost,
            limit: 10,
            offset: 0,
          ),
        ).called(1);
      });

      test('throws SearchLostFoundItemsFailure on error', () async {
        when(
          () => apiClient.searchLostFoundItems(
            query: any(named: 'query'),
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.searchItems(query: 'wallet'),
          throwsA(isA<SearchLostFoundItemsFailure>()),
        );
      });
    });

    group('getUserItems', () {
      final mockItems = [
        LostFoundItem(
          id: 'item1',
          authorId: 'user123',
          authorEmail: 'user@example.com',
          itemName: 'User Item 1',
          status: LostFoundItemStatus.lost,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final mockResponse = LostFoundItemsResponse(items: mockItems);

      test('gets user items successfully', () async {
        when(
          () => apiClient.getUserLostFoundItems(
            authorId: any(named: 'authorId'),
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getUserItems(
          authorId: 'user123',
          status: LostFoundItemStatus.lost,
        );

        expect(result, equals(mockItems));
        verify(
          () => apiClient.getUserLostFoundItems(
            authorId: 'user123',
            status: LostFoundItemStatus.lost,
            limit: 20,
            offset: 0,
          ),
        ).called(1);
      });

      test('throws GetLostFoundItemsFailure on error', () async {
        when(
          () => apiClient.getUserLostFoundItems(
            authorId: any(named: 'authorId'),
            status: any(named: 'status'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.getUserItems(authorId: 'user123'),
          throwsA(isA<GetLostFoundItemsFailure>()),
        );
      });
    });

    group('getItemsCount', () {
      test('gets items count successfully', () async {
        when(
          () => apiClient.getLostFoundItemsCount(
            status: any(named: 'status'),
            authorId: any(named: 'authorId'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => 42);

        final result = await repository.getItemsCount(
          status: LostFoundItemStatus.lost,
          authorId: 'user123',
          searchQuery: 'wallet',
        );

        expect(result, equals(42));
        verify(
          () => apiClient.getLostFoundItemsCount(
            status: LostFoundItemStatus.lost,
            authorId: 'user123',
            searchQuery: 'wallet',
          ),
        ).called(1);
      });

      test('throws GetLostFoundItemsFailure on error', () async {
        when(
          () => apiClient.getLostFoundItemsCount(
            status: any(named: 'status'),
            authorId: any(named: 'authorId'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => repository.getItemsCount(),
          throwsA(isA<GetLostFoundItemsFailure>()),
        );
      });
    });
  });
}
