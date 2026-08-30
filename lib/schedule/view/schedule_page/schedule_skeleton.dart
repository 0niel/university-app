import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_lesson_cards_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_view_selector_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_strip_skeleton.dart';

part 'schedule_chrome_skeleton.dart';
part 'schedule_filter_row_skeleton.dart';

class ScheduleSkeleton extends StatelessWidget {
  const ScheduleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ColoredBox(
        color: colors.canvas,
        child: const Column(
          crossAxisAlignment: .stretch,
          children: [
            _ScheduleChromeSkeleton(),
            ScheduleViewSelectorSkeleton(),
            Padding(
              padding: .fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                8,
              ),
              child: Align(
                alignment: .centerLeft,
                child: NinjaSkeleton(width: 132, height: 10, radius: 5),
              ),
            ),
            ScheduleWeekStripSkeleton(),
            Expanded(
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: ScheduleHeaderSkeleton()),
                  SliverToBoxAdapter(child: _ScheduleFilterRowSkeleton()),
                  SliverToBoxAdapter(child: ScheduleLessonCardsSkeleton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
