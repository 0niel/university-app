part of 'wallet_balance_block.dart';

class _WalletBalanceBlockSkeleton extends StatelessWidget {
  const _WalletBalanceBlockSkeleton();

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NinjaSkeleton.bar(height: 11, widthFactor: 0.34),
          SizedBox(height: 14),
          NinjaSkeleton(
            height: 46,
            widthFactor: 0.5,
            radius: NinjaRadius.control,
          ),
          SizedBox(height: 18),
          Row(
            children: [
              _WalletStatBlockSkeleton(),
              SizedBox(width: 10),
              _WalletStatBlockSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}
