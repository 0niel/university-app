import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/attendance/models/absence.dart';
import 'package:rtu_mirea_app/attendance/utils/attendance_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceMissRow extends StatelessWidget {
  const AttendanceMissRow({
    required this.absence,
    required this.onCertificate,
    required this.onRemove,
    super.key,
  });

  final Absence absence;
  final VoidCallback onCertificate;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final reason = switch (absence.reason) {
      .sick => l10n.attendanceReasonSick,
      .noReason => l10n.attendanceReasonNone,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 11,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                formatShortDate(absence.date, locale),
                style: AppText.subtextBold.copyWith(color: colors.muted),
              ),
            ),
            Expanded(
              child: Text(
                l10n.attendanceMissRow(reason),
                style: AppText.sans(13.5, FontWeight.w500).copyWith(
                  color: colors.ink,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            if (absence.isUnexcused)
              AppButton.text(
                label: l10n.attendanceCertificate,
                size: AppButtonSize.small,
                onPressed: onCertificate,
              ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.trash),
              tooltip: l10n.attendanceRemoveAbsence,
              onPressed: onRemove,
              tone: AppIconButtonTone.plain,
            ),
          ],
        ),
      ),
    );
  }
}
