part of 'mini_apps_page.dart';

class _CatalogSectionLabel extends StatelessWidget {
  const _CatalogSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        28,
        AppSpacing.screen,
        10,
      ),
      child: Text(
        title,
        style: AppText.title.copyWith(color: context.colors.ink),
      ),
    );
  }
}
