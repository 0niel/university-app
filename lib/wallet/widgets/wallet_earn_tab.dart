import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'wallet_earn_more_toggle.dart';
part 'wallet_earn_row.dart';

typedef WalletEarnWay = ({
  String title,
  String description,
  String value,
  String per,
  bool live,
});

class WalletEarnTab extends StatefulWidget {
  const WalletEarnTab({super.key});

  @override
  State<WalletEarnTab> createState() => _WalletEarnTabState();
}

class _WalletEarnTabState extends State<WalletEarnTab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ways = [
      (
        title: l10n.walletEarnAttendTitle,
        description: l10n.walletEarnAttendDesc,
        value: '+10',
        per: l10n.walletEarnAttendPer,
        live: false,
      ),
      (
        title: l10n.walletEarnStreakTitle,
        description: l10n.walletEarnStreakDesc,
        value: '+5→50',
        per: l10n.walletEarnStreakPer,
        live: false,
      ),
      (
        title: l10n.walletEarnUploadTitle,
        description: l10n.walletEarnUploadDesc,
        value: '+30',
        per: l10n.walletEarnUploadPer,
        live: true,
      ),
      (
        title: l10n.walletEarnDownloadTitle,
        description: l10n.walletEarnDownloadDesc,
        value: '+21',
        per: l10n.walletEarnDownloadPer,
        live: false,
      ),
      (
        title: l10n.walletEarnLikeTitle,
        description: l10n.walletEarnLikeDesc,
        value: '+2',
        per: l10n.walletEarnLikePer,
        live: false,
      ),
      (
        title: l10n.walletEarnQuestTitle,
        description: l10n.walletEarnQuestDesc,
        value: '+10→150',
        per: l10n.walletEarnQuestPer,
        live: true,
      ),
      (
        title: l10n.walletEarnChatTitle,
        description: l10n.walletEarnChatDesc,
        value: '+15',
        per: l10n.walletEarnChatPer,
        live: false,
      ),
      (
        title: l10n.walletEarnFoundTitle,
        description: l10n.walletEarnFoundDesc,
        value: '+100',
        per: l10n.walletEarnFoundPer,
        live: false,
      ),
      (
        title: l10n.walletEarnReferralTitle,
        description: l10n.walletEarnReferralDesc,
        value: '+200',
        per: l10n.walletEarnReferralPer,
        live: false,
      ),
    ];
    final liveWays = ways.where((way) => way.live).toList();
    final comingWays = ways.where((way) => !way.live).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, way) in liveWays.indexed)
          WalletEarnRow(way: way).animateListItem(index: index),
        if (comingWays.isNotEmpty) ...[
          WalletEarnMoreToggle(
            count: comingWays.length,
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          AnimatedSize(
            duration:
                MediaQuery.disableAnimationsOf(context) ||
                    MediaQuery.accessibleNavigationOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: _expanded
                ? Column(
                    children: [
                      for (final way in comingWays)
                        WalletEarnRow(way: way, muted: true),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }
}
