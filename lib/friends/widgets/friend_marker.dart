import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'avatar_bubble.dart';
part 'marker_pop.dart';
part 'my_location_marker.dart';
part 'name_pill.dart';

const friendMarkerAvatarSize = 34.0;
const friendMarkerRingWidth = 3.0;

String friendMarkerSemanticsLabel(Friend friend, AppLocalizations l10n) {
  final freshness = friendFreshnessLabel(friend, l10n);
  return freshness.isEmpty ? friend.fullName : '${friend.fullName}, $freshness';
}

String friendFreshnessLabel(Friend friend, AppLocalizations l10n) {
  final updated = friend.locationUpdatedAt;
  if (updated == null) return '';
  final diff = DateTime.now().difference(updated);
  if (diff.isNegative) return '';
  if (diff.inMinutes < 2) return l10n.friendsJustNow;
  if (diff.inMinutes < 60) return l10n.friendsMinutesShort(diff.inMinutes);
  if (diff.inHours < 24) return l10n.friendsHoursShort(diff.inHours);
  return l10n.friendsDaysShort(diff.inDays);
}

String friendFirstName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.firstOrNull?.isNotEmpty ?? false ? parts.first : fullName;
}

class FriendMarker extends StatelessWidget {
  const FriendMarker({required this.friend, super.key});

  final Friend friend;

  @override
  Widget build(BuildContext context) {
    return _MarkerPop(
      child: Column(
        mainAxisSize: .min,
        children: [
          _AvatarBubble(name: friend.fullName),
          const SizedBox(height: 3),
          _NamePill(label: friendFirstName(friend.fullName)),
        ],
      ),
    );
  }
}
