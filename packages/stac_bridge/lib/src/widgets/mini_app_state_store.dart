import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

class MiniAppStateStore extends ChangeNotifier {
  final Map<String, Object?> _values = <String, Object?>{};
  final Map<String, Object?> _initial = <String, Object?>{};
  static const _equality = DeepCollectionEquality();
  bool _disposed = false;
  BuildContext? actionContext;
  final Map<String, int> _requests = {};
  int _requestId = 0;
  bool _reconcileQueued = false;

  bool get isDisposed => _disposed;

  int beginRequest(String key) {
    final id = ++_requestId;
    _requests[key] = id;
    return id;
  }

  bool isCurrentRequest(String key, int id) =>
      !_disposed && _requests[key] == id;

  void finishRequest(String key, int id) {
    if (_requests[key] == id) _requests.remove(key);
  }

  void seed(Map<String, Object?> initial) {
    _values.addAll(initial);
    _initial.addAll(initial);
  }

  void reconcile(Map<String, Object?> initial) {
    var changed = false;
    for (final entry in initial.entries) {
      if (!_values.containsKey(entry.key) ||
          _equality.equals(_values[entry.key], _initial[entry.key])) {
        changed = changed || !_equality.equals(_values[entry.key], entry.value);
        _values[entry.key] = entry.value;
      }
    }
    _initial
      ..clear()
      ..addAll(initial);
    if (changed && !_reconcileQueued && !_disposed) {
      _reconcileQueued = true;
      scheduleMicrotask(() {
        _reconcileQueued = false;
        if (!_disposed) notifyListeners();
      });
    }
  }

  Object? get(String key) => _values[key];

  Map<String, Object?> snapshot() => .unmodifiable(_values);

  void set(String key, Object? value) {
    setAll({key: value});
  }

  void setAll(Map<String, Object?> values) {
    if (_disposed) return;
    var changed = false;
    for (final entry in values.entries) {
      if (!_values.containsKey(entry.key) ||
          !_equality.equals(_values[entry.key], entry.value)) {
        _values[entry.key] = entry.value;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void add(String key, num delta) {
    final current = get(key);
    final base = current is num
        ? current
        : num.tryParse(current?.toString() ?? '');
    set(key, (base ?? 0) + delta);
  }

  @override
  void dispose() {
    _disposed = true;
    actionContext = null;
    _values.clear();
    _initial.clear();
    _requests.clear();
    super.dispose();
  }
}
