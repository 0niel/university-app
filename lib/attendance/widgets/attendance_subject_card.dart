import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/attendance/models/attendance_subject.dart';
import 'package:rtu_mirea_app/attendance/utils/attendance_format.dart';
import 'package:rtu_mirea_app/attendance/widgets/attendance_miss_row.dart';
import 'package:rtu_mirea_app/grades/widgets/risk_badge.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceSubjectCard extends StatelessWidget {
  const AttendanceSubjectCard({
    required this.subject,
    required this.expanded,
    required this.onToggle,
    required this.onCertificate,
    required this.onRemove,
    super.key,
  });

  final AttendanceSubject subject;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onCertificate;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final color = attendanceColor(colors, subject.percent);
    return AppCard(
      radius: AppRadius.row,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.row),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPressable(
              onTap: onToggle,
              pressedScale: 1,
              semanticsLabel: l10n.attendanceExpandSemantics(subject.subject),
              semanticsButton: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sectionGap,
                ),
                child: Row(
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
                              if (subject.isRisk) ...[
                                const SizedBox(width: AppSpacing.sm),
                                const RiskBadge(),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: NinjaProgressBar(
                                  value: subject.percent / 100,
                                  height: 5,
                                  color: color,
                                  trackColor: colors.surface2,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.gap),
                              Text(
                                '${subject.attended}/${subject.total}',
                                style: AppText.captionStrong.copyWith(
                                  color: colors.muted,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 42),
                      child: Text(
                        subject.total == 0 ? '—' : '${subject.percent}%',
                        textAlign: TextAlign.end,
                        style: AppText.sans(15, FontWeight.w800).copyWith(
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : NinjaMotion.base,
                      child: AppLineIconWidget(
                        AppLineIcon.chevronD,
                        size: 16,
                        color: colors.muted2,
                        strokeWidth: 2.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) ...[
              const AppDivider(),
              for (final miss in subject.misses)
                AttendanceMissRow(
                  absence: miss,
                  onCertificate: () => onCertificate(miss.id),
                  onRemove: () => onRemove(miss.id),
                ),
              if (subject.isRisk)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Text(
                    l10n.attendanceRiskNote,
                    style: AppText.subtext.copyWith(
                      color: colors.muted,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
