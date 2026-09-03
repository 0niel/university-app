part of 'nfc_card_info.dart';

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AppRowTrailing(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.body.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
