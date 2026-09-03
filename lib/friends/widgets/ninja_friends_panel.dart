import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';
import 'package:rtu_mirea_app/friends/friends_layout.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

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

  final DraggableScrollableController? controller;

  String? _distanceTo(Friend friend, AppLocalizations l10n) {
    final myLat = myLatitude;
    final myLng = myLongitude;
    final friendLat = friend.latitude;
    final friendLng = friend.longitude;
    if (myLat == null ||
        myLng == null ||
        !myLat.isFinite ||
        !myLng.isFinite ||
        myLat.abs() > 90 ||
        myLng.abs() > 180 ||
        friendPresence(friend, DateTime.now()) == FriendPresence.off ||
        friend.isGhost ||
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
        padding: const .symmetric(horizontal: AppSpacing.screen),
        child: AppErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          footnote: null,
          primaryLabel: l10n.retry,
          onPrimary: onRetry,
        ),
      );
    }
    if (friends.isEmpty) {
      return Padding(
        key: const ValueKey('empty'),
        padding: const .symmetric(horizontal: AppSpacing.screen),
        child: Column(
          children: [
            AppEmptyState(
              lineIcon: AppLineIcon.people,
              title: l10n.friendsEmptyTitle,
              subtitle: l10n.friendsEmptySub,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
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
    final colors = context.colors;
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
              top: .circular(AppRadius.sheet),
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
                    color: colors.surface2,
                    borderRadius: .circular(AppRadius.full),
                  ),
                ),
              ),
              Padding(
                padding: const .fromLTRB(
                  AppSpacing.screen,
                  14,
                  AppSpacing.screen,
                  12,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      l10n.friendsTitle,
                      style: AppText.title.copyWith(color: colors.ink),
                    ),
                    if (loading)
                      const NinjaSkeleton(
                        width: 18,
                        height: 12,
                        radius: AppRadius.focusOutline,
                      )
                    else
                      Text(
                        '${friends.length}',
                        style: AppText.subtext
                            .copyWith(color: colors.muted)
                            .copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
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
            ],
          ),
        );
      },
    );
  }
}
