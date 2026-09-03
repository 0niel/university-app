import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SupportBanner extends StatelessWidget {
  const SupportBanner({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: NinjaBanner(
        title: l10n.settingsSupportTitle,
        body: l10n.settingsSupportSubtitle,
        actionLabel: l10n.settingsSupportCta,
        onAction: onTap,
      ),
    );
  }
}
