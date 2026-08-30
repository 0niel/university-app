import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'deadlines/create_sheet/picker_field.dart';
part 'deadlines/create_sheet/quick_date_chip.dart';
part 'deadlines/create_sheet/toggle_row.dart';

class CreateDeadlineSheet extends StatefulWidget {
  const CreateDeadlineSheet({super.key, this.universityConfig, this.now});

  final UniversityConfig? universityConfig;
  final DateTime? now;

  @override
  State<CreateDeadlineSheet> createState() => _CreateDeadlineSheetState();
}

class _CreateDeadlineSheetState extends State<CreateDeadlineSheet> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  late DateTime _dueAt;
  DeadlineQuickDate? _quickDate = .tomorrow;
  DeadlinePriority _priority = .medium;
  bool _remind = true;
  bool _shareWithGroup = false;
  bool _hasTitle = false;

  DateTime get _now => widget.now ?? DateTime.now();
  UniversityConfig get _config => widget.universityConfig ?? .current;

  @override
  void initState() {
    super.initState();
    _dueAt = resolveDeadlineQuickDate(
      .tomorrow,
      now: _now,
      universityConfig: _config,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = _now;
    final date = await showAppDatePicker(
      context,
      initial: _dueAt,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _quickDate = null;
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        _dueAt.hour,
        _dueAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final time = await showAppTimePicker(
      context,
      initial: (hour: _dueAt.hour, minute: _dueAt.minute),
    );
    if (time == null || !mounted) return;
    setState(() {
      _dueAt = DateTime(
        _dueAt.year,
        _dueAt.month,
        _dueAt.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _selectQuickDate(DeadlineQuickDate quickDate) {
    setState(() {
      _quickDate = quickDate;
      _dueAt = resolveDeadlineQuickDate(
        quickDate,
        now: _now,
        universityConfig: _config,
      );
    });
  }

  void _submit() {
    if (!_canSubmit) return;
    final title = _titleController.text.trim();
    Navigator.of(context).pop(
      DeadlineDraft(
        title: title,
        subjectName: _subjectController.text.trim(),
        dueAt: _dueAt,
        source: _shareWithGroup ? .group : .me,
        priority: _priority,
        remind: _remind,
      ),
    );
  }

  void _titleChanged(String value) {
    final hasTitle = value.trim().isNotEmpty;
    if (hasTitle == _hasTitle) return;
    setState(() => _hasTitle = hasTitle);
  }

  bool get _canSubmit => _hasTitle && _dueAt.isAfter(_now);

  String _dateLabel(BuildContext context) {
    final due = DateTime(_dueAt.year, _dueAt.month, _dueAt.day);
    final now = _now;
    final today = DateTime(now.year, now.month, now.day);
    if (due == today) return context.l10n.deadlineToday;
    if (due == today.add(const Duration(days: 1))) {
      return context.l10n.deadlineTomorrow;
    }
    return DateFormat(
      'd MMM',
      Localizations.localeOf(context).toString(),
    ).format(_dueAt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        NinjaInput(
          controller: _titleController,
          autofocus: true,
          placeholder: l10n.deadlineTitleHint,
          onChanged: _titleChanged,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 10),
        NinjaInput(
          controller: _subjectController,
          placeholder: l10n.deadlineSubjectHint,
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final stack =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            final date = _PickerField(
              icon: .calendar,
              label: l10n.deadlineDateLabel,
              value: _dateLabel(context),
              onTap: () => unawaited(_pickDate()),
            );
            final time = _PickerField(
              icon: .clock,
              label: l10n.deadlineTimeLabel,
              value: DateFormat.Hm(
                Localizations.localeOf(context).toString(),
              ).format(_dueAt),
              onTap: () => unawaited(_pickTime()),
            );
            if (stack) {
              return Column(
                children: [date, const SizedBox(height: 8), time],
              );
            }
            return Row(
              spacing: 10,
              children: [
                Expanded(child: date),
                Expanded(child: time),
              ],
            );
          },
        ),
        if (!_dueAt.isAfter(_now)) ...[
          const SizedBox(height: 6),
          Text(
            l10n.deadlinePastError,
            style: NinjaText.helper.copyWith(color: context.ninja.scarlet),
          ),
        ],
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _QuickDateChip(
              label: l10n.deadlineQuickToday,
              selected: _quickDate == .today,
              onTap: () => _selectQuickDate(.today),
            ),
            _QuickDateChip(
              label: l10n.deadlineQuickTomorrow,
              selected: _quickDate == .tomorrow,
              onTap: () => _selectQuickDate(.tomorrow),
            ),
            _QuickDateChip(
              label: l10n.deadlineQuickWeek,
              selected: _quickDate == .week,
              onTap: () => _selectQuickDate(.week),
            ),
            _QuickDateChip(
              label: l10n.deadlineQuickSession,
              selected: _quickDate == .session,
              onTap: () => _selectQuickDate(.session),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.deadlinePriorityLabel,
          style: NinjaText.microLabel.copyWith(
            color: context.ninja.muted,
          ),
        ),
        const SizedBox(height: 8),
        NinjaSegmented<DeadlinePriority>(
          value: _priority,
          onChanged: (value) => setState(() => _priority = value),
          expanded: true,
          segments: [
            NinjaSegment(value: .low, label: l10n.deadlinePriorityLow),
            NinjaSegment(
              value: .medium,
              label: l10n.deadlinePriorityMedium,
            ),
            NinjaSegment(
              value: .urgent,
              label: l10n.deadlinePriorityUrgent,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ToggleRow(
          title: l10n.deadlineRemindTitle,
          subtitle: l10n.deadlineRemindSubtitle,
          value: _remind,
          onChanged: (value) => setState(() => _remind = value),
        ),
        const SizedBox(height: 8),
        _ToggleRow(
          title: l10n.deadlineShareTitle,
          subtitle: l10n.deadlineShareSubtitle,
          value: _shareWithGroup,
          onChanged: (value) => setState(() => _shareWithGroup = value),
        ),
        const SizedBox(height: 18),
        NinjaButton.primary(
          label: l10n.createDeadlineButton,
          expanded: true,
          size: NinjaButtonSize.large,
          onPressed: _canSubmit ? _submit : null,
        ),
      ],
    );
  }
}
