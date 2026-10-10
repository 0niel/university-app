import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/rows/settings_rows.dart';

class TeacherDashboardServicesSection extends StatelessWidget {
  const TeacherDashboardServicesSection({
    required this.navigationBusy,
    required this.onOpenChanges,
    required this.onExport,
    super.key,
  });

  final bool navigationBusy;
  final VoidCallback onOpenChanges;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOverline(l10n.schedule),
        AppListGroup(
          children: [
            ProfileLinkRow(
              icon: AppLineIcon.bell,
              title: l10n.scheduleChanges,
              onTap: navigationBusy ? null : onOpenChanges,
            ),
            ProfileLinkRow(
              icon: AppLineIcon.calendar,
              title: l10n.settingsExportCalendar,
              onTap: navigationBusy ? null : onExport,
            ),
          ],
        ),
      ],
    );
  }
}
