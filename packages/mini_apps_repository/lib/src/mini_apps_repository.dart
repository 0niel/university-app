import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:mini_apps_repository/src/mini_apps_failures.dart';
import 'package:mini_apps_repository/src/models/models.dart';
import 'package:storage/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template mini_apps_repository}
/// Repository for the mini apps platform: catalog, authoring, reports,
/// hiding, ratings, moderation and proxied screen/API access.
///
/// Screen fetches and mini app API calls go through the `miniapp-proxy`
/// edge function — the client never talks to a developer server directly.
/// With a cache the last successful screen and storage payloads are kept
/// locally for instant (and offline) launches.
/// {@endtemplate}
class MiniAppsRepository {
  /// {@macro mini_apps_repository}
  const MiniAppsRepository({
    required SupabaseClient supabase,
    required String organizationId,
    Storage? cache,
  }) : _supabase = supabase,
       _organizationId = organizationId,
       _cache = cache;

  final SupabaseClient _supabase;
  final String _organizationId;
  final Storage? _cache;

  static const _proxyFunction = 'miniapp-proxy';

  String? get _cacheUserId => _supabase.auth.currentUser?.id;

  String _screenCacheKey(String userId, String slug, String? path) =>
      'mini_app_screen.$userId.$slug.${path ?? '/'}';

  String _storageCacheKey(String userId, String appId) =>
      'mini_app_storage.$userId.$appId';

  /// The last successfully fetched screen, or null when never cached.
  Future<Map<String, dynamic>?> readCachedScreen({
    required String slug,
    String? path,
  }) {
    final userId = _cacheUserId;
    return _readCachedJson(
      userId == null ? null : _screenCacheKey(userId, slug, path),
    );
  }

  /// The last successfully fetched storage snapshot for an app.
  Future<Map<String, dynamic>?> readCachedStorage(String appId) {
    final userId = _cacheUserId;
    return _readCachedJson(
      userId == null ? null : _storageCacheKey(userId, appId),
    );
  }

  Future<Map<String, dynamic>?> _readCachedJson(String? key) async {
    if (key == null) return null;
    try {
      final raw = await _cache?.read(key: key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } on Exception {
      // A broken cache entry behaves like a miss.
    }
    return null;
  }

  Future<void> _writeCache(String? key, Map<String, dynamic> value) async {
    if (key == null) return;
    try {
      await _cache?.write(key: key, value: jsonEncode(value));
    } on Exception {
      // Cache writes are best effort.
    }
  }

  /// Published apps for the catalog, with optional search, category filter
  /// and [sort] order. Featured apps always float first. Apps hidden by the
  /// viewer are excluded unless [includeHidden].
  Future<List<MiniApp>> getApps({
    String? query,
    MiniAppCategory? category,
    MiniAppSort sort = MiniAppSort.popular,
    bool includeHidden = false,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_apps',
        params: {
          'p_organization_id': _organizationId,
          'p_query': query,
          'p_category': category?.name,
          'p_include_hidden': includeHidden,
          'p_limit': limit,
          'p_offset': offset,
          'p_sort': sort.wireName,
        },
      );
      return _parseApps(res);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMiniAppsFailure(error), stackTrace);
    }
  }

  /// Apps the viewer opened recently, newest first.
  Future<List<MiniApp>> getRecentApps({int limit = 10}) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_recent_mini_apps',
        params: {'p_organization_id': _organizationId, 'p_limit': limit},
      );
      return _parseApps(res);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetRecentMiniAppsFailure(error), stackTrace);
    }
  }

  /// A single app by [slug], or null when it is not visible to the viewer.
  Future<MiniApp?> getApp(String slug) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app',
        params: {'p_organization_id': _organizationId, 'p_slug': slug},
      );
      if (res is! Map) return null;
      return MiniApp.fromJson(res.cast<String, dynamic>());
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMiniAppFailure(error), stackTrace);
    }
  }

  /// All apps owned by the viewer, any status.
  Future<List<MiniApp>> getMyApps() async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_my_mini_apps',
        params: {'p_organization_id': _organizationId},
      );
      return _parseApps(res);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMyMiniAppsFailure(error), stackTrace);
    }
  }

  /// Submits a new mini app and returns its id. With [asDraft] the app is
  /// saved without entering the moderation queue.
  Future<String> submitApp({
    required String slug,
    required String name,
    String description = '',
    String iconEmoji = '🧩',
    String accentColor = '#7C5CFF',
    MiniAppCategory category = MiniAppCategory.other,
    List<String> tags = const [],
    MiniAppSourceKind sourceKind = MiniAppSourceKind.hosted,
    String? originUrl,
    String entryPath = '/',
    List<MiniAppScreen> screens = const [],
    List<MiniAppPermission> permissions = const [],
    bool asDraft = false,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'submit_mini_app',
        params: {
          'p_organization_id': _organizationId,
          'p_slug': slug,
          'p_name': name,
          'p_description': description,
          'p_icon_emoji': iconEmoji,
          'p_accent_color': accentColor,
          'p_category': category.name,
          'p_tags': tags,
          'p_source_kind': sourceKind.name,
          'p_origin_url': originUrl,
          'p_entry_path': entryPath,
          'p_screens': screens.map((s) => s.toJson()).toList(),
          'p_permissions': permissions.map((p) => p.name).toList(),
          'p_as_draft': asDraft,
        },
      );
      if (res is Map && res['id'] is String) return res['id'] as String;
      throw const FormatException('submit_mini_app returned no id');
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SubmitMiniAppFailure(error), stackTrace);
    }
  }

  /// Updates an owned app. A non-null field overwrites the stored value;
  /// with [submit] the app goes back to the moderation queue.
  Future<void> updateApp({
    required String appId,
    String? name,
    String? description,
    String? iconEmoji,
    String? accentColor,
    MiniAppCategory? category,
    List<String>? tags,
    String? originUrl,
    String? entryPath,
    List<MiniAppScreen>? screens,
    List<MiniAppPermission>? permissions,
    bool submit = true,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'update_mini_app',
        params: {
          'p_app_id': appId,
          'p_name': name,
          'p_description': description,
          'p_icon_emoji': iconEmoji,
          'p_accent_color': accentColor,
          'p_category': category?.name,
          'p_tags': tags,
          'p_origin_url': originUrl,
          'p_entry_path': entryPath,
          'p_screens': screens?.map((s) => s.toJson()).toList(),
          'p_permissions': permissions?.map((p) => p.name).toList(),
          'p_submit': submit,
        },
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateMiniAppFailure(error), stackTrace);
    }
  }

  /// Deletes an owned app.
  Future<void> deleteApp(String appId) async {
    try {
      await _supabase.rpc<Object?>(
        'delete_mini_app',
        params: {'p_app_id': appId},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteMiniAppFailure(error), stackTrace);
    }
  }

  /// Hosted screens of an owned (or moderated) app, for editing/preview.
  Future<List<MiniAppScreen>> getScreens(String appId) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app_screens',
        params: {'p_app_id': appId},
      );
      if (res is! List) return const [];
      return res
          .whereType<Map<Object?, Object?>>()
          .map((e) => MiniAppScreen.fromJson(e.cast<String, dynamic>()))
          .toList();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMiniAppScreensFailure(error), stackTrace);
    }
  }

  /// The viewer's key-value storage for an app (used by `setStorage` and
  /// `{{storage.*}}` placeholders in hosted apps).
  Future<Map<String, dynamic>> getStorage(String appId) async {
    final requestUserId = _cacheUserId;
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app_storage',
        params: {'p_app_id': appId},
      );
      if (_cacheUserId != requestUserId) {
        throw const FormatException(
          'Authentication changed while loading storage',
        );
      }
      if (res is Map) {
        final values = res.cast<String, dynamic>();
        await _writeCache(
          requestUserId == null ? null : _storageCacheKey(requestUserId, appId),
          values,
        );
        return values;
      }
      return const {};
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppStorageFailure(error), stackTrace);
    }
  }

  /// Writes (or deletes, with a null [value]) one storage key.
  Future<void> setStorageValue({
    required String appId,
    required String key,
    Object? value,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'set_mini_app_storage',
        params: {'p_app_id': appId, 'p_key': key, 'p_value': value},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppStorageFailure(error), stackTrace);
    }
  }

  /// Daily launch statistics of an owned (or moderated) app.
  Future<List<MiniAppDailyStat>> getStats(String appId, {int days = 30}) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app_stats',
        params: {'p_app_id': appId, 'p_days': days},
      );
      if (res is! List) return const [];
      return res
          .whereType<Map<Object?, Object?>>()
          .map((e) => MiniAppDailyStat.fromJson(e.cast<String, dynamic>()))
          .toList();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMiniAppStatsFailure(error), stackTrace);
    }
  }

  /// Screen revisions of an owned (or moderated) app, newest first.
  Future<List<MiniAppRevision>> getRevisions(String appId) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app_revisions',
        params: {'p_app_id': appId},
      );
      if (res is! List) return const [];
      return res
          .whereType<Map<Object?, Object?>>()
          .map((e) => MiniAppRevision.fromJson(e.cast<String, dynamic>()))
          .toList();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppRevisionsFailure(error), stackTrace);
    }
  }

  /// Restores a revision as the current screens (goes back to review).
  Future<void> restoreRevision({
    required String appId,
    required int version,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'restore_mini_app_revision',
        params: {'p_app_id': appId, 'p_version': version},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppRevisionsFailure(error), stackTrace);
    }
  }

  /// Creates a deploy token; the plaintext is returned exactly once.
  Future<CreatedMiniAppDeployToken> createDeployToken({
    String name = '',
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'create_mini_app_deploy_token',
        params: {'p_name': name},
      );
      if (res is Map && res['token'] is String) {
        return CreatedMiniAppDeployToken(
          id: res['id'] as String? ?? '',
          token: res['token'] as String,
        );
      }
      throw const FormatException('create_mini_app_deploy_token: no token');
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppDeployTokenFailure(error), stackTrace);
    }
  }

  /// The viewer's deploy tokens (metadata only).
  Future<List<MiniAppDeployToken>> listDeployTokens() async {
    try {
      final res = await _supabase.rpc<Object?>(
        'list_mini_app_deploy_tokens',
      );
      if (res is! List) return const [];
      return res
          .whereType<Map<Object?, Object?>>()
          .map((e) => MiniAppDeployToken.fromJson(e.cast<String, dynamic>()))
          .toList();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppDeployTokenFailure(error), stackTrace);
    }
  }

  /// Revokes a deploy token.
  Future<void> revokeDeployToken(String tokenId) async {
    try {
      await _supabase.rpc<Object?>(
        'revoke_mini_app_deploy_token',
        params: {'p_id': tokenId},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppDeployTokenFailure(error), stackTrace);
    }
  }

  /// Signing-secret metadata for a remote app (never the plaintext).
  Future<MiniAppSigningSecretInfo> getSigningSecretInfo(String appId) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_app_signing_secret_info',
        params: {'p_app_id': appId},
      );
      if (res is Map) {
        return MiniAppSigningSecretInfo.fromJson(res.cast<String, dynamic>());
      }
      return const MiniAppSigningSecretInfo();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppSigningSecretFailure(error), stackTrace);
    }
  }

  /// Generates (or rotates) a remote app's signing secret; the plaintext is
  /// returned exactly once. A prior secret stays valid for [graceMinutes] so
  /// the developer's server has time to redeploy with the new value.
  Future<CreatedMiniAppSigningSecret> rotateSigningSecret(
    String appId, {
    int graceMinutes = 1440,
  }) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'rotate_mini_app_signing_secret',
        params: {'p_app_id': appId, 'p_grace_minutes': graceMinutes},
      );
      if (res is Map && res['secret'] is String) {
        return CreatedMiniAppSigningSecret(
          secret: res['secret'] as String,
          fingerprint: res['fingerprint'] as String? ?? '',
        );
      }
      throw const FormatException('rotate_mini_app_signing_secret: no secret');
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppSigningSecretFailure(error), stackTrace);
    }
  }

  /// Disables request signing by dropping the app's secret.
  Future<void> revokeSigningSecret(String appId) async {
    try {
      await _supabase.rpc<Object?>(
        'revoke_mini_app_signing_secret',
        params: {'p_app_id': appId},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppSigningSecretFailure(error), stackTrace);
    }
  }

  /// Uploads a captured image into the viewer's own folder of the public
  /// `mini-app-uploads` bucket and returns its public url (used by the
  /// `pickImage` capability). The url is public-by-link, like app icons.
  Future<String> uploadImage({
    required String appId,
    required Uint8List bytes,
    String fileName = 'photo.jpg',
    String? contentType,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw const FormatException('Not authenticated');
      final (ext, mimeType) = _imageFormat(bytes);
      final unique =
          '${DateTime.now().microsecondsSinceEpoch}'
          '-${Random().nextInt(0x7fffffff)}';
      final path = '$userId/$appId/$unique.$ext';
      final storage = _supabase.storage.from('mini-app-uploads');
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: mimeType,
        ),
      );
      return storage.getPublicUrl(path);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppUploadFailure(error), stackTrace);
    }
  }

  static (String, String) _imageFormat(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return ('jpg', 'image/jpeg');
    }
    const pngSignature = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
    if (bytes.length >= pngSignature.length &&
        Iterable<int>.generate(
          pngSignature.length,
        ).every((index) => bytes[index] == pngSignature[index])) {
      return ('png', 'image/png');
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return ('webp', 'image/webp');
    }
    throw const FormatException('Choose a JPEG, PNG or WebP image');
  }

  /// Uploads an arbitrary captured file (the `pickFile` capability) and
  /// returns its public url. The content type is derived from the file name;
  /// types outside the bucket's allowlist are rejected by storage.
  Future<String> uploadFile({
    required String appId,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw const FormatException('Not authenticated');
      final ext = _extensionOf(fileName, fallback: 'bin');
      final unique =
          '${DateTime.now().microsecondsSinceEpoch}'
          '-${Random().nextInt(0x7fffffff)}';
      final path = '$userId/$appId/$unique.$ext';
      final storage = _supabase.storage.from('mini-app-uploads');
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: contentType ?? _mimeOf(ext),
          upsert: true,
        ),
      );
      return storage.getPublicUrl(path);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(MiniAppUploadFailure(error), stackTrace);
    }
  }

  static String _extensionOf(String fileName, {String fallback = 'jpg'}) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) return fallback;
    final ext = fileName.substring(dot + 1).toLowerCase();
    return RegExp(r'^[a-z0-9]{1,5}$').hasMatch(ext) ? ext : fallback;
  }

  static String _mimeOf(String ext) {
    return switch (ext) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'pdf' => 'application/pdf',
      'txt' => 'text/plain',
      'csv' => 'text/csv',
      'zip' => 'application/zip',
      'doc' => 'application/msword',
      'docx' =>
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls' => 'application/vnd.ms-excel',
      'xlsx' =>
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      _ => 'application/octet-stream',
    };
  }

  /// Validates screens against the platform's known widget/action registry.
  Future<MiniAppValidation> validateScreens(
    List<MiniAppScreen> screens,
  ) async {
    try {
      final res = await _supabase.rpc<Object?>(
        'validate_mini_app_screens',
        params: {'p_screens': screens.map((s) => s.toJson()).toList()},
      );
      if (res is Map) {
        return MiniAppValidation.fromJson(res.cast<String, dynamic>());
      }
      return const MiniAppValidation();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ValidateMiniAppScreensFailure(error),
        stackTrace,
      );
    }
  }

  /// Features or unfeatures an app in the catalog (moderators).
  Future<void> setFeatured({
    required String appId,
    required bool featured,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'set_mini_app_featured',
        params: {'p_app_id': appId, 'p_featured': featured},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SetMiniAppFeaturedFailure(error), stackTrace);
    }
  }

  /// Files (or updates) the viewer's report on an app.
  Future<void> reportApp({
    required String appId,
    required MiniAppReportReason reason,
    String details = '',
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'report_mini_app',
        params: {
          'p_app_id': appId,
          'p_reason': reason.name,
          'p_details': details,
        },
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(ReportMiniAppFailure(error), stackTrace);
    }
  }

  /// Hides or unhides an app in the viewer's catalog.
  Future<void> setHidden({required String appId, required bool hidden}) async {
    try {
      await _supabase.rpc<Object?>(
        'set_mini_app_hidden',
        params: {'p_app_id': appId, 'p_hidden': hidden},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SetMiniAppHiddenFailure(error), stackTrace);
    }
  }

  /// Stores the viewer's permission decision for an app. Scopes outside
  /// the app's requested set are clamped server-side.
  Future<void> setConsents({
    required String appId,
    required List<MiniAppPermission> scopes,
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'set_mini_app_consents',
        params: {
          'p_app_id': appId,
          'p_scopes': scopes.map((s) => s.name).toList(),
        },
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SetMiniAppConsentsFailure(error), stackTrace);
    }
  }

  /// Sets the viewer's 1–5 rating.
  Future<void> rateApp({required String appId, required int rating}) async {
    try {
      await _supabase.rpc<Object?>(
        'rate_mini_app',
        params: {'p_app_id': appId, 'p_rating': rating},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(RateMiniAppFailure(error), stackTrace);
    }
  }

  /// Bumps the launch counter; failures are intentionally swallowed —
  /// analytics must never break a launch.
  Future<void> trackLaunch(String appId) async {
    try {
      await _supabase.rpc<Object?>(
        'track_mini_app_launch',
        params: {'p_app_id': appId},
      );
    } on Exception {
      // Launch analytics are best effort.
    }
  }

  /// Whether the viewer can moderate mini apps.
  Future<bool> isModerator() async {
    try {
      final res = await _supabase.rpc<Object?>(
        'is_mini_app_moderator',
        params: {'p_organization_id': _organizationId},
      );
      return res == true;
    } on Exception {
      return false;
    }
  }

  /// The moderation queue (empty for non-moderators).
  Future<MiniAppsModerationQueue> getModerationQueue() async {
    try {
      final res = await _supabase.rpc<Object?>(
        'get_mini_apps_moderation_queue',
        params: {'p_organization_id': _organizationId},
      );
      if (res is! Map) return const MiniAppsModerationQueue();
      return MiniAppsModerationQueue.fromJson(res.cast<String, dynamic>());
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(GetModerationQueueFailure(error), stackTrace);
    }
  }

  /// Applies a moderation decision.
  Future<void> moderateApp({
    required String appId,
    required MiniAppModerationAction action,
    String notes = '',
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'moderate_mini_app',
        params: {'p_app_id': appId, 'p_action': action.name, 'p_notes': notes},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(ModerateMiniAppFailure(error), stackTrace);
    }
  }

  /// Closes all open reports on an app.
  Future<void> resolveReports({
    required String appId,
    bool dismiss = false,
    String notes = '',
  }) async {
    try {
      await _supabase.rpc<Object?>(
        'resolve_mini_app_reports',
        params: {'p_app_id': appId, 'p_dismiss': dismiss, 'p_notes': notes},
      );
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ResolveMiniAppReportsFailure(error),
        stackTrace,
      );
    }
  }

  /// Fetches a screen's Stac JSON through the secure proxy.
  ///
  /// Works for hosted screens (served from Postgres) and remote ones
  /// (fetched server-side from the developer's origin).
  Future<Map<String, dynamic>> fetchScreen({
    required String slug,
    String? path,
  }) async {
    final requestUserId = _cacheUserId;
    try {
      final res = await _supabase.functions.invoke(
        _proxyFunction,
        body: {
          'organizationId': _organizationId,
          'slug': slug,
          'kind': 'screen',
          'path': ?path,
        },
      );
      if (_cacheUserId != requestUserId) {
        throw const FormatException(
          'Authentication changed while loading a screen',
        );
      }
      final Object? data = res.data;
      if (data is Map) {
        final screen = data.cast<String, dynamic>();
        await _writeCache(
          requestUserId == null
              ? null
              : _screenCacheKey(requestUserId, slug, path),
          screen,
        );
        return screen;
      }
      throw const FormatException('Proxy returned a non-object screen');
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchMiniAppScreenFailure(error), stackTrace);
    }
  }

  /// Performs a mini app API call through the secure proxy and returns
  /// the upstream JSON.
  Future<Object?> callApi({
    required String slug,
    required String path,
    String method = 'GET',
    Map<String, String>? query,
    Object? body,
  }) async {
    try {
      final res = await _supabase.functions.invoke(
        _proxyFunction,
        body: {
          'organizationId': _organizationId,
          'slug': slug,
          'kind': 'api',
          'path': path,
          'method': method,
          'query': ?query,
          'body': ?body,
        },
      );
      return res.data;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(CallMiniAppApiFailure(error), stackTrace);
    }
  }

  static List<MiniApp> _parseApps(Object? res) {
    if (res is! List) return const [];
    return res
        .whereType<Map<Object?, Object?>>()
        .map((e) => MiniApp.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
