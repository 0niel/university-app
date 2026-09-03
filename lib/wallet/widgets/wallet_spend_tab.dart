import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'wallet_coming_later_note.dart';
part 'wallet_spend_row.dart';

typedef WalletSpendItem = ({
  String title,
  String description,
  String cost,
});

class WalletSpendTab extends StatelessWidget {
  const WalletSpendTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final boost = (
      title: l10n.walletSpendBoostTitle,
      description: l10n.walletSpendBoostDesc,
      cost: l10n.walletSpendBoostCost,
    );
    final teaser = (
      title: l10n.walletSpendMaterialsTitle,
      description: l10n.walletSpendMaterialsDesc,
      cost: l10n.walletSpendMaterialsCost,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.gap),
          child: Text(
            l10n.walletSpendSectionTitle,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
        ),
        WalletSpendRow(
          item: boost,
          onTap: () => context.go('/services/team-finder'),
        ).animateListItem(),
        WalletSpendRow(item: teaser).animateListItem(index: 1),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.gap),
          child: WalletComingLaterNote(text: l10n.walletSpendPartnersLater),
        ),
      ],
    );
  }
}
