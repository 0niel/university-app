part of '../schedule_details_page.dart';

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final AppLineIcon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppButton.tonal(
    label: label,
    icon: AppLineIconWidget(icon),
    size: AppButtonSize.small,
    expanded: true,
    onPressed: onTap,
  );
}
