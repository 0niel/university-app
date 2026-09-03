import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_row.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

class FreeRoomsList extends StatelessWidget {
  const FreeRoomsList({
    required this.state,
    required this.onRetry,
    required this.onRoomTap,
    this.roomFloors = const {},
    this.now,
    super.key,
  });

  final FreeRoomsState state;
  final VoidCallback onRetry;
  final ValueChanged<FreeRoomViewModel> onRoomTap;
  final Map<String, int> roomFloors;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = now ?? DateTime.now();
    if (state.rooms.isEmpty &&
        (state.status == FreeRoomsStatus.initial ||
            state.status == FreeRoomsStatus.loading)) {
      return Semantics(
        label: l10n.loadingContent,
        liveRegion: true,
        child: const NinjaSkeletonGroup(
          key: ValueKey('free-rooms-loading'),
          child: Column(
            children: [
              AppSkeletonRow(),
              SizedBox(height: 8),
              AppSkeletonRow(),
              SizedBox(height: 8),
              AppSkeletonRow(),
            ],
          ),
        ),
      );
    }
    if (state.status == FreeRoomsStatus.failure && state.rooms.isEmpty) {
      return NinjaErrorState(
        key: const ValueKey('free-rooms-failure'),
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      );
    }
    final rooms = state
        .filtered(roomFloors)
        .where(
          (room) => room.freeUntil == null || room.freeUntil!.isAfter(current),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.status == FreeRoomsStatus.failure) ...[
          AppBanner(
            message: l10n.loadingError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
          const SizedBox(height: 12),
        ],
        if (rooms.isEmpty)
          NinjaEmptyState(
            key: const ValueKey('free-rooms-empty'),
            icon: const AppLineIconWidget(AppLineIcon.door),
            title: l10n.freeRoomsEmptyTitle,
            message: l10n.freeRoomsNothingFoundAll,
            actionLabel: l10n.freeRoomsRefresh,
            onAction: onRetry,
          )
        else
          AppListGroup(
            key: const ValueKey('free-rooms-list'),
            children: [
              for (final room in rooms) _row(context, room, current),
            ],
          ),
      ],
    );
  }

  Widget _row(BuildContext context, FreeRoom room, DateTime current) {
    final model = FreeRoomViewModel(
      room: room,
      now: current,
      floor: roomFloors[roomKey(room.room)],
      locale: context.l10n.localeName,
    );
    return FreeRoomRow(room: model, onTap: () => onRoomTap(model));
  }
}
