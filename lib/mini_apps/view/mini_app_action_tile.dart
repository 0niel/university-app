part of 'mini_apps_page.dart';

class _MiniAppActionTile extends StatelessWidget {
  const _MiniAppActionTile({
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Opacity(
        opacity: onTap == null ? .5 : 1,
        child: AppListRow(
          title: title,
          destructive: titleColor != null,
          showChevron: true,
          onTap: onTap,
        ),
      ),
    );
  }
}
