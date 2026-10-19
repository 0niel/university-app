part of 'mini_apps_catalog.dart';

class _CatalogSectionLabelSkeleton extends StatelessWidget {
  const _CatalogSectionLabelSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        10,
        AppSpacing.screen,
        8,
      ),
      child: NinjaSkeleton(
        width: width,
        height: MediaQuery.textScalerOf(context).scale(16) * 1.2,
        radius: AppRadius.skeleton,
      ),
    );
  }
}
