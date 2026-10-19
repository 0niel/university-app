import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';

class SchedulePinnedDaySliver extends StatelessWidget {
  const SchedulePinnedDaySliver({
    required this.strip,
    required this.topInset,
    super.key,
  });

  final ScheduleDayStrip strip;
  final double topInset;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final leading =
          constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
      final safeTop = (topInset - leading).clamp(0.0, topInset);
      return PinnedHeaderSliver(
        child: ScheduleDayStripHeader(
          strip: strip,
          topInset: safeTop,
          elevated: constraints.scrollOffset > 0 || leading <= topInset,
        ),
      );
    },
  );
}
