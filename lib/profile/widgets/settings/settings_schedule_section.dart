import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';

class SettingsScheduleSection extends StatelessWidget {
  const SettingsScheduleSection({required this.group, super.key});

  final String? group;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SettingsSection(
      label: l10n.schedule,
      children: [
        SettingsRow(
          title: l10n.settingsMyGroup,
          lineIcon: AppLineIcon.book,
          value: group ?? '—',
          onTap: () => _openScheduleManagement(context),
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
