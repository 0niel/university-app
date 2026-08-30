import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_section.dart';

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
    final colors = context.ninja;
    final l10n = context.l10n;
    return SettingsSection(
      label: l10n.notifications,
      children: [
        SettingsRow(
          title: l10n.notifications,
          lineIcon: AppLineIcon.bell,
          value: enabled
              ? l10n.settingsNotificationsOn
              : l10n.settingsNotificationsOff,
          valueColor: enabled ? colors.green : colors.muted,
          onTap: onTap,
        ),
      ],
    );
  }
}
