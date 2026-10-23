part of 'mini_apps_catalog.dart';

class _MiniAppsAppBar extends StatelessWidget {
  const _MiniAppsAppBar({
    required this.count,
    required this.isSearching,
    required this.onSearchToggled,
    this.onBack,
    this.subtitle,
  });

  final int count;
  final bool isSearching;
  final VoidCallback onSearchToggled;
  final VoidCallback? onBack;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppInnerHeader(
      title: l10n.miniAppsTitle,
      padding: _CatalogLayout.compactHeight(context)
          ? EdgeInsets.fromLTRB(
              AppSpacing.screen,
              MediaQuery.paddingOf(context).top + AppSpacing.md,
              AppSpacing.screen,
              0,
            )
          : null,
      titleStyle: AppText.sans(32, FontWeight.w600, height: 1.08).copyWith(
        letterSpacing: -.8,
      ),
      subtitle: subtitle ?? l10n.miniAppsSubtitle(count),
      onBack: onBack,
      backSemanticsLabel: l10n.back,
      actions: [
        AppHeaderAction(
          child: AnimatedSwitcher(
            duration: NinjaMotion.of(context, NinjaMotion.fast),
            switchInCurve: NinjaMotion.enter,
            switchOutCurve: NinjaMotion.exit,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation.drive(Tween(begin: .8, end: 1)),
                child: child,
              ),
            ),
            child: AppLineIconWidget(
              isSearching ? AppLineIcon.close : AppLineIcon.search,
              key: ValueKey(isSearching),
              size: AppIconSize.md,
            ),
          ),
          semanticsLabel: isSearching
              ? MaterialLocalizations.of(context).closeButtonTooltip
              : l10n.miniAppsSearch,
          onTap: onSearchToggled,
        ),
      ],
    );
  }
}
