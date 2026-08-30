import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/data/datasources/home_screen_widget_service.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

part 'select_row.dart';

String languageLabel(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      .system => l10n.settingsLanguageSystem,
      .ru => l10n.settingsLanguageRu,
      .en => l10n.settingsLanguageEn,
    };

String visibilityLabel(AppLocalizations l10n, ProfileVisibility visibility) =>
    switch (visibility) {
      .everyone => l10n.settingsVisibilityEveryone,
      .group => l10n.settingsVisibilityGroup,
      .nobody => l10n.settingsVisibilityNobody,
    };

String biometricLabel(AppLocalizations l10n, BiometricKind kind) =>
    switch (kind) {
      .face => l10n.biometricFaceId,
      .fingerprint || .iris => l10n.biometricFingerprint,
      .none => l10n.biometricUnavailable,
    };

String syncPolicyLabel(AppLocalizations l10n, SyncPolicy policy) =>
    switch (policy) {
      .always => l10n.settingsSyncAlways,
      .wifiOnly => l10n.settingsSyncWifiOnly,
      .manualOnly => l10n.settingsSyncManual,
    };

String homeSectionLabel(AppLocalizations l10n, HomeSection section) =>
    switch (section) {
      .smartChips => l10n.homeSectionSmartChips,
      .deadlines => l10n.homeSectionDeadlines,
      .today => l10n.homeSectionToday,
      .trending => l10n.homeSectionTrending,
    };

String homeContentSummary(AppLocalizations l10n, UiPreferencesState state) {
  final enabled = HomeSection.values.where(state.isSectionEnabled).toList();
  if (enabled.isEmpty) return l10n.settingsHomeContentNone;
  if (enabled.length == HomeSection.values.length) {
    return l10n.settingsHomeContentAll;
  }
  return enabled
      .map((section) => homeSectionLabel(l10n, section).toLowerCase())
      .join(', ');
}

Future<void> showLanguageSheet(
  BuildContext context, {
  required AppLanguage current,
  required ValueChanged<AppLanguage> onSelected,
}) {
  final l10n = context.l10n;
  return showAppSheet<void>(
    context,
    title: l10n.settingsLanguage,
    contentPadding: .zero,
    child: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        for (final language in AppLanguage.values)
          _SelectRow(
            label: languageLabel(l10n, language),
            value: language,
            groupValue: current,
            onTap: () {
              onSelected(language);
              Navigator.of(context).pop();
            },
          ),
      ],
    ),
  );
}

Future<void> showProfileVisibilitySheet(
  BuildContext context, {
  required ProfileVisibility current,
  required ValueChanged<ProfileVisibility> onSelected,
}) {
  final l10n = context.l10n;
  return showAppSheet<void>(
    context,
    title: l10n.settingsWhoSeesProfile,
    subtitle: l10n.settingsVisibilitySheetSubtitle,
    contentPadding: .zero,
    child: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        for (final visibility in ProfileVisibility.values)
          _SelectRow(
            label: visibilityLabel(l10n, visibility),
            value: visibility,
            groupValue: current,
            onTap: () {
              onSelected(visibility);
              Navigator.of(context).pop();
            },
          ),
      ],
    ),
  );
}

Future<void> showSyncPolicySheet(
  BuildContext context, {
  required SyncPolicy current,
  required ValueChanged<SyncPolicy> onSelected,
}) {
  final l10n = context.l10n;
  return showAppSheet<void>(
    context,
    title: l10n.settingsSync,
    subtitle: l10n.settingsSyncSheetSubtitle,
    contentPadding: .zero,
    child: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        for (final policy in SyncPolicy.values)
          _SelectRow(
            label: syncPolicyLabel(l10n, policy),
            value: policy,
            groupValue: current,
            onTap: () {
              onSelected(policy);
              Navigator.of(context).pop();
            },
          ),
      ],
    ),
  );
}

Future<void> showHomeContentSheet(BuildContext context) {
  final l10n = context.l10n;
  final cubit = context.read<UiPreferencesCubit>();
  return showAppSheet<void>(
    context,
    title: l10n.settingsHomeContentTitle,
    subtitle: l10n.settingsHomeContentSubtitle,
    contentPadding: .zero,
    child: BlocProvider.value(
      value: cubit,
      child: BlocBuilder<UiPreferencesCubit, UiPreferencesState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              for (final section in HomeSection.values)
                SettingsToggleRow(
                  label: homeSectionLabel(l10n, section),
                  horizontalPadding: AppSpacing.xl,
                  value: state.isSectionEnabled(section),
                  onChanged: (value) =>
                      cubit.setSection(section, enabled: value),
                ),
            ],
          );
        },
      ),
    ),
  );
}

Future<void> showWidgetSheet(BuildContext context) {
  final l10n = context.l10n;
  final colors = context.ninja;
  final scheduleBloc = context.read<ScheduleBloc>();
  return showAppSheet<void>(
    context,
    title: l10n.settingsScreenWidgets,
    child: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.settingsWidgetSheetSubtitle,
          style: NinjaText.subtext.copyWith(height: 1.5, color: colors.muted),
        ),
        const SizedBox(height: 18),
        NinjaButton.primary(
          label: l10n.settingsWidgetRefresh,
          size: .large,
          expanded: true,
          onPressed: () {
            final selected = scheduleBloc.state.selectedSchedule;
            if (selected != null) {
              unawaited(
                const ScheduleWidgetUpdater(
                  HomeScreenWidgetService(),
                ).updateWidgetsFromSelectedSchedule(selected),
              );
            }
            Navigator.of(context).pop();
            showNinjaToast(context, message: l10n.settingsWidgetRefreshed);
          },
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
