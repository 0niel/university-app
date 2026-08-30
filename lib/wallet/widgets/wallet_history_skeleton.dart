part of 'wallet_history_tab.dart';

class WalletHistorySkeleton extends StatelessWidget {
  const WalletHistorySkeleton({super.key});

  static const _itemCount = 6;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: context.l10n.loadingContent,
      child: ExcludeSemantics(
        child: NinjaSkeletonGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: List.generate(
              _itemCount,
              (_) => const WalletHistoryRowSkeleton(),
            ),
          ),
        ),
      ),
    );
  }
}
