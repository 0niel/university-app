import 'package:friends_repository/friends_repository.dart';

List<Friend> mergeFriendLocations(
  List<Friend> friends,
  List<FriendLocationUpdate> updates,
) {
  final byUser = {for (final update in updates) update.userId: update};
  return [
    for (final friend in friends)
      switch (byUser[friend.userId]) {
        null when friend.hasLocation => friend.withoutLocation(),
        null => friend,
        final update when update.isGhost => friend.withoutLocation(),
        final update => friend.copyWith(
          latitude: update.latitude,
          longitude: update.longitude,
          battery: update.battery,
          mood: update.mood,
          isGhost: false,
          locationUpdatedAt: update.updatedAt,
        ),
      },
  ];
}
