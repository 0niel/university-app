part of 'mini_apps_catalog.dart';

class _CatalogSectionLabel extends StatelessWidget {
  const _CatalogSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        10,
        AppSpacing.screen,
        8,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Semantics(
          headingLevel: 2,
          child: Text(
            title,
            style: AppText.sans(16, FontWeight.w600, height: 1.2).copyWith(
              color: context.colors.ink,
              letterSpacing: -.25,
            ),
          ),
        ),
      ),
    );
  }
}
