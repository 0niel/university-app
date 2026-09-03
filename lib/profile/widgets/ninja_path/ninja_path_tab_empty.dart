import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaPathTabEmpty extends StatelessWidget {
  const NinjaPathTabEmpty({
    required this.icon,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final AppLineIcon icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      lineIcon: icon,
      title: context.l10n.ninjaPathNoData,
      actionLabel: actionLabel,
      onAction: onAction,
    ).animateEmptyState();
  }
}
