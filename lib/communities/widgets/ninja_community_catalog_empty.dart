import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaCommunityCatalogEmpty extends StatelessWidget {
  const NinjaCommunityCatalogEmpty({super.key, this.onReset});

  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) => NinjaEmptyState.screen(
    icon: const AppLineIconWidget(AppLineIcon.search, size: 24),
    title: context.l10n.communitiesNotFound,
    message: context.l10n.communitiesTryFilters,
    actionLabel: onReset == null ? null : context.l10n.clear,
    onAction: onReset,
  ).animateEmptyState();
}
