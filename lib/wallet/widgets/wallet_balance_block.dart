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
    final colors = context.colors;
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
          color: loading ? colors.surface : colors.ink,
          borderRadius: BorderRadius.circular(AppRadius.hero),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                            style: AppText.body.copyWith(
                              color: colors.canvas,
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
                            dimension: AppControlSize.iconButton,
                            child: Center(
                              child: AppLineIconWidget(
                                AppLineIcon.info,
                                size: 20,
                                color: colors.canvas,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.gap),
                    Row(
                      children: [
                        AppNinjaMark(size: 28, color: colors.canvas),
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Text(
                            balance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.tabular(
                              AppText.displayHero.copyWith(
                                color: colors.canvas,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.fieldGap),
                    Row(
                      children: [
                        Expanded(
                          child: _WalletBalanceStat(
                            value: '${profile.streakDays}',
                            label: l10n.walletStreakDays,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.gap),
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
