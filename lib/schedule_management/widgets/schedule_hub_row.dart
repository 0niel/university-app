import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule_management/utils/utils.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/schedule_entity_avatar.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleHubRow extends StatelessWidget {
  const ScheduleHubRow({
    required this.target,
    required this.name,
    required this.schedule,
    super.key,
    this.updatedAt,
    this.onTap,
  });

  final ScheduleTarget target;
  final String name;
  final List<SchedulePart> schedule;
  final DateTime? updatedAt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final status = ScheduleLiveStatus.of(schedule);
    final meta = [
      l10n.scheduleHubLessonsToday(status.todayCount),
      if (updatedAt case final lastUpdatedAt?)
        scheduleUpdatedAgo(l10n, lastUpdatedAt),
    ].join(' · ');

    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$name, $meta',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          10,
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              ScheduleEntityAvatar(target: target, name: name),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    if (status.isLive) ...[
                      const SizedBox(height: 5),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: NinjaBadge(l10n.scheduleHubLiveLesson),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppLineIconWidget(
                AppLineIcon.chevronR,
                size: 16,
                color: colors.chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
