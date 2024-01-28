import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart' show Account;
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/settings/models/exportable.dart';
import 'package:neon_framework/src/settings/models/option.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:neon_framework/src/utils/findable.dart';

/// Helper class to export all [Option]s.
///
/// Json based operations:
/// * [exportToJson]
/// * [applyFromJson]
///
/// [Uint8List] based operations:
/// * [exportToFile]
/// * [applyFromFile]
@internal
@immutable
class SettingsExportHelper {
  /// Creates a new settings exporter for the given [exportables].
  const SettingsExportHelper({
    required this.exportables,
  });

  /// Collections of elements to export.
  final Set<Exportable> exportables;

  /// Imports [file] and applies the stored [Option]s.
  ///
  /// See:
  /// * [applyFromJson] to import a json map.
  Future<void> applyFromFile(Stream<List<int>>? file) async {
    final transformer = const Utf8Decoder().fuse(const JsonDecoder());

    final data = await file?.transform(transformer).single;

    if (data == null) {
      return;
    }

    await applyFromJson(data as Map<String, Object?>);
  }

  /// Imports the [json] data and applies the stored [Option]s.
  ///
  /// See:
  /// * [applyFromFile] to import data from a [Stream<Uint8List>].
  Future<void> applyFromJson(Map<String, Object?> json) async {
    for (final exportable in exportables) {
      await exportable.import(json);
    }
  }

  /// Exports the stored [Option]s into a [Uint8List].
  ///
  /// See:
  /// * [exportToJson] to export to a json map.
  Uint8List exportToFile() {
    final transformer = JsonUtf8Encoder();

    final json = exportToJson();
    return transformer.convert(json) as Uint8List;
  }

  /// Exports the stored [Option]s into a json map.
  ///
  /// See:
  /// * [exportToFile] to export data to a [Uint8List].
  Map<String, Object?> exportToJson() => Map.fromEntries(exportables.map((e) => e.export()));
}

/// Helper class to export [AppImplementation]s implementing the [Exportable] interface.
@internal
@immutable
class AppImplementationsExporter implements Exportable {
  /// Creates a new [AppImplementation] exporter.
  const AppImplementationsExporter(this.appImplementations);

  /// List of apps to export.
  final Iterable<AppImplementation> appImplementations;

  /// Key the exported value will be stored at.
  static final _key = StorageKeys.apps.value;

  @override
  MapEntry<String, Object?> export() => MapEntry(
        _key,
        Map.fromEntries(appImplementations.map((app) => app.options.export())),
      );

  @override
  void import(Map<String, Object?> data) {
    final values = data[_key] as Map<String, Object?>?;

    if (values == null) {
      return;
    }

    for (final element in values.entries) {
      final app = appImplementations.tryFind(element.key);

      if (app != null) {
        app.options.import(values);
      }
    }
  }
}

/// Helper class to export [Account]s implementing the [Exportable] interface.
@internal
@immutable
class AccountsBlocExporter implements Exportable {
  /// Creates a new [Account] exporter.
  const AccountsBlocExporter(this.accountsBloc);

  /// AccountsBloc containing the accounts to export.
  final AccountsBloc accountsBloc;

  /// Key the exported value will be stored at.
  static final _key = StorageKeys.accounts.value;

  @override
  MapEntry<String, Object?> export() => MapEntry(_key, Map.fromEntries(_serialize()));

  Iterable<MapEntry<String, Object?>> _serialize() sync* {
    for (final account in accountsBloc.accounts.value) {
      yield accountsBloc.getOptionsFor(account).export();
    }
  }

  @override
  void import(Map<String, Object?> data) {
    final values = data[_key] as Map<String, Object?>?;

    if (values == null) {
      return;
    }

    for (final element in values.entries) {
      final account = accountsBloc.accounts.value.tryFind(element.key);

      if (account != null) {
        accountsBloc.getOptionsFor(account).import(values);
      }
    }
  }
}
