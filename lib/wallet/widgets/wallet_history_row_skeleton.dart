part of 'wallet_history_tab.dart';

class WalletHistoryRowSkeleton extends StatelessWidget {
  const WalletHistoryRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeleton.bar(widthFactor: 0.55, height: 15),
                SizedBox(height: 8),
                NinjaSkeleton.bar(height: 11, widthFactor: 0.28),
              ],
            ),
          ),
          SizedBox(width: 12),
          NinjaSkeleton(width: 42, height: 16),
        ],
      ),
    );
  }
}
