import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/grades/models/subject_grades.dart';
import 'package:rtu_mirea_app/grades/utils/grades_format.dart';
import 'package:rtu_mirea_app/grades/widgets/grades_mark_tile.dart';
import 'package:rtu_mirea_app/grades/widgets/risk_badge.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesSubjectCard extends StatelessWidget {
  const GradesSubjectCard({
    required this.subject,
    super.key,
    this.isNew = false,
    this.onTap,
  });

  final SubjectGrades subject;
  final bool isNew;
  final VoidCallback? onTap;

  static Color averageColor(AppColors colors, double? average) {
    if (average == null) return colors.muted2;
    if (average >= 4.5) return colors.lecture;
    if (average >= SubjectGrades.riskThreshold) return colors.ink;
    return colors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final average = subject.average;
    return AppCard(
      radius: AppRadius.row,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      onTap: onTap,
      semanticsLabel: subject.subject,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            subject.subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.headlineStrong.copyWith(
                              color: colors.ink,
                            ),
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: AppSpacing.sm),
                          AppDot(size: 8, color: colors.accent),
                        ],
                        if (subject.isRisk) ...[
                          const SizedBox(width: AppSpacing.sm),
                          const RiskBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subject.teacher.isEmpty
                          ? l10n.gradesTeacherUnknown
                          : subject.teacher,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                average == null ? '—' : formatGrade(average),
                style: AppText.serif(24).copyWith(
                  color: averageColor(colors, average),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          if (subject.marks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.gap),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final mark in subject.marks)
                  GradesMarkTile(value: mark.value),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
