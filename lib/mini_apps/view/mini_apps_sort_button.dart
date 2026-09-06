part of 'mini_apps_page.dart';

class _MiniAppsSortButton extends StatelessWidget {
  const _MiniAppsSortButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppButton.text(
    key: const ValueKey('mini-apps-sort-button'),
    label: label,
    icon: const AppLineIconWidget(.filter, size: AppIconSize.md),
    tooltip: '${context.l10n.miniAppsSortTitle}: $label',
    onPressed: onPressed,
  );
}
