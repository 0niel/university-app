import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/services/friends_location_service.dart';
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
  bool? _showStudents;
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

    final showingStudents = _showStudents ?? state.friends.isEmpty;
    final people = showingStudents ? state.students : state.friends;
    final friendsWithLocation = people.where((f) => f.hasLocation).toList();
    final loading =
        people.isEmpty &&
        (state.status == FriendsMapStatus.initial ||
            state.status == FriendsMapStatus.loading ||
            showingStudents && state.studentsLoading);
    final failed = showingStudents
        ? state.studentsLoadFailed && people.isEmpty
        : state.status == FriendsMapStatus.failure && people.isEmpty;
    final locationMessage = state.locationPublishFailed
        ? context.l10n.friendsLocationPublishFailed
        : switch (state.locationStatus) {
            FriendsLocationStatus.permissionDenied ||
            FriendsLocationStatus.permissionDeniedForever ||
            FriendsLocationStatus.failure =>
              context.l10n.friendsLocationUnavailable,
            FriendsLocationStatus.serviceDisabled =>
              context.l10n.friendsLocationServiceDisabled,
            FriendsLocationStatus.unavailable =>
              context.l10n.friendsLocationUnsupported,
            _ => null,
          };

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
            showingStudents: showingStudents,
            onBack: () => Navigator.of(context).maybePop(),
            onRequests: () => _showRequests(context),
            onAddFriend: () => _showAddFriend(context),
          ),
          if (locationMessage != null)
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
                  title: locationMessage,
                  actionLabel: context.l10n.friendsGeoSharing,
                  onAction: () => _showGeoSettings(context),
                ).animateSectionEntrance(),
              ),
            ),
          FriendsMapControls(
            panelExtent: _panelExtent,
            isGhost: state.isGhost,
            onMyLocation: hasMyLocation
                ? () => _focusOn(myLatitude, myLongitude)
                : () => context.read<FriendsMapCubit>().retryLocation(),
            onToggleGhost: state.privacyBusy
                ? null
                : state.geoSettings.sharing &&
                      state.geoSettings.visibility != GeoVisibility.none
                ? () => context.read<FriendsMapCubit>().toggleGhostMode()
                : () => _showGeoSettings(context),
            onGeoSettings: () => _showGeoSettings(context),
          ),
          NinjaFriendsPanel(
            controller: _panelController,
            friends: people,
            showingStudents: showingStudents,
            onShowStudentsChanged: (value) {
              setState(() => _showStudents = value);
              if (value) {
                unawaited(context.read<FriendsMapCubit>().refreshStudents());
              }
            },
            myLatitude: state.myLatitude,
            myLongitude: state.myLongitude,
            loading: loading,
            failed: failed,
            onRetry: () => unawaited(
              showingStudents
                  ? context.read<FriendsMapCubit>().refreshStudents()
                  : context.read<FriendsMapCubit>().load(),
            ),
            onFriendTap: (friend) {
              final latitude = friend.latitude;
              final longitude = friend.longitude;
              if (friend.hasLocation && latitude != null && longitude != null) {
                _focusOn(latitude, longitude);
              }
              unawaited(_showFriendCard(context, friend));
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
    final isFriend = cubit.state.friends.any(
      (item) => item.userId == friend.userId,
    );
    final shouldRemove = await showAppSheet<bool>(
      context,
      child: FriendCardSheet(friend: friend, isFriend: isFriend),
    );
    if (!isFriend || shouldRemove != true || !context.mounted) return;
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
