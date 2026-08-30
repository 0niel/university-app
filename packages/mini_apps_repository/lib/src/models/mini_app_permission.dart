/// Data scope a mini app may request from the user.
///
/// Data scopes (identity/email/profile/group) are forwarded to the developer's
/// server by the proxy as signed headers; the Supabase session/JWT is never
/// forwarded. Without any grants the developer only sees a pseudonymous per-app
/// user id. Device scopes (location/camera) carry no data — they only gate the
/// matching in-app capability and appear in the granted-scope list.
enum MiniAppPermission {
  /// Real user UUID (stable across all mini apps).
  identity,

  /// University email.
  email,

  /// Full name and course.
  profile,

  /// Academic group code.
  group,

  /// Push notifications from the app's developer (max 2/day).
  notifications,

  /// Device geolocation (the `getLocation` capability).
  location,

  /// Camera for photos and code scanning (`pickImage`, `scanCode`).
  camera,

  /// Files: pick and upload a document (`pickFile`).
  files,

  /// Device calendar: add events (`addCalendarEvent`).
  calendar;

  /// Parses a wire value, null for unknown scopes (forward compatibility).
  static MiniAppPermission? tryFromName(String? name) {
    for (final permission in MiniAppPermission.values) {
      if (permission.name == name) return permission;
    }
    return null;
  }

  /// Parses a wire list, dropping unknown scopes.
  static List<MiniAppPermission> listFromJson(Object? json) {
    if (json is! List) return const [];
    return json
        .whereType<String>()
        .map(tryFromName)
        .whereType<MiniAppPermission>()
        .toList();
  }
}
