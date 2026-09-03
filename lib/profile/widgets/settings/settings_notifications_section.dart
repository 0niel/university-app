import 'package:app_ui/app_ui.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

class SettingsNotificationsSection extends StatelessWidget {
  const SettingsNotificationsSection({
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final profile = context.watch<ProfileCubit>();
    final settings = profile.state.settings;
    return SettingsSection(
      label: l10n.notifications,
      children: [
        SettingsToggleRow(
          label: l10n.settingsNotificationsScheduleTitle,
          sub: l10n.settingsNotificationsScheduleSub,
          value: enabled && settings.scheduleChangeAlerts,
          onChanged: enabled
              ? (value) => profile.updateSettings(
                  settings.copyWith(scheduleChangeAlerts: value),
                )
              : null,
        ),
        SettingsToggleRow(
          label: l10n.settingsNotificationsQuestsTitle,
          sub: l10n.settingsNotificationsQuestsSub,
          value: enabled && settings.questReminders,
          onChanged: enabled
              ? (value) => profile.updateSettings(
                  settings.copyWith(questReminders: value),
                )
              : null,
        ),
        SettingsToggleRow(
          label: l10n.settingsNotificationsAchievementsTitle,
          sub: l10n.settingsNotificationsAchievementsSub,
          value: enabled && settings.achievementAlerts,
          onChanged: enabled
              ? (value) => profile.updateSettings(
                  settings.copyWith(achievementAlerts: value),
                )
              : null,
        ),
        SettingsRow(
          title: l10n.settingsAllNotifications,
          lineIcon: AppLineIcon.bell,
          value: enabled
              ? l10n.settingsNotificationsOn
              : l10n.settingsNotificationsOff,
          valueColor: enabled ? colors.lecture : colors.muted,
          onTap: onTap,
        ),
      ],
    );
  }
}
