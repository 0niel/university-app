import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colors.examTint,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        context.l10n.riskBadge,
        style: AppText.countBadge.copyWith(color: colors.danger),
      ),
    );
  }
}
