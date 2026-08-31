import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class WalletExplainerRow extends StatelessWidget {
  const WalletExplainerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaBanner(
      title: l10n.walletExplainerNoCash,
      body: l10n.walletExplainer,
    );
  }
}
