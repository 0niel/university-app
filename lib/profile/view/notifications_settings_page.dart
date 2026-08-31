import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final settings = state.settings;
    final isMasterOn = settings.notificationsEnabled;
    final cold =
        state.status == ProfileStatus.loading &&
        state.gamificationProfile.isEmpty;

    void update(UserSettings next) {
      unawaited(context.read<ProfileCubit>().updateSettings(next));
    }

    ValueChanged<bool>? whenMasterOn(ValueChanged<bool> onChanged) =>
        isMasterOn ? onChanged : null;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: colors.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 60,
          leading: Center(
            child: NinjaIconButton(
              icon: const AppLineIconWidget(.chevronL, size: 20),
              tooltip: l10n.back,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            l10n.notifications,
            style: NinjaText.appBarTitle.copyWith(color: colors.ink),
          ),
        ),
        if (cold)
          const SliverToBoxAdapter(child: SettingsSkeleton.notifications())
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                8,
                NinjaMetrics.screenPadding,
                6,
              ),
              child: Text(
                l10n.settingsNotificationsPushSub,
                style: NinjaText.subtext.copyWith(color: colors.mutedDark),
              ),
            ),
          ),
          SliverList.list(
            children: [
              if (state.hasFailed(.settings))
                SettingsFailureCard(
                  onRetry: () => unawaited(
                    context.read<ProfileCubit>().reloadSection(.settings),
                  ),
                ),
              Padding(
                padding: const .fromLTRB(
                  NinjaMetrics.screenPadding,
                  12,
                  NinjaMetrics.screenPadding,
                  0,
                ),
                child: SettingsCard(
                  children: [
                    NotificationsToggleRow(
                      label: l10n.settingsNotificationsPushTitle,
                      sub: l10n.settingsNotificationsPushSub,
                    ),
                  ],
                ),
              ),
              SettingsSection(
                label: l10n.settingsNotificationsScheduleSection,
                children: [
                  SettingsToggleRow(
                    label: l10n.settingsNotificationsScheduleTitle,
                    sub: l10n.settingsNotificationsScheduleSub,
                    value: settings.scheduleChangeAlerts && isMasterOn,
                    onChanged: whenMasterOn(
                      (value) => update(
                        settings.copyWith(scheduleChangeAlerts: value),
                      ),
                    ),
                  ),
                ],
              ),
              SettingsSection(
                label: l10n.settingsNotificationsGamificationSection,
                children: [
                  SettingsToggleRow(
                    label: l10n.settingsNotificationsQuestsTitle,
                    sub: l10n.settingsNotificationsQuestsSub,
                    value: settings.questReminders && isMasterOn,
                    onChanged: whenMasterOn(
                      (value) =>
                          update(settings.copyWith(questReminders: value)),
                    ),
                  ),
                  SettingsToggleRow(
                    label: l10n.settingsNotificationsAchievementsTitle,
                    sub: l10n.settingsNotificationsAchievementsSub,
                    value: settings.achievementAlerts && isMasterOn,
                    onChanged: whenMasterOn(
                      (value) =>
                          update(settings.copyWith(achievementAlerts: value)),
                    ),
                  ),
                  SettingsToggleRow(
                    label: l10n.settingsNotificationsLeaderboardTitle,
                    sub: l10n.settingsNotificationsLeaderboardSub,
                    value: settings.leaderboardUpdates && isMasterOn,
                    onChanged: whenMasterOn(
                      (value) =>
                          update(settings.copyWith(leaderboardUpdates: value)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
            ],
          ),
        ],
      ],
    ).animatePageEntrance();
  }
}
