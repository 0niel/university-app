part of 'mini_apps_page.dart';

class _MiniAppsHero extends StatelessWidget {
  const _MiniAppsHero({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => AppSectionTitle(
    title: context.l10n.miniAppsCatalogSection,
    subtitle: context.l10n.miniAppsSubtitle(count),
    topMargin: 0,
    bottomPadding: 0,
  );
}
