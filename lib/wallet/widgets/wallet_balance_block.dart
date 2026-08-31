import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/wallet/widgets/wallet_explainer_row.dart';

part 'wallet_balance_block_skeleton.dart';
part 'wallet_balance_stat.dart';
part 'wallet_stat_block_skeleton.dart';

class WalletBalanceBlock extends StatelessWidget {
  const WalletBalanceBlock({
    required this.profile,
    required this.overview,
    this.loading = false,
    super.key,
  });

  final UserGamificationProfile profile;
  final ProfileOverview overview;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final balance = NumberFormat(
      '#,###',
      Localizations.localeOf(context).toString(),
    ).format(profile.shurikens);
    final groupRank = overview.groupRank;

    return Semantics(
      container: true,
      liveRegion: loading,
      label: loading
          ? l10n.loadingContent
          : '${l10n.walletBalanceLabel}: $balance',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: loading ? colors.surface : colors.accentSoft,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: loading
              ? const _WalletBalanceBlockSkeleton()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.walletBalanceLabel,
                            style: NinjaText.body.copyWith(
                              color: colors.onAccentSoftMuted,
                            ),
                          ),
                        ),
                        AppPressable(
                          semanticsLabel: l10n.walletExplainer,
                          onTap: () => unawaited(
                            showAppSheet<void>(
                              context,
                              child: const WalletExplainerRow(),
                            ),
                          ),
                          child: SizedBox.square(
                            dimension: NinjaMetrics.minTouchTarget,
                            child: Center(
                              child: AppLineIconWidget(
                                AppLineIcon.info,
                                size: 20,
                                color: colors.onAccentSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AppNinjaMark(size: 28, color: colors.onAccentSoft),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            balance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: NinjaText.tabular(
                              NinjaText.display.copyWith(
                                color: colors.onAccentSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _WalletBalanceStat(
                            value: '${profile.streakDays}',
                            label: l10n.walletStreakDays,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _WalletBalanceStat(
                            value: groupRank != null
                                ? '#$groupRank'
                                : 'LVL ${profile.level}',
                            label: groupRank != null
                                ? l10n.walletInGroup
                                : l10n.walletLevel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
