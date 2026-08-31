import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_report_status_button.dart';

class LostFoundReportStatusSelector extends StatelessWidget {
  const LostFoundReportStatusSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final LostFoundItemStatus value;
  final ValueChanged<LostFoundItemStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: LostFoundReportStatusButton(
            icon: AppLineIcon.search,
            label: l10n.lostFoundStatusLostMe,
            selected: value == .lost,
            onTap: () => onChanged(.lost),
          ),
        ),
        const SizedBox(width: AppSpacing.gap),
        Expanded(
          child: LostFoundReportStatusButton(
            icon: AppLineIcon.heart,
            label: l10n.lostFoundStatusFoundMe,
            selected: value == .found,
            onTap: () => onChanged(.found),
          ),
        ),
      ],
    );
  }
}
