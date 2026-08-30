part of 'mini_apps_page.dart';

class _SortIcon extends StatelessWidget {
  const _SortIcon({required this.sort});

  final MiniAppSort sort;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final icon = switch (sort) {
      MiniAppSort.popular => AppLineIcon.bolt,
      MiniAppSort.newest => AppLineIcon.clock,
      MiniAppSort.top => AppLineIcon.trophy,
    };
    return SizedBox.square(
      dimension: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: AppLineIconWidget(icon, size: 19, color: colors.mutedDark),
        ),
      ),
    );
  }
}
