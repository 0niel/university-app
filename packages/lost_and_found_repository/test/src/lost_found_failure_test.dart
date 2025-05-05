import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';

void main() {
  group('LostFoundFailure', () {
    test('equatable props contains error', () {
      const error = 'test error';
      final failures = [
        const CreateLostFoundItemFailure(error),
        const UpdateLostFoundItemFailure(error),
        const DeleteLostFoundItemFailure(error),
        const GetLostFoundItemsFailure(error),
        const SearchLostFoundItemsFailure(error),
        const GetLostFoundItemFailure(error),
      ];

      for (final failure in failures) {
        expect(failure.props, [error]);
      }
    });

    test('failures with same error are equal', () {
      const error = 'test error';

      expect(
        const CreateLostFoundItemFailure(error),
        equals(const CreateLostFoundItemFailure(error)),
      );

      expect(
        const UpdateLostFoundItemFailure(error),
        equals(const UpdateLostFoundItemFailure(error)),
      );

      expect(
        const DeleteLostFoundItemFailure(error),
        equals(const DeleteLostFoundItemFailure(error)),
      );

      expect(
        const GetLostFoundItemsFailure(error),
        equals(const GetLostFoundItemsFailure(error)),
      );

      expect(
        const SearchLostFoundItemsFailure(error),
        equals(const SearchLostFoundItemsFailure(error)),
      );

      expect(
        const GetLostFoundItemFailure(error),
        equals(const GetLostFoundItemFailure(error)),
      );
    });

    test('failures with different errors are not equal', () {
      const error1 = 'test error 1';
      const error2 = 'test error 2';

      expect(
        const CreateLostFoundItemFailure(error1),
        isNot(equals(const CreateLostFoundItemFailure(error2))),
      );

      expect(
        const UpdateLostFoundItemFailure(error1),
        isNot(equals(const UpdateLostFoundItemFailure(error2))),
      );
    });

    test('different failure types are not equal', () {
      const error = 'test error';

      expect(
        const CreateLostFoundItemFailure(error),
        isNot(equals(const UpdateLostFoundItemFailure(error))),
      );

      expect(
        const GetLostFoundItemsFailure(error),
        isNot(equals(const GetLostFoundItemFailure(error))),
      );
    });
  });
}
