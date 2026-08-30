part of 'wallet_balance_block.dart';

class _WalletStatBlockSkeleton extends StatelessWidget {
  const _WalletStatBlockSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: NinjaSkeleton(height: 60, radius: NinjaRadius.control),
    );
  }
}
