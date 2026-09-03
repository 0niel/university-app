import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_state.dart';
import 'package:rtu_mirea_app/grades/utils/grades_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesGpaCard extends StatelessWidget {
  const GradesGpaCard({required this.state, super.key});

  final GradesState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final gpa = state.gpa;
    final delta = state.gpaDelta;
    final gap = state.scholarshipGap;
    final weakest = state.weakestSubject;
    final hint = gap == null
        ? null
        : gap <= 0
        ? l10n.gradesScholarshipReached
        : weakest == null
        ? null
        : l10n.gradesScholarshipHint(weakest.subject);
    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gradesGpaLabel,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          gpa == null ? '—' : formatGap(gpa),
          style: AppText.displayHero.copyWith(
            color: gpa == null ? colors.muted2 : colors.ink,
            height: 1,
          ),
        ),
        if (delta != null) ...[
          const SizedBox(height: AppSpacing.xsm),
          Text(
            l10n.gradesGpaDelta(formatGradeDelta(delta)),
            style: AppText.subtextBold.copyWith(
              color: delta < 0 ? colors.danger : colors.lecture,
            ),
          ),
        ],
      ],
    );
    final scholarship = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l10n.gradesScholarshipLabel,
          textAlign: TextAlign.end,
          style: AppText.captionStrong.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          gap == null ? '—' : formatGap(gap),
          style: AppText.sans(16, FontWeight.w800).copyWith(color: colors.ink),
        ),
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            hint,
            textAlign: TextAlign.end,
            style: AppText.caption.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
    return AppCard(
      tinted: true,
      radius: AppRadius.hero,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.fieldGap,
      ),
      child: MediaQuery.textScalerOf(context).scale(1) >= 1.5
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                summary,
                const SizedBox(height: AppSpacing.lg),
                scholarship,
              ],
            )
          : Row(
              children: [
                Expanded(flex: 2, child: summary),
                const SizedBox(width: AppSpacing.lg),
                Expanded(flex: 3, child: scholarship),
              ],
            ),
    );
  }
}
