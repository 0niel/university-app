import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ScheduleSelectorEmptyState extends StatelessWidget {
  const ScheduleSelectorEmptyState({required this.onCreate, super.key});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return AppEmptyState(
      title: l10n.noOwnSchedules,
      subtitle: l10n.createCustomSchedule,
      icon: AppLineIconWidget(
        AppLineIcon.calendar,
        size: 20,
        color: colors.muted,
      ),
      actionLabel: l10n.createSchedule,
      onAction: onCreate,
    ).animateEmptyState();
  }
}
