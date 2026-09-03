import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/friends/widgets/friend_marker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

LatLng? friendPoint(Friend friend) {
  final lat = friend.latitude;
  final lng = friend.longitude;
  if (lat == null ||
      lng == null ||
      !lat.isFinite ||
      !lng.isFinite ||
      lat.abs() > 90 ||
      lng.abs() > 180) {
    return null;
  }
  return LatLng(lat, lng);
}

class FriendsMarkerLayer extends StatefulWidget {
  const FriendsMarkerLayer({
    required this.friends,
    required this.onFriendTap,
    super.key,
    this.myLatitude,
    this.myLongitude,
    this.isGhost = false,
  });

  final List<Friend> friends;
  final ValueChanged<Friend> onFriendTap;
  final double? myLatitude;
  final double? myLongitude;
  final bool isGhost;

  @override
  State<FriendsMarkerLayer> createState() => _FriendsMarkerLayerState();
}

class _FriendsMarkerLayerState extends State<FriendsMarkerLayer>
    with SingleTickerProviderStateMixin {
  static const _glide = Duration(milliseconds: 650);

  late final AnimationController _controller;

  final _displayed = <String, LatLng>{};
  final _from = <String, LatLng>{};
  final _to = <String, LatLng>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _glide)
      ..addListener(_onTick);
    for (final friend in widget.friends) {
      final point = _pointOf(friend);
      if (point != null) _displayed[friend.userId] = point;
    }
  }

  @override
  void didUpdateWidget(covariant FriendsMarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _to.clear();
    final liveIds = <String>{};

    for (final friend in widget.friends) {
      final target = _pointOf(friend);
      if (target == null) continue;
      liveIds.add(friend.userId);
      final current = _displayed[friend.userId];
      if (current == null) {
        _displayed[friend.userId] = target;
      } else if (current.latitude != target.latitude ||
          current.longitude != target.longitude) {
        _from[friend.userId] = current;
        _to[friend.userId] = target;
      }
    }

    _displayed.removeWhere((id, _) => !liveIds.contains(id));
    _from.removeWhere((id, _) => !_to.containsKey(id));

    if (_to.isEmpty) return;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduceMotion) {
      _to.forEach((id, target) => _displayed[id] = target);
      _from.clear();
      _to.clear();
      return;
    }
    unawaited(_controller.forward(from: 0));
  }

  void _onTick() {
    final t = Curves.easeInOut.transform(_controller.value);
    setState(() {
      for (final entry in _to.entries) {
        final from = _from[entry.key];
        if (from == null) continue;
        final to = entry.value;
        _displayed[entry.key] = LatLng(
          lerpDouble(from.latitude, to.latitude, t) ?? to.latitude,
          lerpDouble(from.longitude, to.longitude, t) ?? to.longitude,
        );
      }
    });
    if (_controller.isCompleted) {
      _to.forEach((id, target) => _displayed[id] = target);
      _from.clear();
      _to.clear();
    }
  }

  LatLng? _pointOf(Friend friend) => friendPoint(friend);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myLat = widget.myLatitude;
    final myLng = widget.myLongitude;
    return MarkerLayer(
      markers: [
        if (myLat != null && myLng != null && myLat.isFinite && myLng.isFinite)
          Marker(
            point: LatLng(myLat, myLng),
            width: 96,
            height: 96,
            alignment: .center,
            child: RepaintBoundary(
              child: MyLocationMarker(isGhost: widget.isGhost),
            ),
          ),
        for (final friend in widget.friends)
          if (_displayed[friend.userId] case final point?)
            Marker(
              point: point,
              width: 110,
              height: 110,
              alignment: .center,
              child: AppPressable(
                key: ValueKey(friend.userId),
                behavior: HitTestBehavior.deferToChild,
                onTap: () => widget.onFriendTap(friend),
                semanticsLabel: friendMarkerSemanticsLabel(
                  friend,
                  context.l10n,
                ),
                child: RepaintBoundary(child: FriendMarker(friend: friend)),
              ),
            ),
      ],
    );
  }
}
