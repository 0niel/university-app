import 'dart:async';

import 'package:collection/collection.dart';

abstract class MiniAppHost {
  const MiniAppHost();

  FutureOr<void> openLocation(String location);

  FutureOr<void> openExternalUrl(Uri url);

  FutureOr<void> openPage({required String path, String? title});

  FutureOr<void> openMiniApp({required String slug, String? path});

  FutureOr<void> reload();

  FutureOr<void> reloadRoot() => reload();

  FutureOr<void> setStorage(String key, Object? value);

  FutureOr<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, Object?>? query,
    Object? body,
  }) => null;

  FutureOr<Map<String, double>?> getLocation() => null;

  FutureOr<String?> pickImage({required bool fromCamera}) => null;

  FutureOr<String?> scanCode() => null;

  FutureOr<Map<String, String>?> pickFile() => null;

  FutureOr<bool> authenticate({required String reason}) => false;

  FutureOr<int?> scheduleReminder({
    required String title,
    required String body,
    required String whenIso,
  }) => null;

  FutureOr<bool> addCalendarEvent({
    required String title,
    required String startIso,
    String? endIso,
    String? location,
    String? notes,
  }) => false;

  void closeMiniApp();
}

class MiniAppSession {
  const MiniAppSession({required this.slug, required this.host});

  final String slug;

  final MiniAppHost host;
}

abstract final class MiniAppSessionStack {
  static final List<MiniAppSession> _stack = [];
  static final _sessionKey = Object();

  static MiniAppSession? get current =>
      Zone.current[_sessionKey] as MiniAppSession? ?? _stack.lastOrNull;

  static T runWith<T>(MiniAppSession? session, T Function() action) =>
      runZoned(action, zoneValues: {_sessionKey: session});

  static void push(MiniAppSession session) => _stack.add(session);

  static void pop(MiniAppSession session) => _stack.remove(session);
}
