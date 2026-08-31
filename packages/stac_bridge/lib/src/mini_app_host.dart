import 'dart:async';

import 'package:collection/collection.dart';

/// {@template mini_app_host}
/// Host capabilities a running mini app may invoke through custom actions.
///
/// Implemented by the app shell (runner page), so the bridge package stays
/// independent from go_router and the application's deep link whitelist.
/// {@endtemplate}
abstract class MiniAppHost {
  /// {@macro mini_app_host}
  const MiniAppHost();

  /// Opens an in-app location (`/schedule`, `/services/map?floor=2`, …).
  /// Implementations must validate it against the deep link whitelist.
  FutureOr<void> openLocation(String location);

  /// Opens an external https url in the browser.
  FutureOr<void> openExternalUrl(Uri url);

  /// Pushes another screen of the same mini app (fetched via the proxy).
  FutureOr<void> openPage({required String path, String? title});

  /// Opens another mini app (optionally on a specific page).
  FutureOr<void> openMiniApp({required String slug, String? path});

  /// Reloads the entry screen of the running mini app.
  FutureOr<void> reload();

  /// Persists one key of the per-user storage (null value deletes).
  FutureOr<void> setStorage(String key, Object? value);

  /// Calls the mini app's backend through the secure proxy and returns the
  /// decoded JSON (`Map`/`List`), or null on failure or when unavailable.
  /// Defaults to unavailable so adding it never breaks existing hosts.
  FutureOr<Object?> fetch({
    required String path,
    String method = 'GET',
    Map<String, Object?>? query,
    Object? body,
  }) => null;

  // ── Device capabilities (opt-in) ─────────────────────────────────────────
  // Each defaults to "unavailable" so a host implements only what it supports
  // and adding a capability never breaks existing MiniAppHost implementations.

  /// Reads the device's current location, or null when the `location` scope
  /// is not granted or the position is unavailable. Keys: `lat`, `lng`,
  /// `accuracy` (metres).
  FutureOr<Map<String, double>?> getLocation() => null;

  /// Captures a photo (camera) or picks one (gallery), uploads it and returns
  /// its public url — or null when the `camera` scope is denied or the user
  /// cancels.
  FutureOr<String?> pickImage({required bool fromCamera}) => null;

  /// Scans a QR/barcode and returns the decoded text, or null when the
  /// `camera` scope is denied or the user cancels.
  FutureOr<String?> scanCode() => null;

  /// Picks a file, uploads it and returns `{url, name}` — or null when the
  /// `files` scope is denied or the user cancels.
  FutureOr<Map<String, String>?> pickFile() => null;

  /// Prompts for biometric/device authentication with [reason]; true on
  /// success, false when it fails, is cancelled or is unavailable.
  FutureOr<bool> authenticate({required String reason}) => false;

  /// Schedules a local reminder to fire at [whenIso] (ISO-8601). Returns the
  /// reminder id, or null when it could not be scheduled.
  FutureOr<int?> scheduleReminder({
    required String title,
    required String body,
    required String whenIso,
  }) => null;

  /// Adds an event to the device calendar (`calendar` scope). Returns true on
  /// success. [startIso]/[endIso] are ISO-8601.
  FutureOr<bool> addCalendarEvent({
    required String title,
    required String startIso,
    String? endIso,
    String? location,
    String? notes,
  }) => false;

  /// Closes the mini app and returns to the catalog.
  void closeMiniApp();
}

/// {@template mini_app_session}
/// The currently running mini app: its slug plus the [MiniAppHost].
/// {@endtemplate}
class MiniAppSession {
  /// {@macro mini_app_session}
  const MiniAppSession({required this.slug, required this.host});

  /// Slug of the running mini app (used by the proxy network layer).
  final String slug;

  /// Host callbacks for custom actions.
  final MiniAppHost host;
}

/// {@template mini_app_session_stack}
/// Tracks which mini app is currently on screen. The runner pushes a
/// session when it opens and pops it on dispose; custom actions and the
/// proxy interceptor read [current].
/// {@endtemplate}
abstract final class MiniAppSessionStack {
  static final List<MiniAppSession> _stack = [];

  /// The session of the mini app on top of the navigation stack.
  static MiniAppSession? get current => _stack.lastOrNull;

  /// Registers a newly opened mini app.
  static void push(MiniAppSession session) => _stack.add(session);

  /// Unregisters a closed mini app.
  static void pop(MiniAppSession session) => _stack.remove(session);
}
