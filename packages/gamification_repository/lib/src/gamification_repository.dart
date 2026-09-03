import 'package:gamification_repository/src/models/gamification_models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase/supabase.dart';

class GamificationRepository {
  const GamificationRepository({required this._supabase});

  final SupabaseClient _supabase;

  Future<void> ensureAcademicProfile(
    String organizationId, {
    String? academicGroup,
  }) async {
    await _supabase
        .rpc<Object?>(
          'ensure_academic_profile',
          params: {
            'p_organization_id': organizationId,
            'p_group': ?academicGroup,
          },
        )
        .timeout(const Duration(seconds: 8));
  }

  Future<UserGamificationProfile> ensureProfile(String organizationId) async {
    final response = await _supabase.rpc<Object?>(
      'ensure_gamification_profile',
      params: {'p_organization_id': organizationId},
    );
    final json = _decodeObject(
      response,
      operation: 'ensure profile',
      allowNull: true,
    );
    if (json.isEmpty) return UserGamificationProfile.empty;
    return _decodeModel(
      json,
      operation: 'ensure profile',
      factory: UserGamificationProfile.fromJson,
    );
  }

  Future<UserGamificationProfile> getProfile() async {
    final response = await _supabase.rpc<Object?>('get_gamification_profile');
    final json = _decodeObject(
      response,
      operation: 'get profile',
      allowNull: true,
    );
    if (json.isEmpty) return UserGamificationProfile.empty;
    return _decodeModel(
      json,
      operation: 'get profile',
      factory: UserGamificationProfile.fromJson,
    );
  }

  Future<ProfileOverview> getProfileOverview(String organizationId) async {
    final response = await _supabase.rpc<Object?>(
      'get_profile_overview',
      params: {'p_organization_id': organizationId},
    );
    final json = _decodeObject(
      response,
      operation: 'get profile overview',
      allowNull: true,
    );
    if (json.isEmpty) return ProfileOverview.empty;
    return _decodeModel(
      json,
      operation: 'get profile overview',
      factory: ProfileOverview.fromJson,
    );
  }

  /// Sets the caller's display name and unique `@handle`, returning the
  /// refreshed overview. Throws [HandleTakenException] when the handle is
  /// already used by someone else.
  Future<ProfileOverview> setUserIdentity({
    required String organizationId,
    required String fullName,
    required String handle,
  }) async {
    try {
      final response = await _supabase.rpc<Object?>(
        'set_user_identity',
        params: {
          'p_organization_id': organizationId,
          'p_full_name': fullName,
          'p_handle': handle,
        },
      );
      final json = _decodeObject(response, operation: 'set user identity');
      if (json.isEmpty) return ProfileOverview.empty;
      return await _decodeModel(
        json,
        operation: 'set user identity',
        factory: ProfileOverview.fromJson,
      );
    } on PostgrestException catch (error, stackTrace) {
      if (error.message.contains('handle_taken')) {
        Error.throwWithStackTrace(const HandleTakenException(), stackTrace);
      }
      rethrow;
    }
  }

  /// Whether [handle] is free for the caller to take (false for taken or
  /// malformed handles; the client validates format separately).
  Future<bool> isHandleAvailable(String handle) async {
    final response = await _supabase.rpc<Object?>(
      'is_handle_available',
      params: {'p_handle': handle},
    );
    return response == true;
  }

  /// Records that the current user was active today (feeds the streak
  /// fire-calendar). Idempotent for the same day.
  Future<void> recordActiveDay() async {
    await _supabase.rpc<Object?>('record_active_day');
  }

  /// Recomputes the caller's quest progress and achievements server-side and
  /// returns badges earned by this call (for celebration UI). The server owns
  /// all progress and rewards; this only triggers a re-evaluation.
  Future<List<GamificationBadge>> syncGamification() async {
    final response = await _supabase.rpc<Object?>('sync_gamification');
    final data = _decodeObject(response, operation: 'sync gamification');
    final newly = data['newlyEarned'];
    if (newly is! List) return const [];
    return [
      for (final item in newly)
        if (item is Map<String, dynamic>)
          GamificationBadge.fromJson(item)
        else if (item is Map)
          GamificationBadge.fromJson(Map<String, dynamic>.from(item)),
    ];
  }

  Future<List<GamificationBadge>> getBadges() async {
    final response = await _supabase.rpc<Object?>('get_badges_for_user');
    return _decodeModels(
      response,
      operation: 'get badges',
      factory: GamificationBadge.fromJson,
    );
  }

  Future<List<GamificationQuest>> getQuests() async {
    final response = await _supabase.rpc<Object?>('get_quests_for_user');
    return _decodeModels(
      response,
      operation: 'get quests',
      factory: GamificationQuest.fromJson,
    );
  }

  Future<Map<String, Object?>> incrementQuestProgress(
    String questId, {
    int amount = 1,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'increment_quest_progress',
      params: {'p_quest_id': questId, 'p_amount': amount},
    );
    return _decodeObject(response, operation: 'increment quest progress');
  }

  Future<List<LeaderboardEntry>> getLeaderboard(
    String organizationId, {
    String scope = 'group',
    int limit = 50,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_leaderboard',
      params: {
        'p_organization_id': organizationId,
        'p_scope': scope,
        'p_limit': limit,
      },
    );
    return _decodeModels(
      response,
      operation: 'get leaderboard',
      factory: LeaderboardEntry.fromJson,
    );
  }

  Future<SquadChallenge?> getSquadChallenge(String organizationId) async {
    final response = await _supabase.rpc<Object?>(
      'get_squad_challenge',
      params: {'p_organization_id': organizationId},
    );
    final json = _decodeObject(
      response,
      operation: 'get squad challenge',
      allowNull: true,
    );
    if (json.isEmpty) return null;
    return _decodeModel(
      json,
      operation: 'get squad challenge',
      factory: SquadChallenge.fromJson,
    );
  }

  Future<List<ShurikenEntry>> getShurikenHistory(
    String organizationId, {
    int limit = 50,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'get_shuriken_history',
      params: {'p_organization_id': organizationId, 'p_limit': limit},
    );
    return _decodeModels(
      response,
      operation: 'get shuriken history',
      factory: ShurikenEntry.fromJson,
    );
  }

  /// Spends shurikens; throws when the balance is insufficient.
  Future<void> spendShurikens({
    required String title,
    required int amount,
    String emoji = '🎁',
  }) async {
    await _supabase.rpc<Object?>(
      'spend_shurikens',
      params: {'p_title': title, 'p_amount': amount, 'p_emoji': emoji},
    );
  }

  Future<UserSettings> getSettings() async {
    final response = await _supabase.rpc<Object?>('get_user_settings');
    final json = _decodeObject(
      response,
      operation: 'get settings',
      allowNull: true,
    );
    return _decodeModel(
      json,
      operation: 'get settings',
      factory: UserSettings.fromJson,
    );
  }

  /// Persists [settings] and returns the stored row.
  ///
  /// Pass the last known server state as [previous] to send a partial update:
  /// only the fields that actually changed travel to the RPC, which coalesces
  /// every omitted parameter to its stored value. Without [previous] the whole
  /// object is sent.
  Future<UserSettings> updateSettings(
    UserSettings settings, {
    UserSettings? previous,
  }) async {
    final response = await _supabase.rpc<Object?>(
      'upsert_user_settings',
      params: _changedSettingsParams(settings, previous),
    );
    return _decodeModel(
      _decodeObject(response, operation: 'update settings'),
      operation: 'update settings',
      factory: UserSettings.fromJson,
    );
  }

  static Map<String, Object?> _changedSettingsParams(
    UserSettings next,
    UserSettings? previous,
  ) => {
    if (previous?.notificationsEnabled != next.notificationsEnabled)
      'p_notifications_enabled': next.notificationsEnabled,
    if (previous?.scheduleChangeAlerts != next.scheduleChangeAlerts)
      'p_schedule_change_alerts': next.scheduleChangeAlerts,
    if (previous?.questReminders != next.questReminders)
      'p_quest_reminders': next.questReminders,
    if (previous?.achievementAlerts != next.achievementAlerts)
      'p_achievement_alerts': next.achievementAlerts,
    if (previous?.leaderboardUpdates != next.leaderboardUpdates)
      'p_leaderboard_updates': next.leaderboardUpdates,
    if (previous?.themeMode != next.themeMode) 'p_theme_mode': next.themeMode,
    if (previous?.accentColor != next.accentColor)
      'p_accent_color': next.accentColor,
    if (previous?.density != next.density) 'p_density': next.density,
    if (previous?.showMascot != next.showMascot)
      'p_show_mascot': next.showMascot,
    if (previous?.profileVisibility != next.profileVisibility)
      'p_profile_visibility': next.profileVisibility.name,
    if (previous?.anonymousReactions != next.anonymousReactions)
      'p_anonymous_reactions': next.anonymousReactions,
  };

  static Map<String, Object?> _decodeObject(
    Object? response, {
    required String operation,
    bool allowNull = false,
  }) {
    if (response == null && allowNull) return const {};
    if (response is Map<String, Object?>) return response;
    throw GamificationResponseException(
      operation: operation,
      expected: 'JSON object',
      actualType: response.runtimeType.toString(),
    );
  }

  static T _decodeModel<T>(
    Map<String, Object?> json, {
    required String operation,
    required T Function(Map<String, Object?> json) factory,
  }) {
    try {
      return factory(json);
    } on CheckedFromJsonException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GamificationResponseException(
          operation: operation,
          expected: 'valid JSON object',
          actualType: error.badKey ? 'invalid key' : 'invalid value',
        ),
        stackTrace,
      );
    }
  }

  static List<T> _decodeModels<T>(
    Object? response, {
    required String operation,
    required T Function(Map<String, Object?> json) factory,
  }) {
    final rows = _decodeObjectList(response, operation: operation);
    return [
      for (final (index, row) in rows.indexed)
        _decodeModel(
          row,
          operation: '$operation item $index',
          factory: factory,
        ),
    ];
  }

  static List<Map<String, Object?>> _decodeObjectList(
    Object? response, {
    required String operation,
  }) {
    if (response == null) return const [];
    if (response is! List<Object?>) {
      throw GamificationResponseException(
        operation: operation,
        expected: 'JSON array',
        actualType: response.runtimeType.toString(),
      );
    }
    return [
      for (final (index, value) in response.indexed)
        _decodeObject(value, operation: '$operation item $index'),
    ];
  }
}

/// Thrown by [GamificationRepository.setUserIdentity] when the requested
/// `@handle` is already taken by another user.
class HandleTakenException implements Exception {
  const HandleTakenException();
}

class GamificationResponseException implements Exception {
  const GamificationResponseException({
    required this.operation,
    required this.expected,
    required this.actualType,
  });

  final String operation;
  final String expected;
  final String actualType;

  @override
  String toString() =>
      'GamificationResponseException($operation): expected $expected, '
      'got $actualType';
}
