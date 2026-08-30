import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SettingsFailureCard extends StatelessWidget {
  const SettingsFailureCard({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        16,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: NinjaErrorCard(
        title: l10n.loadingError,
        message: l10n.profileSectionLoadFailed,
        actionLabel: l10n.tryAgain,
        onAction: onRetry,
      ),
    );
  }
}
