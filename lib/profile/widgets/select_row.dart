part of 'settings_sheets.dart';

class _SelectRow<T> extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  final String label;
  final T value;
  final T groupValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      title: label,
      showChevron: false,
      horizontalPadding: AppSpacing.xl,
      onTap: onTap,
      trailing: NinjaRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onTap(),
      ),
    );
  }
}
