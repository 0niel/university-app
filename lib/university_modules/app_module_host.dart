import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/university_modules/module_scoped_storage.dart';
import 'package:university_modules/university_modules.dart';

final class AppModuleHost implements ModuleHost, DigitalPassDeviceHost {
  AppModuleHost({
    required this.organizationId,
    required this.accountId,
    required this.digitalPassAvailable,
    required this._storage,
    this._setDigitalPassSession,
    this._clearDigitalPassSession,
    this._clearDigitalPassBinding,
  });

  @override
  final String organizationId;
  @override
  final String accountId;
  @override
  final bool digitalPassAvailable;

  final ModuleScopedStorage _storage;
  final Future<void> Function(String cookie)? _setDigitalPassSession;
  final Future<void> Function()? _clearDigitalPassSession;
  final Future<void> Function()? _clearDigitalPassBinding;

  @override
  Future<void> Function(String cookie)? get setDigitalPassSession =>
      digitalPassAvailable && _setDigitalPassSession != null
      ? _adoptDigitalPassSession
      : null;

  @override
  Future<void> Function()? get clearDigitalPassSession =>
      digitalPassAvailable && _clearDigitalPassSession != null
      ? _removeDigitalPassSession
      : null;

  Future<void> _adoptDigitalPassSession(String cookie) async {
    _storage.checkAccount();
    await _setDigitalPassSession!(cookie);
    _storage.checkAccount();
  }

  Future<void> _removeDigitalPassSession() async {
    _storage.checkAccount();
    await _clearDigitalPassSession!();
    _storage.checkAccount();
  }

  @override
  Future<void> clearDigitalPassBinding() async {
    _storage.checkAccount();
    final clear = _clearDigitalPassBinding;
    if (!digitalPassAvailable || clear == null) {
      throw UnsupportedError('Device pass removal is unavailable.');
    }
    await clear();
    _storage.checkAccount();
  }

  @override
  Future<String?> readSecure(String key) => _storage.read(key);

  @override
  Future<void> writeSecure(String key, String value) =>
      _storage.write(key, value);

  @override
  Future<void> deleteSecure(String key) => _storage.delete(key);

  @override
  Future<void> openDigitalPass(BuildContext context) async {
    _storage.checkAccount();
    if (!digitalPassAvailable || !context.mounted) return;
    await context.push<void>('/services/nfc');
  }
}
