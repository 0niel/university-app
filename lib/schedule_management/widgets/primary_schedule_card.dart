import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/utils/utils.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/schedule_entity_avatar.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'badge.dart';
part 'mine_tag.dart';
part 'now_pill.dart';
part 'updated_chip.dart';

class PrimaryScheduleCard extends StatelessWidget {
  const PrimaryScheduleCard({
    required this.schedule,
    super.key,
    this.onTap,
    this.updatedAt,
  });

  final SelectedSchedule schedule;
  final DateTime? updatedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final target = _targetOf(schedule);
    final status = ScheduleLiveStatus.of(schedule.schedule);

    return AppPressable(
      onTap: onTap,
      semanticsLabel: schedule.name,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.tint2,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Badge(target: target, name: schedule.name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        schedule.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.heading.copyWith(
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: .centerStart,
                        child: _MineTag(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.scheduleHubLessonsToday(status.todayCount),
                        style: AppText.subtext.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (updatedAt case final lastUpdatedAt?) ...[
              const SizedBox(height: 10),
              _UpdatedChip(label: scheduleUpdatedShort(l10n, lastUpdatedAt)),
            ],
            const SizedBox(height: 14),
            _NowPill(status: status),
          ],
        ),
      ),
    );
  }

  static ScheduleTarget? _targetOf(SelectedSchedule schedule) =>
      switch (schedule) {
        SelectedGroupSchedule() => .group,
        SelectedTeacherSchedule() => .teacher,
        SelectedClassroomSchedule() => .classroom,
        SelectedCustomSchedule() => null,
      };
}
