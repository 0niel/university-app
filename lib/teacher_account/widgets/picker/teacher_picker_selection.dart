import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherPickerSelection extends StatelessWidget {
  const TeacherPickerSelection({
    required this.teacher,
    required this.showIdentity,
    super.key,
  });

  final Teacher teacher;
  final bool showIdentity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Semantics(
      key: const ValueKey('teacher-picker-selection'),
      liveRegion: true,
      label: l10n.teacherPickerSelected(teacher.name),
      excludeSemantics: true,
      child: AppCard(
        tinted: true,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: AppCheckMark(size: 16, color: colors.accent),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.teacherPickerSelectionLabel,
                    style: AppText.subtext.copyWith(color: colors.accent),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    teacher.name,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  if (showIdentity && teacher.uid != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.teacherPickerIdentity(teacher.uid!),
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
          ],
        ),
      ),
    );
  }
}
