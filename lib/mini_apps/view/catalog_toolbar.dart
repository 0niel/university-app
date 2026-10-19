part of 'mini_apps_catalog.dart';

class _CatalogToolbar extends StatelessWidget {
  const _CatalogToolbar({
    required this.state,
    required this.onSortChanged,
    required this.onCreate,
    this.onModerate,
  });

  final MiniAppsCatalogState state;
  final ValueChanged<MiniAppSort> onSortChanged;
  final VoidCallback onCreate;
  final VoidCallback? onModerate;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      AppSpacing.md,
      AppSpacing.screen,
      AppSpacing.sm,
    ),
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _MiniAppsSortButton(selected: state.sort, onChanged: onSortChanged),
        AppButton.glass(
          key: const ValueKey('mini-apps-create-button'),
          label: context.l10n.miniAppsCreate,
          icon: const AppLineIconWidget(AppLineIcon.plus),
          onPressed: onCreate,
        ),
        if (state.isModerator && onModerate != null)
          AppIconButton(
            tone: AppIconButtonTone.glass,
            shape: AppIconButtonShape.circle,
            tooltip: context.l10n.miniAppsModeration,
            icon: const AppLineIconWidget(AppLineIcon.shield),
            onPressed: onModerate,
          ),
      ],
    ),
  );
}
