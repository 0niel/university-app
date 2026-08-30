import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_row.dart';
import 'package:rtu_mirea_app/community/widgets/ninja_section_title.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineGroup extends StatelessWidget {
  const DeadlineGroup({
    required this.title,
    required this.deadlines,
    required this.pendingDeadlineIds,
    required this.onToggle,
    super.key,
    this.dimmed = false,
  });

  final String title;
  final List<Deadline> deadlines;
  final Set<String> pendingDeadlineIds;
  final ValueChanged<String> onToggle;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: NinjaSectionTitle(
            title: title,
            count: deadlines.length,
            topPadding: 8,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            6,
            NinjaMetrics.screenPadding,
            0,
          ),
          sliver: SliverList.builder(
            itemCount: deadlines.length,
            itemBuilder: (context, index) {
              final deadline = deadlines[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DeadlineRow(
                  deadline: deadline,
                  pending: pendingDeadlineIds.contains(deadline.id),
                  dimmed: dimmed,
                  onToggle: () => onToggle(deadline.id),
                ),
              ).animateListItem(key: ValueKey(deadline.id), index: index);
            },
          ),
        ),
      ],
    );
  }
}
