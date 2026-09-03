import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeStatusStrip extends StatelessWidget {
  const HomeStatusStrip({
    required this.deadlines,
    required this.now,
    required this.onProfile,
    required this.onDeadlines,
    required this.onExam,
    this.profile,
    this.exam,
    this.readiness,
    super.key,
  });
  final List<Deadline> deadlines;
  final UserGamificationProfile? profile;
  final HomeLessonEntry? exam;
  final double? readiness;
  final DateTime now;
  final VoidCallback onProfile;
  final VoidCallback onDeadlines;
  final VoidCallback onExam;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final active = deadlines.where((deadline) => !deadline.isDone).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final nearest = active.firstOrNull;
    final urgent = nearest?.isUrgentAt(now) ?? false;
    final nextExam = exam;
    final days = nextExam == null
        ? null
        : DateUtils.dateOnly(
            nextExam.start,
          ).difference(DateUtils.dateOnly(now)).inDays;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Row(
        children: [
          if (profile != null && !profile!.isEmpty) ...[
            _StatusPill(
              label: l10n.homeStreakDays(profile!.streakDays),
              dot: colors.lecture,
              onTap: onProfile,
            ),
            const SizedBox(width: 6),
          ],
          _StatusPill(
            label: l10n.homeDeadlinesCount(active.length),
            detail: urgent ? homeDeadlineLeft(l10n, nearest!, now) : null,
            dot: urgent
                ? colors.danger
                : active.isEmpty
                ? colors.muted2
                : colors.warn,
            onTap: onDeadlines,
          ),
          if (days != null) ...[
            const SizedBox(width: 6),
            _StatusPill(
              label: days == 0 ? l10n.homeExamToday : l10n.homeExamIn(days),
              detail: readiness == null
                  ? null
                  : '${(readiness! * 100).round()}%',
              dot: colors.exam,
              onTap: onExam,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.dot,
    required this.onTap,
    this.detail,
  });
  final String label;
  final String? detail;
  final Color dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: onTap,
    semanticsLabel: [label, ?detail].join(', '),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDot(size: 8, color: dot),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppText.subtextBold.copyWith(color: context.colors.ink),
            ),
            if (detail != null) ...[
              const SizedBox(width: 6),
              Text(detail!, style: AppText.subtextStrong.copyWith(color: dot)),
            ],
          ],
        ),
      ),
    ),
  );
}
