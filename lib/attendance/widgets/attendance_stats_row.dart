import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceStatsRow extends StatelessWidget {
  const AttendanceStatsRow({
    required this.totalPercent,
    required this.missed,
    required this.riskCount,
    super.key,
  });

  final int? totalPercent;
  final int missed;
  final int riskCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _StatCard(
              value: totalPercent == null ? '—' : '$totalPercent%',
              caption: l10n.attendanceStatSemester,
              color: totalPercent == null ? colors.muted2 : colors.lecture,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _StatCard(
              value: '$missed',
              caption: l10n.attendanceStatMissed,
              color: colors.ink,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _StatCard(
              value: '$riskCount',
              caption: l10n.attendanceStatRisk(riskCount),
              color: colors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.caption,
    required this.color,
  });

  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.metricLarge.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xxs),
          Text(caption, style: AppText.caption.copyWith(color: colors.muted)),
        ],
      ),
    );
  }
}
