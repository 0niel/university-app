import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_repeat.dart';
import 'package:rtu_mirea_app/schedule/view/custom_lesson_editor_page.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'widgets/edit_lesson_row.dart';

class EditSchedulePage extends StatefulWidget {
  const EditSchedulePage({required this.scheduleId, super.key});

  final String scheduleId;

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  int _weekday = clampWeekday(DateTime.now().weekday);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final cubit = context.watch<CustomScheduleCubit>();
    final schedule = cubit.scheduleById(widget.scheduleId);
    final lessons = cubit.lessonsForWeekday(widget.scheduleId, _weekday);

    final dayLabels = [
      l10n.weekdayShortMon,
      l10n.weekdayShortTue,
      l10n.weekdayShortWed,
      l10n.weekdayShortThu,
      l10n.weekdayShortFri,
      l10n.weekdayShortSat,
    ];

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            AppInnerHeader(
              title: l10n.editScheduleTitle,
              onBack: () => Navigator.of(context).maybePop(),
              backSemanticsLabel: l10n.back,
            ),
            SizedBox(
              height: ScheduleMetrics.weekdayStripHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.sm,
                  AppSpacing.screen,
                  AppSpacing.sm,
                ),
                itemCount: dayLabels.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final label = dayLabels[index];
                  final selected = _weekday == index + 1;
                  return AppPressable(
                    onTap: () => setState(() => _weekday = index + 1),
                    semanticsLabel: label,
                    semanticsSelected: selected,
                    child: Container(
                      width: AppControlSize.buttonMedium,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? colors.accent : colors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        label,
                        style: AppText.subtext.copyWith(
                          color: selected ? colors.onAccent : colors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: schedule == null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const .symmetric(
                          horizontal: AppSpacing.screen,
                        ),
                        child: AppEmptyState(
                          title: l10n.editScheduleNotFound,
                          icon: AppLineIconWidget(
                            AppLineIcon.calendar,
                            size: 20,
                            color: colors.muted,
                          ),
                          actionLabel: l10n.back,
                          onAction: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ).animateEmptyState()
                  : Column(
                      children: [
                        Padding(
                          padding: const .fromLTRB(
                            AppSpacing.screen,
                            AppSpacing.sm,
                            AppSpacing.screen,
                            AppSpacing.md,
                          ),
                          child: Row(
                            spacing: AppSpacing.xsm,
                            children: [
                              AppLineIconWidget(
                                .swipe,
                                size: 14,
                                color: colors.muted,
                              ),
                              Expanded(
                                child: Text(
                                  l10n.editScheduleSwipeHint,
                                  style: AppText.captionSmall.copyWith(
                                    color: colors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: lessons.isEmpty
                              ? SingleChildScrollView(
                                  child: Padding(
                                    padding: const .symmetric(
                                      horizontal: AppSpacing.screen,
                                    ),
                                    child: AppEmptyState(
                                      title: l10n.editScheduleEmptyDay,
                                      icon: AppLineIconWidget(
                                        AppLineIcon.plus,
                                        size: 20,
                                        color: colors.muted,
                                      ),
                                      actionLabel: l10n.addClass,
                                      onAction: _addLesson,
                                    ),
                                  ),
                                ).animateEmptyState()
                              : ReorderableListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                    AppSpacing.screen,
                                    AppSpacing.zero,
                                    AppSpacing.screen,
                                    ninjaBottomInset(context) + AppSpacing.sm,
                                  ),
                                  buildDefaultDragHandles: false,
                                  itemCount: lessons.length,
                                  onReorderItem: (oldIndex, newIndex) => context
                                      .read<CustomScheduleCubit>()
                                      .reorderLessons(
                                        widget.scheduleId,
                                        _weekday,
                                        oldIndex,
                                        newIndex,
                                      ),
                                  itemBuilder: (context, index) {
                                    final lesson = lessons[index];
                                    return Padding(
                                      key: ValueKey(
                                        'edit-${lesson.subject}-'
                                        '${lesson.lessonBells.startTime}',
                                      ),
                                      padding: const .only(
                                        bottom: AppSpacing.gap,
                                      ),
                                      child: _EditLessonRow(
                                        lesson: lesson,
                                        index: index,
                                        onEdit: () => _editLesson(lesson),
                                        onDelete: () => context
                                            .read<CustomScheduleCubit>()
                                            .removeLesson(
                                              widget.scheduleId,
                                              lesson,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.screen,
                            AppSpacing.sm,
                            AppSpacing.screen,
                            ninjaBottomInset(context) + AppSpacing.xlg,
                          ),
                          child: AppButton.primary(
                            label: l10n.addClass,
                            expanded: true,
                            size: AppButtonSize.large,
                            onPressed: _addLesson,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _editLesson(LessonSchedulePart lesson) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CustomLessonEditorPage(
            scheduleId: widget.scheduleId,
            lesson: lesson,
            weekday: _weekday,
          ),
        ),
      ),
    );
  }

  void _addLesson() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CustomLessonEditorPage(
            scheduleId: widget.scheduleId,
            weekday: _weekday,
          ),
        ),
      ),
    );
  }
}
