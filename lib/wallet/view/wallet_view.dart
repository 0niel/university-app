import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/wallet/cubit/wallet_cubit.dart';
import 'package:rtu_mirea_app/wallet/widgets/widgets.dart';

part 'wallet_tabs.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<WalletCubit>().state;
    final cubit = context.read<WalletCubit>();
    final loading = state.status == .loading;
    final failed = state.status == .failure && state.history.isEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NinjaAppBar(title: l10n.walletTitle),
      body: RefreshIndicator(
        color: colors.brand,
        backgroundColor: colors.surface,
        onRefresh: cubit.load,
        child: NinjaSkeletonGroup(
          excludeSemantics: false,
          pulse: loading,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (failed)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    NinjaMetrics.screenPadding,
                    8,
                    NinjaMetrics.screenPadding,
                    32,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: NinjaErrorState(
                      title: l10n.loadingError,
                      message: l10n.tryAgain,
                      retryLabel: l10n.retry,
                      onRetry: () => unawaited(cubit.load()),
                    ).animateEmptyState(),
                  ),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    NinjaMetrics.screenPadding,
                    4,
                    NinjaMetrics.screenPadding,
                    10,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: WalletBalanceBlock(
                      profile: state.profile,
                      overview: state.overview,
                      loading: loading,
                    ).animateSectionEntrance(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _WalletTabsHeader(
                    background: colors.canvas,
                    child: _WalletTabs(
                      value: state.tab,
                      onChanged: cubit.tabChanged,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    NinjaMetrics.screenPadding,
                    10,
                    NinjaMetrics.screenPadding,
                    40,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: NinjaStateSwitcher(
                      duration: NinjaMotion.fast,
                      child: switch (state.tab) {
                        .earn => const WalletEarnTab(key: ValueKey('earn')),
                        .spend => const WalletSpendTab(key: ValueKey('spend')),
                        .history => WalletHistoryTab(
                          key: const ValueKey('history'),
                          entries: state.history,
                          loading: loading,
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletTabsHeader extends SliverPersistentHeaderDelegate {
  const _WalletTabsHeader({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: background, child: child);
  }

  @override
  bool shouldRebuild(_WalletTabsHeader oldDelegate) =>
      oldDelegate.background != background || oldDelegate.child != child;
}
