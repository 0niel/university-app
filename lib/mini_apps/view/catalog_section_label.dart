part of 'mini_apps_page.dart';

class _CatalogSectionLabel extends StatelessWidget {
  const _CatalogSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        AppSpacing.lg,
        AppSpacing.screen,
        10,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          header: true,
          child: Text(
            title,
            style: AppText.title.copyWith(color: context.colors.ink),
          ),
        ),
      ),
    );
  }
}
