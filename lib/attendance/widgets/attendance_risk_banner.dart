import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/attendance/models/attendance_subject.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceRiskBanner extends StatelessWidget {
  const AttendanceRiskBanner({required this.subject, super.key});

  final AttendanceSubject subject;

  @override
  Widget build(BuildContext context) {
    return AppBanner(
      tone: AppBannerTone.danger,
      message: context.l10n.attendanceRiskBanner(
        subject.subject,
        subject.unexcusedCount,
      ),
    );
  }
}
