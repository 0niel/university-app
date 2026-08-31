import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_cubit.freezed.dart';
part 'profile_section.dart';
part 'profile_state.dart';

const _kLeaderboardPreviewLimit = 4;

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GamificationRepository gamificationRepository,
    required this.organizationId,
    required User currentUser,
  }) : _gamification = gamificationRepository,
       super(ProfileState(user: currentUser));

  final GamificationRepository _gamification;
  final String organizationId;
  var _persistedSettings = const UserSettings();
  var _settingsRevision = 0;
  var _loadRevision = 0;
  Future<void> _settingsQueue = Future.value();

  Future<void> load() async {
    if (isClosed) return;
    if (state.status == .loading) return;
    emit(state.copyWith(status: .loading));
    final revision = ++_loadRevision;

    final (synced, _) = await (
      _capture(_gamification.syncGamification),
      _reporting(_gamification.recordActiveDay),
    ).wait;
    if (isClosed || revision != _loadRevision) return;
    _report(synced);

    final settingsRevision = _settingsRevision;
    final results = await (
      _capture(() => _gamification.ensureProfile(organizationId)),
      _capture(() => _gamification.getProfileOverview(organizationId)),
      _capture(_gamification.getQuests),
      _capture(
        () => _gamification.getLeaderboard(
          organizationId,
          limit: _kLeaderboardPreviewLimit,
        ),
      ),
      _capture(_gamification.getBadges),
      _capture(_gamification.getSettings),
    ).wait;
    if (isClosed || revision != _loadRevision) return;

    final failures = <ProfileSection>{
      if (results.$1.error != null) .profile,
      if (results.$2.error != null) .overview,
      if (results.$3.error != null) .quests,
      if (results.$4.error != null) .leaderboard,
      if (results.$5.error != null) .badges,
      if (results.$6.error != null) .settings,
    };
    final loadedSettings = results.$6.value;
    final canApplySettings =
        loadedSettings != null && settingsRevision == _settingsRevision;
    if (canApplySettings) _persistedSettings = loadedSettings;
    final profile = results.$1.value ?? state.gamificationProfile;

    emit(
      state.copyWith(
        status: failures.contains(ProfileSection.profile) && profile.isEmpty
            ? .error
            : .loaded,
        gamificationProfile: profile,
        overview: results.$2.value ?? state.overview,
        quests: results.$3.value ?? state.quests,
        leaderboard: results.$4.value ?? state.leaderboard,
        badges: results.$5.value ?? state.badges,
        settings: canApplySettings ? loadedSettings : state.settings,
        failedSections: failures,
        newlyEarnedBadges: synced.value ?? const [],
      ),
    );

    _report(results.$1);
    _report(results.$2);
    _report(results.$3);
    _report(results.$4);
    _report(results.$5);
    _report(results.$6);
  }

  Future<void> reloadSection(ProfileSection section) => switch (section) {
    .profile => _reload(
      section,
      () => _gamification.ensureProfile(organizationId),
      (value) => state.copyWith(gamificationProfile: value),
    ),
    .overview => _reload(
      section,
      () => _gamification.getProfileOverview(organizationId),
      (value) => state.copyWith(overview: value),
    ),
    .quests => _reload(
      section,
      _gamification.getQuests,
      (value) => state.copyWith(quests: value),
    ),
    .leaderboard => _reload(
      section,
      () => _gamification.getLeaderboard(
        organizationId,
        limit: _kLeaderboardPreviewLimit,
      ),
      (value) => state.copyWith(leaderboard: value),
    ),
    .badges => _reload(
      section,
      _gamification.getBadges,
      (value) => state.copyWith(badges: value),
    ),
    .settings => _reloadSettings(),
  };

  void celebrationsShown() {
    if (isClosed || state.newlyEarnedBadges.isEmpty) return;
    emit(state.copyWith(newlyEarnedBadges: const []));
  }

  Future<void> updateSettings(UserSettings settings) async {
    if (isClosed) return;
    final revision = ++_settingsRevision;
    emit(state.copyWith(settings: settings));
    final operation = _settingsQueue.then(
      (_) => _persistSettings(settings, revision),
    );
    _settingsQueue = operation;
    await operation;
  }

  Future<IdentityUpdateResult> updateIdentity({
    required String fullName,
    required String handle,
  }) async {
    if (isClosed) return IdentityUpdateResult.error;
    try {
      final overview = await _gamification.setUserIdentity(
        organizationId: organizationId,
        fullName: fullName,
        handle: handle,
      );
      if (isClosed) return IdentityUpdateResult.error;
      emit(state.copyWith(overview: overview));
      return IdentityUpdateResult.success;
    } on HandleTakenException {
      return IdentityUpdateResult.handleTaken;
    } on Exception {
      return IdentityUpdateResult.error;
    }
  }

  Future<void> _reload<T extends Object>(
    ProfileSection section,
    Future<T> Function() fetch,
    ProfileState Function(T value) apply,
  ) async {
    if (isClosed) return;
    final result = await _capture(fetch);
    if (isClosed) return;
    final value = result.value;
    if (value == null) {
      emit(state.copyWith(failedSections: {...state.failedSections, section}));
      _report(result);
      return;
    }
    emit(
      apply(value).copyWith(
        failedSections: {...state.failedSections}..remove(section),
      ),
    );
  }

  Future<void> _reloadSettings() async {
    if (isClosed) return;
    final revision = _settingsRevision;
    final result = await _capture(_gamification.getSettings);
    if (isClosed) return;
    final value = result.value;
    if (value == null) {
      emit(
        state.copyWith(
          failedSections: {...state.failedSections, ProfileSection.settings},
        ),
      );
      _report(result);
      return;
    }
    if (revision != _settingsRevision) return;
    _persistedSettings = value;
    emit(
      state.copyWith(
        settings: value,
        failedSections: {...state.failedSections}
          ..remove(ProfileSection.settings),
      ),
    );
  }

  Future<void> _persistSettings(
    UserSettings settings,
    int revision,
  ) async {
    final previous = _persistedSettings;
    try {
      final updated = await _gamification.updateSettings(
        settings,
        previous: previous,
      );
      _persistedSettings = updated;
      if (!isClosed && revision == _settingsRevision) {
        _settingsRevision++;
        emit(state.copyWith(settings: updated));
      }
    } on Exception catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
      if (!isClosed && revision == _settingsRevision) {
        _settingsRevision++;
        emit(state.copyWith(settings: previous));
      }
    }
  }

  Future<_LoadResult<T>> _capture<T extends Object>(
    Future<T> Function() operation,
  ) async {
    try {
      return _LoadResult(value: await operation());
    } on Object catch (error, stackTrace) {
      return _LoadResult(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _reporting(Future<void> Function() operation) async {
    try {
      await operation();
    } on Object catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
    }
  }

  void _report(_LoadResult<Object> result) {
    final error = result.error;
    final stackTrace = result.stackTrace;
    if (error != null && stackTrace != null) addError(error, stackTrace);
  }
}

enum IdentityUpdateResult { success, handleTaken, error }

class _LoadResult<T extends Object> {
  const _LoadResult({this.value, this.error, this.stackTrace});

  final T? value;
  final Object? error;
  final StackTrace? stackTrace;
}
