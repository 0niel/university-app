import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/app/view/app_device_token_sync.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/notifications/notification_permission.dart';
import 'package:rtu_mirea_app/notifications/view/schedule_changes_read_scope.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_card.dart';

part 'widgets/changes_skeleton.dart';
part 'widgets/change_timeline_row_skeleton.dart';
part 'widgets/subscribe_banner.dart';

class ChangesPage extends StatefulWidget {
  const ChangesPage({super.key});

  @override
  State<ChangesPage> createState() => _ChangesPageState();
}

class _ChangesPageState extends State<ChangesPage> with WidgetsBindingObserver {
  UserSettings? _settings;
  bool? _permissionGranted;
  var _permissionRead = 0;
  bool _savingSettings = false;
  bool _settingsError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_loadChanges());
      unawaited(_loadSettings());
      unawaited(_refreshPermission());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissionRead++;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_savingSettings) {
      unawaited(_refreshPermission());
    }
  }

  Future<void> _refreshPermission() async {
    final request = ++_permissionRead;
    try {
      final granted = await hasNotificationPermission(
        context.read<LocalNotificationsRepository>(),
      );
      if (mounted && request == _permissionRead) {
        setState(() => _permissionGranted = granted);
      }
    } on Exception {
      if (mounted && request == _permissionRead) {
        setState(() => _permissionGranted = false);
      }
    }
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
    _permissionRead++;
    setState(() => _savingSettings = true);
    try {
      if (value) {
        final granted = await requestNotificationPermission(
          context.read<LocalNotificationsRepository>(),
        );
        if (!mounted) return;
        setState(() => _permissionGranted = granted);
        if (!granted) {
          ToastManager.showWarning(
            context,
            message: context.l10n.onboardingPushDenied,
          );
          return;
        }
        await AppDeviceTokenSync.refresh(context);
        if (!mounted) return;
      }
      final next = current.copyWith(
        scheduleChangeAlerts: value,
        notificationsEnabled: value || current.notificationsEnabled,
      );
      setState(() => _settings = next);
      await context.read<GamificationRepository>().updateSettings(
        next,
        previous: current,
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
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final cubit = context.watch<ScheduleChangesCubit>();
    final selected = context.watch<ScheduleBloc>().state.selectedSchedule;
    final request = changesRequestFor(selected);
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
          child: ScheduleChangesReadScope(
            changes: state.changes,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, constraints) => AppInnerHeader(
                      title: l10n.changesTitle,
                      titleStyle:
                          constraints.maxWidth < 360 &&
                              MediaQuery.textScalerOf(context).scale(14) > 20
                          ? AppText.headline
                          : null,
                      onBack: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
                SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.xsm,
                      AppSpacing.screen,
                      AppSpacing.md,
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
                        else if (_settings == null ||
                            _permissionGranted == null)
                          const AppSkeletonRow()
                        else
                          _SubscribeBanner(
                            enabled:
                                _settings!.notificationsEnabled &&
                                _settings!.scheduleChangeAlerts &&
                                _permissionGranted == true,
                            onChanged: _savingSettings
                                ? null
                                : (value) => unawaited(_toggleAlerts(value)),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.xxl,
                    ),
                    sliver: state.changes.isEmpty
                        ? SliverToBoxAdapter(
                            child: AppStateSwitcher(
                              child: _buildChanges(context, state),
                            ),
                          )
                        : SliverList.builder(
                            key: const ValueKey('changes_list'),
                            itemCount: state.changes.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.gap,
                              ),
                              child: ScheduleChangeCard(
                                change: state.changes[index],
                              ),
                            ).animateListItem(index: index),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
