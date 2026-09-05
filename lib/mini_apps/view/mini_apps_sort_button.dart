part of 'mini_apps_page.dart';

class _MiniAppsSortButton extends StatelessWidget {
  const _MiniAppsSortButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => NinjaIconButton(
    key: const ValueKey('mini-apps-sort-button'),
    icon: const AppLineIconWidget(.filter, size: AppIconSize.md),
    tooltip: '${context.l10n.miniAppsSortTitle}: $label',
    shape: AppIconButtonShape.circle,
    onPressed: onPressed,
  );
}
