import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart'
    show showScheduleExportSheet;

class SettingsScheduleSection extends StatelessWidget {
  const SettingsScheduleSection({required this.group, super.key});

  final String? group;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = context.watch<ScheduleDisplayCubit>();
    final ui = context.watch<UiPreferencesCubit>();
    return SettingsSection(
      label: l10n.schedule,
      children: [
        SettingsRow(
          title: l10n.settingsGroup,
          value: group ?? '—',
          onTap: () => _openScheduleManagement(context),
        ),
        SettingsToggleRow(
          label: l10n.settingsShowPast,
          sub: l10n.settingsShowPastSub,
          value: display.state.showPast,
          onChanged: (value) => display.setShowPast(value: value),
        ),
        SettingsToggleRow(
          label: l10n.settingsShowCancelled,
          sub: l10n.settingsShowCancelledSub,
          value: display.state.showCancelled,
          onChanged: (value) => display.setShowCancelled(value: value),
        ),
        SettingsToggleRow(
          label: l10n.settingsLessonReactions,
          sub: l10n.settingsLessonReactionsSub,
          value: ui.state.showLessonReactions,
          onChanged: (value) => ui.setShowLessonReactions(value: value),
        ),
        SettingsRow(
          title: l10n.settingsExportCalendar,
          value: l10n.settingsExportScheduleValue,
          valueColor: context.colors.accent,
          showChevron: false,
          onTap: () => showScheduleExportSheet(context),
        ),
      ],
    );
  }

  void _openScheduleManagement(BuildContext context) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go('/profile/schedule-management');
  }
}
