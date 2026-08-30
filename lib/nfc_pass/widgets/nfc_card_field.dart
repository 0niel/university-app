part of 'nfc_pass_card.dart';

class _NfcCardField extends StatelessWidget {
  const _NfcCardField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.helper.copyWith(color: colors.onAccentSoftMuted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.tabular(
            NinjaText.body.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onAccentSoft,
            ),
          ),
        ),
      ],
    );
  }
}
