part of 'wallet_spend_tab.dart';

class WalletComingLaterNote extends StatelessWidget {
  const WalletComingLaterNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: NinjaText.subtext.copyWith(color: colors.muted),
        ),
      ),
    );
  }
}
