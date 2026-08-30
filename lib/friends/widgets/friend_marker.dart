import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'my_location_marker.dart';
part 'avatar_bubble.dart';
part 'pulse_ring.dart';
part 'marker_pop.dart';
part 'mood_badge.dart';
part 'name_pill.dart';

bool _isLive(DateTime? updatedAt) =>
    updatedAt != null && DateTime.now().difference(updatedAt).inMinutes < 5;

class FriendMarker extends StatelessWidget {
  const FriendMarker({required this.friend, super.key});

  final Friend friend;

  String _freshness(AppLocalizations l10n) {
    final updated = friend.locationUpdatedAt;
    if (updated == null) return '';
    final diff = DateTime.now().difference(updated);
    if (diff.inMinutes < 2) return l10n.friendsJustNow;
    if (diff.inMinutes < 60) return l10n.friendsMinutesShort(diff.inMinutes);
    if (diff.inHours < 24) return l10n.friendsHoursShort(diff.inHours);
    return l10n.friendsDaysShort(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final freshness = _freshness(context.l10n);
    final live = _isLive(friend.locationUpdatedAt);

    return _MarkerPop(
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: .none,
              children: [
                if (live) _PulseRing(color: colors.brand),
                _AvatarBubble(name: friend.fullName),
                if (friend.mood.isNotEmpty)
                  Positioned(top: -4, right: 6, child: _MoodBadge(friend.mood)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _NamePill(
            label:
                friend.fullName.split(' ').elementAtOrNull(0) ??
                friend.fullName,
            freshness: freshness,
            color: live ? colors.brandInk : colors.muted,
          ),
        ],
      ),
    );
  }
}
