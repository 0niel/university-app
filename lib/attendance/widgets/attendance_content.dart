import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/widgets/add_absence_sheet.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_risk_banner.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_stats_row.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_subject_card.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_weeks_card.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceContent extends StatelessWidget {
  const AttendanceContent({required this.state, super.key});

  final AttendanceState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<AttendanceCubit>();
    final subjects = state.subjects;
    final risk = state.riskSubject;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.contentGap),
        AttendanceStatsRow(
          totalPercent: state.totalPercent,
          missed: state.missedCount,
          riskCount: state.riskCount,
        ),
        const SizedBox(height: AppSpacing.sm),
        AttendanceWeeksCard(
          weeks: state.weeks,
          semesterStart: state.semesterStart,
        ),
        if (risk != null) ...[
          const SizedBox(height: AppSpacing.sm),
          AttendanceRiskBanner(subject: risk),
        ],
        AppOverline(
          l10n.attendanceBySubjects,
          topPadding: 24,
          bottomPadding: 12,
        ),
        if (subjects.isEmpty)
          AppEmptyState(
            lineIcon: AppLineIcon.check,
            title: l10n.attendanceNoLessonsTitle,
            subtitle: l10n.attendanceNoLessonsSubtitle,
            actionLabel: l10n.attendanceAddAbsence,
            onAction: () => showAddAbsenceSheet(context, cubit: cubit),
          )
        else
          for (final (index, subject) in subjects.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            AttendanceSubjectCard(
              subject: subject,
              expanded: state.expandedSubject == subject.subject,
              onToggle: () => cubit.toggleSubject(subject.subject),
              onCertificate: (id) async {
                final saved = await cubit.attachCertificate(id);
                if (!saved && context.mounted) {
                  ToastManager.showError(context, message: l10n.error);
                }
              },
              onRemove: (id) async {
                final saved = await cubit.removeAbsence(id);
                if (!saved && context.mounted) {
                  ToastManager.showError(context, message: l10n.error);
                }
              },
            ),
          ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.personalRecordsNotice,
          style: AppText.subtext.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.xsm),
        Text(
          l10n.attendanceEstimateNotice,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }
}
