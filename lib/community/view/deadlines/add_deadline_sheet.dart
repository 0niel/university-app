import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_options.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

enum DeadlineDue { today, tomorrow, week, pick }

Future<void> showAddDeadlineSheet(
  BuildContext context, {
  DeadlinesCubit? cubit,
}) async {
  final owned = cubit == null
      ? DeadlinesCubit(repository: context.read<ScheduleRepository>())
      : null;
  final target = cubit ?? owned!;
  final subjects = _scheduleSubjects(context);
  try {
    await showAppSheet<void>(
      context,
      title: context.l10n.addDeadlineTitle,
      child: AddDeadlineSheet(cubit: target, subjects: subjects),
    );
  } finally {
    if (owned != null) unawaited(owned.close());
  }
}

List<String> _scheduleSubjects(BuildContext context) {
  final schedule =
      context.read<ScheduleBloc>().state.selectedSchedule?.schedule ??
      const <SchedulePart>[];
  final seen = <String>{};
  return [
    for (final part in schedule)
      if (part is LessonSchedulePart &&
          part.subject.trim().isNotEmpty &&
          seen.add(part.subject))
        part.subject,
  ];
}

class AddDeadlineSheet extends StatefulWidget {
  const AddDeadlineSheet({
    required this.cubit,
    required this.subjects,
    super.key,
    this.now,
  });

  final DeadlinesCubit cubit;
  final List<String> subjects;
  final DateTime? now;

  @override
  State<AddDeadlineSheet> createState() => _AddDeadlineSheetState();
}

class _AddDeadlineSheetState extends State<AddDeadlineSheet> {
  final TextEditingController _controller = TextEditingController();
  String? _subject;
  DeadlineDue _due = DeadlineDue.tomorrow;
  DateTime? _pickedDate;
  bool _shared = false;
  bool _saving = false;
  DeadlinePriority _priority = .medium;
  bool _remind = true;
  int _hour = 23;
  int _minute = 59;

  @override
  void initState() {
    super.initState();
    _subject = widget.subjects.isEmpty ? null : widget.subjects.first;
    _controller.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTitleChanged)
      ..dispose();
    super.dispose();
  }

  void _onTitleChanged() => setState(() {});

  DateTime get _now => widget.now ?? DateTime.now();

  DateTime get _dueAt {
    final base = DateTime(_now.year, _now.month, _now.day, _hour, _minute);
    return switch (_due) {
      DeadlineDue.today => base,
      DeadlineDue.tomorrow => base.add(const Duration(days: 1)),
      DeadlineDue.week => base.add(const Duration(days: 7)),
      DeadlineDue.pick =>
        _pickedDate == null
            ? base.add(const Duration(days: 1))
            : DateTime(
                _pickedDate!.year,
                _pickedDate!.month,
                _pickedDate!.day,
                _hour,
                _minute,
              ),
    };
  }

  Future<void> _pickDate() async {
    final picked = await showAppDatePicker(
      context,
      initial: _pickedDate ?? _now.add(const Duration(days: 1)),
      firstDate: DateTime(_now.year, _now.month, _now.day),
      lastDate: DateTime(_now.year + 2, _now.month, _now.day),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _pickedDate = picked;
      _due = DeadlineDue.pick;
    });
  }

  Future<void> _save() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _saving || !_dueAt.isAfter(_now)) return;
    setState(() => _saving = true);
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final created = await widget.cubit.createDeadline(
      DeadlineDraft(
        title: title,
        dueAt: _dueAt,
        source: _shared ? DeadlineSource.group : DeadlineSource.me,
        subjectName: _subject?.trim() ?? '',
        priority: _priority,
        remind: _remind,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (created) {
      ToastManager.showSuccess(context, message: l10n.deadlineSaved);
      navigator.pop();
    } else {
      ToastManager.showError(context, message: l10n.deadlinesCreateError);
    }
  }

  String _dueLabel(BuildContext context, DeadlineDue due) {
    final l10n = context.l10n;
    return switch (due) {
      DeadlineDue.today => l10n.deadlineQuickToday,
      DeadlineDue.tomorrow => l10n.deadlineQuickTomorrow,
      DeadlineDue.week => l10n.deadlineQuickWeek,
      DeadlineDue.pick =>
        _pickedDate == null
            ? l10n.addDeadlinePickDate
            : DateFormat.MMMd(
                Localizations.localeOf(context).toString(),
              ).format(_pickedDate!),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final valid = _controller.text.trim().isNotEmpty && _dueAt.isAfter(_now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputField(
          key: const ValueKey('add-deadline-title'),
          controller: _controller,
          placeholder: l10n.addDeadlineWhatHint,
          autofocus: true,
          height: 50,
          fillColor: colors.surface,
          showClear: false,
          textStyle: AppText.bodyLarge.copyWith(color: colors.ink),
        ),
        if (widget.subjects.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sectionGap),
          _FieldLabel(l10n.addDeadlineSubject),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final subject in widget.subjects)
                AppChip.filter(
                  key: ValueKey('add-deadline-subject-$subject'),
                  label: subject,
                  selected: _subject == subject,
                  onTap: () => setState(() => _subject = subject),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        _FieldLabel(l10n.addDeadlineDue),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final due in DeadlineDue.values)
              AppChip.filter(
                key: ValueKey('add-deadline-due-${due.name}'),
                label: _dueLabel(context, due),
                selected: _due == due,
                onTap: () {
                  if (due == DeadlineDue.pick) {
                    unawaited(_pickDate());
                  } else {
                    setState(() => _due = due);
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.banner),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionGap,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addDeadlineSharedTitle,
                        style: AppText.bodyStrong.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.addDeadlineSharedSubGeneric,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AppSwitch(
                  key: const ValueKey('add-deadline-shared'),
                  value: _shared,
                  semanticsLabel: l10n.addDeadlineSharedTitle,
                  onChanged: (value) => setState(() => _shared = value),
                ),
              ],
            ),
          ),
        ),
        if (!_dueAt.isAfter(_now))
          Text(
            l10n.deadlinePastError,
            style: AppText.caption.copyWith(color: colors.danger),
          ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppButton.primary(
          key: const ValueKey('add-deadline-submit'),
          label: l10n.add,
          size: AppButtonSize.large,
          expanded: true,
          loading: _saving,
          onPressed: valid && !_saving ? () => unawaited(_save()) : null,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        DeadlineOptions(
          dueAt: _dueAt,
          subject: _subject ?? '',
          priority: _priority,
          remind: _remind,
          onSubjectChanged: (value) => setState(() => _subject = value),
          onPriorityChanged: (value) => setState(() => _priority = value),
          onRemindChanged: (value) => setState(() => _remind = value),
          onTime: () async {
            final time = await showAppTimePicker(
              context,
              initial: (hour: _hour, minute: _minute),
            );
            if (time != null && mounted) {
              setState(() {
                _hour = time.hour;
                _minute = time.minute;
              });
            }
          },
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.captionStrong.copyWith(color: context.colors.muted),
    );
  }
}
