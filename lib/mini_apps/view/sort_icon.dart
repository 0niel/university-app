part of 'mini_apps_page.dart';

class _SortIcon extends StatelessWidget {
  const _SortIcon({required this.sort});

  final MiniAppSort sort;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = switch (sort) {
      MiniAppSort.popular => AppLineIcon.bolt,
      MiniAppSort.newest => AppLineIcon.clock,
      MiniAppSort.top => AppLineIcon.trophy,
    };
    return SizedBox.square(
      dimension: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.compact),
        ),
        child: Center(
          child: AppLineIconWidget(icon, size: 19, color: colors.muted),
        ),
      ),
    );
  }
}
