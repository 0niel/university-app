part of 'home_day_pager.dart';

class _HomeDayCell extends StatelessWidget {
  const _HomeDayCell({
    required this.day,
    required this.locale,
    required this.lessonCount,
    required this.selected,
    required this.accessible,
    required this.onTap,
  });

  final DateTime day;
  final String locale;
  final int lessonCount;
  final bool selected;
  final bool accessible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final motion = reduceMotion ? Duration.zero : NinjaMotion.fast;
    final weekday = DateFormat.E(locale).format(day).replaceAll('.', '');
    final fullDate = DateFormat.yMMMMEEEEd(locale).format(day);
    return AppPressable(
      semanticsLabel: '$fullDate, $lessonCount',
      semanticsButton: true,
      semanticsSelected: selected,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            weekday,
            maxLines: 1,
            overflow: .ellipsis,
            style: NinjaText.badge.copyWith(
              color: selected ? colors.brandInk : colors.muted,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedScale(
            scale: selected ? 1 : .92,
            duration: motion,
            curve: NinjaMotion.enter,
            child: AnimatedContainer(
              duration: motion,
              curve: NinjaMotion.enter,
              width: accessible ? 44 : 34,
              height: accessible ? 44 : 34,
              alignment: .center,
              decoration: BoxDecoration(
                color: selected ? colors.brand : Colors.transparent,
                shape: .circle,
              ),
              child: Text(
                '${day.day}',
                style: NinjaText.tabular(
                  NinjaText.headline.copyWith(
                    color: selected ? colors.onBrand : colors.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
