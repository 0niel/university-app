part of 'mini_apps_page.dart';

class _MiniAppsAppBar extends StatelessWidget {
  const _MiniAppsAppBar({
    required this.isModerator,
    required this.isSearching,
    required this.onSearchToggled,
  });

  final bool isModerator;
  final bool isSearching;
  final VoidCallback onSearchToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppInnerHeader(
      title: l10n.miniAppsTitle,
      onBack: Navigator.of(context).canPop()
          ? () => Navigator.of(context).maybePop()
          : null,
      backSemanticsLabel: l10n.back,
      actions: [
        if (isModerator)
          AppHeaderAction(
            icon: AppLineIcon.shield,
            semanticsLabel: l10n.miniAppsModeration,
            onTap: () => context.go('/services/apps/moderation'),
          ),
        AppHeaderAction(
          child: Semantics(
            selected: isSearching,
            child: AppLineIconWidget(
              isSearching ? AppLineIcon.close : AppLineIcon.search,
              size: AppIconSize.md,
            ),
          ),
          semanticsLabel: l10n.miniAppsSearch,
          onTap: onSearchToggled,
        ),
      ],
    );
  }
}
