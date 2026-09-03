import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/utils/friends_map_camera.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_page.dart';
import 'package:rtu_mirea_app/friends/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const kFriendsMapFallbackCenter = LatLng(55.6699, 37.4803);

class FriendsMapView extends StatefulWidget {
  const FriendsMapView({super.key});

  @override
  State<FriendsMapView> createState() => _FriendsMapViewState();
}

class _FriendsMapViewState extends State<FriendsMapView>
    with TickerProviderStateMixin {
  final _mapController = MapController();
  final _panelController = DraggableScrollableController();
  final ValueNotifier<double> _panelExtent = ValueNotifier(0.28);
  late final TileProvider _tileProvider = AppMapTiles.createTileProvider();
  late final FriendsMapCamera _camera = FriendsMapCamera(
    _mapController,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _panelController.addListener(_syncPanelExtent);
  }

  void _syncPanelExtent() {
    if (!mounted || !_panelController.isAttached) return;
    final extent = _panelController.size;
    if ((extent - _panelExtent.value).abs() < 0.002) return;
    _panelExtent.value = extent;
  }

  @override
  void dispose() {
    _camera.dispose();
    _tileProvider.dispose();
    _mapController.dispose();
    _panelController
      ..removeListener(_syncPanelExtent)
      ..dispose();
    _panelExtent.dispose();
    super.dispose();
  }

  void _focusOn(double latitude, double longitude) {
    _camera.focusOn(
      latitude,
      longitude,
      animate:
          !MediaQuery.disableAnimationsOf(context) &&
          !MediaQuery.accessibleNavigationOf(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = context.watch<FriendsMapCubit>().state;
    final myLatitude = state.myLatitude;
    final myLongitude = state.myLongitude;
    final hasMyLocation =
        state.hasMyLocation && myLatitude != null && myLongitude != null;

    final friendsWithLocation = state.friends
        .where((f) => f.hasLocation)
        .toList();
    final loading =
        state.status == FriendsMapStatus.loading && state.friends.isEmpty;
    final failed =
        state.status == FriendsMapStatus.failure && state.friends.isEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: hasMyLocation
                  ? LatLng(myLatitude, myLongitude)
                  : kFriendsMapFallbackCenter,
              initialZoom: 15.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              AppMapTiles.tileLayer(
                context,
                tileProvider: _tileProvider,
              ),
              FriendsMarkerLayer(
                friends: friendsWithLocation,
                myLatitude: state.hasMyLocation ? state.myLatitude : null,
                myLongitude: state.hasMyLocation ? state.myLongitude : null,
                isGhost: state.isGhost,
                onFriendTap: (friend) =>
                    unawaited(_showFriendCard(context, friend)),
              ),
            ],
          ),
          FriendsMapTopBar(
            isGhost: state.isGhost,
            friendsOnMap: friendsWithLocation.length,
            requestCount: state.requests.length,
            loading: loading,
            onBack: () => Navigator.of(context).maybePop(),
            onRequests: () => _showRequests(context),
            onAddFriend: () => _showAddFriend(context),
          ),
          if (state.locationPermissionDenied)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  64,
                  AppSpacing.screen,
                  0,
                ),
                child: NinjaBanner(
                  tone: NinjaBannerTone.warn,
                  title: context.l10n.friendsGeoDenied,
                ).animateSectionEntrance(),
              ),
            ),
          FriendsMapControls(
            panelExtent: _panelExtent,
            isGhost: state.isGhost,
            onMyLocation: hasMyLocation
                ? () => _focusOn(myLatitude, myLongitude)
                : null,
            onToggleGhost: () =>
                context.read<FriendsMapCubit>().toggleGhostMode(),
            onGeoSettings: () => _showGeoSettings(context),
          ),
          NinjaFriendsPanel(
            controller: _panelController,
            friends: state.friends,
            myLatitude: state.myLatitude,
            myLongitude: state.myLongitude,
            loading: loading,
            failed: failed,
            onRetry: () => unawaited(context.read<FriendsMapCubit>().load()),
            onFriendTap: (friend) {
              final latitude = friend.latitude;
              final longitude = friend.longitude;
              if (friend.hasLocation && latitude != null && longitude != null) {
                _focusOn(latitude, longitude);
              }
            },
            onAddFriend: () => _showAddFriend(context),
          ),
          FriendsMapAttribution(panelExtent: _panelExtent),
        ],
      ),
    );
  }

  void _showRequests(BuildContext context) {
    final cubit = context.read<FriendsMapCubit>();
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.friendsRequests,
        child: BlocProvider.value(
          value: cubit,
          child: const NinjaFriendRequestsSheet(),
        ),
      ),
    );
  }

  void _showGeoSettings(BuildContext context) {
    final cubit = context.read<FriendsMapCubit>();
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.friendsGeoSharing,
        contentPadding: .zero,
        child: BlocProvider.value(
          value: cubit,
          child: const NinjaGeoSharingSheet(),
        ),
      ),
    );
  }

  void _showAddFriend(BuildContext context) {
    unawaited(
      Navigator.of(context, rootNavigator: true).push(FindFriendsPage.route()),
    );
  }

  Future<void> _showFriendCard(BuildContext context, Friend friend) async {
    final cubit = context.read<FriendsMapCubit>();
    final shouldRemove = await showAppSheet<bool>(
      context,
      child: FriendCardSheet(friend: friend),
    );
    if (shouldRemove != true || !context.mounted) return;
    final removed = await cubit.removeFriend(friend.userId);
    if (context.mounted && !removed) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.error,
      );
    }
  }
}
