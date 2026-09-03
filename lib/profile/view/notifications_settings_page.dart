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
      backgroundColor: context.colors.canvas,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    final colors = context.colors;
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
        SliverToBoxAdapter(
          child: AppInnerHeader(
            title: l10n.notifications,
            backSemanticsLabel: l10n.back,
            onBack: () => Navigator.of(context).maybePop(),
          ),
        ),
        if (cold)
          const SliverToBoxAdapter(child: SettingsSkeleton.notifications())
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const .fromLTRB(
                AppSpacing.screen,
                8,
                AppSpacing.screen,
                6,
              ),
              child: Text(
                l10n.settingsNotificationsPushSub,
                style: AppText.subtext.copyWith(color: colors.muted),
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
                  AppSpacing.screen,
                  12,
                  AppSpacing.screen,
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
