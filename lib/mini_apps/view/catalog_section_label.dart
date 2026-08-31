part of 'mini_apps_page.dart';

class _CatalogSectionLabel extends StatelessWidget {
  const _CatalogSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Text(
        title,
        style: NinjaText.title.copyWith(color: context.ninja.ink),
      ),
    );
  }
}
