part of 'wallet_spend_tab.dart';

class WalletComingLaterNote extends StatelessWidget {
  const WalletComingLaterNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          text,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ),
    );
  }
}
