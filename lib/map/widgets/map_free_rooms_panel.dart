import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

class MapFreeRoomsPanel extends StatelessWidget {
  const MapFreeRoomsPanel({
    required this.controller,
    required this.collapsedSize,
    required this.viewportHeight,
    required this.bottomInset,
    required this.compactContentExtent,
    required this.mapState,
    required this.onRoomTap,
    required this.onFloor,
    required this.onToggle,
    required this.onMappedRoomTap,
    this.discovery,
    super.key,
  });

  final DraggableScrollableController controller;
  final double collapsedSize;
  final double viewportHeight;
  final double bottomInset;
  final double compactContentExtent;
  final MapState mapState;
  final ValueChanged<FreeRoomViewModel> onRoomTap;
  final ValueChanged<FloorModel> onFloor;
  final VoidCallback onToggle;
  final ValueChanged<RoomModel> onMappedRoomTap;
  final Widget? discovery;

  Future<void> _chooseFloor(BuildContext context) => showAppSheet<void>(
    context,
    title: 'Этажи',
    subtitle: mapState.selectedCampus?.displayName,
    child: AppListGroup(
      children: [
        if (discovery == null)
          AppListRow(
            title: 'Свободные на всех этажах',
            leading: const AppIconTile(icon: AppLineIcon.grid),
            onTap: () {
              context.read<FreeRoomsCubit>().floorChanged(null);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        for (final floor in mapState.selectedCampus?.floors ?? <FloorModel>[])
          AppListRow(
            title: context.l10n.mapFloorNumber(floor.number),
            leading: const AppIconTile(icon: AppLineIcon.map),
            trailing: mapState.selectedFloor?.id == floor.id
                ? const AppLineIconWidget(AppLineIcon.check)
                : null,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              onFloor(floor);
            },
          ),
      ],
    ),
  );

  static double compactContentExtentOf(
    BuildContext context, {
    required double width,
    required String campusName,
    bool discoveryMode = false,
  }) {
    double height(String text, TextStyle style, double maxWidth) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        locale: Localizations.maybeLocaleOf(context),
      )..layout(maxWidth: maxWidth);
      final result = painter.height;
      painter.dispose();
      return result;
    }

    final floor = math.max(
      AppControlSize.touchTarget,
      height('1 этаж', AppText.chipStrong, double.infinity) + 18,
    );
    return 20 + floor + 12;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<FreeRoomsCubit>().state;
    final campus = mapState.selectedCampus;
    final filtered = state.copyWith(campus: campus?.displayName ?? '');
    final mappedRooms = state.query.trim().isEmpty
        ? <RoomModel>[]
        : mapState.rooms
              .where(
                (room) =>
                    roomKey(room.name).contains(roomKey(state.query)) ||
                    roomKey(room.roomId).contains(roomKey(state.query)),
              )
              .toList();
    Widget header(ScrollController scrollController) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (!controller.isAttached) return;
        controller.jumpTo(
          (controller.size - details.delta.dy / viewportHeight).clamp(
            collapsedSize,
            .78,
          ),
        );
      },
      onVerticalDragEnd: (_) {
        if (!controller.isAttached) return;
        if (scrollController.hasClients) scrollController.jumpTo(0);
        final target = controller.size < (collapsedSize + .78) / 2
            ? collapsedSize
            : .78;
        if (MediaQuery.disableAnimationsOf(context) ||
            MediaQuery.accessibleNavigationOf(context)) {
          controller.jumpTo(target);
        } else {
          unawaited(
            controller.animateTo(
              target,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: colors.muted2,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Места',
                    style: AppText.labelStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (mapState.selectedFloor != null)
                  AppChip.filter(
                    label: l10n.mapFloorNumber(mapState.selectedFloor!.number),
                    onTap: () => _chooseFloor(context),
                  ),
                const SizedBox(width: AppSpacing.sm),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    final expanded =
                        controller.isAttached &&
                        controller.size > collapsedSize + .08;
                    return AppIconButton(
                      icon: AnimatedRotation(
                        turns: expanded ? .5 : 0,
                        duration: NinjaMotion.of(context),
                        child: const AppLineIconWidget(AppLineIcon.chevronU),
                      ),
                      tooltip: expanded
                          ? l10n.mapCollapseSheet
                          : l10n.mapExpandSheet,
                      shape: AppIconButtonShape.circle,
                      size: AppIconButtonSize.compact,
                      tone: AppIconButtonTone.surface,
                      onPressed: () {
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(0);
                        }
                        onToggle();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final rooms = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?discovery,
        if (mappedRooms.isNotEmpty && discovery == null) ...[
          AppListGroup(
            children: [
              for (final room in mappedRooms)
                AppListRow(
                  title: room.name.isEmpty ? room.roomId : room.name,
                  subtitle: l10n.roomRoute,
                  onTap: () => onMappedRoomTap(room),
                ),
            ],
          ),
          const SizedBox(height: 14),
        ],
        Text(l10n.freeRoomsNowTitle, style: AppText.sectionLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${campus?.displayName ?? ''} · ${l10n.freeRoomsSubtitle}',
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 12),
        FreeRoomsList(
          state: filtered,
          roomFloors: mapState.roomFloors,
          onRetry: () => unawaited(context.read<FreeRoomsCubit>().load()),
          onRoomTap: onRoomTap,
        ),
      ],
    );
    return DraggableScrollableSheet(
      controller: controller,
      minChildSize: collapsedSize,
      initialChildSize: state.query.trim().isEmpty ? collapsedSize : .78,
      maxChildSize: .78,
      snap: true,
      snapSizes: [collapsedSize, .78],
      builder: (context, scrollController) => DecoratedBox(
        key: const ValueKey('map-panel-surface'),
        decoration: BoxDecoration(
          color: colors.canvas,
          border: Border.all(color: colors.line),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final collapsed =
                  constraints.maxHeight <=
                  viewportHeight * collapsedSize - bottomInset + 1;
              final scrollingHeader =
                  viewportHeight * collapsedSize - bottomInset <
                      compactContentExtent - 1 ||
                  MediaQuery.textScalerOf(context).scale(14) > 19;
              if (scrollingHeader) {
                return SingleChildScrollView(
                  key: const ValueKey('map-panel-scroll'),
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: AppSpacing.screen),
                  child: Column(
                    children: [
                      header(scrollController),
                      if (!collapsed)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                          child: rooms,
                        ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  header(scrollController),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: SingleChildScrollView(
                          key: const ValueKey('map-panel-scroll'),
                          controller: scrollController,
                          padding: EdgeInsets.only(
                            top: collapsed ? 0 : AppSpacing.sectionGap,
                            bottom: AppSpacing.screen,
                          ),
                          child: collapsed ? const SizedBox.shrink() : rooms,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
