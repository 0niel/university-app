import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'building_selector.dart';
part 'building_selector_skeleton.dart';
part 'free_room_row_skeleton.dart';
part 'free_rooms_list_skeleton.dart';
part 'free_rooms_message.dart';

class FreeRoomsView extends StatelessWidget {
  const FreeRoomsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<FreeRoomsCubit>().state;
    final cubit = context.read<FreeRoomsCubit>();
    final loading = state.status == .loading && state.rooms.isEmpty;
    final failed = state.status == .failure && state.rooms.isEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NinjaAppBar(title: l10n.classrooms),
      body: NinjaSkeletonGroup(
        excludeSemantics: false,
        pulse: loading,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                18,
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    l10n.freeRoomsSubtitle,
                    style: NinjaText.body.copyWith(color: colors.muted),
                  ),
                  if (!failed) ...[
                    const SizedBox(height: 18),
                    FreeRoomsSummary(
                      count: state.rooms.length,
                      loading: loading,
                    ),
                  ],
                ],
              ),
            ),
            if (loading)
              const _BuildingSelectorSkeleton()
            else if (!failed && state.buildings.isNotEmpty)
              _BuildingSelector(
                buildings: state.buildings,
                value: state.building,
                onChanged: cubit.buildingChanged,
              ),
            Expanded(
              child: RefreshIndicator(
                color: colors.brand,
                backgroundColor: colors.surface,
                onRefresh: cubit.load,
                child: NinjaStateSwitcher(
                  child: _body(
                    context,
                    state: state,
                    cubit: cubit,
                    loading: loading,
                    failed: failed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context, {
    required FreeRoomsState state,
    required FreeRoomsCubit cubit,
    required bool loading,
    required bool failed,
  }) {
    final l10n = context.l10n;
    if (loading) {
      return const _FreeRoomsListSkeleton(key: ValueKey('free-rooms-loading'));
    }
    if (failed) {
      return _FreeRoomsMessage(
        key: const ValueKey('free-rooms-failure'),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(cubit.load()),
        ),
      );
    }
    final rooms = state.filteredRooms;
    if (rooms.isEmpty) {
      return _FreeRoomsMessage(
        key: const ValueKey('free-rooms-empty'),
        child: Column(
          mainAxisSize: .min,
          children: [
            NinjaEmptyState.screen(
              icon: const AppLineIconWidget(.door),
              title: l10n.freeRoomsEmptyTitle,
              message: l10n.freeRoomsEmptySub,
            ),
            NinjaChip(
              label: l10n.freeRoomsRefresh,
              selected: true,
              onTap: () => unawaited(cubit.load()),
            ),
          ],
        ).animateEmptyState(),
      );
    }
    return ListView.separated(
      key: const ValueKey('free-rooms-list'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        40,
      ),
      itemCount: rooms.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => FreeRoomRow(room: rooms[index]),
    );
  }
}
