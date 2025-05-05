import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:university_app_server_api/client.dart';

void main() {
  group('Package exports', () {
    test('exports LostFoundRepository', () {
      expect(LostFoundRepository, isNotNull);

      // Verify we can instantiate the repository
      final repo = LostFoundRepository(apiClient: MockApiClient());
      expect(repo, isA<LostFoundRepository>());
    });

    test('exports LostFoundFailure classes', () {
      expect(LostFoundFailure, isNotNull);
      expect(CreateLostFoundItemFailure, isNotNull);
      expect(UpdateLostFoundItemFailure, isNotNull);
      expect(DeleteLostFoundItemFailure, isNotNull);
      expect(GetLostFoundItemsFailure, isNotNull);
      expect(SearchLostFoundItemsFailure, isNotNull);
      expect(GetLostFoundItemFailure, isNotNull);

      // Verify we can instantiate the failure classes
      const error = 'test error';
      expect(const CreateLostFoundItemFailure(error), isA<LostFoundFailure>());
      expect(const UpdateLostFoundItemFailure(error), isA<LostFoundFailure>());
      expect(const DeleteLostFoundItemFailure(error), isA<LostFoundFailure>());
      expect(const GetLostFoundItemsFailure(error), isA<LostFoundFailure>());
      expect(const SearchLostFoundItemsFailure(error), isA<LostFoundFailure>());
      expect(const GetLostFoundItemFailure(error), isA<LostFoundFailure>());
    });

    test('exports LostFoundItem model', () {
      expect(LostFoundItem, isNotNull);

      // Verify we can instantiate and use LostFoundItem
      final item = LostFoundItem(
        authorId: 'user123',
        authorEmail: 'user@example.com',
        itemName: 'Test Item',
        status: LostFoundItemStatus.lost,
        createdAt: DateTime.now(),
      );

      expect(item, isA<LostFoundItem>());
      expect(item.authorId, equals('user123'));
      expect(item.itemName, equals('Test Item'));
      expect(item.status, equals(LostFoundItemStatus.lost));
    });

    test('exports LostFoundItemStatus enum', () {
      expect(LostFoundItemStatus, isNotNull);
      expect(LostFoundItemStatus.lost, isNotNull);
      expect(LostFoundItemStatus.found, isNotNull);
      expect(LostFoundItemStatus.values.length, equals(2));

      // Verify we can use the enum values
      const lostStatus = LostFoundItemStatus.lost;
      const foundStatus = LostFoundItemStatus.found;

      expect(lostStatus.toString().contains('lost'), isTrue);
      expect(foundStatus.toString().contains('found'), isTrue);
    });

    test('exports LostFoundItemsResponse model', () {
      expect(LostFoundItemsResponse, isNotNull);

      // Verify we can instantiate and use LostFoundItemsResponse
      final items = [
        LostFoundItem(
          id: 'item1',
          authorId: 'user1',
          authorEmail: 'user1@example.com',
          itemName: 'Item 1',
          status: LostFoundItemStatus.lost,
          createdAt: DateTime.now(),
        ),
      ];

      final response = LostFoundItemsResponse(items: items);

      expect(response, isA<LostFoundItemsResponse>());
      expect(response.items, hasLength(1));
      expect(response.items.first.id, equals('item1'));
    });
  });
}

// Mock for testing repository instantiation
class MockApiClient implements ApiClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
