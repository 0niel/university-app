import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

part 'ninja_friends_panel_skeleton.dart';
part 'friend_card_sheet.dart';
part 'ninja_friend_card.dart';
part 'friend_row_skeleton.dart';

class NinjaFriendsPanel extends StatelessWidget {
  const NinjaFriendsPanel({
    required this.friends,
    required this.loading,
    required this.onFriendTap,
    required this.onAddFriend,
    super.key,
    this.failed = false,
    this.onRetry,
    this.myLatitude,
    this.myLongitude,
    this.attribution,
    this.controller,
  });

  final List<Friend> friends;
  final bool loading;
  final bool failed;
  final VoidCallback? onRetry;
  final ValueChanged<Friend> onFriendTap;
  final VoidCallback onAddFriend;
  final double? myLatitude;
  final double? myLongitude;

  final String? attribution;
  final DraggableScrollableController? controller;

  String? _distanceTo(Friend friend, AppLocalizations l10n) {
    final myLat = myLatitude;
    final myLng = myLongitude;
    final friendLat = friend.latitude;
    final friendLng = friend.longitude;
    if (myLat == null ||
        myLng == null ||
        !friend.hasLocation ||
        friendLat == null ||
        friendLng == null) {
      return null;
    }
    final meters = const Distance().as(
      .Meter,
      LatLng(myLat, myLng),
      LatLng(friendLat, friendLng),
    );
    if (meters < 1000) return l10n.friendsMeters(meters.round());
    return l10n.friendsKm((meters / 1000).toStringAsFixed(1));
  }

  Widget _content(AppLocalizations l10n) {
    if (loading) {
      return const _NinjaFriendsPanelSkeleton(key: ValueKey('loading'));
    }
    if (failed) {
      return Padding(
        key: const ValueKey('failure'),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      );
    }
    if (friends.isEmpty) {
      return Padding(
        key: const ValueKey('empty'),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: Column(
          children: [
            NinjaEmptyState(
              icon: const AppLineIconWidget(AppLineIcon.people),
              title: l10n.friendsEmptyTitle,
              message: l10n.friendsEmptySub,
            ),
            const SizedBox(height: 14),
            FriendsPillButton(
              label: l10n.friendsAddFriend,
              icon: .plus,
              onTap: onAddFriend,
            ),
          ],
        ).animateEmptyState(),
      );
    }
    return Column(
      key: const ValueKey('friends'),
      children: [
        for (final (index, friend) in friends.indexed)
          _NinjaFriendCard(
            friend: friend,
            distance: _distanceTo(friend, l10n),
            onTap: () => onFriendTap(friend),
          ).animateListItem(index: index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.28,
      minChildSize: 0.12,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.canvas,
            borderRadius: const .vertical(
              top: .circular(NinjaRadius.sheet),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const .only(top: 10, bottom: 24),
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: .circular(NinjaRadius.pill),
                  ),
                ),
              ),
              Padding(
                padding: const .fromLTRB(
                  NinjaMetrics.screenPadding,
                  14,
                  NinjaMetrics.screenPadding,
                  12,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      l10n.friendsTitle,
                      style: NinjaText.title.copyWith(color: colors.ink),
                    ),
                    if (loading)
                      const NinjaSkeleton(width: 18, height: 12, radius: 6)
                    else
                      Text(
                        '${friends.length}',
                        style: NinjaText.tabular(
                          NinjaText.subtext.copyWith(color: colors.muted),
                        ),
                      ),
                    const Spacer(),
                    FriendsPillButton(
                      label: l10n.friendsAddShort,
                      onTap: onAddFriend,
                    ),
                  ],
                ),
              ),
              NinjaStateSwitcher(child: _content(l10n)),
              if (attribution case final attributionText?) ...[
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    attributionText,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
