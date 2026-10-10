import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherScheduleStatus extends StatelessWidget {
  const TeacherScheduleStatus({
    required this.resource,
    required this.changes,
    required this.onRetry,
    super.key,
  });

  final TeacherResource<TeacherScheduleSnapshot> resource;
  final TeacherResource<List<ScheduleChange>> changes;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final snapshot = resource.data;
    final savedDate = snapshot?.fetchedAt;
    final savedTime = savedDate == null
        ? null
        : '${DateFormat.MMMd(l10n.localeName).format(savedDate)} '
              '${DateFormat.Hm(l10n.localeName).format(savedDate)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (resource.isLoading) ...[
          LinearProgressIndicator(
            color: colors.accent,
            backgroundColor: colors.line,
            minHeight: 2,
            semanticsLabel: l10n.loadingContent,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (resource.hasError) ...[
          AppBanner(
            key: const ValueKey('teacher-schedule-refresh-error'),
            message: l10n.teacherScheduleRefreshError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (savedTime != null) ...[
          Text(
            [
              if (resource.hasError ||
                  snapshot?.source == TeacherScheduleSource.cache)
                l10n.teacherScheduleSaved,
              l10n.updatedAtTime(savedTime),
            ].join(' · '),
            key: const ValueKey('teacher-schedule-freshness'),
            style: AppText.caption.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (changes.hasError) ...[
          AppBanner(
            message: l10n.teacherChangesLoadError,
            tone: AppBannerTone.warn,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
