import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'widgets/change_timeline_row.dart';
part 'widgets/changes_skeleton.dart';
part 'widgets/change_timeline_row_skeleton.dart';
part 'widgets/subscribe_banner.dart';

class ChangesPage extends StatefulWidget {
  const ChangesPage({super.key});

  @override
  State<ChangesPage> createState() => _ChangesPageState();
}

class _ChangesPageState extends State<ChangesPage> {
  UserSettings? _settings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_loadChanges());
      unawaited(_loadSettings());
    });
  }

  Future<void> _loadChanges() {
    final selected = context.read<ScheduleBloc>().state.selectedSchedule;
    final request = switch (selected) {
      SelectedGroupSchedule(:final group) => (
        ScheduleTargetType.group,
        group.name,
      ),
      SelectedTeacherSchedule(:final teacher) => (
        ScheduleTargetType.teacher,
        teacher.name,
      ),
      SelectedClassroomSchedule(:final classroom) => (
        ScheduleTargetType.classroom,
        classroom.name,
      ),
      SelectedCustomSchedule() || null => null,
    };
    if (request == null) return Future.value();
    return context.read<ScheduleChangesCubit>().load(
      targetType: request.$1,
      target: request.$2,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await context
          .read<GamificationRepository>()
          .getSettings();
      if (mounted) setState(() => _settings = settings);
    } on Exception catch (_) {}
  }

  Future<void> _toggleAlerts(bool value) async {
    final current = _settings;
    if (current == null) return;
    setState(() => _settings = current.copyWith(scheduleChangeAlerts: value));
    try {
      await context.read<GamificationRepository>().updateSettings(
        current.copyWith(scheduleChangeAlerts: value),
      );
    } on Exception catch (_) {
      if (mounted) setState(() => _settings = current);
    }
  }

  Widget _buildChanges(BuildContext context, ScheduleChangesState state) {
    final l10n = context.l10n;
    if (state.isLoading && state.changes.isEmpty) {
      return const _ChangesSkeleton(key: ValueKey('changes_skeleton'));
    }
    if (state.status == .failure && state.changes.isEmpty) {
      return NinjaErrorState(
        title: l10n.errorLoadingSchedule,
        message: l10n.lessonDetailsCheckConnection,
        retryLabel: l10n.retry,
        onRetry: () => unawaited(_loadChanges()),
      ).animateEmptyState(key: const ValueKey('changes_error'));
    }
    if (state.changes.isEmpty) {
      return NinjaEmptyState(
        title: l10n.changesEmptyTitle,
        message: l10n.changesEmptySubtitle,
        icon: AppLineIconWidget(
          AppLineIcon.bell,
          size: 20,
          color: context.ninja.muted,
        ),
        actionLabel: l10n.retry,
        onAction: () => unawaited(_loadChanges()),
      ).animateEmptyState(key: const ValueKey('changes_empty'));
    }
    return Column(
      key: const ValueKey('changes_list'),
      crossAxisAlignment: .stretch,
      children: [
        for (final (index, change) in state.changes.indexed)
          _ChangeTimelineRow(
            change: change,
            last: index == state.changes.length - 1,
          ).animateListItem(index: index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<ScheduleChangesCubit>().state;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.ink,
        onRefresh: _loadChanges,
        child: CustomScrollView(
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
                l10n.changesTitle,
                style: NinjaText.headline.copyWith(color: colors.ink),
              ),
              actions: [
                Stack(
                  clipBehavior: .none,
                  children: [
                    NinjaIconButton(
                      icon: const AppLineIconWidget(
                        .bell,
                        size: 20,
                      ),
                      tooltip: l10n.notifications,
                      onPressed: _settings == null
                          ? null
                          : () => unawaited(
                              _toggleAlerts(
                                !(_settings?.scheduleChangeAlerts ?? true),
                              ),
                            ),
                    ),
                    if (state.changes.isNotEmpty)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.brand,
                            shape: .circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  6,
                  NinjaMetrics.screenPadding,
                  32,
                ),
                sliver: SliverList.list(
                  children: [
                    _SubscribeBanner(
                      enabled: _settings?.scheduleChangeAlerts ?? true,
                      onChanged: _settings == null
                          ? null
                          : (value) => unawaited(_toggleAlerts(value)),
                    ),
                    const SizedBox(height: 28),
                    NinjaStateSwitcher(child: _buildChanges(context, state)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
