import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.sub,
    this.icon,
    this.lineIcon,
    this.horizontalPadding = 16,
  });

  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final AppLineIcon? lineIcon;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    return SettingsRow(
      title: label,
      subtitle: sub,
      icon: icon,
      lineIcon: lineIcon,
      showChevron: false,
      horizontalPadding: horizontalPadding,
      verticalPadding: 13,
      minimumHeight: 64,
      enabled: onChanged != null,
      trailing: SizedBox(
        width: 48,
        height: 28,
        child: AppSwitch(
          value: value,
          onChanged: onChanged,
          semanticsLabel: label,
        ),
      ),
      onTap: onChanged == null ? null : () => onChanged(!value),
    );
  }
}
