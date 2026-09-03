import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart'
    show showScheduleExportSheet;

class SettingsDataSection extends StatelessWidget {
  const SettingsDataSection({
    required this.cacheLabel,
    required this.onClearCache,
    super.key,
  });

  final String? cacheLabel;
  final VoidCallback? onClearCache;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final language = context.watch<LocaleCubit>().state;
    final syncPolicy = context.watch<SyncPreferencesCubit>().state;
    return SettingsSection(
      label: l10n.settingsDataAndLanguage,
      children: [
        SettingsRow(
          title: l10n.settingsLanguage,
          lineIcon: AppLineIcon.globe,
          value: languageLabel(l10n, language),
          onTap: () => showLanguageSheet(
            context,
            current: language,
            onSelected: (value) =>
                context.read<LocaleCubit>().setLanguage(value),
          ),
        ),
        SettingsRow(
          title: l10n.settingsSync,
          lineIcon: AppLineIcon.refresh,
          value: syncPolicyLabel(l10n, syncPolicy),
          onTap: () => showSyncPolicySheet(
            context,
            current: syncPolicy,
            onSelected: (value) =>
                context.read<SyncPreferencesCubit>().setPolicy(value),
          ),
        ),
        SettingsRow(
          title: l10n.settingsClearCache,
          lineIcon: AppLineIcon.database,
          value: cacheLabel ?? '…',
          onTap: onClearCache,
        ),
        SettingsRow(
          title: l10n.settingsExportSchedule,
          lineIcon: AppLineIcon.share,
          value: l10n.settingsExportScheduleValue,
          valueColor: colors.accent,
          onTap: () => showScheduleExportSheet(context),
        ),
      ],
    );
  }
}
