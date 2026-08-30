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
    final colors = context.ninja;
    final lineIcon = this.lineIcon;
    final tint = danger ? colors.dangerTint : colors.surfaceAlt;
    final ink = danger ? colors.scarlet : colors.mutedDark;
    return Container(
      width: 34,
      height: 34,
      alignment: .center,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: .circular(11),
      ),
      child: lineIcon != null
          ? AppLineIconWidget(lineIcon, size: 18, color: ink)
          : Icon(icon, size: 18, color: ink),
    );
  }
}
