import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class NfcPassHeader extends StatelessWidget {
  const NfcPassHeader({
    required this.title,
    super.key,
    this.statusLabel,
    this.onBack,
    this.backTooltip,
    this.onSettings,
    this.settingsTooltip,
  });

  final String title;
  final String? statusLabel;
  final VoidCallback? onBack;
  final String? backTooltip;
  final VoidCallback? onSettings;
  final String? settingsTooltip;

  @override
  Widget build(BuildContext context) => AppInnerHeader(
    title: title,
    subtitle: statusLabel,
    onBack: onBack,
    backSemanticsLabel: backTooltip,
    actions: [
      if (onSettings != null)
        AppHeaderAction(
          icon: AppLineIcon.tune,
          onTap: onSettings,
          semanticsLabel: settingsTooltip,
        ),
    ],
  );
}
