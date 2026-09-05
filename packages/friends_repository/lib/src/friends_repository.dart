import 'package:friends_repository/src/friends_failure.dart';
import 'package:friends_repository/src/models/friends_models.dart';
import 'package:network_location_client/network_location_client.dart';
import 'package:supabase/supabase.dart';

class FriendsRepository {
  factory FriendsRepository({
    required SupabaseClient supabase,
    NetworkLocationClient? networkLocationClient,
  }) => FriendsRepository._(
    supabase,
    networkLocationClient ?? NetworkLocationClient(),
    networkLocationClient == null,
  );

  const FriendsRepository._(
    this._supabase,
    this._networkLocation,
    this._ownsNetworkLocation,
  );

  final SupabaseClient _supabase;
  final NetworkLocationClient _networkLocation;
  final bool _ownsNetworkLocation;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  void close() {
    if (_ownsNetworkLocation) _networkLocation.close();
  }

  Future<bool> getGhostMode() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_ghost_mode');
      if (response case final bool isGhost) return isGhost;
      throw const FriendsResponseException(
        'get_ghost_mode must return a boolean',
      );
    },
    GetGhostModeFailure.new,
  );

  Future<List<Friend>> getFriends() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_friends');
      return _decodeList(response, 'get_friends', Friend.fromJson);
    },
    GetFriendsFailure.new,
  );

  Future<List<Friend>> getMapStudents() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_map_students');
      final students = _decodeList(
        response,
        'get_map_students',
        Friend.fromJson,
      );
      if (students.any(
        (student) => !student.hasLocation || student.locationUpdatedAt == null,
      )) {
        throw const FriendsResponseException(
          'get_map_students contains an unavailable location',
        );
      }
      return students;
    },
    GetMapStudentsFailure.new,
  );

  Future<bool> getLocationVisibility() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_location_visibility');
      if (response case final bool visibleToStudents) return visibleToStudents;
      throw const FriendsResponseException(
        'get_location_visibility must return a boolean',
      );
    },
    GetLocationVisibilityFailure.new,
  );

  Future<void> setLocationVisibility({required bool visibleToStudents}) =>
      _guard(
        () => _supabase.rpc<void>(
          'set_location_visibility',
          params: {'p_visible_to_students': visibleToStudents},
        ),
        SetLocationVisibilityFailure.new,
      );

  Future<List<FriendRequest>> getFriendRequests() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_friend_requests');
      return _decodeList(
        response,
        'get_friend_requests',
        FriendRequest.fromJson,
      );
    },
    GetFriendRequestsFailure.new,
  );

  Future<List<UserSearchResult>> searchUsers(String query) => _guard(
    () async {
      final response = await _supabase.rpc<Object?>(
        'search_users',
        params: {'p_query': query.trim()},
      );
      return _decodeList(response, 'search_users', UserSearchResult.fromJson);
    },
    SearchFriendsFailure.new,
  );

  Future<void> sendFriendRequest(String userId) => _guard(
    () => _supabase.rpc<void>(
      'send_friend_request',
      params: {'p_user_id': userId},
    ),
    SendFriendRequestFailure.new,
  );

  Future<void> respondFriendRequest({
    required String friendshipId,
    required bool accept,
  }) => _guard(
    () => _supabase.rpc<void>(
      'respond_friend_request',
      params: {'p_friendship_id': friendshipId, 'p_accept': accept},
    ),
    RespondFriendRequestFailure.new,
  );

  Future<GroupRoster> getGroupMembers() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>('get_group_members');
      final map = _expectMap(response, 'get_group_members');
      final group = map['group'];
      if (group != null && group is! String) {
        throw const FriendsResponseException(
          'get_group_members.group must be a string or null',
        );
      }
      return GroupRoster(
        group: group as String?,
        members: _decodeList(
          map['members'],
          'get_group_members.members',
          GroupMember.fromJson,
        ),
      );
    },
    GetGroupMembersFailure.new,
  );

  Future<List<SuggestedFriend>> getPeopleYouMayKnow() => _guard(
    () async {
      final response = await _supabase.rpc<Object?>(
        'get_people_you_may_know',
      );
      return _decodeList(
        response,
        'get_people_you_may_know',
        SuggestedFriend.fromJson,
      );
    },
    GetFriendSuggestionsFailure.new,
  );

  Future<void> removeFriend(String userId) => _guard(
    () => _supabase.rpc<void>(
      'remove_friend',
      params: {'p_user_id': userId},
    ),
    RemoveFriendFailure.new,
  );

  Future<void> registerDevice({
    required String token,
    required String platform,
  }) => _guard(
    () => _supabase.rpc<void>(
      'register_device',
      params: {'p_token': token, 'p_platform': platform},
    ),
    RegisterFriendDeviceFailure.new,
  );

  Future<void> unregisterDevice(String token) => _guard(
    () => _supabase.rpc<void>(
      'unregister_device',
      params: {'p_token': token},
    ),
    UnregisterFriendDeviceFailure.new,
  );

  Future<void> publishLocation({
    required double latitude,
    required double longitude,
    double? accuracyM,
    double? heading,
    double? speedMps,
    int? battery,
  }) => _guard(
    () => _supabase.rpc<void>(
      'upsert_my_location',
      params: {
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_accuracy_m': accuracyM,
        'p_heading': heading,
        'p_speed_mps': speedMps,
        'p_battery': battery,
      },
    ),
    PublishFriendLocationFailure.new,
  );

  Future<void> setGhostMode({required bool ghost}) => _guard(
    () => _supabase.rpc<void>(
      'set_ghost_mode',
      params: {'p_ghost': ghost},
    ),
    SetGhostModeFailure.new,
  );

  Future<void> setMood(String mood) => _guard(
    () => _supabase.rpc<void>(
      'set_location_mood',
      params: {'p_mood': mood.trim()},
    ),
    SetLocationMoodFailure.new,
  );

  /// Realtime stream of every visible row in `friend_locations` (the user's
  /// own row + non-ghost friends, enforced by RLS). Emits the full visible
  /// set on every change.
  Stream<List<FriendLocationUpdate>> watchLocations() {
    return _supabase
        .from('friend_locations')
        .stream(primaryKey: ['user_id'])
        .map(
          (rows) => rows
              .map((row) {
                final update = _decodeModel(
                  row,
                  'friend_locations',
                  FriendLocationUpdate.fromRow,
                );
                if (!update.hasValidCoordinates) {
                  throw const FriendsResponseException(
                    'friend_locations contains invalid coordinates',
                  );
                }
                return update;
              })
              .toList(growable: false),
        );
  }

  Future<List<WifiAccessPointReading>> scanWifiAccessPoints() async {
    try {
      return await _networkLocation.scanAccessPoints();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ScanWifiAccessPointsFailure(error), stackTrace);
    }
  }

  Future<NetworkLocationEstimate?> resolveWifiPosition(
    List<WifiAccessPointReading> accessPoints,
  ) async {
    if (accessPoints.length < NetworkLocationClient.minAccessPoints) {
      return null;
    }
    try {
      final response = await _supabase.rpc<Object?>(
        'wifi_resolve',
        params: {
          'p_aps': [for (final ap in accessPoints) ap.toJson()],
        },
      );
      if (response == null) {
        return await _networkLocation.geolocate(accessPoints);
      }
      final map = _expectMap(response, 'wifi_resolve');
      final latitude = _requiredDouble(map, 'latitude', 'wifi_resolve');
      final longitude = _requiredDouble(map, 'longitude', 'wifi_resolve');
      final accuracy = switch (map['accuracyM']) {
        null => 100.0,
        final num value when value.isFinite => value.toDouble(),
        _ => throw const FriendsResponseException(
          'wifi_resolve.accuracyM must be a finite number or null',
        ),
      };
      if (latitude < -90 ||
          latitude > 90 ||
          longitude < -180 ||
          longitude > 180) {
        throw const FriendsResponseException(
          'wifi_resolve coordinates are out of range',
        );
      }
      return NetworkLocationEstimate(
        latitude: latitude,
        longitude: longitude,
        accuracyM: accuracy,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResolveWifiPositionFailure(error), stackTrace);
    }
  }

  /// Submits BSSID observations without SSIDs. A short-lived per-user server
  /// timestamp is retained solely for rate limiting.
  Future<void> submitWifiObservations({
    required double latitude,
    required double longitude,
    required double accuracyM,
    required List<WifiAccessPointReading> accessPoints,
  }) async {
    if (accessPoints.isEmpty) return;
    try {
      await _supabase.rpc<Object?>(
        'wifi_observations_submit',
        params: {
          'p_latitude': latitude,
          'p_longitude': longitude,
          'p_accuracy_m': accuracyM,
          'p_aps': [for (final ap in accessPoints) ap.toJson()],
        },
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SubmitWifiObservationsFailure(error),
        stackTrace,
      );
    }
  }

  static List<T> _decodeList<T>(
    Object? response,
    String operation,
    T Function(Map<String, Object?>) fromJson,
  ) {
    if (response is! List<Object?>) {
      throw FriendsResponseException('$operation must return a list');
    }
    return [
      for (final row in response) _decodeModel(row, operation, fromJson),
    ];
  }

  static T _decodeModel<T>(
    Object? response,
    String operation,
    T Function(Map<String, Object?>) fromJson,
  ) {
    try {
      return fromJson(_expectMap(response, operation));
    } on FriendsResponseException {
      rethrow;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(FriendsResponseException(error), stackTrace);
    }
  }

  static Map<String, Object?> _expectMap(
    Object? response,
    String operation,
  ) {
    if (response is! Map<Object?, Object?>) {
      throw FriendsResponseException('$operation must return an object');
    }
    final result = <String, Object?>{};
    for (final MapEntry(:key, :value) in response.entries) {
      if (key is! String) {
        throw FriendsResponseException('$operation contains a non-string key');
      }
      result[key] = value;
    }
    return result;
  }

  static double _requiredDouble(
    Map<String, Object?> map,
    String key,
    String operation,
  ) {
    final value = map[key];
    if (value is num && value.isFinite) return value.toDouble();
    throw FriendsResponseException('$operation.$key must be a finite number');
  }

  static Future<T> _guard<T>(
    Future<T> Function() operation,
    FriendsFailure Function(Object) failure,
  ) async {
    try {
      return await operation();
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(failure(error), stackTrace);
    }
  }
}
