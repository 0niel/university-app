import 'package:collection/collection.dart';

/// Interface to be implemented by classes that want to use the [FindExtension.find] and [FindExtension.tryFind] methods.
abstract interface class Findable {
  /// Unique ID of the element.
  String get id;
}

/// An extension to find [Findable]s in an iterable.
extension FindExtension<T extends Findable> on Iterable<T> {
  /// Returns the first element matching [id] by [Findable.id].
  ///
  /// If no element was found `null` is returned.
  T? tryFind(String? id) {
    if (id == null) {
      return null;
    }

    return firstWhereOrNull((e) => e.id == id);
  }

  /// Returns the first element matching [id] by [Findable.id].
  ///
  /// Throws a [StateError] if no item was found.
  /// Use [tryFind] to get a nullable result.
  T find(String id) => firstWhere((e) => e.id == id);
}
