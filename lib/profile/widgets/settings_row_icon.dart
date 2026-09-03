part of 'settings_row.dart';

class _SettingsRowIcon extends StatelessWidget {
  const _SettingsRowIcon({
    required this.lineIcon,
    required this.icon,
    required this.danger,
  });

  final AppLineIcon? lineIcon;
  final IconData? icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lineIcon = this.lineIcon;
    final tint = danger ? colors.dangerTint : colors.surface2;
    final ink = danger ? colors.danger : colors.muted;
    return Container(
      width: 34,
      height: 34,
      alignment: .center,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: .circular(AppRadius.badge),
      ),
      child: lineIcon != null
          ? AppLineIconWidget(lineIcon, size: 18, color: ink)
          : Icon(icon, size: 18, color: ink),
    );
  }
}
