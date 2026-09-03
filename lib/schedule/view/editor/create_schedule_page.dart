import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';
import 'package:rtu_mirea_app/search/widgets/global_search_button.dart';

part 'widgets/way_card.dart';

class CreateSchedulePage extends StatelessWidget {
  const CreateSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: l10n.createScheduleTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.sm,
                AppSpacing.screen,
                AppSpacing.xxl,
              ),
              sliver: SliverList.list(
                children: [
                  Text(
                    l10n.createScheduleHeadline,
                    style: AppText.title.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.createScheduleSubtitle,
                    style: AppText.body.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.sheetBottom),
                  _WayCard(
                    icon: AppLineIcon.people,
                    title: l10n.createWayGroupTitle,
                    description: l10n.createWayGroupDescription,
                    recommended: true,
                    badge: l10n.createWayFastBadge,
                    onTap: () => openGlobalSearch(context),
                  ),
                  const SizedBox(height: AppSpacing.gap),
                  _WayCard(
                    icon: AppLineIcon.search,
                    title: l10n.createWaySearchTitle,
                    description: l10n.createWaySearchDescription,
                    onTap: () => openGlobalSearch(context),
                  ),
                  const SizedBox(height: AppSpacing.gap),
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
                    const SizedBox(height: AppSpacing.sheetBottom),
                    Text(
                      l10n.mySchedules,
                      style: AppText.title.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppListRow(
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
