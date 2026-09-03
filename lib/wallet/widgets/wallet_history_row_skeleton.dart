part of 'wallet_history_tab.dart';

class WalletHistoryRowSkeleton extends StatelessWidget {
  const WalletHistoryRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(widthFactor: 0.55, height: 15),
                SizedBox(height: AppSpacing.sm),
                NinjaSkeleton.bar(height: 11, widthFactor: 0.28),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          NinjaSkeleton(width: 42, height: 16),
        ],
      ),
    );
  }
}
