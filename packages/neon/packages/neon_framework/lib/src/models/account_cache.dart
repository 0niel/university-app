import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/utils/findable.dart';

/// Cache for [Account] specific [Disposable] objects.
class AccountCache<T extends Disposable> implements Disposable {
  /// Creates a new account cache.
  AccountCache();

  final Map<String, T> _cache = {};

  /// Disposes all entries and clears the cache.
  @override
  void dispose() {
    _cache
      ..disposeAll()
      ..clear();
  }

  /// Updates the cache against the given [accounts].
  ///
  /// Every cache entry with an account no longer in [accounts] is removed and
  /// disposed. This method is in O(N²).
  void pruneAgainst(Iterable<Account> accounts) {
    _cache.removeWhere((key, value) {
      if (accounts.tryFind(key) == null) {
        value.dispose();
        return true;
      }

      return false;
    });
  }

  /// Removes [account] and its associated value, if present, from the cache.
  ///
  /// If present the value associated with `account` is disposed.
  void remove(Account? account) {
    final removed = _cache.remove(account?.id);
    removed?.dispose();
  }

  /// The value for the given [account], or `null` if [account] is not in the cache.
  T? operator [](Account account) => _cache[account.id];

  /// Associates the [account] with the given [value].
  ///
  /// If the account was already in the cache, its associated value is changed.
  /// Otherwise the account/value pair is added to the cache.
  void operator []=(Account account, T value) => _cache[account.id] = value;
}
