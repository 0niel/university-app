import 'package:storage/storage.dart';

final class ModuleScopedStorage {
  ModuleScopedStorage({
    required this._storage,
    required String organizationId,
    required String accountId,
    required String moduleId,
    required this._isAccountActive,
  }) : _prefix = [
         'university-module',
         organizationId,
         accountId,
         moduleId,
       ].map(Uri.encodeComponent).join(':') {
    if (organizationId.isEmpty || accountId.isEmpty || moduleId.isEmpty) {
      throw ArgumentError('Module storage requires a complete account scope.');
    }
  }

  final Storage _storage;
  final bool Function() _isAccountActive;
  final String _prefix;

  void checkAccount() {
    if (!_isAccountActive()) throw const ModuleAccountChangedException();
  }

  String _key(String key) {
    checkAccount();
    if (!RegExp(r'^[A-Za-z0-9._-]{1,120}$').hasMatch(key)) {
      throw ArgumentError('Invalid module storage key.');
    }
    return '$_prefix:$key';
  }

  Future<String?> read(String key) async {
    final value = await _storage.read(key: _key(key));
    checkAccount();
    return value;
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: _key(key), value: value);
    checkAccount();
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: _key(key));
    checkAccount();
  }
}

final class ModuleAccountChangedException implements Exception {
  const ModuleAccountChangedException();

  @override
  String toString() => 'The module account session has changed.';
}
