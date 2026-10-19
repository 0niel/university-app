import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/university_modules/module_scoped_storage.dart';
import 'package:university_modules/university_modules.dart';

final class AppModuleHost implements ModuleHost, DigitalPassDeviceHost {
  const AppModuleHost({
    required this.organizationId,
    required this.accountId,
    required this.digitalPassAvailable,
    required this._storage,
    Future<String?> Function()? institutionLogin,
    Future<void> Function(String cookie)? setDigitalPassSession,
    Future<void> Function()? clearDigitalPassSession,
    Future<void> Function()? clearDigitalPassBinding,
  }) : _onInstitutionLogin = institutionLogin,
       _onSetDigitalPassSession = setDigitalPassSession,
       _onClearDigitalPassSession = clearDigitalPassSession,
       _onClearDigitalPassBinding = clearDigitalPassBinding;

  @override
  final String organizationId;
  @override
  final String accountId;
  @override
  final bool digitalPassAvailable;

  final ModuleScopedStorage _storage;
  final Future<String?> Function()? _onInstitutionLogin;
  final Future<void> Function(String cookie)? _onSetDigitalPassSession;
  final Future<void> Function()? _onClearDigitalPassSession;
  final Future<void> Function()? _onClearDigitalPassBinding;

  @override
  Future<String?> Function()? get institutionLogin =>
      _onInstitutionLogin == null ? null : _runInstitutionLogin;

  Future<String?> _runInstitutionLogin() async {
    _storage.checkAccount();
    final cookie = await _onInstitutionLogin!();
    _storage.checkAccount();
    return cookie;
  }

  @override
  Future<void> Function(String cookie)? get setDigitalPassSession =>
      digitalPassAvailable && _onSetDigitalPassSession != null
      ? _adoptDigitalPassSession
      : null;

  @override
  Future<void> Function()? get clearDigitalPassSession =>
      digitalPassAvailable && _onClearDigitalPassSession != null
      ? _removeDigitalPassSession
      : null;

  Future<void> _adoptDigitalPassSession(String cookie) async {
    _storage.checkAccount();
    await _onSetDigitalPassSession!(cookie);
    _storage.checkAccount();
  }

  Future<void> _removeDigitalPassSession() async {
    _storage.checkAccount();
    await _onClearDigitalPassSession!();
    _storage.checkAccount();
  }

  @override
  Future<void> clearDigitalPassBinding() async {
    _storage.checkAccount();
    final clear = _onClearDigitalPassBinding;
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
