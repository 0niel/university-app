import 'package:meta/meta.dart';
import 'package:nextcloud/ids.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage interface used by `Option`s.
///
/// Mimics the interface of [SharedPreferences].
///
/// See:
///   * [SingleValueStorage] for a storage that saves a single value.
///   * [AppStorage] for a storage that fully implements the [SharedPreferences] interface.
///   * [NeonStorage] that manages the storage backend.
@internal
abstract interface class SettingsStorage {
  /// {@template NeonStorage.getString}
  /// Reads a value from persistent storage, throwing an `Exception` if it's not a `String`.
  /// {@endtemplate}
  String? getString(String key);

  /// {@template NeonStorage.setString}
  /// Saves a `String` [value] to persistent storage in the background.
  ///
  /// Note: Due to limitations in Android's SharedPreferences,
  /// values cannot start with any one of the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'
  /// {@endtemplate}
  Future<bool> setString(String key, String value);

  /// {@template NeonStorage.getBool}
  /// Reads a value from persistent storage, throwing an `Exception` if it's not a `bool`.
  /// {@endtemplate}
  bool? getBool(String key);

  /// {@template NeonStorage.setBool}
  /// Saves a `bool` [value] to persistent storage in the background.
  /// {@endtemplate}
  // ignore: avoid_positional_boolean_parameters
  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(String key, bool value);

  /// {@template NeonStorage.remove}
  /// Removes an entry from persistent storage.
  /// {@endtemplate}
  Future<bool> remove(String key);
}

/// Interface of a storable element.
///
/// Usually used in enhanced enums to ensure uniqueness of the storage keys.
abstract interface class Storable {
  /// The key of this storage element.
  String get value;
}

/// Unique storage keys.
///
/// Required by the users of the [NeonStorage] storage backend.
///
/// See:
///   * [AppStorage] for a storage that fully implements the [SharedPreferences] interface.
///   * [SettingsStorage] for the public interface used in `Option`s.
@internal
enum StorageKeys implements Storable {
  /// The key for the `AppImplementation`s.
  apps._('app'),

  /// The key for the `Account`s and their `AccountOptions`.
  accounts._('accounts'),

  /// The key for the `GlobalOptions`.
  global._('global'),

  /// The key for the `AccountsBloc` last used account.
  lastUsedAccount._('last-used-account'),

  /// The key used by the `PushNotificationsBloc` to persist the last used endpoint.
  lastEndpoint._('last-endpoint'),

  /// The key for the `FirstLaunchBloc`.
  firstLaunch._('first-launch'),

  /// The key for the `PushUtils`.
  notifications._(AppIDs.notifications);

  const StorageKeys._(this.value);

  @override
  final String value;
}

/// Neon storage that manages the storage backend.
///
/// [init] must be called and completed before accessing individual storages.
///
/// See:
///   * [SingleValueStorage] for a storage that saves a single value.
///   * [AppStorage] for a storage that fully implements the [SharedPreferences] interface.
///   * [SettingsStorage] for the public interface used in `Option`s.
@internal
final class NeonStorage {
  const NeonStorage._();

  /// Shared preferences instance.
  ///
  /// Use [database] to access it.
  /// Make sure it has been initialized with [init] before.
  static SharedPreferences? _sharedPreferences;

  /// Initializes the database instance with a mocked value.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void mock(SharedPreferences mock) => _sharedPreferences = mock;

  /// Sets up the [SharedPreferences] instance.
  ///
  /// Required to be called before accessing [database].
  static Future<void> init() async {
    if (_sharedPreferences != null) {
      return;
    }

    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Returns the database instance.
  ///
  /// Throws a `StateError` if [init] has not completed.
  @visibleForTesting
  static SharedPreferences get database {
    if (_sharedPreferences == null) {
      throw StateError(
        'NeonStorage has not been initialized yet. Please make sure NeonStorage.init() has been called before and completed.',
      );
    }

    return _sharedPreferences!;
  }
}

/// A storage that saves a single value.
///
/// [NeonStorage.init] must be called and completed before accessing individual values.
///
/// See:
///   * [NeonStorage] to initialize the storage backend.
///   * [AppStorage] for a storage that fully implements the [SharedPreferences] interface.
///   * [SettingsStorage] for the public interface used in `Option`s.
@immutable
@internal
final class SingleValueStorage {
  /// Creates a new storage for a single value.
  const SingleValueStorage(this.key);

  /// The key used by the storage backend.
  final StorageKeys key;

  /// {@macro NeonStorage.containsKey}
  bool hasValue() => NeonStorage.database.containsKey(key.value);

  /// {@macro NeonStorage.remove}
  Future<bool> remove() => NeonStorage.database.remove(key.value);

  /// {@macro NeonStorage.getString}
  String? getString() => NeonStorage.database.getString(key.value);

  /// {@macro NeonStorage.setString}
  Future<bool> setString(String value) => NeonStorage.database.setString(key.value, value);

  /// {@macro NeonStorage.getBool}
  bool? getBool() => NeonStorage.database.getBool(key.value);

  /// {@macro NeonStorage.setBool}
  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBool(bool value) => NeonStorage.database.setBool(key.value, value);

  /// {@macro NeonStorage.getStringList}
  List<String>? getStringList() => NeonStorage.database.getStringList(key.value);

  /// {@macro NeonStorage.setStringList}
  Future<bool> setStringList(List<String> value) => NeonStorage.database.setStringList(key.value, value);
}

/// A storage that can save a group of values.
///
/// Implements the interface of [SharedPreferences].
/// [NeonStorage.init] must be called and completed before accessing individual values.
///
/// See:
///   * [NeonStorage] to initialize the storage backend.
///   * [SingleValueStorage] for a storage that saves a single value.
///   * [SettingsStorage] for the public interface used in `Option`s.
@immutable
@internal
final class AppStorage implements SettingsStorage {
  /// Creates a new app storage.
  const AppStorage(
    this.groupKey, [
    this.suffix,
  ]);

  /// The group key for this app storage.
  ///
  /// Keys are formatted with [formatKey]
  final StorageKeys groupKey;

  /// The optional suffix of the storage key.
  ///
  /// Used to differentiate between multiple AppStorages with the same [groupKey].
  final String? suffix;

  /// Returns the id for this app storage.
  ///
  /// Uses the [suffix] and falling back to the [groupKey] if not present.
  /// This uniquely identifies the storage and is used in `Exportable` classes.
  String get id => suffix ?? groupKey.value;

  /// Concatenates the [groupKey], [suffix] and [key] to build a unique key
  /// used in the storage backend.
  @visibleForTesting
  String formatKey(String key) {
    if (suffix != null) {
      return '${groupKey.value}-$suffix-$key';
    }

    return '${groupKey.value}-$key';
  }

  /// {@template NeonStorage.containsKey}
  /// Returns true if the persistent storage contains the given [key].
  /// {@endtemplate}
  bool containsKey(String key) => NeonStorage.database.containsKey(formatKey(key));

  @override
  Future<bool> remove(String key) => NeonStorage.database.remove(formatKey(key));

  @override
  String? getString(String key) => NeonStorage.database.getString(formatKey(key));

  @override
  Future<bool> setString(String key, String value) => NeonStorage.database.setString(formatKey(key), value);

  @override
  bool? getBool(String key) => NeonStorage.database.getBool(formatKey(key));

  @override
  Future<bool> setBool(String key, bool value) => NeonStorage.database.setBool(formatKey(key), value);

  /// {@template NeonStorage.getStringList}
  /// Reads a set of string values from persistent storage, throwing an `Exception` if it's not a `String` set.
  /// {@endtemplate}
  List<String>? getStringList(String key) => NeonStorage.database.getStringList(formatKey(key));

  /// {@template NeonStorage.setStringList}
  /// Saves a list of `String` [value]s to persistent storage in the background.
  /// {@endtemplate}
  Future<bool> setStringList(String key, List<String> value) =>
      NeonStorage.database.setStringList(formatKey(key), value);
}
