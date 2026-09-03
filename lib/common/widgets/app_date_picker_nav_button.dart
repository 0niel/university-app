part of 'app_date_picker.dart';

class AppDatePickerNavButton extends StatelessWidget {
  const AppDatePickerNavButton({
    required this.icon,
    required this.onTap,
    required this.semanticsLabel,
    super.key,
  });

  final AppLineIcon icon;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: AppLineIconWidget(icon),
      onPressed: onTap,
      tooltip: semanticsLabel,
      tone: AppIconButtonTone.surface,
      shape: AppIconButtonShape.circle,
      size: AppIconButtonSize.small,
      iconSize: 18,
      strokeWidth: 2.4,
    );
  }
}
