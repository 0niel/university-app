import 'dart:async';

final class DeviceTokenSyncController {
  DeviceTokenSyncController({
    required Future<String?> Function() getToken,
    required this._tokenRefresh,
    required Future<void> Function(String token) register,
    required Future<void> Function(String token) unregister,
    required Future<void> Function() deleteToken,
    required this._onError,
  }) : _onGetToken = getToken,
       _onRegister = register,
       _onUnregister = unregister,
       _onDeleteToken = deleteToken;

  final Future<String?> Function() _onGetToken;
  final Stream<String> _tokenRefresh;
  final Future<void> Function(String token) _onRegister;
  final Future<void> Function(String token) _onUnregister;
  final Future<void> Function() _onDeleteToken;
  final void Function(Object error, StackTrace stackTrace) _onError;

  Future<void> _serial = Future.value();
  StreamSubscription<String>? _refreshSubscription;
  String? _registeredToken;
  var _generation = 0;
  var _active = false;

  Future<void> start() async {
    if (_active) return;
    _active = true;
    final generation = ++_generation;
    _refreshSubscription = _tokenRefresh.listen(
      (token) => unawaited(
        _registerIfCurrent(token, generation).onError(_onError),
      ),
      onError: _onError,
    );

    try {
      final token = await _onGetToken();
      if (token != null) await _registerIfCurrent(token, generation);
    } on Exception {
      await pause();
      rethrow;
    }
  }

  Future<void> pause() async {
    _active = false;
    _generation++;
    await _refreshSubscription?.cancel();
    _refreshSubscription = null;
  }

  Future<void> stopAndUnregister() async {
    final wasActive = _active;
    await pause();
    if (!wasActive && _registeredToken == null) {
      await _onDeleteToken();
      return;
    }
    try {
      await _enqueue(() async {
        final token = _registeredToken ?? await _onGetToken();
        if (token == null) return;
        await _onUnregister(token);
        _registeredToken = null;
      });
    } finally {
      await _onDeleteToken();
    }
  }

  Future<void> _registerIfCurrent(String token, int generation) {
    return _enqueue(() async {
      if (!_active || generation != _generation) return;
      final previous = _registeredToken;
      if (previous == token) return;
      if (previous != null) await _onUnregister(previous);
      if (!_active || generation != _generation) return;
      await _onRegister(token);
      _registeredToken = token;
    });
  }

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _serial.then((_) => operation());
    _serial = result.then<void>(
      (_) => null,
      onError: (Object _, StackTrace _) => null,
    );
    return result;
  }
}
