import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/widgets/add_mark_sheet.dart';
import 'package:rtu_mirea_app/grades/widgets/grades_gpa_card.dart';
import 'package:rtu_mirea_app/grades/widgets/grades_subject_card.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GradesContent extends StatelessWidget {
  const GradesContent({required this.state, super.key});

  final GradesState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subjects = state.subjects;
    final now = state.now ?? DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.contentGap),
        GradesGpaCard(state: state),
        const SizedBox(height: AppSpacing.sectionGap),
        AppSegmentedControl<String>(
          onCanvas: true,
          value: state.termId,
          onChanged: context.read<GradesCubit>().termChanged,
          options: [
            for (final (index, term) in state.terms.indexed)
              AppSegmentedOption(
                value: term.id,
                label: index == 0
                    ? l10n.gradesTermCurrent
                    : l10n.gradesTermSemester(term.semester),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        if (subjects.isEmpty)
          state.isCurrentTerm
              ? AppEmptyState(
                  lineIcon: AppLineIcon.chart,
                  title: l10n.gradesNoSubjectsTitle,
                  subtitle: l10n.gradesNoSubjectsSubtitle,
                )
              : AppEmptyState.compact(title: l10n.gradesTermEmpty)
        else
          for (final (index, subject) in subjects.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            GradesSubjectCard(
              subject: subject,
              isNew: subject.isNew(now),
              onTap: () => showAddMarkSheet(
                context,
                cubit: context.read<GradesCubit>(),
                subject: subject,
              ),
            ),
          ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.personalRecordsNotice,
          style: AppText.subtext.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: AppSpacing.xsm),
        Text(
          l10n.gradesScholarshipDisclaimer,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }
}
