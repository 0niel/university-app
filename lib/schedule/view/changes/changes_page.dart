import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/notification_feed.dart';
import 'package:rtu_mirea_app/notifications/view/schedule_changes_read_scope.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';
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
  bool _savingSettings = false;
  bool _settingsError = false;

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
    final request = changesRequestFor(selected);
    final cubit = context.read<ScheduleChangesCubit>();
    if (request == null) {
      cubit.clear();
      return Future.value();
    }
    return cubit.load(
      targetType: request.$1,
      target: request.$2,
    );
  }

  Future<void> _loadSettings() async {
    if (_settingsError && mounted) setState(() => _settingsError = false);
    try {
      final settings = await context
          .read<GamificationRepository>()
          .getSettings();
      if (mounted) setState(() => _settings = settings);
    } on Exception catch (_) {
      if (mounted) setState(() => _settingsError = true);
    }
  }

  Future<void> _toggleAlerts(bool value) async {
    final current = _settings;
    if (current == null || _savingSettings) return;
    setState(() {
      _settings = current.copyWith(scheduleChangeAlerts: value);
      _savingSettings = true;
    });
    try {
      await context.read<GamificationRepository>().updateSettings(
        current.copyWith(scheduleChangeAlerts: value),
      );
    } on Exception catch (_) {
      if (mounted) {
        setState(() => _settings = current);
        ToastManager.showError(
          context,
          message: context.l10n.scheduleActionFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _savingSettings = false);
    }
  }

  Widget _buildChanges(BuildContext context, ScheduleChangesState state) {
    final l10n = context.l10n;
    if (state.isLoading && state.changes.isEmpty) {
      return const _ChangesSkeleton(key: ValueKey('changes_skeleton'));
    }
    if (state.status == .failure && state.changes.isEmpty) {
      return AppErrorState(
        title: l10n.errorLoadingSchedule,
        message: l10n.lessonDetailsCheckConnection,
        primaryLabel: l10n.retry,
        footnote: null,
        onPrimary: () => unawaited(_loadChanges()),
      ).animateEmptyState(key: const ValueKey('changes_error'));
    }
    if (state.changes.isEmpty) {
      return AppEmptyState(
        title: l10n.changesEmptyTitle,
        subtitle: l10n.changesEmptySubtitle,
        icon: AppLineIconWidget(
          AppLineIcon.bell,
          size: 20,
          color: context.colors.muted,
        ),
        actionLabel: l10n.retry,
        onAction: () => unawaited(_loadChanges()),
      ).animateEmptyState(key: const ValueKey('changes_empty'));
    }
    return ScheduleChangesReadScope(
      changes: state.changes,
      child: Column(
        key: const ValueKey('changes_list'),
        crossAxisAlignment: .stretch,
        children: [
          for (final (index, change) in state.changes.indexed)
            _ChangeTimelineRow(
              change: change,
              last: index == state.changes.length - 1,
            ).animateListItem(index: index),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final cubit = context.watch<ScheduleChangesCubit>();
    final selected = context.watch<ScheduleBloc>().state.selectedSchedule;
    final request = changesRequestFor(selected);
    final notifications = context.watch<NotificationsCubit?>()?.state;
    final state = request != null && cubit.matchesTarget(request.$1, request.$2)
        ? cubit.state
        : const ScheduleChangesState();

    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listenWhen: (before, after) =>
            before.selectedSchedule != after.selectedSchedule,
        listener: (_, _) => unawaited(_loadChanges()),
        child: RefreshIndicator(
          color: colors.ink,
          onRefresh: _loadChanges,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: AppInnerHeader(
                  title: l10n.changesTitle,
                  onBack: () => Navigator.of(context).maybePop(),
                  actions: [
                    AppHeaderAction(
                      icon: AppLineIcon.bell,
                      semanticsLabel: l10n.notifications,
                      badge: state.changes.any(
                        (change) =>
                            !(notifications?.isRead(
                                  scheduleChangeNotificationId(change),
                                ) ??
                                false),
                      ),
                      onTap: _settings == null || _savingSettings
                          ? null
                          : () => unawaited(
                              _toggleAlerts(
                                !(_settings?.scheduleChangeAlerts ?? true),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.xsm,
                    AppSpacing.screen,
                    AppSpacing.xxl,
                  ),
                  sliver: SliverList.list(
                    children: [
                      if (_settingsError)
                        AppBanner(
                          tone: AppBannerTone.warn,
                          message: l10n.loadingError,
                          actionLabel: l10n.retry,
                          onAction: () => unawaited(_loadSettings()),
                        )
                      else if (_settings == null)
                        const AppSkeletonRow()
                      else
                        _SubscribeBanner(
                          enabled: _settings!.scheduleChangeAlerts,
                          onChanged: _savingSettings
                              ? null
                              : (value) => unawaited(_toggleAlerts(value)),
                        ),
                      const SizedBox(height: AppSpacing.sheetBottom),
                      AppStateSwitcher(child: _buildChanges(context, state)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
