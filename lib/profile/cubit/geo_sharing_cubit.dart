import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';

const kGeoSharingPrefsKey = 'geo_sharing';

class GeoSharingState extends Equatable {
  const GeoSharingState({
    this.settings = const GeoSharingSettings(
      visibility: GeoVisibility.none,
      privacyForcedGhost: true,
    ),
    this.loaded = false,
    this.busy = false,
    this.failed = false,
  });

  final GeoSharingSettings settings;
  final bool busy;
  final bool failed;
  final bool loaded;

  bool get sharing => settings.sharing;

  GeoSharingState copyWith({
    GeoSharingSettings? settings,
    bool? busy,
    bool? failed,
    bool? loaded,
  }) {
    return GeoSharingState(
      settings: settings ?? this.settings,
      busy: busy ?? this.busy,
      failed: failed ?? this.failed,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [settings, busy, failed, loaded];
}

class GeoSharingCubit extends Cubit<GeoSharingState> {
  GeoSharingCubit({
    required PreferencesRepository preferencesRepository,
    required FriendsRepository friendsRepository,
    FriendsMapCubit? mapCubit,
  }) : _preferences = preferencesRepository,
       _friends = friendsRepository,
       _mapCubit = mapCubit,
       super(const GeoSharingState()) {
    _mapSubscription = mapCubit?.stream.listen(_applyMapState);
  }

  final PreferencesRepository _preferences;
  final FriendsRepository _friends;
  final FriendsMapCubit? _mapCubit;
  StreamSubscription<FriendsMapState>? _mapSubscription;
  int _revision = 0;

  void _applyMapState(FriendsMapState mapState) {
    if (isClosed) return;
    emit(
      state.copyWith(
        settings: mapState.geoSettings,
        busy: mapState.privacyBusy,
        failed: mapState.privacySyncFailed,
      ),
    );
  }

  @override
  Future<void> close() async {
    final closed = super.close();
    await _mapSubscription?.cancel();
    await closed;
  }

  Future<void> load() async {
    if (state.busy || isClosed) return;
    final mapCubit = _mapCubit;
    if (mapCubit != null) {
      await mapCubit.initialize();
      if (isClosed) return;
      _applyMapState(mapCubit.state);
      emit(state.copyWith(loaded: true));
      return;
    }
    final revision = ++_revision;
    emit(state.copyWith(busy: true, failed: false));
    try {
      final entry = await _preferences.get(kGeoSharingPrefsKey);
      if (isClosed || revision != _revision) return;
      emit(
        state.copyWith(
          settings: entry == null
              ? const GeoSharingState().settings
              : GeoSharingSettings.fromJson(entry.value),
          loaded: true,
          busy: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _revision) return;
      addError(error, stackTrace);
      emit(state.copyWith(busy: false, failed: true));
    }
  }

  Future<bool> setSharing({required bool enabled}) async {
    if (state.busy || isClosed) return false;
    final mapCubit = _mapCubit;
    if (mapCubit != null) {
      final settings = mapCubit.state.geoSettings;
      await mapCubit.updateGeoSettings(
        settings.copyWith(
          sharing: enabled,
          visibility: enabled
              ? settings.visibility == GeoVisibility.none
                    ? GeoVisibility.all
                    : settings.visibility
              : GeoVisibility.none,
          privacyForcedGhost: !enabled || settings.privacyForcedGhost,
        ),
      );
      if (isClosed) return false;
      _applyMapState(mapCubit.state);
      return !mapCubit.state.privacySyncFailed;
    }
    final revision = ++_revision;
    final next = state.settings.copyWith(
      sharing: enabled,
      visibility: enabled ? GeoVisibility.all : GeoVisibility.none,
      privacyForcedGhost: !enabled,
    );
    final safe = next.copyWith(
      sharing: false,
      visibility: GeoVisibility.none,
      privacyForcedGhost: true,
    );
    emit(
      state.copyWith(
        settings: enabled ? state.settings : safe,
        busy: true,
        failed: false,
      ),
    );
    try {
      await _preferences.set(kGeoSharingPrefsKey, next.toJson());
      if (isClosed || revision != _revision) return false;
      await _friends.setGhostMode(ghost: !enabled);
      if (isClosed || revision != _revision) return false;
      emit(
        state.copyWith(
          settings: next,
          busy: false,
          loaded: true,
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _revision) return false;
      addError(error, stackTrace);
      emit(state.copyWith(settings: safe, failed: true));
      try {
        await _preferences.set(kGeoSharingPrefsKey, safe.toJson());
      } on Object catch (error, stackTrace) {
        if (!isClosed) addError(error, stackTrace);
      }
      if (isClosed || revision != _revision) return false;
      try {
        await _friends.setGhostMode(ghost: true);
      } on Object catch (error, stackTrace) {
        if (!isClosed) addError(error, stackTrace);
      }
      if (!isClosed && revision == _revision) {
        emit(state.copyWith(busy: false));
      }
      return false;
    }
  }
}
