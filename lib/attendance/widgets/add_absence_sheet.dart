import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/models/absence.dart';
import 'package:rtu_mirea_app/attendance/utils/attendance_format.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<void> showAddAbsenceSheet(
  BuildContext context, {
  required AttendanceCubit cubit,
}) {
  return showAppSheet<void>(
    context,
    title: context.l10n.attendanceAddAbsence,
    child: AddAbsenceSheet(cubit: cubit),
  );
}

class AddAbsenceSheet extends StatefulWidget {
  const AddAbsenceSheet({required this.cubit, super.key});

  final AttendanceCubit cubit;

  @override
  State<AddAbsenceSheet> createState() => _AddAbsenceSheetState();
}

class _AddAbsenceSheetState extends State<AddAbsenceSheet> {
  late final List<String> _subjects = [
    for (final subject in widget.cubit.state.subjects) subject.subject,
  ];
  late final TextEditingController _subjectController = TextEditingController();
  String? _subject;
  late DateTime _date = widget.cubit.state.today;
  AbsenceReason _reason = AbsenceReason.noReason;
  bool _saving = false;
  bool _failed = false;

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final state = widget.cubit.state;
    final picked = await showAppDatePicker(
      context,
      initial: _date,
      firstDate: state.semesterStart,
      lastDate: state.today,
      title: context.l10n.attendanceSheetDate,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final subject = _subject;
    if (_saving || subject == null || subject.trim().isEmpty) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final saved = await widget.cubit.addAbsence(
      subject: subject,
      date: _date,
      reason: _reason,
    );
    if (!mounted) return;
    if (!saved) {
      setState(() {
        _saving = false;
        _failed = true;
      });
      return;
    }
    ToastManager.showSuccess(context, message: l10n.attendanceAbsenceAdded);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final canSubmit = !_saving && (_subject?.trim().isNotEmpty ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_failed) ...[
          AppErrorState.compact(title: l10n.error),
          const SizedBox(height: AppSpacing.md),
        ],
        AppFieldLabel(l10n.attendanceSheetSubject),
        if (_subjects.isEmpty)
          AppInputField(
            controller: _subjectController,
            enabled: !_saving,
            placeholder: l10n.attendanceSheetSubject,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) => setState(() => _subject = value),
          )
        else
          AppChipGroup(
            chips: [
              for (final subject in _subjects)
                AppChip(
                  label: subject,
                  selected: _subject == subject,
                  enabled: !_saving,
                  onTap: _saving
                      ? null
                      : () => setState(() => _subject = subject),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
        AppSelectField(
          label: l10n.attendanceSheetDate,
          value: formatShortDate(_date, locale),
          leadingIcon: AppLineIcon.calendar,
          onTap: _saving ? null : _pickDate,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppFieldLabel(l10n.attendanceSheetReason),
        AppChipGroup(
          chips: [
            for (final reason in AbsenceReason.values)
              AppChip(
                label: switch (reason) {
                  .sick => l10n.attendanceReasonSick,
                  .noReason => l10n.attendanceReasonNone,
                },
                selected: _reason == reason,
                enabled: !_saving,
                color: reason == .sick ? colors.lecture : colors.warn,
                onTap: _saving ? null : () => setState(() => _reason = reason),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xlg),
        AppButton.primary(
          label: l10n.attendanceSheetSubmit,
          size: AppButtonSize.large,
          expanded: true,
          loading: _saving,
          onPressed: canSubmit ? _submit : null,
        ),
      ],
    );
  }
}
