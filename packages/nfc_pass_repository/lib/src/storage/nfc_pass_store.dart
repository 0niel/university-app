import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:nfc_pass_repository/src/nfc_pass_failure.dart';
import 'package:storage/storage.dart';

final class NfcPassStore {
  NfcPassStore({
    required Storage storage,
    required DigitalPassChannel digitalPassChannel,
  })  : _secureStorage = storage,
        _digitalPassChannel = digitalPassChannel;

  final Storage _secureStorage;
  final DigitalPassChannel _digitalPassChannel;

  static const _kKeyCookie = 'nfc_cookie';
  static const _kKeyJwt = 'nfc_jwt';
  static const _kKeyPassId = 'nfc_pass_id';
  static const _kKeySessionAccount = 'nfc_session_account';

  Future<void> _storageOperation = Future<void>.value();
  int _sessionRevision = 0;
  int _sessionChangeRequest = 0;
  bool _sessionAllowed = true;
  bool _accountManaged = false;
  bool _accountReady = false;
  String? _accountId;
  int _accountRevision = 0;

  Future<void> synchronizeSessionAccount(String? accountId) {
    if (accountId != null && accountId.isEmpty) {
      throw ArgumentError.value(accountId, 'accountId');
    }
    if (_accountManaged && _accountReady && _accountId == accountId) {
      return Future<void>.value();
    }
    final forceClear = _accountManaged && _accountId != accountId;
    _accountManaged = true;
    _accountReady = false;
    _accountId = accountId;
    _sessionAllowed = false;
    final accountRevision = ++_accountRevision;
    final sessionRevision = ++_sessionRevision;
    _sessionChangeRequest++;
    return _serializeStorage(() async {
      final storedAccount = await _secureStorage.read(key: _kKeySessionAccount);
      if (forceClear || accountId == null || storedAccount != accountId) {
        await _secureStorage.write(key: _kKeySessionAccount, value: '');
        await _secureStorage.delete(key: _kKeyCookie);
        await _secureStorage.delete(key: _kKeyJwt);
      }
      if (_accountRevision != accountRevision) return;
      if (accountId != null && (forceClear || storedAccount != accountId)) {
        await _secureStorage.write(
          key: _kKeySessionAccount,
          value: accountId,
        );
      }
      if (_accountRevision != accountRevision) return;
      _accountReady = true;
      _sessionAllowed =
          accountId != null && _sessionRevision == sessionRevision;
    });
  }

  void _checkAccountForWrite() {
    if (_accountManaged && (!_accountReady || _accountId == null)) {
      throw const NfcPassLoginFailure(
        'The authenticated account is unavailable.',
      );
    }
  }

  Future<T> _serializeStorage<T>(Future<T> Function() operation) {
    final result = _storageOperation.then((_) => operation());
    _storageOperation = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<(String?, int)> readSession() => _serializeStorage(() async {
        final cookie = _sessionAllowed
            ? await _secureStorage.read(key: _kKeyCookie)
            : null;
        return (_sessionAllowed ? cookie : null, _sessionRevision);
      });

  Future<String?> readSessionCookie() async => (await readSession()).$1;

  Future<void> setSessionCookie(String cookie) {
    nfcSessionCookieHeader(cookie);
    final request = ++_sessionChangeRequest;
    return _serializeStorage(() => _storeSessionCookie(cookie, request));
  }

  void _checkSessionChange(int request) {
    if (_sessionChangeRequest != request) {
      throw const NfcPassLoginFailure('The authenticated session changed.');
    }
  }

  Future<void> _storeSessionCookie(String cookie, int request) async {
    _checkAccountForWrite();
    _checkSessionChange(request);
    final previous = await _secureStorage.read(key: _kKeyCookie);
    _checkSessionChange(request);
    if (previous == cookie && _sessionAllowed) return;
    _sessionRevision++;
    await _secureStorage.delete(key: _kKeyJwt);
    await _secureStorage.write(key: _kKeyCookie, value: cookie);
    _checkSessionChange(request);
    if (_accountManaged) {
      await _secureStorage.write(key: _kKeySessionAccount, value: _accountId!);
      _checkSessionChange(request);
    }
    _sessionAllowed = true;
  }

  Future<void> clearSessionCookie() {
    _sessionAllowed = false;
    _sessionRevision++;
    _sessionChangeRequest++;
    return _serializeStorage(() async {
      final accountRevision = _accountRevision;
      if (_accountManaged) {
        await _secureStorage.write(key: _kKeySessionAccount, value: '');
      }
      await _secureStorage.delete(key: _kKeyCookie);
      await _secureStorage.delete(key: _kKeyJwt);
      if (_accountManaged &&
          _accountReady &&
          _accountId != null &&
          _accountRevision == accountRevision) {
        await _secureStorage.write(
          key: _kKeySessionAccount,
          value: _accountId!,
        );
      }
    });
  }

  void checkSession(int revision) {
    if (_sessionRevision != revision) {
      throw const NfcPassLoginFailure('The authenticated session changed.');
    }
  }

  /// Checks if the pass is already bound (if passId exists in local storage).
  Future<bool> isPassBound() async {
    final passId = await _secureStorage.read(key: _kKeyPassId);
    return passId != null;
  }

  /// Returns the saved passId (or null if not saved).
  ///
  /// Re-mirrors the id to the native store on every read so already-bound users
  /// self-heal when they open the pass screen (best-effort — a native hiccup
  /// must not break reading the pass).
  Future<int?> getPassId() async {
    final passIdString = await _secureStorage.read(key: _kKeyPassId);
    if (passIdString == null) return null;
    final passId = int.tryParse(passIdString);
    if (passId != null) {
      try {
        await _digitalPassChannel.savePassId(passId);
      } on Object {
        // Best-effort sync; ignore native errors.
      }
    }
    return passId;
  }

  /// Unbinds the pass (clears cookie, token, passId).
  Future<void> unbindPass() {
    _sessionAllowed = false;
    _sessionRevision++;
    _sessionChangeRequest++;
    return _serializeStorage(() async {
      await _secureStorage.delete(key: _kKeyCookie);
      await _secureStorage.delete(key: _kKeyJwt);
      await _secureStorage.delete(key: _kKeyPassId);
      await _digitalPassChannel.clearPassId();
    });
  }

  int get sessionRevision => _sessionRevision;

  Future<int> invalidateRejectedSession(int revision) =>
      _serializeStorage(() async {
        checkSession(revision);
        final nextRevision = ++_sessionRevision;
        await _secureStorage.delete(key: _kKeyCookie);
        await _secureStorage.delete(key: _kKeyJwt);
        checkSession(nextRevision);
        return nextRevision;
      });

  Future<(String, String, int)> readConfirmation() =>
      _serializeStorage(() async {
        if (!_sessionAllowed) return ('', '', _sessionRevision);
        final jwt = await _secureStorage.read(key: _kKeyJwt) ?? '';
        final cookie = await _secureStorage.read(key: _kKeyCookie) ?? '';
        return _sessionAllowed
            ? (jwt, cookie, _sessionRevision)
            : ('', '', _sessionRevision);
      });

  Future<(int, int)> captureLogin(int expectedRevision) =>
      _serializeStorage(() async {
        checkSession(expectedRevision);
        _checkAccountForWrite();
        return (_sessionRevision, _sessionChangeRequest);
      });

  Future<void> storeLoginCookie(String cookie, int revision, int request) =>
      _serializeStorage(() async {
        checkSession(revision);
        await _storeSessionCookie(cookie, request);
      });

  Future<void> saveJwt(String jwt, int revision) => _serializeStorage(() async {
        checkSession(revision);
        await _secureStorage.write(key: _kKeyJwt, value: jwt);
        checkSession(revision);
      });

  Future<void> savePass(int passId, int revision) =>
      _serializeStorage(() async {
        checkSession(revision);
        final previous = await _secureStorage.read(key: _kKeyPassId);
        checkSession(revision);
        await _secureStorage.write(key: _kKeyPassId, value: passId.toString());
        var nativeWriteStarted = false;
        try {
          checkSession(revision);
          nativeWriteStarted = true;
          await _digitalPassChannel.savePassId(passId);
          checkSession(revision);
        } on NfcPassLoginFailure {
          if (previous == null) {
            await _secureStorage.delete(key: _kKeyPassId);
          } else {
            await _secureStorage.write(key: _kKeyPassId, value: previous);
          }
          if (nativeWriteStarted) {
            final previousId = int.tryParse(previous ?? '');
            if (previousId == null) {
              await _digitalPassChannel.clearPassId();
            } else {
              await _digitalPassChannel.savePassId(previousId);
            }
          }
          rethrow;
        }
      });
}
