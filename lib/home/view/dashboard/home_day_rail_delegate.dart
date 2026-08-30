import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/home/view/home_day_pager.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeDayRailDelegate extends SliverPersistentHeaderDelegate {
  const HomeDayRailDelegate({
    required double height,
    required this.days,
    required this.lessonCounts,
    required this.selectedIndex,
    required this.onSelected,
  }) : minExtent = height,
       maxExtent = height;

  final List<DateTime> days;
  final List<int> lessonCounts;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  final double minExtent;

  @override
  final double maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = context.ninja;
    return SizedBox.expand(
      child: ColoredBox(
        color: colors.canvas.withValues(alpha: .97),
        child: Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: AppTourAnchor(
            target: .homeDays,
            child: HomeDayPager(
              days: days,
              lessonCounts: lessonCounts,
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeDayRailDelegate oldDelegate) =>
      minExtent != oldDelegate.minExtent ||
      selectedIndex != oldDelegate.selectedIndex ||
      !listEquals(days, oldDelegate.days) ||
      !listEquals(lessonCounts, oldDelegate.lessonCounts);
}
