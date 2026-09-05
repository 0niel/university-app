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
  String? _boundUserId;
  var _hasUserBinding = false;
  var _generation = 0;
  var _active = false;
  var _rotationRequired = false;

  Future<void> synchronizeUser(String? userId) {
    final next = userId == null || userId.isEmpty ? null : userId;
    if (_hasUserBinding && next == _boundUserId) {
      return next == null ? Future.value() : start();
    }
    final previous = _boundUserId;
    _boundUserId = next;
    _hasUserBinding = true;
    if (next == null) return stopAndUnregister();
    return _activate(rotate: previous != null && previous != next);
  }

  Future<void> start() {
    if (_active) return Future.value();
    return _activate(rotate: false);
  }

  Future<void> _activate({required bool rotate}) {
    _rotationRequired = _rotationRequired || rotate;
    final generation = ++_generation;
    _active = true;
    final cancellation = _cancelRefresh();
    return _enqueue(() async {
      await cancellation;
      if (!_isCurrent(generation)) return;
      try {
        if (_rotationRequired) {
          _registeredToken = null;
          await _onDeleteToken();
          if (!_isCurrent(generation)) return;
          _rotationRequired = false;
        }
        _refreshSubscription = _tokenRefresh.listen(
          (token) => unawaited(
            _enqueue(() async {
              try {
                await _register(token, generation);
              } on Object catch (error, stackTrace) {
                if (_isCurrent(generation)) {
                  _active = false;
                  _generation++;
                  await _cancelRefresh();
                }
                _onError(error, stackTrace);
              }
            }),
          ),
          onError: _onError,
        );
        final token = await _onGetToken();
        if (token == null || token.isEmpty) {
          throw StateError('Firebase device token is not available yet');
        }
        await _register(token, generation);
      } on Object {
        if (_isCurrent(generation)) {
          _active = false;
          _generation++;
          await _cancelRefresh();
        }
        rethrow;
      }
    });
  }

  Future<void> pause() async {
    _active = false;
    _generation++;
    await _cancelRefresh();
    await _serial;
  }

  Future<void> stopAndUnregister() => _stop(unregister: true);

  Future<void> invalidate() => _stop(unregister: false);

  Future<void> _stop({required bool unregister}) {
    _rotationRequired = true;
    final wasActive = _active;
    final generation = ++_generation;
    _active = false;
    final cancellation = _cancelRefresh();
    return _enqueue(() async {
      await cancellation;
      try {
        if (unregister && generation == _generation) {
          final token =
              _registeredToken ?? (wasActive ? await _onGetToken() : null);
          if (token != null && generation == _generation) {
            await _onUnregister(token);
          }
        }
      } finally {
        _registeredToken = null;
        await _onDeleteToken();
        if (generation == _generation) _rotationRequired = false;
      }
    });
  }

  Future<void> _cancelRefresh() {
    final cancellation = _refreshSubscription?.cancel() ?? Future<void>.value();
    _refreshSubscription = null;
    return cancellation;
  }

  bool _isCurrent(int generation) => _active && generation == _generation;

  Future<void> _register(String token, int generation) async {
    if (!_isCurrent(generation)) return;
    final previous = _registeredToken;
    if (previous == token) return;
    if (previous != null) await _onUnregister(previous);
    if (!_isCurrent(generation)) return;
    await _onRegister(token);
    _registeredToken = token;
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
