import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_picker_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherPickerRow extends StatelessWidget {
  const TeacherPickerRow({
    required this.teacher,
    required this.enabled,
    required this.ambiguous,
    required this.onSelected,
    super.key,
  });

  final Teacher teacher;
  final bool enabled;
  final bool ambiguous;
  final ValueChanged<Teacher> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final linkable = teacher.isPickerLinkable;
    final selectable = enabled && linkable;
    final detail = !linkable
        ? l10n.teacherPickerUnavailable
        : ambiguous
        ? l10n.teacherPickerIdentity(teacher.uid!)
        : teacher.department ?? teacher.post;
    return AppPressable(
      key: ValueKey('teacher-picker-${teacher.pickerKey}'),
      onTap: () => onSelected(teacher),
      enabled: selectable,
      pressedScale: 1,
      semanticsLabel: [teacher.name, ?detail].join(', '),
      semanticsButton: true,
      semanticsSelected: false,
      child: ColoredBox(
        color: colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: AppText.headline.copyWith(
                        color: selectable ? colors.ink : colors.muted,
                      ),
                    ),
                    if (detail != null && detail.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        detail,
                        style: AppText.sans(
                          11.5,
                          FontWeight.w400,
                          height: 1.35,
                        ).copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface2,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
