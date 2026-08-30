import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friend_location_merger.dart';

void main() {
  final friend = Friend(
    friendshipId: 'friendship-id',
    userId: 'friend-id',
    fullName: 'Ada Lovelace',
    latitude: 55.75,
    longitude: 37.62,
    battery: 80,
    mood: 'studying',
    locationUpdatedAt: DateTime.utc(2026, 7, 9),
  );

  test('clears a location omitted from a full realtime snapshot', () {
    final result = mergeFriendLocations([friend], const []);
    final [merged] = result;

    expect(merged.hasLocation, isFalse);
    expect(merged.battery, isNull);
    expect(merged.mood, isEmpty);
    expect(merged.locationUpdatedAt, isNull);
    expect(merged.isGhost, isTrue);
  });

  test('applies a visible realtime location update', () {
    final updatedAt = DateTime.utc(2026, 7, 10);
    final result = mergeFriendLocations(
      [friend],
      [
        FriendLocationUpdate(
          userId: 'friend-id',
          latitude: 55.8,
          longitude: 37.7,
          battery: 50,
          mood: 'coffee',
          updatedAt: updatedAt,
        ),
      ],
    );
    final [merged] = result;

    expect(merged.latitude, 55.8);
    expect(merged.longitude, 37.7);
    expect(merged.battery, 50);
    expect(merged.mood, 'coffee');
    expect(merged.locationUpdatedAt, updatedAt);
    expect(merged.isGhost, isFalse);
  });
}
