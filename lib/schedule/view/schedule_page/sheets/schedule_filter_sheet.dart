import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_actions_sheet.dart';

Future<void> showScheduleFilterSheet(
  BuildContext context, {
  DateTime? day,
}) async {
  final action = await showAppSheet<ScheduleAction>(
    context,
    title: context.l10n.scheduleFilterTitle,
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<ScheduleDisplayCubit>()),
        BlocProvider.value(value: context.read<SchedulePreferencesCubit>()),
      ],
      child: const _ScheduleFilters(),
    ),
  );
  if (action != null && context.mounted) {
    await performScheduleAction(context, action, day: day ?? DateTime.now());
  }
}

class _ScheduleFilters extends StatelessWidget {
  const _ScheduleFilters();

  @override
  Widget build(BuildContext context) {
    final display = context.watch<ScheduleDisplayCubit>();
    final preferences = context.watch<SchedulePreferencesCubit>();
    final state = preferences.state;
    final l10n = context.l10n;
    void types({
      bool? lecture,
      bool? practice,
      bool? lab,
      bool? exam,
      bool? gaps,
    }) => preferences.applyFilters(
      showLectures: lecture ?? state.showLectures,
      showSeminars: practice ?? state.showSeminars,
      showLabs: lab ?? state.showLabs,
      showExams: exam ?? state.showExams,
      showGaps: gaps ?? state.showGaps,
      collapsePast: state.collapsePast,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppListGroup(
          children: [
            AppListRow(
              title: l10n.filtersPastLessons,
              subtitle: l10n.scheduleFilterPastSub,
              trailing: AppSwitch(
                value: display.state.showPast,
                semanticsLabel: l10n.filtersPastLessons,
                onChanged: (value) => display.setShowPast(value: value),
              ),
            ),
            AppListRow(
              title: l10n.scheduleFilterCancelled,
              subtitle: l10n.scheduleFilterCancelledSub,
              trailing: AppSwitch(
                value: display.state.showCancelled,
                semanticsLabel: l10n.scheduleFilterCancelled,
                onChanged: (value) => display.setShowCancelled(value: value),
              ),
            ),
            AppListRow(
              title: l10n.filtersShowGaps,
              subtitle: l10n.filtersShowGapsSub,
              trailing: AppSwitch(
                value: state.showGaps,
                semanticsLabel: l10n.filtersShowGaps,
                onChanged: (value) => types(gaps: value),
              ),
            ),
          ],
        ),
        AppOverline(l10n.filtersLessonTypes),
        Wrap(
          spacing: AppSpacing.xsm,
          runSpacing: AppSpacing.xsm,
          children: [
            AppChip(
              label: l10n.lecture,
              selected: state.showLectures,
              onTap: () => types(lecture: !state.showLectures),
            ),
            AppChip(
              label: l10n.practice,
              selected: state.showSeminars,
              onTap: () => types(practice: !state.showSeminars),
            ),
            AppChip(
              label: l10n.scheduleLegendLab,
              selected: state.showLabs,
              onTap: () => types(lab: !state.showLabs),
            ),
            AppChip(
              label: l10n.scheduleExamsLabel,
              selected: state.showExams,
              onTap: () => types(exam: !state.showExams),
            ),
          ],
        ),
        if (state.hiddenSubjects.isNotEmpty) ...[
          AppOverline(l10n.filtersHiddenSection),
          Wrap(
            spacing: AppSpacing.xsm,
            runSpacing: AppSpacing.xsm,
            children: [
              for (final subject in state.hiddenSubjects)
                AppChip(
                  label: subject,
                  removeSemanticLabel: l10n.filtersRestore,
                  onRemove: () => preferences.unhideSubject(subject),
                ),
            ],
          ),
        ],
        AppOverline(l10n.scheduleActionsTitle),
        ScheduleActionsMenu(
          onSelected: (action) => Navigator.of(context).pop(action),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: l10n.done,
          expanded: true,
          size: AppButtonSize.large,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
