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
  }) : _sliver = false;

  const FreeRoomsList.sliver({
    required this.state,
    required this.onRetry,
    required this.onRoomTap,
    this.roomFloors = const {},
    this.now,
    super.key,
  }) : _sliver = true;

  final FreeRoomsState state;
  final VoidCallback onRetry;
  final ValueChanged<FreeRoomViewModel> onRoomTap;
  final Map<String, int> roomFloors;
  final DateTime? now;
  final bool _sliver;

  Widget _box(Widget child) =>
      _sliver ? SliverToBoxAdapter(child: child) : child;

  @override
  Widget build(BuildContext context) {
    Visibility.of(context);
    final l10n = context.l10n;
    final current = now ?? DateTime.now();
    if (state.rooms.isEmpty &&
        (state.status == FreeRoomsStatus.initial ||
            state.status == FreeRoomsStatus.loading)) {
      return _box(
        Semantics(
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
        ),
      );
    }
    if (state.status == FreeRoomsStatus.failure && state.rooms.isEmpty) {
      return _box(
        NinjaErrorState(
          key: const ValueKey('free-rooms-failure'),
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      );
    }
    final rooms = state
        .filtered(roomFloors)
        .where(
          (room) => room.freeUntil == null || room.freeUntil!.isAfter(current),
        )
        .toList();
    if (_sliver && rooms.isNotEmpty) {
      final colors = context.colors;
      final radius = BorderRadius.circular(AppRadius.card);
      return SliverMainAxisGroup(
        slivers: [
          if (state.status == FreeRoomsStatus.failure)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppBanner(
                  message: l10n.loadingError,
                  tone: AppBannerTone.warn,
                  actionLabel: l10n.retry,
                  onAction: onRetry,
                ),
              ),
            ),
          DecoratedSliver(
            key: const ValueKey('free-rooms-list'),
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: AppSurfaceStyle.outline(context),
            ),
            sliver: DecoratedSliver(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.alphaBlend(
                      colors.white.withValues(
                        alpha: colors.isDark ? .025 : .22,
                      ),
                      colors.surface,
                    ),
                    colors.surface,
                  ],
                ),
              ),
              sliver: SliverList.separated(
                itemCount: rooms.length,
                addRepaintBoundaries: false,
                itemBuilder: (context, index) =>
                    _row(context, rooms[index], current),
                separatorBuilder: (context, index) => AppDivider(
                  color: colors.line.withValues(
                    alpha: colors.line.a * (colors.isDark ? .62 : .75),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return _box(
      Column(
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
      ),
    );
  }

  Widget _row(BuildContext context, FreeRoom room, DateTime current) {
    final model = FreeRoomViewModel(
      room: room,
      now: current,
      floor: roomFloors[roomKey(room.room)],
      locale: context.l10n.localeName,
    );
    return RepaintBoundary(
      child: FreeRoomRow(room: model, onTap: () => onRoomTap(model)),
    );
  }
}
