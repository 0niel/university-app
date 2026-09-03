import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_how_it_works.dart';

class NfcNotConnected extends StatelessWidget {
  const NfcNotConnected({required this.onConnect, super.key});

  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NinjaEmptyState(
          title: l10n.nfcPassNotConnectedTitle,
          message: l10n.nfcPassNotConnectedDescription,
          icon: AppLineIconWidget(
            AppLineIcon.contactless,
            color: colors.accent,
          ),
          actionLabel: l10n.nfcPassConnectButton,
          onAction: onConnect,
        ).animateEmptyState(),
        const SizedBox(height: 28),
        const NfcHowItWorks(),
      ],
    );
  }
}
