import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/models/subject_grades.dart';
import 'package:rtu_mirea_app/grades/widgets/grades_mark_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const kGradeMarkValues = [5, 4, 3, 2];

Future<void> showAddMarkSheet(
  BuildContext context, {
  required GradesCubit cubit,
  required SubjectGrades subject,
}) {
  return showAppSheet<void>(
    context,
    title: subject.subject,
    subtitle: context.l10n.gradesAddMarkSubtitle,
    child: AddMarkSheet(cubit: cubit, subject: subject),
  );
}

class AddMarkSheet extends StatefulWidget {
  const AddMarkSheet({required this.cubit, required this.subject, super.key});

  final GradesCubit cubit;
  final SubjectGrades subject;

  @override
  State<AddMarkSheet> createState() => _AddMarkSheetState();
}

class _AddMarkSheetState extends State<AddMarkSheet> {
  bool _saving = false;
  bool _failed = false;

  Future<void> _save(int? value) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    final saved = value == null
        ? await widget.cubit.removeLastMark(widget.subject.subject)
        : await widget.cubit.addMark(
            subject: widget.subject.subject,
            teacher: widget.subject.teacher,
            value: value,
          );
    if (!mounted) return;
    if (!saved) {
      setState(() {
        _saving = false;
        _failed = true;
      });
      return;
    }
    final l10n = context.l10n;
    if (value != null) {
      ToastManager.showSuccess(context, message: l10n.gradesMarkAdded(value));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subject = widget.subject;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_failed) ...[
          AppErrorState.compact(title: l10n.error),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: [
            for (final (index, value) in kGradeMarkValues.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MarkButton(
                  value: value,
                  onTap: _saving ? null : () => _save(value),
                ),
              ),
            ],
          ],
        ),
        if (_saving)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(child: NinjaSpinner(size: 24)),
          ),
        if (subject.marks.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final mark in subject.marks)
                GradesMarkTile(value: mark.value),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.secondary(
            label: l10n.gradesRemoveLast,
            expanded: true,
            onPressed: _saving ? null : () => _save(null),
          ),
        ],
      ],
    );
  }
}

class _MarkButton extends StatelessWidget {
  const _MarkButton({required this.value, required this.onTap});

  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = GradesMarkTile.palette(
      context.colors,
      value,
    );
    return AppPressable(
      onTap: onTap,
      semanticsLabel: context.l10n.gradesMarkSemantics(value),
      semanticsButton: true,
      child: Container(
        height: AppControlSize.buttonHero,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.banner),
        ),
        child: Text(
          '$value',
          style: AppText.code.copyWith(color: foreground),
        ),
      ),
    );
  }
}
