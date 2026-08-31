import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';

part 'widgets/way_card.dart';

class CreateSchedulePage extends StatelessWidget {
  const CreateSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: colors.canvas,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.createScheduleTitle,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList.list(
                children: [
                  Text(
                    l10n.createScheduleHeadline,
                    style: NinjaText.title.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createScheduleSubtitle,
                    style: NinjaText.body.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: 28),
                  _WayCard(
                    icon: AppLineIcon.people,
                    title: l10n.createWayGroupTitle,
                    description: l10n.createWayGroupDescription,
                    recommended: true,
                    badge: l10n.createWayFastBadge,
                    onTap: () => openGlobalSearch(context),
                  ),
                  const SizedBox(height: 10),
                  _WayCard(
                    icon: AppLineIcon.search,
                    title: l10n.createWaySearchTitle,
                    description: l10n.createWaySearchDescription,
                    onTap: () => openGlobalSearch(context),
                  ),
                  const SizedBox(height: 10),
                  _WayCard(
                    icon: AppLineIcon.pencil,
                    title: l10n.createWayManualTitle,
                    description: l10n.createWayManualDescription,
                    onTap: () => _createManually(context),
                  ),
                  if (context
                      .watch<CustomScheduleCubit>()
                      .state
                      .customSchedules
                      .isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(
                      l10n.mySchedules,
                      style: NinjaText.title.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 4),
                    NinjaListCell(
                      title: l10n.openMySchedules,
                      subtitle: l10n.openMySchedulesSubtitle,
                      onTap: () => context.go('/schedule/custom'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createManually(BuildContext context) {
    final schedule = context.read<CustomScheduleCubit>().create(
      name: context.l10n.customScheduleDefaultName,
    );
    unawaited(context.push('/schedule/edit/${schedule.id}'));
  }
}
