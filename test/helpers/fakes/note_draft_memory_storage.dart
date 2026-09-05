import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class NoteDraftMemoryStorage implements Storage {
  final values = <String, Object?>{};
  final calls = <String>[];
  Completer<void>? nextWrite;
  bool failWrites = false;
  bool failDeletes = false;

  @override
  Object? read(String key) => values[key];

  @override
  Future<void> write(String key, Object? value) async {
    calls.add('write');
    final pending = nextWrite;
    nextWrite = null;
    if (pending != null) await pending.future;
    if (failWrites) throw StateError('Local storage write failed');
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    calls.add('delete');
    if (failDeletes) throw StateError('Local storage delete failed');
    values.remove(key);
  }

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> close() async {}
}
