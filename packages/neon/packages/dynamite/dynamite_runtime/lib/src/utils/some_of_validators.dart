import 'package:collection/collection.dart';

/// Validates that at least one value in the given list is not `null`.
///
/// Throws a [Exception] in the case all values are null.
void validateAnyOf(List<dynamic> values) {
  final match = values.firstWhereOrNull((x) => x != null);
  if (match == null) {
    throw Exception('At least one of $values must not be null');
  }
}

/// Validates that exactly one value in the given list is not null.
///
/// Throws a [Exception] when no or more than one value is not null.
void validateOneOf(List<dynamic> values) {
  final match = values.singleWhereOrNull((x) => x != null);
  if (match == null) {
    throw Exception('Exactly one of $values must not be null');
  }
}
