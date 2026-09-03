import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_exam.dart';

class CountdownHero extends StatelessWidget {
  const CountdownHero({
    required this.exam,
    required this.readiness,
    super.key,
    this.onReadiness,
  });

  final SessionExam exam;
  final double readiness;
  final VoidCallback? onReadiness;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppCard(
      radius: AppRadius.hero,
      color: colors.examTint,
      padding: const EdgeInsets.all(AppSpacing.fieldGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xsm,
                  ),
                  child: Text(
                    l10n.examsNearestIn(exam.days),
                    style: AppText.sans(
                      12,
                      FontWeight.w700,
                    ).copyWith(color: colors.danger),
                  ),
                ),
              ),
              Text(
                DateFormat(
                  'd MMM · HH:mm',
                  Localizations.localeOf(context).toString(),
                ).format(exam.date),
                style: AppText.label.copyWith(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${exam.typeName} · ${exam.subject}',
            style: AppText.section.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = MediaQuery.textScalerOf(context).scale(1) < 1.5;
              final readinessControl = AppPressable(
                onTap: onReadiness,
                semanticsButton: onReadiness != null,
                semanticsLabel: l10n.examsReadiness,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.examsReadiness,
                            style: AppText.captionBold.copyWith(
                              color: colors.ink,
                            ),
                          ),
                        ),
                        Text(
                          '${(readiness * 100).round()}%',
                          style: AppText.captionBold.copyWith(
                            color: colors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xsm),
                    AppProgressBar(
                      value: readiness,
                      color: colors.danger,
                      trackColor: colors.surface,
                    ),
                  ],
                ),
              );
              final metadata = Text(
                [
                  if (exam.room.isNotEmpty) exam.room,
                  if (exam.teacher.isNotEmpty) exam.teacher,
                ].join(' · '),
                style: AppText.captionStrong.copyWith(color: colors.muted),
              );
              return compact
                  ? Row(
                      children: [
                        Expanded(child: readinessControl),
                        if (exam.room.isNotEmpty ||
                            exam.teacher.isNotEmpty) ...[
                          const SizedBox(width: AppSpacing.sectionGap),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * .42,
                            ),
                            child: metadata,
                          ),
                        ],
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        readinessControl,
                        if (exam.room.isNotEmpty ||
                            exam.teacher.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          metadata,
                        ],
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}
