import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/friends_repository.dart';

part 'friends_map_state.freezed.dart';
part 'friends_map_state.g.dart';

@freezed
abstract class FriendsMapState with _$FriendsMapState {
  const factory FriendsMapState({
    @Default(FriendsMapStatus.initial) FriendsMapStatus status,
    @Default(<Friend>[]) List<Friend> friends,
    @Default(<FriendRequest>[]) List<FriendRequest> requests,
    double? myLatitude,
    double? myLongitude,
    @Default(false) bool isGhost,
    @Default(false) bool locationPermissionDenied,
    @Default(false) bool privacySyncFailed,
    @Default(false) bool privacyBusy,
    @Default(GeoSharingSettings()) GeoSharingSettings geoSettings,
    @Default(<String>{}) Set<String> pendingResponseIds,
  }) = _FriendsMapState;

  const FriendsMapState._();

  bool get hasMyLocation {
    final latitude = myLatitude;
    final longitude = myLongitude;
    return latitude != null &&
        longitude != null &&
        latitude.isFinite &&
        longitude.isFinite;
  }
}

enum FriendsMapStatus { initial, loading, ready, failure }

enum GeoVisibility { all, none }

enum GeoPrecision { exact, campus, city }

@freezed
abstract class GeoSharingSettings with _$GeoSharingSettings {
  @JsonSerializable(checked: true)
  const factory GeoSharingSettings({
    @Default(false) bool sharing,
    @JsonKey(unknownEnumValue: GeoVisibility.none)
    @Default(GeoVisibility.all)
    GeoVisibility visibility,
    @JsonKey(unknownEnumValue: GeoPrecision.exact)
    @Default(GeoPrecision.exact)
    GeoPrecision precision,
    @Default(false) bool privacyForcedGhost,
  }) = _GeoSharingSettings;

  factory GeoSharingSettings.fromJson(Map<String, Object?> json) =>
      _$GeoSharingSettingsFromJson(json);
}
