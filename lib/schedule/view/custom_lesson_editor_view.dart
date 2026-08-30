import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/common/widgets/searchable_entity_picker.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_lesson_editor/custom_lesson_editor_widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

const List<LessonType> kLessonTypes = [
  LessonType.lecture,
  LessonType.practice,
  LessonType.laboratoryWork,
  LessonType.credit,
  LessonType.exam,
];

class CustomLessonEditorView extends StatefulWidget {
  const CustomLessonEditorView({
    required this.isEditing,
    required this.bellSlots,
    required this.colors,
    required this.reminderLeadMinutes,
    super.key,
  });

  final bool isEditing;
  final List<LessonBellSlotConfig> bellSlots;
  final List<int> colors;
  final List<int> reminderLeadMinutes;

  @override
  State<CustomLessonEditorView> createState() => _CustomLessonEditorViewState();
}

class _CustomLessonEditorViewState extends State<CustomLessonEditorView> {
  late final TextEditingController _subjectController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(
      text: context.read<CustomLessonEditorCubit>().state.subject,
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocBuilder<CustomLessonEditorCubit, CustomLessonEditorState>(
        builder: (context, state) => CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: colors.canvas,
              surfaceTintColor: Colors.transparent,
              title: Text(
                widget.isEditing
                    ? l10n.lessonEditorEditTitle
                    : l10n.lessonEditorCreateTitle,
                style: NinjaText.headline.copyWith(color: colors.ink),
              ),
              actions: [
                NinjaIconButton(
                  icon: const AppLineIconWidget(
                    .check,
                    size: 20,
                  ),
                  tooltip: l10n.save,
                  onPressed: _save,
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
                  32,
                ),
                sliver: SliverList.list(
                  children: [
                    LessonEditorSubjectCard(
                      controller: _subjectController,
                      label: l10n.lessonEditorSubjectLabel,
                      hint: l10n.lessonEditorSubjectHint,
                      onChanged: context
                          .read<CustomLessonEditorCubit>()
                          .subjectChanged,
                    ),
                    const SizedBox(height: 28),
                    LessonEditorSectionLabel(l10n.lessonEditorTypeLabel),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in kLessonTypes)
                          LessonEditorTypeChip(
                            label: _typeLabel(l10n, type),
                            selected: state.lessonType == type,
                            onTap: () => context
                                .read<CustomLessonEditorCubit>()
                                .lessonTypeChanged(type),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    LessonEditorSectionLabel(l10n.lessonEditorColorLabel),
                    const SizedBox(height: 10),
                    LessonEditorColorPicker(
                      colors: widget.colors,
                      selected: state.color,
                      semanticLabelBuilder: (index) =>
                          '${l10n.lessonEditorColorLabel} ${index + 1}',
                      onSelected: context
                          .read<CustomLessonEditorCubit>()
                          .colorChanged,
                    ),
                    const SizedBox(height: 28),
                    LessonEditorFieldCard(
                      children: [
                        LessonEditorFieldRow(
                          icon: .clock,
                          label: l10n.lessonEditorTimeLabel,
                          value: '${state.startTime} – ${state.endTime}',
                          divider: false,
                          onTap: () => unawaited(_pickTimeRange()),
                        ),
                        LessonEditorFieldRow(
                          icon: .pin,
                          label: l10n.lessonEditorRoomLabel,
                          value: state.selectedClassrooms.isEmpty
                              ? l10n.lessonEditorNotSet
                              : state.selectedClassrooms
                                    .map((classroom) => classroom.name)
                                    .join(', '),
                          muted: state.selectedClassrooms.isEmpty,
                          stacked: true,
                          onTap: () => unawaited(_addClassroom()),
                        ),
                        LessonEditorFieldRow(
                          icon: .user,
                          label: l10n.lessonEditorTeacherLabel,
                          value: state.selectedTeachers.isEmpty
                              ? l10n.lessonEditorNotSet
                              : state.selectedTeachers
                                    .map((teacher) => teacher.name)
                                    .join(', '),
                          muted: state.selectedTeachers.isEmpty,
                          stacked: true,
                          onTap: () => unawaited(_addTeacher()),
                        ),
                        LessonEditorFieldRow(
                          icon: .calendar,
                          label: l10n.lessonEditorRepeatLabel,
                          value: _repeatLabel(l10n, state),
                          stacked: true,
                          onTap: () => unawaited(_openRepeatSheet()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LessonEditorReminderCard(
                      title: l10n.lessonEditorReminderTitle,
                      enabled: state.reminderMinutes != null,
                      leadLabel: state.reminderMinutes == null
                          ? null
                          : l10n.lessonEditorReminderLead(
                              state.reminderMinutes!,
                            ),
                      onToggle: (enabled) => context
                          .read<CustomLessonEditorCubit>()
                          .reminderEnabledChanged(enabled: enabled),
                      onTapLead: state.reminderMinutes == null
                          ? null
                          : () => unawaited(_pickReminderLead()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, LessonType type) => switch (type) {
    .lecture => l10n.lessonTypeLectureName,
    .practice => l10n.lessonTypeSeminarName,
    .laboratoryWork => l10n.lessonTypeLabName,
    .credit => l10n.lessonTypeCreditName,
    .exam => l10n.lessonTypeExamName,
    .individualWork ||
    .physicalEducation ||
    .consultation ||
    .courseWork ||
    .courseProject ||
    .unknown => type.name,
  };

  String _repeatLabel(
    AppLocalizations l10n,
    CustomLessonEditorState state,
  ) => switch (state.repeat) {
    .everyWeek => l10n.lessonEditorRepeatEvery,
    .evenWeek => l10n.lessonEditorRepeatEven,
    .oddWeek => l10n.lessonEditorRepeatOdd,
    .custom => l10n.lessonEditorDatesCount(
      state.selectedDates.length,
    ),
  };

  Future<void> _pickTimeRange() async {
    final cubit = context.read<CustomLessonEditorCubit>();
    final current = cubit.state;
    final result = await showAppTimeRangePicker(
      context,
      start: (
        hour: current.startTime.hour,
        minute: current.startTime.minute,
      ),
      end: (hour: current.endTime.hour, minute: current.endTime.minute),
      quickSlots: widget.bellSlots.map(_timeSlot).toList(growable: false),
    );
    if (result == null || !mounted) return;
    cubit.timeChanged(
      TimeOfDay(hour: result.$1.hour, minute: result.$1.minute),
      TimeOfDay(hour: result.$2.hour, minute: result.$2.minute),
    );
  }

  Future<void> _openRepeatSheet() async {
    final cubit = context.read<CustomLessonEditorCubit>();
    final current = cubit.state;
    final result = await showAppSheet<LessonEditorRepeatResult>(
      context,
      title: context.l10n.lessonEditorRepeatLabel,
      child: LessonEditorRepeatSheet(
        repeat: current.repeat,
        weekday: current.weekday,
        dates: current.selectedDates,
        reference: current.selectedDates.firstOrNull,
      ),
    );
    if (result == null || !mounted) return;
    if (result.openManual) {
      await _pickCustomDates();
      return;
    }
    cubit.repeatChanged(result.repeat, result.dates);
  }

  Future<void> _pickCustomDates() async {
    final cubit = context.read<CustomLessonEditorCubit>();
    final result = await showAppMultiDatePicker(
      context,
      selected: cubit.state.selectedDates,
      selectableDayPredicate: (day) =>
          !day.isBefore(cubit.earliestSelectableDate),
    );
    if (result != null && mounted) {
      cubit.repeatChanged(.custom, result);
    }
  }

  Future<void> _pickReminderLead() async {
    final cubit = context.read<CustomLessonEditorCubit>();
    final picked = await showAppSheet<int>(
      context,
      title: context.l10n.lessonEditorReminderTitle,
      child: LessonEditorReminderLeadSheet(
        current: cubit.state.reminderMinutes ?? 15,
        options: widget.reminderLeadMinutes,
      ),
    );
    if (picked != null && mounted) cubit.reminderMinutesChanged(picked);
  }

  TimeSlot _timeSlot(LessonBellSlotConfig slot) => (
    label: slot.label,
    start: (hour: slot.startHour, minute: slot.startMinute),
    end: (hour: slot.endHour, minute: slot.endMinute),
  );

  Future<void> _addClassroom() async {
    final repository = context.read<ScheduleRepository>();
    final result = await showAppSheet<Classroom>(
      context,
      title: context.l10n.lessonEditorAddClassroom,
      scrollable: false,
      child: SearchableEntityPicker<Classroom>(
        icon: .pin,
        searchHint: context.l10n.lessonEditorClassroomSearchHint,
        onSearch: (query) async =>
            (await repository.searchClassrooms(query: query)).results,
        titleBuilder: (classroom) => classroom.name,
        subtitleBuilder: (classroom) => classroom.campus?.name,
        onManualCreate: (name) => Classroom(name: name),
      ),
    );
    if (result != null && mounted) {
      context.read<CustomLessonEditorCubit>().classroomsChanged([result]);
    }
  }

  Future<void> _addTeacher() async {
    final repository = context.read<ScheduleRepository>();
    final result = await showAppSheet<Teacher>(
      context,
      title: context.l10n.lessonEditorAddTeacher,
      scrollable: false,
      child: SearchableEntityPicker<Teacher>(
        icon: .user,
        searchHint: context.l10n.lessonEditorTeacherSearchHint,
        onSearch: (query) async =>
            (await repository.searchTeachers(query: query)).results,
        titleBuilder: (teacher) => teacher.name,
        subtitleBuilder: (teacher) => teacher.post ?? teacher.department,
        onManualCreate: (name) => Teacher(name: name),
      ),
    );
    if (result != null && mounted) {
      context.read<CustomLessonEditorCubit>().teachersChanged([result]);
    }
  }

  void _save() {
    final result = context.read<CustomLessonEditorCubit>().save();
    if (result == .success) {
      Navigator.of(context).pop();
      return;
    }
    final l10n = context.l10n;
    final message = switch (result) {
      .subjectRequired => l10n.lessonEditorSubjectRequired,
      .datesRequired => l10n.lessonEditorSelectDateError,
      .invalidTimeRange => l10n.lessonEditorInvalidTimeRange,
      .duplicate => l10n.lessonEditorDuplicateError,
      .targetNotFound => l10n.lessonEditorScheduleMissing,
      .success => l10n.lessonEditorSaveError,
    };
    showNinjaToast(context, showCheck: false, message: message);
  }
}
