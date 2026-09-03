import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SettingsSearchEmpty extends StatelessWidget {
  const SettingsSearchEmpty({required this.onClear, super.key});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        24,
        AppSpacing.screen,
        8,
      ),
      child: AppEmptyState(
        lineIcon: AppLineIcon.search,
        title: l10n.searchNoResults,
        subtitle: l10n.searchNoResultsHint,
        actionLabel: l10n.clear,
        onAction: onClear,
      ).animateEmptyState(),
    );
  }
}
