import 'dart:async';

import 'package:collection/collection.dart';
import 'package:neon_framework/src/settings/models/option.dart';

/// Exportable data interface.
abstract interface class Exportable {
  /// Exports into a json map entry.
  MapEntry<String, Object?> export();

  /// Imports [data] from an export.
  FutureOr<void> import(Map<String, Object?> data);
}

/// Serialization helpers for a collection of [Option]s.
extension SerializeOptions on Iterable<Option<dynamic>> {
  /// Serializes into an [Iterable<JsonEntry>].
  ///
  /// Use [Map.fromEntries] to get a json Map.
  Iterable<MapEntry<String, Object?>> serialize() sync* {
    for (final option in this) {
      if (option.enabled) {
        yield MapEntry(option.key.value, option.serialize());
      }
    }
  }

  /// Deserializes [data] and updates the [Option]s.
  void deserialize(Map<String, Object?> data) {
    for (final entry in data.entries) {
      final option = firstWhereOrNull((option) => option.key.value == entry.key);

      if (entry.value != null) {
        option?.load(entry.value);
      } else {
        option?.reset();
      }
    }
  }
}
