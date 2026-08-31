import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/widgets/schedule_sheet_widgets.dart';

Future<void> showScheduleFilterSheet(BuildContext context) {
  final l10n = context.l10n;
  final preferences = context.read<SchedulePreferencesCubit>();
  final initial = preferences.state;

  var lectures = initial.showLectures;
  var seminars = initial.showSeminars;
  var labs = initial.showLabs;
  var exams = initial.showExams;
  var gaps = initial.showGaps;
  var collapsePast = initial.collapsePast;
  final hidden = [...initial.hiddenSubjects];

  return showAppSheet<void>(
    context,
    title: l10n.filtersTitle,
    subtitle: l10n.filtersSubtitle,
    backgroundColor: context.ninja.canvas,
    child: StatefulBuilder(
      builder: (context, setState) {
        final colors = context.ninja;
        return Padding(
          padding: const .fromLTRB(0, 4, 0, 24),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              ScheduleSheetSectionLabel(
                l10n.filtersLessonTypes,
                first: true,
              ),
              ScheduleSheetToggleRow(
                title: l10n.filterLectures,
                value: lectures,
                first: true,
                onChanged: (value) => setState(() => lectures = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.filterSeminars,
                value: seminars,
                onChanged: (value) => setState(() => seminars = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.filterLabsFull,
                value: labs,
                onChanged: (value) => setState(() => labs = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.filterExamsFull,
                value: exams,
                onChanged: (value) => setState(() => exams = value),
              ),
              ScheduleSheetSectionLabel(l10n.filtersDisplaySection),
              ScheduleSheetToggleRow(
                title: l10n.filtersShowGaps,
                subtitle: l10n.filtersShowGapsSub,
                value: gaps,
                first: true,
                onChanged: (value) => setState(() => gaps = value),
              ),
              ScheduleSheetToggleRow(
                title: l10n.filtersPastLessons,
                subtitle: l10n.filtersPastLessonsSub,
                value: collapsePast,
                onChanged: (value) => setState(() => collapsePast = value),
              ),
              if (hidden.isNotEmpty) ...[
                ScheduleSheetSectionLabel(l10n.filtersHiddenSection),
                Text(
                  l10n.filtersHiddenHint,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final subject in hidden)
                      NinjaChip(
                        label: subject,
                        selected: true,
                        onRemove: () {
                          preferences.unhideSubject(subject);
                          setState(() => hidden.remove(subject));
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 22),
              Row(
                children: [
                  NinjaButton.outline(
                    label: l10n.reset,
                    onPressed: () {
                      preferences.resetFilters();
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NinjaButton.primary(
                      label: l10n.apply,
                      expanded: true,
                      onPressed: () {
                        preferences.applyFilters(
                          showLectures: lectures,
                          showSeminars: seminars,
                          showLabs: labs,
                          showExams: exams,
                          showGaps: gaps,
                          collapsePast: collapsePast,
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
