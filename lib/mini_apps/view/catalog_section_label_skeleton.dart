part of 'mini_apps_page.dart';

class _CatalogSectionLabelSkeleton extends StatelessWidget {
  const _CatalogSectionLabelSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: NinjaSkeleton(width: width, height: 19, radius: 9),
    );
  }
}
