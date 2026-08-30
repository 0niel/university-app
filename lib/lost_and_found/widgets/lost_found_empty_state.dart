import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundEmptyState extends StatelessWidget {
  const LostFoundEmptyState({required this.status, this.onReport, super.key});

  final LostFoundItemStatus status;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaEmptyState.screen(
      icon: AppLineIconWidget(
        AppLineIcon.search,
        size: 42,
        color: context.ninja.muted,
      ),
      title: status == .found
          ? l10n.lostFoundEmptyFound
          : l10n.lostFoundEmptyLost,
      message: l10n.lostFoundEmptySub,
      actionLabel: onReport == null ? null : l10n.lostFoundReport,
      onAction: onReport,
    );
  }
}
